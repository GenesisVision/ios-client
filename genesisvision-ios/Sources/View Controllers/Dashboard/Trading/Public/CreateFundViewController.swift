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
        
        setup()
    }
    
    func setup() {
        viewModel = CreateFundViewModel(self, addAssetsProtocol: self)
        
        showProgressHUD()
        viewModel.fetch()
        
        stackView.amountView.maxButton.addTarget(self, action: #selector(copyMaxValueButtonAction), for: .touchUpInside)
        
        stackView.amountView.textField.designableTextFieldDelegate = self
        stackView.amountView.textField.delegate = self
        stackView.amountView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        
        stackView.nameView.textField.delegate = self
        stackView.nameView.textField.designableTextFieldDelegate = self
        stackView.nameView.textField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        stackView.nameView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        
        stackView.descriptionView.textView.textContainerInset = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: -6)
        stackView.descriptionView.textView.delegate = self
        stackView.descriptionView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        
        stackView.entryFeeView.textField.text = "0"
        stackView.exitFeeView.textField.text = "0"
    }
    
    func updateUI() {
        stackView.configure(viewModel)
        viewModel.addAssetListViewModel.setup(self)
    }
    @objc private func nameDidChange() {
        if let text = stackView.nameView.textField.text {
            let max = 20
            let count = text.count
            stackView.nameView.subtitleValueLabel.text = "\(count) / \(max)"
            stackView.nameView.subtitleValueLabel.textColor = count < 4 || count > 20 ? UIColor.Common.red : UIColor.Cell.subtitle
        }
        checkActionButton()
    }
    
    @objc func checkActionButton() {
        guard let amountText = stackView.amountView.textField.text, !amountText.isEmpty, let value = amountText.doubleValue else {
            stackView.amountView.approxLabel.text = ""
            stackView.actionButton.setEnabled(false)
            return
        }
        
        stackView.amountView.approxLabel.text = viewModel.getApproxString(value)
        
        guard let minDeposit = viewModel.getMinDepositValue(), let exchangedValue = viewModel.exchangeValueInCurrency(value), exchangedValue >= minDeposit else { return
            stackView.actionButton.setEnabled(false)
        }
        
        guard let name = stackView.nameView.textField.text,
            let description = stackView.descriptionView.textView.text,
            let exitFee = stackView.exitFeeView.textField.text,
            let entryFee = stackView.entryFeeView.textField.text else { return }
        
        let enable = name.count >= 4 && name.count <= 20 && description.count >= 20 && description.count <= 500 && !exitFee.isEmpty && !entryFee.isEmpty
        
        stackView.actionButton.setEnabled(enable)
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
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        if let wallet = viewModel.fromListViewModel?.selected(), let currency = wallet.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let availableInWalletFromValue = wallet.available {
            
            stackView.amountView.textField.text = availableInWalletFromValue.rounded(with: currencyType).toString(withoutFormatter: true)
        }
    }
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        showImagePicker()
    }
    @IBAction func createFundButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let title = stackView.nameView.textField.text {
            viewModel.request.title = title
        }
        if let description = stackView.descriptionView.textView.text {
            viewModel.request.description = description
        }
        if let entryFee = stackView.entryFeeView.textField.text?.doubleValue {
            viewModel.request.entryFee = entryFee
        }
        if let exitFee = stackView.exitFeeView.textField.text?.doubleValue {
            viewModel.request.exitFee = exitFee
        }
        if let depositAmount = stackView.amountView.textField.text?.doubleValue {
            viewModel.request.depositAmount = depositAmount
        }
        
        showProgressHUD()
        viewModel.createFund { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
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
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
}

extension CreateFundViewController: UITextFieldDelegate, DesignableUITextFieldDelegate {
    func textFieldDidClear(_ textField: UITextField) {
        stackView.nameView.subtitleValueLabel.text = "0 / 20"
        stackView.nameView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        checkActionButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkActionButton()
    }
}

extension CreateFundViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = stackView.descriptionView.textView.text {
            let max = 500
            let count = text.count
            stackView.descriptionView.subtitleValueLabel.text = "\(count) / \(max)"
            stackView.descriptionView.subtitleValueLabel.textColor = count < 20 || count > 500 ? UIColor.Common.red : UIColor.Cell.subtitle
        }
        checkActionButton()
    }
}

extension CreateFundViewController: BaseTableViewProtocol {
    func didSelect(_ type: DidSelectType, index: Int) {
        self.view.endEditing(true)
        bottomSheetController.dismiss()
        
        switch type {
        case .walletFrom:
            viewModel.updateWallet(index)
        default:
            break
        }
        
        updateUI()
    }
    
    func didReload() {
        hideAll()
        updateUI()
    }
}

extension CreateFundViewController: AddAssetListViewModelProtocol {
    func addAssets(_ assets: [PlatformAsset]?) {
        guard let assets = assets else { return }
        
        viewModel.request.assets = assets.map { FundAssetPart(id: $0.id, percent: $0.mandatoryFundPercent ) }
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
    var uploadedUuidString: String? {
        didSet {
            request.logo = uploadedUuidString
        }
    }
    var assetCollectionViewModel: AssetCollectionViewModel!
    var assetCollectionDataSource: CollectionViewDataSource<AssetCollectionViewModel>!
    
    var addAssetListViewModel: AddAssetListViewModel!
    var addAssetListDataSource: TableViewDataSource!
    
    var fromListViewModel: FromListViewModel!
    var fromListDataSource: TableViewDataSource!
    
    var ratesModel: RatesModel?
    var walletSummary: WalletSummary? {
        didSet {
            if let wallets = walletSummary?.wallets, !wallets.isEmpty {
                fromListViewModel = FromListViewModel(delegate, items: wallets, selectedIndex: 0)
                fromListDataSource = TableViewDataSource(fromListViewModel)
            }
        }
    }
    var createFundInfo: FundCreateAssetPlatformInfo?
    var twoFactorStatus: TwoFactorStatus?
    lazy var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    var request = NewFundRequest(assets: nil, entryFee: nil, exitFee: nil, depositAmount: nil, depositWalletId: nil, title: nil, description: nil, logo: nil)
    
    weak var addAssetsProtocol: AddAssetListViewModelProtocol?
    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?, addAssetsProtocol: AddAssetListViewModelProtocol?) {
        self.delegate = delegate
        self.addAssetsProtocol = addAssetsProtocol
        
        assetCollectionViewModel = AssetCollectionViewModel()
        assetCollectionDataSource = CollectionViewDataSource(assetCollectionViewModel)
        
        addAssetListViewModel = AddAssetListViewModel()
        addAssetListDataSource = TableViewDataSource(addAssetListViewModel)
    }
    
    func fetch() {
        WalletDataProvider.get(with: getPlatformCurrencyType(), completion: { [weak self] (walletSummary) in
            self?.walletSummary = walletSummary
            self?.delegate?.didReload()
        }, errorCompletion: errorCompletion)
        PlatformManager.shared.getPlatformInfo { [weak self] (model) in
            guard let model = model?.assetInfo?.fundInfo?.createFundInfo else { return }
            self?.createFundInfo = model
        }
        TwoFactorDataProvider.getStatus(completion: { [weak self] (twoFactorStatus) in
            self?.twoFactorStatus = twoFactorStatus
        }, errorCompletion: errorCompletion)
    }
    func updateRates() {
        RateDataProvider.getRates(from: [Currency.gvt.rawValue], to: [Currency.gvt.rawValue, Currency.btc.rawValue, Currency.eth.rawValue, Currency.usdt.rawValue], completion: { [weak self] (ratesModel) in
            self?.ratesModel = ratesModel
        }) { (result) in
            
        }
    }
    func getMinDeposit() -> String {
        guard let minDeposit = createFundInfo?.minDeposit else { return "" }
        let currencyType: CurrencyType = .gvt
        return minDeposit.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    func getMinDepositValue() -> Double? {
        guard let minDeposit = createFundInfo?.minDeposit else { return nil }

        return minDeposit
    }
    func getSelectedWallet() -> String {
        guard let selected = fromListViewModel.selected(), let title = selected.title, let currency = selected.currency?.rawValue else { return "" }
        
        return "\(currency) | \(title)"
    }
    func getSelectedWalletCurrency() -> String {
        guard let currency = fromListViewModel.selected()?.currency?.rawValue else { return "" }
        
        return currency
    }
    func getAvailable() -> String {
        guard let selected = fromListViewModel?.selected(), let currency = selected.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let available = fromListViewModel?.selected()?.available else { return "" }
        return available.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    func getRate() -> Double? {
        guard let rates = ratesModel?.rates, let fromCurrency = fromListViewModel.selected()?.currency, fromCurrency != Currency.gvt else { return nil }
        
        let rate = rates.GVT?.first(where: { $0.currency == fromCurrency })?.rate
        
        return rate != 0 ? rate : nil
    }
    func getApproxString(_ value: Double) -> String {
        let currency = CurrencyType.gvt
        guard let rate = getRate() else { return "" }
        
        
        let text = "≈" + (value / rate).rounded(with: currency).toString() + " " + currency.rawValue
        return text
    }
    
    func exchangeValueInCurrency(_ value: Double) -> Double? {
        guard let rate = getRate() else { return nil }
        return value / rate
    }
    func createFund(completion: @escaping CompletionBlock) {
        saveProfilePhoto { [weak self] (result) in
            switch result {
            case .success:
                AssetsDataProvider.createFund(self?.request, completion: completion)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    func updateWallet(_ index: Int) {
        request.depositWalletId = fromListViewModel?.selected()?.id
        updateRates()
    }
    
    // MARK: - Public methods
    func saveProfilePhoto(completion: @escaping (CompletionBlock)) {
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

class AssetCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var selectedIndex: Int = 0

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundAssetCollectionViewCellViewModel.self]
    }

    var assets = [PlatformAsset]() {
        didSet {
            viewModels = [FundAssetCollectionViewCellViewModel]()
            var value = 0.0
            assets.forEach { (asset) in
                value += asset.mandatoryFundPercent ?? 0
                viewModels.append(FundAssetCollectionViewCellViewModel(assetModel: asset))
            }
            
            if value < 100 {
                viewModels.append(FundAssetCollectionViewCellViewModel(assetModel: PlatformAsset(id: nil, name: nil, asset: nil, description: nil, icon: nil, color: nil, mandatoryFundPercent: 100 - value)))
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
        return 70.0
    }
    
    func makeLayout() -> UICollectionViewLayout {
        return CustomLayout.defaultLayout(3, pagging: false)
    }
    
    
}
protocol AddAssetListViewModelProtocol: class {
    func addAssets(_ assets: [PlatformAsset]?)
}
final class AddAssetListViewModel: ViewModelWithListProtocol {
    var title = "Add assets"
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AddFundAssetTableViewCellViewModel.self]
    }
    
    var assets: [PlatformAsset] = [PlatformAsset]()
    weak var delegate: AddAssetListViewModelProtocol?

    func setup(_ delegate: AddAssetListViewModelProtocol?) {
        self.delegate = delegate
        
        PlatformManager.shared.getPlatformAssets { [weak self] (model) in
            if let assets = model?.assets {
                self?.assets = assets
                self?.updateAssets()
            }
        }
    }
    
    func updateAssets() {
        var models = [AddFundAssetTableViewCellViewModel]()
        
        assets.sort { $0.asset ?? "" < $1.asset ?? "" }
        assets.sort { $0.mandatoryFundPercent! > $1.mandatoryFundPercent! }
        
        assets.forEach { (asset) in
            models.append(AddFundAssetTableViewCellViewModel(assetModel: asset, delegate: self))
        }
        
        viewModels = models
        
        let addedAssets = assets.filter({ $0.mandatoryFundPercent! > 0 })
        self.delegate?.addAssets(addedAssets)
    }
    
    
}
extension AddAssetListViewModel: AddFundAssetTableViewCellProtocol {
    func confirmAsset(_ asset: PlatformAsset?) {
        guard let asset = asset else { return }

        if let index = assets.firstIndex(where: { $0.asset == asset.asset }) {
            assets.remove(at: index)
        }
        assets.append(asset)
        
        updateAssets()
    }
}
