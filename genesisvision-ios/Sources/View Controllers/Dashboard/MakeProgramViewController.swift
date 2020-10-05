//
//  MakeProgramViewController.swift
//  genesisvision-ios
//
//  Created by George on 03.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class MakeProgramViewController: BaseModalViewController {
    typealias ViewModel = MakeProgramViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: MakeProgramStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg

        setup()
    }
    
    func setup() {
        stackView.limitView.limitSwitch.addTarget(self, action: #selector(limitSwitchChanged), for: .valueChanged)
        viewModel = MakeProgramViewModel(self)
        
        showProgressHUD()
        viewModel.fetch()
        
        stackView.nameView.textField.delegate = self
        stackView.nameView.textField.designableTextFieldDelegate = self
        stackView.nameView.textField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        stackView.nameView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        
        stackView.descriptionView.textView.textContainerInset = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: -6)
        stackView.descriptionView.textView.delegate = self
        stackView.descriptionView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        
        stackView.stopOutView.textField.designableTextFieldDelegate = self
        stackView.stopOutView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        
        stackView.entryFeeView.textField.designableTextFieldDelegate = self
        stackView.entryFeeView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        stackView.successFeeView.textField.designableTextFieldDelegate = self
        stackView.successFeeView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        
        stackView.entryFeeView.textField.text = "0"
        stackView.successFeeView.textField.text = "0"
    }
    
    func updateUI() {
        stackView.configure(viewModel)
    }
    @objc func limitSwitchChanged(_ sender: UISwitch) {
        stackView.limitView.amountView.isHidden = sender.isOn
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
        guard let name = stackView.nameView.textField.text,
            let description = stackView.descriptionView.textView.text,
            let stopOut = stackView.stopOutView.textField.text,
            let successFee = stackView.successFeeView.textField.text,
            let entryFee = stackView.entryFeeView.textField.text else { return }
        
        let value = name.count >= 4 && name.count <= 20 && description.count >= 20 && description.count <= 500 && !stopOut.isEmpty && !successFee.isEmpty && !entryFee.isEmpty
        
        stackView.actionButton.setEnabled(value)
    }
    
    // MARK: - Actions
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        showImagePicker()
    }
    @IBAction func makeProgramButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let title = stackView.nameView.textField.text {
            viewModel.request.title = title
        }
        if let description = stackView.descriptionView.textView.text {
            viewModel.request._description = description
        }
        if let entryFee = stackView.entryFeeView.textField.text?.doubleValue {
            viewModel.request.managementFee = entryFee
        }
        if let successFee = stackView.successFeeView.textField.text?.doubleValue {
            viewModel.request.successFee = successFee
        }
        if let stopOutLevel = stackView.stopOutView.textField.text?.doubleValue {
            viewModel.request.stopOutLevel = stopOutLevel
        }
        if let investmentLimit = stackView.limitView.textField.text?.doubleValue {
            viewModel.request.investmentLimit = investmentLimit
        }
        
        showProgressHUD()
        viewModel.makeProgram { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    @IBAction func selectPeriodButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.periodsViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.periodsViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.periodsDataSource
            tableView.dataSource = viewModel.periodsDataSource
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func selectTradesDelayButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.tradesDelayViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.tradesDelayViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.tradesDelayDataSource
            tableView.dataSource = viewModel.tradesDelayDataSource
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
}

extension MakeProgramViewController: UITextFieldDelegate, DesignableUITextFieldDelegate {
    func textFieldDidClear(_ textField: UITextField) {
        stackView.nameView.subtitleValueLabel.text = "0 / 20"
        stackView.nameView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        checkActionButton()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkActionButton()
    }
}

extension MakeProgramViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = stackView.descriptionView.textView.text {
            let max = 500
            let count = text.count
            stackView.descriptionView.subtitleValueLabel.text = "\(count) / \(max)"
            stackView.descriptionView.subtitleValueLabel.textColor = count < 20 || count > 500 ? UIColor.Common.red : UIColor.Cell.subtitle
        }
    }
}

extension MakeProgramViewController: ImagePickerPresentable {
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
        stackView.uploadLogoView.logoStackView.layoutSubviews()
        stackView.uploadLogoView.layoutSubviews()
        stackView.layoutSubviews()
    }
}

extension MakeProgramViewController: BaseTableViewProtocol {
    func didReload() {
        hideAll()
        updateUI()
    }
    
    func didSelect(_ type: DidSelectType, index: Int) {
        self.view.endEditing(true)
        bottomSheetController.dismiss()

        switch type {
        case .periods:
            viewModel.updatePeriods(index)
        case .tradesDelay:
            viewModel.updateTrades(index)
        default:
            break
        }
        
        updateUI()
    }
}

extension TradesDelay {
    func getValue() -> String {
        switch self {
        case ._none:
            return "Without"
        case .fiveMinutes:
            return "5 minutes"
        case .fifteenMinutes:
            return "15 minutes"
        case .thirtyMinutes:
            return "30 minutes"
        case .oneHour:
            return "1 hour"
        case .sixHours:
            return "6 hours"
        }
    }
}
class MakeProgramViewModel {
    // MARK: - Variables
    var pickedImage: UIImage?
    var pickedImageURL: URL?
    var uploadedUuidString: String? {
        didSet {
            request.logo = uploadedUuidString
        }
    }
    
    var periodsViewModel: PeriodListViewModel!
    var periodsDataSource: TableViewDataSource!
    
    var tradesDelayViewModel: TradesDelayListViewModel!
    var tradesDelayDataSource: TableViewDataSource!
    
    var programAssetPlatformInfo: ProgramAssetPlatformInfo? {
        didSet {
            if let periods = programAssetPlatformInfo?.periods {
                periodsViewModel = PeriodListViewModel(delegate, items: periods, selectedIndex: 0)
                periodsDataSource = TableViewDataSource(periodsViewModel)
                delegate?.didReload()
            }
        }
    }
    
    lazy var currency = getPlatformCurrencyType()
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    
    var request = MakeTradingAccountProgram(_id: nil, periodLength: nil, stopOutLevel: nil, investmentLimit: nil, tradesDelay: nil, successFee: nil, managementFee: nil, title: nil, _description: nil, logo: nil)
    
    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
        
        let trades: [TradesDelay] = [._none, .fiveMinutes, .fifteenMinutes, .thirtyMinutes, .oneHour, .sixHours]
        tradesDelayViewModel = TradesDelayListViewModel(delegate, items: trades, selectedIndex: 0)
        tradesDelayDataSource = TableViewDataSource(tradesDelayViewModel)
    }
    
    func fetch() {
        PlatformManager.shared.getPlatformInfo { [weak self] (model) in
            guard let model = model?.assetInfo?.programInfo else { return }
            self?.programAssetPlatformInfo = model
        }
    }
    
    func makeProgram(completion: @escaping CompletionBlock) {
        saveProfilePhoto { [weak self] (result) in
            switch result {
            case .success:
                AssetsDataProvider.makeAccountProgram(self?.request, completion: completion)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    func updatePeriods(_ index: Int) {
        periodsViewModel.selectedIndex = index
        if let selected = periodsViewModel.selected() {
            request.periodLength = selected
        }
    }
    func updateTrades(_ index: Int) {
        tradesDelayViewModel.selectedIndex = index
        if let selected = tradesDelayViewModel.selected() {
            request.tradesDelay = selected
        }
    }
    func getPeriods() -> String {
        guard let selected = periodsViewModel?.selected()?.toString() else { return "" }
        return selected
    }
    func isEnablePeriodsSelector() -> Bool {
        guard let count = periodsViewModel?.items.count else { return false }
        return count > 1
    }
    func getTrades() -> String {
        guard let selected = tradesDelayViewModel?.selected()?.rawValue else { return "" }
        return selected
    }
    func isEnableTradesSelector() -> Bool {
        guard let count = tradesDelayViewModel?.items.count else { return false }
        return count > 1
    }
    // MARK: - Public methods
    func saveProfilePhoto(completion: @escaping CompletionBlock) {
        
        guard let pickedImage = pickedImage?.pngData() else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        BaseDataProvider.uploadImage(imageData: pickedImage, imageLocation: .asset, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedUuidString = uuidString
            completion(.success)
        }, errorCompletion: completion)
    }
}
class PeriodListViewModel: SelectableListViewModel<Int> {
    var title = "Choose period"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item.toString(), selected: isSelected)

        return cell
    }
    
}
class TradesDelayListViewModel: SelectableListViewModel<TradesDelay> {
    var title = "Choose trades delay"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item.rawValue, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)

        delegate?.didSelect(.tradesDelay, index: indexPath.row)
    }
}
