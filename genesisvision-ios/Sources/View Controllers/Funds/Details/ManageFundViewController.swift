//
//  ManageFundViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 03.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

class ManageFundViewController: BaseViewController {
    
    var viewModel: ManageFundViewModel!
    
    @IBOutlet weak var dangerZoneSwitch: UISwitch! {
        didSet {
            dangerZoneSwitch.isOn = false
            dangerZoneSwitch.onTintColor = UIColor.primary
            dangerZoneSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            dangerZoneSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dangerZoneView: UIView! {
        didSet {
            dangerZoneView.isHidden = true
        }
    }
    
    @IBOutlet weak var informationLabel: SubtitleLabel!
    @IBOutlet weak var closeFundButton: ActionButton! {
        didSet {
            closeFundButton.setTitle("Close Fund", for: .normal)
            closeFundButton.configure(with: .custom(options: ActionButtonOptions(borderWidth: 0, borderColor: nil, fontSize: 15, bgColor: UIColor.Common.red, textColor: UIColor.Common.white, image: nil, rightPosition: false)))
        }
    }
    @IBOutlet weak var entryFeeLabel: TitleLabel! {
        didSet {
            entryFeeLabel.font = UIFont.getFont(.semibold, size: 16.0)
        }
    }
    @IBOutlet weak var exitFeeLabel: TitleLabel! {
        didSet {
            exitFeeLabel.font = UIFont.getFont(.semibold, size: 16.0)
        }
    }
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manage Fund"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                self?.setupCollectionView()
                self?.updateUI()
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            if let exitText = self.viewModel.fundDetails?.exitFeeCurrent?.toString(), let entryText = self.viewModel.fundDetails?.entryFeeCurrent?.toString() {
                self.exitFeeLabel.text = exitText + "%"
                self.entryFeeLabel.text = entryText + "%"
            }
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel.assetCollectionViewDataSource
        collectionView.delegate = viewModel.assetCollectionViewDataSource
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.indicatorStyle = .black
        collectionView.registerNibs(for: viewModel.assetCollectionViewModel.cellModelsForRegistration)
        
        let minimumHeight = 200
        
        let heightvalue = (65)*(viewModel.assetCollectionViewModel.viewModels.count/2)
        
        collectionViewHeightConstraint.constant = heightvalue > minimumHeight ? CGFloat(heightvalue) : CGFloat(minimumHeight)
        
        NSLayoutConstraint.activate([collectionViewHeightConstraint])
    }
    
    @IBAction func dangerZoneSwitchAction(_ sender: Any) {
        dangerZoneView.isHidden = !dangerZoneSwitch.isOn
    }
    
    @IBAction func reallocateButtonAction(_ sender: Any) {
        guard let viewController = FundReallocationViewController.storyboardInstance(.fund), let assetId = self.viewModel.assetId else { return }
        
        let viewModel = FundReallocationViewModel(with: assetId)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func closeFundButtonAction(_ sender: Any) {
        
        showAlertWithTitle(title: "Close fund", message: "The fund will be closed after pressing the button. Are you sure?", actionTitle: "Confirm", cancelTitle: "Cancel", handler: {
            self.closeFund()
        }, cancelHandler: nil)
    }
    
    @IBAction func changeSettingsButtonAction(_ sender: Any) {
        guard let viewController = ChangeFundSettingsViewController.storyboardInstance(.fund), let assetId = self.viewModel.assetId else { return }
        
        let viewModel = ChangeFundSettingsViewModel()
        viewModel.assetId = assetId
        viewController.viewModel = viewModel
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func closeFund() {
        showProgressHUD()
        viewModel.closeFund(twoFactorCode: "123456") { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.showSuccessHUD()
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
}

class ManageFundViewModel {
        
    var assetCollectionViewModel: FundAssetCollectionViewModel!
    var assetCollectionViewDataSource: CollectionViewDataSource!
    var assetId: String?
    var fundDetails: FundDetailsFull?
    
    init(with: String? = nil) {
        assetId = with
        assetCollectionViewModel = FundAssetCollectionViewModel()
        assetCollectionViewDataSource = CollectionViewDataSource(assetCollectionViewModel)
    }
    
    
    func fetch(completion: @escaping CompletionBlock) {
        guard let assetId = assetId else {
            completion(.failure(errorType: .apiError(message: nil)))
            return }
        
        FundsDataProvider.get(assetId, currencyType: .usdt, completion: { [weak self] (fundDetailsFull) in
            if let fundDetailsFull = fundDetailsFull, let assets = fundDetailsFull.assetsStructure {
                self?.fundDetails = fundDetailsFull
                self?.assetCollectionViewModel.assets = assets
            }
            completion(.success)
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(errorType: let errorType):
                completion(.failure(errorType: errorType))
            }
        }
    }
    
    func closeFund(twoFactorCode: String, completion: @escaping CompletionBlock) {
        guard let assetId = self.assetId, !twoFactorCode.isEmpty else {
            completion(.failure(errorType: .apiError(message: nil)))
            return
        }
        let model = TwoFactorCodeModel(twoFactorCode: twoFactorCode)
        AssetsDataProvider.closeFund(assetId, model: model, completion: completion)
    }
}

class FundAssetCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var selectedIndex: Int = 0

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true
    
    let collectionTopInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionBottomInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionLeftInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionRightInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionLineSpacing: CGFloat = Constants.SystemSizes.Cell.lineSpacing
    let collectionInteritemSpacing: CGFloat = Constants.SystemSizes.Cell.interitemSpacing

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundAssetManageCollectionViewCellViewModel.self]
    }

    var assets = [FundAssetInfo]() {
        didSet {
            viewModels = [FundAssetManageCollectionViewCellViewModel]()
            
            
            assets.forEach { (fundAssetInfo) in
                viewModels.append(FundAssetManageCollectionViewCellViewModel(assetModel: fundAssetInfo, reallocateMode: nil, closeButtonDelegate: nil))
            }
        }
    }
    
    init() {
        self.title = "Asset selection"
        self.type = .createFund
    }
    
    func didSelect(at indexPath: IndexPath) {
    }
    
    func getRightButtons() -> [UIButton] {
        return []
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 150
    }
    
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        let space: CGFloat = collectionLineSpacing + collectionLeftInset + collectionRightInset
        let size: CGFloat = (frame.width - space) / 2.0
        return CGSize(width: size, height: 50)
    }
    
    func insetForSection(for section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionTopInset, left: collectionLeftInset, bottom: collectionBottomInset, right: collectionRightInset)
    }
    
    func minimumLineSpacing(for section: Int) -> CGFloat {
        return collectionLineSpacing
    }
    
    func minimumInteritemSpacing(for section: Int) -> CGFloat {
        return collectionInteritemSpacing
    }
    
    func numberOfRows(in section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
}
