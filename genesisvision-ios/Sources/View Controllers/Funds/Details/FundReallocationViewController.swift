//
//  FundReallocationViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 12.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class FundReallocationViewController: BaseViewController {
    
    var viewModel: FundReallocationViewModel!

    @IBOutlet weak var fundInfoLabel: SubtitleLabel!
    @IBOutlet weak var fundReallocationProgressView: MultiProgressView! {
        didSet {
            fundReallocationProgressView.trackBackgroundColor = UIColor.Cell.subtitle
            fundReallocationProgressView.lineCap = .round
            fundReallocationProgressView.cornerRadius = 4.0
        }
    }
    @IBOutlet weak var fundAssetsCollectionView: UICollectionView!
    @IBOutlet weak var addAssetButton: ActionButton! {
        didSet {
            addAssetButton.configure(with: .darkClear)
            addAssetButton.setTitle("+ Add asset", for: .normal)
        }
    }
    @IBOutlet weak var freeSpaceLabel: TitleLabel!
    @IBOutlet weak var reallocateButton: ActionButton! {
        didSet {
            reallocateButton.setTitle("Reallocate", for: .normal)
        }
    }
    
    private var changeFundAssetPartView = ChangeFundAssetPartView(frame: .zero)
    
    private var freeSpaceInFundAsset: Int = 0
    private var assetColor: [Int: UIColor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupChangeFundAssetPartView()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.fundReallocationProgressView.reloadData()
            self.updateProgressView(self.viewModel.assetCollectionViewModel.assets)
            if self.freeSpaceInFundAsset > 0 {
                self.freeSpaceLabel.text = "+" + self.freeSpaceInFundAsset.toString() + "%"
            } else {
                self.freeSpaceLabel.text = ""
            }
            self.fundAssetsCollectionView.reloadData()
            
            let fundInfoLabelText = "The total share of all assets should be equal to 100%.\n" +
            "At least two assets must be in the fund.\n" +
                "Reallocation available - \(self.viewModel.reallocationAvailable)%\n" +
            "You are able to reallocate 3% of the fund per day (cumulative). " +
            "Example: you will be able to change 30% of the fund's allocation after 10 days.\n" +
            "There is a mandatory 1% GVT allocation per fund."
            
            self.fundInfoLabel.text = fundInfoLabelText
        }
    }
    
    private func setupChangeFundAssetPartView() {
        changeFundAssetPartView = ChangeFundAssetPartView(frame: .zero, mainViewHeight: view.frame.height, mainViewWidth: view.frame.width)
        changeFundAssetPartView.translatesAutoresizingMaskIntoConstraints = false
        changeFundAssetPartView.isHidden = true
        view.addSubview(changeFundAssetPartView)
        changeFundAssetPartView.backgroundColor = UIColor.Cell.bg
        changeFundAssetPartView.delegate = self
        
        changeFundAssetPartView.anchorCenter(centerY: view.centerYAnchor, centerX: view.centerXAnchor)
        
        let height = view.frame.height*0.35 > 300 ? view.frame.height*0.35 : 300
        
        changeFundAssetPartView.anchorSize(size: CGSize(width: view.frame.width - 40, height: height))
    }
    
    private func setup() {
        title = "Reallocate"
        
        fundReallocationProgressView.dataSource = self
        freeSpaceLabel.text = ""
        freeSpaceInFundAsset = 0
    }
    
    private func setupCollectionView() {
        fundAssetsCollectionView.dataSource = viewModel.assetCollectionViewDataSource
        fundAssetsCollectionView.delegate = viewModel.assetCollectionViewDataSource
        viewModel.assetCollectionViewModel.assetCellSelectedDelegate = self
        
        if let layout = fundAssetsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        fundAssetsCollectionView.isScrollEnabled = true
        fundAssetsCollectionView.showsHorizontalScrollIndicator = false
        fundAssetsCollectionView.indicatorStyle = .black
        fundAssetsCollectionView.registerNibs(for: viewModel.assetCollectionViewModel.cellModelsForRegistration)
    }

    @IBAction func addAssetButtonAction(_ sender: Any) {
        guard freeSpaceInFundAsset > 0 else { return }
        
        let fundAssetListViewController = FundAssetsListViewController()
        fundAssetListViewController.assetListSelectedDelegate = self
        let viewModel = FundAssetsListViewModel(delegate: fundAssetListViewController)
        fundAssetListViewController.viewModel = viewModel
        push(viewController: fundAssetListViewController)
    }
    
    @IBAction func reallocateButtonAction(_ sender: Any) {
        guard freeSpaceInFundAsset == 0 else { return }
        showProgressHUD()
        viewModel.reallocate { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.showSuccessHUD()
                self?.navigationController?.popViewController(animated: true)
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    func updateProgressView(_ assets: [FundAssetInfo]?) {
        guard let assets = assets else { return }
        
        for (index, asset) in assets.enumerated() {
            if let value = asset.target, asset.asset != nil {
                DispatchQueue.main.async {
                    self.fundReallocationProgressView.setProgress(section: index, to: Float(Double(value) / 100))
                }
            }
        }
    }
}

extension FundReallocationViewController: ChangeFundAssetPartViewProtocol {
    func update(targetInFund: Int, freeInFund: Int, fundSymbol: String) {
        freeSpaceInFundAsset = freeInFund
        viewModel.changeValueForFundAsset(target: targetInFund, symbol: fundSymbol)
        changeFundAssetPartView.isHidden = true
        updateUI()
    }
    
    func close() {
        changeFundAssetPartView.isHidden = true
    }
}

extension FundReallocationViewController: FundReallocationCellActionProtocol {
    func assetCellRemoved(assetInfo: FundAssetInfo) {
        freeSpaceInFundAsset = viewModel.getFreeSpaceInFund()
        updateUI()
    }
    
    func assetCellSelected(assetInfo: FundAssetInfo) {
        changeFundAssetPartView.configure(assetInfo: assetInfo, freeSpaceInFund: freeSpaceInFundAsset)
        
        UIView.animate(withDuration: 0.3) {
            self.changeFundAssetPartView.isHidden = false
        }
    }
}

extension FundReallocationViewController: AssetListSelectedProtocol {
    func assetSelected(asset: PlatformAsset) {
        let newAsset = viewModel.addAsset(asset: asset)
        assetCellSelected(assetInfo: newAsset)
        updateUI()
    }
}

extension FundReallocationViewController: MultiProgressViewDataSource {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return viewModel.assetCollectionViewModel.viewModels.count
    }

    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        
        if let color = assetColor[section] {
            sectionView.backgroundColor = color
        } else {
            assetColor[section] = UIColor.random
            sectionView.backgroundColor = assetColor[section]
        }
        return sectionView
    }
}


final class FundReallocationViewModel {
    
    var assetCollectionViewModel: FundReallocationAssetCollectionViewModel!
    var assetCollectionViewDataSource: CollectionViewDataSource!
    var assetId: String?
    var fundDetails: FundDetailsFull?
    var platformAssets: [PlatformAsset] = []
    var reallocationAvailable: Int = 100
    
    init(with: String? = nil) {
        assetId = with
        assetCollectionViewModel = FundReallocationAssetCollectionViewModel()
        assetCollectionViewDataSource = CollectionViewDataSource(assetCollectionViewModel)
    }
    
    func reallocate(completion: @escaping CompletionBlock) {
        guard let fundId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let fundAssets = assetCollectionViewModel.assets.map { (fundAssetInfo) -> FundAssetPart? in
            guard let platformAsset = platformAssets.first(where: { return $0.name == fundAssetInfo.asset }) else { return nil }
            return FundAssetPart(_id: platformAsset._id, percent: fundAssetInfo.target)
        }.compactMap({ $0 })
        AssetsDataProvider.updateFundAssets(fundId, assets: fundAssets, completion: completion)
    }
    
    func addAsset(asset: PlatformAsset) -> FundAssetInfo {
        let fundAssetInfo = FundAssetInfo(asset: asset.name, symbol: asset.asset, logoUrl: asset.logoUrl, target: 0, current: 0, currentAmount: 0, url: asset.url)
        assetCollectionViewModel.assets.append(fundAssetInfo)
        return fundAssetInfo
    }
    
    
    func fetch(completion: @escaping CompletionBlock) {
        guard let assetId = assetId else {
            completion(.failure(errorType: .apiError(message: nil)))
            return }
        
        FundsDataProvider.get(assetId, currencyType: .usdt, completion: { [weak self] (fundDetailsFull) in
            if let fundDetailsFull = fundDetailsFull, let assets = fundDetailsFull.assetsStructure {
                self?.fundDetails = fundDetailsFull
                if let reallocationAvailable = fundDetailsFull.personalDetails?.availableReallocationPercents {
                    self?.reallocationAvailable = reallocationAvailable
                }
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
        
        PlatformManager.shared.getPlatformAssets { [weak self] (model) in
            if let assets = model?.assets {
                self?.platformAssets = assets
            }
        }
    }
    
    func changeValueForFundAsset(target: Int, symbol: String) {
        var assetInfo = FundAssetInfo()
        assetCollectionViewModel.assets.removeAll { (fundAssetInfo) -> Bool in
            guard let symbolInArray = fundAssetInfo.symbol else { return false}
            
            if symbolInArray == symbol {
                assetInfo = fundAssetInfo
                return true
            } else {
                return false
            }
        }
        
        assetInfo.target = Double(target)
        assetCollectionViewModel.assets.append(assetInfo)
    }
    
    func getFreeSpaceInFund() -> Int {
        var freeSpace: Int = 100
        assetCollectionViewModel.assets.forEach({freeSpace -= Int($0.target ?? 0)})
        return freeSpace
    }
}

protocol FundReallocationCellActionProtocol: class {
    func assetCellSelected(assetInfo: FundAssetInfo)
    func assetCellRemoved(assetInfo: FundAssetInfo)
}

final class FundReallocationAssetCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var selectedIndex: Int = 0

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true
    
    weak var assetCellSelectedDelegate: FundReallocationCellActionProtocol?
    
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
                viewModels.append(FundAssetManageCollectionViewCellViewModel(assetModel: fundAssetInfo, reallocateMode: true, closeButtonDelegate: self))
            }
        }
    }
    
    init() {
        self.title = "Asset selection"
        self.type = .createFund
    }
    
    func didSelect(at indexPath: IndexPath) {
        guard let cellViewModel = viewModels[indexPath.row] as? FundAssetManageCollectionViewCellViewModel, let assetModel = cellViewModel.assetModel else { return }
        assetCellSelectedDelegate?.assetCellSelected(assetInfo: assetModel)
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
    
    func changeValueForFundAsset(target: Int, symbol: String) {
        var assetInfo = FundAssetInfo()
        assets.removeAll { (fundAssetInfo) -> Bool in
            guard let symbolInArray = fundAssetInfo.symbol else { return false}
            
            if symbolInArray == symbol {
                assetInfo = fundAssetInfo
                return true
            } else {
                return false
            }
        }
        
        assetInfo.target = Double(target)
        assets.append(assetInfo)
    }
}

extension FundReallocationAssetCollectionViewModel: FundAssetCellRemoveButtonProtocol {
    func remove(assetInfo: FundAssetInfo) {
        
        if let symbol = assetInfo.symbol, symbol == "GVT" {
            changeValueForFundAsset(target: 1, symbol: symbol)
            assetCellSelectedDelegate?.assetCellRemoved(assetInfo: assetInfo)
        } else {
            assets.removeAll(where: {$0.asset == assetInfo.asset})
            assetCellSelectedDelegate?.assetCellRemoved(assetInfo: assetInfo)
        }
    }
    
}