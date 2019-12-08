//
//  CreateFundViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class CreateFundViewController: BaseModalViewController {
    typealias ViewModel = CreateFundViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: CreateFundStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        viewModel = CreateFundViewModel(self, addAssetsProtocol: self)
        stackView.configure(viewModel)
        viewModel.addAssetListViewModel.setup(self)
    }
    
    // MARK: - Actions
    @IBAction func addAssetButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 400.0

        bottomSheetController.addNavigationBar(viewModel.addAssetListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.addAssetListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.addAssetListDataSource
            tableView.dataSource = viewModel.addAssetListDataSource
            tableView.reloadData()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        showImagePicker()
    }
    @IBAction func createFundButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectWalletCurrencyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.fromListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.fromListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.fromListDataSource
            tableView.dataSource = viewModel.fromListDataSource
            tableView.reloadData()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
}

extension CreateFundViewController: BaseCellProtocol {
    func didSelect(_ type: DidSelectType, index: Int) {
        switch type {
        case .depositFrom:
            stackView.fromView.textLabel.text = viewModel.fromListViewModel.selected?.currency?.rawValue
        default:
            break
        }
        
        bottomSheetController.dismiss()
    }
}

extension CreateFundViewController: AddAssetListViewModelProtocol {
    func addAssets(_ assets: [AssetModel]?) {
        guard let assets = assets else { return }
        
        viewModel.assetCollectionViewModel.assets = assets
        stackView.updateProgressView(assets)
        stackView.assetStackView.collectionView.reloadData()
    }
}

extension CreateFundViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return stackView.uploadLogoView.uploadLogoButton
    }
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImage = pickedImage, let pickedImageURL = pickedImageURL else { return }
        
        viewModel.pickedImage = pickedImage
        viewModel.pickedImageURL = pickedImageURL
        
        stackView.uploadLogoView.uploadLogoButton.isHidden = true
        stackView.uploadLogoView.logoStackView.isHidden = false
        stackView.uploadLogoView.imageView.image = pickedImage
    }
}

class CreateFundViewModel {
    // MARK: - Variables
    var pickedImage: UIImage?
    var pickedImageURL: URL?
    var uploadedUuidString: String?
    
    var assetCollectionViewModel: AssetCollectionViewModel!
    var assetCollectionDataSource: CollectionViewDataSource<AssetCollectionViewModel>!
    
    var addAssetListViewModel: AddAssetListViewModel!
    var addAssetListDataSource: TableViewDataSource<AddAssetListViewModel>!
    
    var fromListViewModel: FromListViewModel!
    var fromListDataSource: TableViewDataSource<FromListViewModel>!
    
    weak var addAssetsProtocol: AddAssetListViewModelProtocol?
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?, addAssetsProtocol: AddAssetListViewModelProtocol?) {
        self.delegate = delegate
        self.addAssetsProtocol = addAssetsProtocol
        
        assetCollectionViewModel = AssetCollectionViewModel()
        assetCollectionDataSource = CollectionViewDataSource(assetCollectionViewModel)
        
        addAssetListViewModel = AddAssetListViewModel()
        addAssetListDataSource = TableViewDataSource(addAssetListViewModel)
        
        let wallets: [WalletWithdrawalInfo] = []
        fromListViewModel = FromListViewModel(delegate, items: wallets, selected: nil)
        fromListDataSource = TableViewDataSource(fromListViewModel)
    }
    
    // MARK: - Public methods
    func saveProfilePhoto(completion: @escaping CompletionBlock) {
        guard let pickedImageURL = pickedImageURL else {
            return completion(.failure(errorType: .apiError(message: nil)))
        }
        BaseDataProvider.uploadImage(imageURL: pickedImageURL, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult.id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedUuidString = uuidString
            completion(.success)
        }, errorCompletion: completion)
    }
}
class AssetCollectionViewModel: ViewModelWithCollection {
    var title: String
    var showActionsView: Bool
    var type: CellActionType
    
    var selectedIndex: Int = 0

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AssetCollectionViewCellViewModel.self]
    }

    var assets = [AssetModel]() {
        didSet {
            viewModels = [AssetCollectionViewCellViewModel]()
            var value = 0
            assets.forEach { (asset) in
                value += asset.value ?? 0
                viewModels.append(AssetCollectionViewCellViewModel(assetModel: asset))
            }
            
            if value < 100 {
                viewModels.append(AssetCollectionViewCellViewModel(assetModel: AssetModel(logo: nil, name: nil, symbol: nil, value: 100 - value)))
            }
        }
    }
    
    init() {
        self.title = "Asset selection"
        self.showActionsView = false
        self.type = .createAccount
    }
    
    func didSelect(at indexPath: IndexPath) {
    }
    
    func getActions() -> [UIButton] {
        return []
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 70.0
    }
    
    func makeLayout() -> UICollectionViewLayout {
        var layout: UICollectionViewLayout!
        if #available(iOS 13.0, *) {
            layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                let itemInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0.0, leading: Constants.SystemSizes.Cell.horizontalMarginValue / 2, bottom: Constants.SystemSizes.Cell.verticalMarginValues, trailing: Constants.SystemSizes.Cell.horizontalMarginValue / 2)
                let sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0.0, leading: Constants.SystemSizes.Cell.horizontalMarginValue, bottom: Constants.SystemSizes.Cell.verticalMarginValues, trailing: Constants.SystemSizes.Cell.horizontalMarginValue)
                
                item.contentInsets = itemInset
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = sectionInset
                section.orthogonalScrollingBehavior = .continuous
                return section
            }
        } else {
            // Fallback on earlier versions
        }
        return layout
    }
}

protocol AddAssetListViewModelProtocol: class {
    func addAssets(_ assets: [AssetModel]?)
}

final class AddAssetListViewModel: ListVMProtocol {
    var title = "Add assets"
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AddFundAssetTableViewCellViewModel.self]
    }
    
    var assets: [AssetModel] = [AssetModel]()
    weak var delegate: AddAssetListViewModelProtocol?

    func setup(_ delegate: AddAssetListViewModelProtocol?) {
        self.delegate = delegate
        
        assets.append(AssetModel(logo: nil, name: "Genesis Vision", symbol: "GVT", value: 1))
        assets.append(AssetModel(logo: nil, name: "Etherium", symbol: "ETH", value: 0))
        assets.append(AssetModel(logo: nil, name: "Bitcoin", symbol: "BTC", value: 0))
        assets.append(AssetModel(logo: nil, name: "Genesis Vision 2", symbol: "GV2", value: 0))
        assets.append(AssetModel(logo: nil, name: "Etherium 2", symbol: "ET2", value: 0))
        assets.append(AssetModel(logo: nil, name: "Bitcoin 2", symbol: "BT2", value: 0))
        
        updateAssets()
    }
    
    func updateAssets() {
        var models = [AddFundAssetTableViewCellViewModel]()
        
        assets.sort { $0.symbol ?? "" > $1.symbol ?? "" }
        assets.sort { $0.value! > $1.value! }
        
        assets.forEach { (asset) in
            models.append(AddFundAssetTableViewCellViewModel(assetModel: asset, delegate: self))
        }
        
        viewModels = models
        
        let addedAssets = assets.filter({ $0.value! > 0 })
        self.delegate?.addAssets(addedAssets)
    }
}

extension AddAssetListViewModel: AddFundAssetTableViewCellProtocol {
    func confirmAsset(_ asset: AssetModel?) {
        guard let asset = asset else { return }

        if let index = assets.firstIndex(where: { $0.symbol == asset.symbol }) {
            assets.remove(at: index)
        }
        assets.append(asset)
        
        updateAssets()
    }
}
