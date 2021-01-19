//
//  ReferralInfoViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 28.10.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class ReferralInfoViewController: BaseViewControllerWithTableView {
    
    var viewModel: ReferralInfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    private func setup() {
        tableView.configure(with: .defaultConfiguration)

        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
        tableView.backgroundColor = UIColor.Cell.headerBg
        setupPullToRefresh(scrollView: tableView)
        isEnableInfiniteIndicator = false
    }
    
    override func fetch() {
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                self?.hideAll()
                self?.reloadData()
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ReferralInfoViewController: ReferralInfoLinkTableViewCellProtocol{
    func shareButtonDidTap() {
        viewModel.shareLink()
    }
    
    func copyButtonDidTap() {
        UIPasteboard.general.string = viewModel.refLink
        showBottomSheet(.success, title: "Your referral link was copied to the clipboard successfully")
    }
}

final class ReferralInfoViewModel: ViewModelWithListProtocol {
    
    enum SectionType {
        case link
        case statistics
    }
    
    var canPullToRefresh: Bool = true
    
    var viewModels: [CellViewAnyModel] = []
    
    private var rates: RatesModel?
    
    var sections: [SectionType] = [.link, .statistics]
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    weak var cellsDelegate: ReferralInfoLinkTableViewCellProtocol?
    
    var router: Router
    
    public private(set) var refLink: String = ""
    
    init(router: Router, cellsDelegate: ReferralInfoLinkTableViewCellProtocol) {
        self.router = router
        self.cellsDelegate = cellsDelegate
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        
        AuthManager.getProfile { [weak self] (viewModel) in
            if let refLink = viewModel?.refUrl {
                self?.refLink = refLink
                self?.viewModels.append(ReferralInfoLinkTableViewCellViewModel(link: refLink, delegate: self?.cellsDelegate))
            }
            
            ReferralDataProvider.getReferralDetails(currency: getPlatformCurrencyType()) { [weak self] (viewModel) in
                if let viewModel = viewModel {
                    self?.viewModels.removeAll(where: { return $0 is ReferralInfoStatisticsTableViewCellViewModel })
                    self?.viewModels.append(ReferralInfoStatisticsTableViewCellViewModel(partnerDetails: viewModel))
                }
                completion(.success)
            } errorCompletion: { (result) in
                switch result {
                case .success:
                    break
                case .failure(errorType: let errorType):
                    completion(.failure(errorType: errorType))
                }
            }
        } completionError: { _ in }
    }
    
    func shareLink() {
        router.share(refLink)
    }
}

extension ReferralInfoViewModel {
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ReferralInfoLinkTableViewCellViewModel.self,
                ReferralInfoStatisticsTableViewCellViewModel.self]
    }
    
    func numberOfSections() -> Int {
        sections.count
    }
    
    func modelsCount() -> Int {
        return 1
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let secionType = sections[indexPath.section]
        
        switch secionType {
        case .link:
            return viewModels.first(where: { return $0 is ReferralInfoLinkTableViewCellViewModel })
        case .statistics:
            return viewModels.first(where: { return $0 is ReferralInfoStatisticsTableViewCellViewModel })
        }
    }
    
    func headerView(_ tableView: UITableView, for section: Int) -> UIView? {
        let secionType = sections[section]
        
        switch secionType {
        case .link:
            return nil
        case .statistics:
            let view = UIView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
            view.backgroundColor = .clear
            return view
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        let secionType = sections[section]
        
        switch secionType {
        case .link:
            return 0
        case .statistics:
            return 20
        }
    }
}
