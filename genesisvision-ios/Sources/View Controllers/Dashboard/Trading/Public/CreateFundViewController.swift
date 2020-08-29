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
    var viewModel: ViewModel?
    
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
        viewModel?.addAssetListViewModel.delegate = self
        viewModel?.updateRates()
        
        showProgressHUD()
        viewModel?.fetch()
        
        stackView.depositView.amountView.maxButton.addTarget(self, action: #selector(copyMaxValueButtonAction), for: .touchUpInside)
        
        stackView.depositView.amountView.textField.designableTextFieldDelegate = self
        stackView.depositView.amountView.textField.delegate = self
        stackView.depositView.amountView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        
        stackView.nameView.textField.delegate = self
        stackView.nameView.textField.keyboardType = .asciiCapable
        stackView.nameView.textField.designableTextFieldDelegate = self
        stackView.nameView.textField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        stackView.nameView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        
        stackView.descriptionView.textView.textContainerInset = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: -6)
        stackView.descriptionView.textView.keyboardType = .asciiCapable
        stackView.descriptionView.textView.delegate = self
        stackView.descriptionView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        
        stackView.entryFeeView.textField.text = "0"
        stackView.entryFeeView.textField.addTarget(self, action: #selector(feeDidChange), for: .editingChanged)
        stackView.exitFeeView.textField.text = "0"
        stackView.exitFeeView.textField.addTarget(self, action: #selector(feeDidChange), for: .editingChanged)
    }
    
    func updateUI() {
        if let viewModel = viewModel {
            stackView.configure(viewModel)
        }
    }
    
    @objc private func feeDidChange() {
        guard let entryFeeText = stackView.entryFeeView.textField.text, !entryFeeText.isEmpty, let exitFeeText = stackView.exitFeeView.textField.text, !exitFeeText.isEmpty else { return }
        
        if let entryFee = Int(entryFeeText) {
            if entryFee >= 10 {
                stackView.entryFeeView.textField.text = "10"
            } else {
                stackView.entryFeeView.textField.text = String(entryFee)
            }
        } else {
            stackView.entryFeeView.textField.text = "0"
        }
        
        if let exitFee = Int(exitFeeText) {
            if exitFee >= 10 {
                stackView.exitFeeView.textField.text = "10"
            } else {
                stackView.exitFeeView.textField.text = String(exitFee)
            }
        } else {
            stackView.exitFeeView.textField.text = "0"
        }
        
        checkActionButton()
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
        var isEnable = false
        
        if let value = stackView.nameView.textField.text {
            viewModel?.request.title = value
        }
        if let value = stackView.descriptionView.textView.text {
            viewModel?.request._description = value
        }
        if let value = stackView.exitFeeView.textField.text?.doubleValue {
            viewModel?.request.exitFee = value
        }
        if let value = stackView.entryFeeView.textField.text?.doubleValue {
            viewModel?.request.entryFee = value
        }
        if let value = stackView.depositView.amountView.textField.text?.doubleValue {
            viewModel?.request.depositAmount = value
            stackView.depositView.amountView.approxLabel.text = viewModel?.getApproxString(value)
        } else {
            stackView.depositView.amountView.approxLabel.text = ""
        }
        
        if
            let value = stackView.depositView.amountView.textField.text?.doubleValue,
            let minDeposit = viewModel?.getMinDepositValue(),
            let exchangedValue = viewModel?.exchangeValueInCurrency(value),
            exchangedValue >= minDeposit,
            let name = stackView.nameView.textField.text,
            let description = stackView.descriptionView.textView.text,
            stackView.exitFeeView.textField.text?.doubleValue != nil,
            stackView.entryFeeView.textField.text?.doubleValue != nil,
            4...20 ~= name.count,
            20...500 ~= description.count,
            viewModel?.addAssetListViewModel.isFull() ?? false {
            isEnable = true
        }
        
        stackView.actionButton.setEnabled(isEnable)
    }
    
    // MARK: - Actions
    @IBAction func addAssetButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 400.0

        bottomSheetController.addNavigationBar(viewModel?.addAssetListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            if let cellModelsForRegistration = viewModel?.addAssetListViewModel.cellModelsForRegistration {
                tableView.registerNibs(for: cellModelsForRegistration)
            }
            tableView.delegate = viewModel?.addAssetListDataSource
            tableView.dataSource = viewModel?.addAssetListDataSource
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        if let wallet = viewModel?.fromListViewModel?.selected(), let currency = wallet.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let availableInWalletFromValue = wallet.available {
            
            stackView.depositView.amountView.textField.text = availableInWalletFromValue.rounded(with: currencyType).toString(withoutFormatter: true)
        }
    }
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        showImagePicker()
    }
    @IBAction func createFundButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        showProgressHUD()
        viewModel?.createFund { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    @IBAction func selectWalletCurrencyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel?.fromListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none
            
            if let cellModelsForRegistration = viewModel?.fromListViewModel.cellModelsForRegistration {
                tableView.registerNibs(for: cellModelsForRegistration)
            }
            tableView.delegate = viewModel?.fromListDataSource
            tableView.dataSource = viewModel?.fromListDataSource
//            tableView.reloadDataSmoothly()
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
            viewModel?.updateWallet(index)
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
        
        viewModel?.request.assets = assets.map { FundAssetPart(_id: $0._id, percent: $0.mandatoryFundPercent ) }
        viewModel?.assetCollectionViewModel.assets = assets
        stackView.updateProgressView(assets)
        stackView.assetStackView.collectionView.reloadData()
        checkActionButton()
    }
}
extension CreateFundViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return stackView.uploadLogoView.uploadLogoButton
    }
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImage = pickedImage, let pickedImageURL = pickedImageURL else { return }
        
        viewModel?.pickedImage = pickedImage
        viewModel?.pickedImageURL = pickedImageURL
        
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
    var assetCollectionDataSource: CollectionViewDataSource!
    
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
                request.depositWalletId = fromListViewModel?.selected()?._id
            }
        }
    }
    var createFundInfo: FundCreateAssetPlatformInfo?
    var twoFactorStatus: TwoFactorStatus?
    lazy var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    var request = NewFundRequest(assets: nil, entryFee: nil, exitFee: nil, depositAmount: nil, depositWalletId: nil, title: nil, _description: nil, logo: nil)
    
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
        
        let rate = rates["GVT"]?.first(where: { $0.currency == fromCurrency })?.rate
        
        return rate != 0 ? rate : nil
    }
    
    func getApproxString(_ value: Double) -> String {
        let currency = CurrencyType.gvt
        guard let rate = getRate() else { return "" }
        
        
        let text = "≈" + (value / rate).rounded(with: currency).toString() + " " + currency.rawValue
        return text
    }
    
    func exchangeValueInCurrency(_ value: Double) -> Double? {
        guard let rate = getRate() else { return value }
        return value / rate
    }
    
    func createFund(completion: @escaping CompletionBlock) {
        guard let pickedImageUrl = pickedImageURL else {
            AssetsDataProvider.createFund(request, completion: completion)
            return
        }
        saveImage(pickedImageUrl) { [weak self] (result) in
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
        request.depositWalletId = fromListViewModel?.selected()?._id
        updateRates()
    }
    
    // MARK: - Public methods
    func saveImage(_ pickedImageURL: URL, completion: @escaping (CompletionBlock)) {
        BaseDataProvider.uploadImage(imageData: pickedImageURL.dataRepresentation, imageLocation: .fundAsset, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
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
                viewModels.append(FundAssetCollectionViewCellViewModel(assetModel: PlatformAsset(mandatoryFundPercent: 100 - value, _id: nil, name: nil, asset: nil, _description: nil, logoUrl: nil, color: nil, url: nil)))
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
        return 50.0
    }
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        return CGSize(width: frame.width * 0.35, height: frame.height)
    }
    func insetForSection(for section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
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

    init() {
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
    
    private func getMandatoryFundPercent() -> Double {
        let sum = assets.map({($0.mandatoryFundPercent ?? 0.0)}).reduce(0.0, +)
        return sum
    }
    
    private func getRemainFundBalancePercent() -> Double {
        return 100 - assets.map({($0.mandatoryFundPercent ?? 0.0)}).reduce(0.0, +)
    }
    
    func isFull() -> Bool {
        return getMandatoryFundPercent() == 100.0
    }
}
extension AddAssetListViewModel: AddFundAssetTableViewCellProtocol {
    func confirmAsset(_ asset: PlatformAsset?) -> Bool {
        guard let asset = asset else { return false }

        if let index = assets.firstIndex(where: { $0.asset == asset.asset }) {
            let oldAsset = assets[index]
            
            if let oldPercent = oldAsset.mandatoryFundPercent, let newPercent = asset.mandatoryFundPercent {
                if newPercent <= oldPercent {
                    assets.remove(at: index)
                } else if !isFull(), (newPercent - oldPercent) <= getRemainFundBalancePercent() {
                    assets.remove(at: index)
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        
        assets.append(asset)
        
        updateAssets()
        
        return true
    }
}
