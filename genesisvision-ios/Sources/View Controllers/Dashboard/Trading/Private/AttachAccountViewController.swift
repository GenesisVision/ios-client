//
//  AttachAccountViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class AttachAccountViewController: BaseModalViewController {
    typealias ViewModel = AttachAccountViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: AttachStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        setup()
    }
    
    func setup() {
        viewModel = AttachAccountViewModel(self)
        
        showProgressHUD()
        viewModel.fetch()
        
        stackView.apiKeyView.textField.designableTextFieldDelegate = self
        stackView.apiKeyView.textField.delegate = self
        stackView.apiKeyView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        stackView.apiSecretView.textField.designableTextFieldDelegate = self
        stackView.apiSecretView.textField.delegate = self
        stackView.apiSecretView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
    }
    
    func updateUI() {
        stackView.configure(viewModel)
    }
    
    @objc func checkActionButton() {
        guard let apiKey = stackView.apiKeyView.textField.text,
            let apiSecret = stackView.apiSecretView.textField.text else { return }
        
        let value = !apiKey.isEmpty && !apiSecret.isEmpty
        
        stackView.actionButton.setEnabled(value)
    }
    // MARK: - Actions
    @IBAction func attachAccountButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let key = stackView.apiKeyView.textField.text {
            viewModel.request.key = key
        }
        if let secret = stackView.apiSecretView.textField.text {
            viewModel.request.secret = secret
        }
        
        showProgressHUD()
        viewModel.attachAccount { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    @IBAction func selectExchangeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.exchangeListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.exchangeListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.exchangeListDataSource
            tableView.dataSource = viewModel.exchangeListDataSource
            tableView.reloadData()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
}
extension AttachAccountViewController: DesignableUITextFieldDelegate, UITextFieldDelegate {
    func textFieldDidClear(_ textField: UITextField) {
        checkActionButton()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkActionButton()
    }
}
extension AttachAccountViewController: BaseTableViewProtocol {
    func didSelect(_ type: DidSelectType, index: Int) {
        self.view.endEditing(true)
        bottomSheetController.dismiss()
        
        switch type {
        case .exchange:
            viewModel.updateExchange(index)
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

class AttachAccountViewModel {
    // MARK: - Variables
    var exchangeListViewModel: ExchangeListViewModel!
    var exchangeListDataSource: TableViewDataSource!
    
    var brokersInfo: BrokersInfo? {
        didSet {
            if let brokers = brokersInfo?.brokers {
                exchangeListViewModel = ExchangeListViewModel(delegate, items: brokers, selectedIndex: 0)
                exchangeListDataSource = TableViewDataSource(exchangeListViewModel)
                request.brokerAccountTypeId = exchangeListViewModel.selected()?.accountTypes?.first?.id
                delegate?.didReload()
            }
        }
    }
    
    var request = NewExternalTradingAccountRequest(brokerAccountTypeId: nil, key: nil, secret: nil)
    var createResultModel: TradingAccountCreateResult?
    
    lazy var currency = getPlatformCurrencyType()
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    
    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
    }
    
    func fetch() {
        BrokersDataProvider.getBrokersExternal(completion: { [weak self] (model) in
            self?.brokersInfo = model
        }, errorCompletion: errorCompletion)
    }
    func updateExchange(_ index: Int) {
        exchangeListViewModel.selectedIndex = index
        request.brokerAccountTypeId = exchangeListViewModel.selected()?.accountTypes?.first?.id
    }
    func attachAccount(completion: @escaping CompletionBlock) {
        AssetsDataProvider.createExternalTradingAccount(request, completion: { [weak self] (model) in
            self?.createResultModel = model
            completion(.success)
        }, errorCompletion: completion)
    }
    func getExchange() -> String {
        guard let selected = exchangeListViewModel?.selected()?.name else { return "" }
        return selected
    }
    func isEnableExchangeSelector() -> Bool {
        guard let count = exchangeListViewModel?.items.count else { return false }
        return count > 1
    }
}
