//
//  FundInfoViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class FundInfoViewModel: ViewModelWithListProtocol {
    enum SectionType {
        case details
        case yourInvestment
        case investNow
    }
    enum RowType {
        case header
        case manager
        case strategy
    }

    // MARK: - Variables
    var title: String = "Info"
    
    var canPullToRefresh: Bool = true
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    private var router: FundInfoRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var inRequestsDelegateManager = InRequestsDelegateManager()
    
    var chartDurationType: ChartDurationType = .all
    var assetId: String!
    var requestSkip = 0
    var requestTake = ApiKeys.take
    
    private var equityChart: [SimpleChartPoint]?
    public private(set) var fundDetailsFull: FundDetailsFull? {
        didSet {
            if let isInvested = fundDetailsFull?.personalDetails?.isInvested, isInvested, let status = fundDetailsFull?.personalDetails?.status, status != .ended {
                if !sections.contains(.yourInvestment) {
                    sections.insert(.yourInvestment, at: 1)
                }
            }
        }
    }
    
    public private(set) var assetOwnerProfile: PublicProfile?
    
    var availableInvestment: Double = 0.0
    
    private var sections: [SectionType] = [.details, .investNow]
    private var rows: [RowType] = [.header, .manager, .strategy]
    
    var viewModels: [CellViewAnyModel] = []
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundHeaderTableViewCellViewModel.self,
                DetailManagerTableViewCellViewModel.self,
                DefaultTableViewCellViewModel.self,
                FundInvestNowTableViewCellViewModel.self,
                FundYourInvestmentTableViewCellViewModel.self]
    }
    weak var delegate: BaseTableViewProtocol?
    // MARK: - Init
    init(withRouter router: FundInfoRouter,
         assetId: String? = nil,
         fundDetailsFull: FundDetailsFull? = nil,
         reloadDataProtocol: ReloadDataProtocol? = nil) {
        self.router = router

        if let assetId = assetId {
            self.assetId = assetId
        }
        
        if let fundDetailsFull = fundDetailsFull, let assetId = fundDetailsFull._id?.uuidString {
            self.fundDetailsFull = fundDetailsFull
            self.assetId = assetId
        }
        
        self.reloadDataProtocol = reloadDataProtocol
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return Constants.headerHeight
        }
    }
    
    func numberOfSections() -> Int {
        guard fundDetailsFull != nil else {
            return 0
        }
        
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let sectionType = sections[section]
        
        switch sectionType {
        case .details:
            return rows.count
        default:
            return 1
        }
    }
    
    func modelsCount() -> Int {
        return viewModels.count == 0 ? 1 : viewModels.count
    }
    
    func didSelect(at indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .details:
            switch rows[indexPath.row] {
            case .manager:
                showManagerVC()
            default:
                break
            }
        default:
            break
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .details:
            switch rows[indexPath.row] {
            case .manager:
                showManagerVC()
            default:
                break
            }
        default:
            break
        }
    }
}

// MARK: - Navigation
extension FundInfoViewModel {
    // MARK: - Public methods
    func showManagerVC() {
        guard let managerId = fundDetailsFull?.owner?._id?.uuidString else { return }
        router.show(routeType: .manager(managerId: managerId))
    }
    
    func invest() {
        guard let assetId = assetId else { return }
        router.show(routeType: .invest(assetId: assetId))
    }
    
    func withdraw() {
        guard let assetId = assetId else { return }
        router.show(routeType: .withdraw(assetId: assetId))
    }
    
    func manageAssets() {
        guard let assetId = assetId else { return }
        router.show(routeType: .manageAssets(assetId: assetId))
    }
    
    func editPublicInfo() {
        guard let assetId = assetId else { return }
        router.show(routeType: .editPublicInfo(assetId: assetId))
    }
}

// MARK: - Fetch
extension FundInfoViewModel {
    // MARK: - Public methods
    func getNickname() -> String {
        return fundDetailsFull?.owner?.username ?? ""
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        guard fundDetailsFull != nil else {
            return nil
        }
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .details:
            let rowType = rows[indexPath.row]
            switch rowType {
            case .header:
                guard let fundDetailsFull = fundDetailsFull else { return nil }
                return FundHeaderTableViewCellViewModel(details: fundDetailsFull)
            case .manager:
                guard let profilePublic = assetOwnerProfile else { return nil }
                return DetailManagerTableViewCellViewModel(profilePublic: profilePublic, delegate: self)
            case .strategy:
                return DefaultTableViewCellViewModel(title: "Strategy", subtitle: fundDetailsFull?.publicInfo?._description, editInfoProtoclDelegate: self, assetType: .fund, isOwner: fundDetailsFull?.publicInfo?.isOwnAsset)
            }
        case .yourInvestment:
            return FundYourInvestmentTableViewCellViewModel(fundDetailsFull: fundDetailsFull, yourInvestmentProtocol: self)
        case .investNow:
            return FundInvestNowTableViewCellViewModel(fundDetailsFull: fundDetailsFull, investNowProtocol: self)
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        FundsDataProvider.get(self.assetId, currencyType: getPlatformCurrencyType(), completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.fundDetailsFull = viewModel
            
            UsersDataProvider.get(with: viewModel?.owner?._id?.uuidString ?? "") { ownerPublicProfile in
                self?.assetOwnerProfile = ownerPublicProfile
                completion(.success)
            } errorCompletion: { _ in
                completion(.success)
            }
        }, errorCompletion: completion)
    }
    
    func updateDetails(with fundDetailsFull: FundDetailsFull) {
        self.fundDetailsFull = fundDetailsFull
        self.reloadDataProtocol?.didReloadData()
    }
}

extension FundInfoViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
    }
}

extension FundInfoViewModel: YourInvestmentProtocol {
    func didTapWithdrawButton() {
        withdraw()
    }
    
    func didTapStatusButton() {
        guard let assetId = assetId else { return }
    }
}

extension FundInfoViewModel: InvestNowProtocol {
    func didTapEntryFeeTooltipButton(_ tooltipText: String) {
        
    }
    
    func didTapInvestButton() {
        guard AuthManager.isLogin() else {
            router.signInAction()
            return
        }
        
        invest()
    }
    func ditTapEditButton() {
        manageAssets()
    }
}

extension FundInfoViewModel: EditInfoProtocol {
    func ditTapEditInfoButton() {
        editPublicInfo()
    }
}

extension FundInfoViewModel: DetailManagerTableViewCellDelegate {
    func followPressed(userId: UUID, followed: Bool) {
        followed ?
            SocialDataProvider.unfollow(userId: userId, completion: { _ in })
            : SocialDataProvider.follow(userId: userId, completion: { _ in })
    }
}
