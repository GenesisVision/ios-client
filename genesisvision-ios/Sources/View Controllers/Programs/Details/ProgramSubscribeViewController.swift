//
//  ProgramSubscribeViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramSubscribeViewController: BaseViewController {
    
    var viewModel: ProgramSubscribeViewModel!
    
    // MARK: - Labels
    //Account Type
    @IBOutlet weak var accountTypeStackView: UIStackView! {
        didSet {
            accountTypeStackView.isHidden = false
        }
    }
    
    @IBOutlet weak var accountTypeTitleLabel: SubtitleLabel! {
        didSet {
            accountTypeTitleLabel.text = "From"
        }
    }
    @IBOutlet weak var accountTypeButton: UIButton!
    @IBOutlet weak var accountTypeValueLabel: TitleLabel! {
        didSet {
            accountTypeValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    //Type
    @IBOutlet weak var typeTitleLabel: SubtitleLabel! {
        didSet {
            typeTitleLabel.text = "Type"
        }
    }
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var typeValueLabel: TitleLabel! {
        didSet {
            typeValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var typeDescriptionLabel: SubtitleLabel! {
        didSet {
            typeDescriptionLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var subscriptionStackView: UIStackView! {
        didSet {
            subscriptionStackView.isHidden = true
        }
    }
    
    //usd
    @IBOutlet weak var usdStackView: UIStackView! {
        didSet {
            usdStackView.isHidden = true
        }
    }
    @IBOutlet weak var usdTitleLabel: SubtitleLabel! {
        didSet {
            usdTitleLabel.text = "USD equivalent *"
        }
    }
    
    @IBOutlet weak var usdTextField: InputTextField! {
        didSet {
            usdTextField.delegate = self
            usdTextField.addTarget(self, action: #selector(usdTextFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var usdSubtitleLabel: SubtitleLabel! {
        didSet {
            usdSubtitleLabel.isHidden = true
            usdSubtitleLabel.text = "* The minimum order size on Binance is 10 USDT"
            usdSubtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    
    //TODO: approximate value with rate etc
    @IBOutlet weak var usdCurrencyValueLabel: SubtitleLabel! {
        didSet {
            usdCurrencyValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    //Volume
    @IBOutlet weak var volumeStackView: UIStackView! {
        didSet {
            volumeStackView.isHidden = true
        }
    }
    @IBOutlet weak var volumeTextField: InputTextField! {
        didSet {
            volumeTextField.delegate = self
            volumeTextField.addTarget(self, action: #selector(volumeTextFieldDidChange), for: .editingChanged)
        }
    }
    
    //Tolerance
    @IBOutlet weak var toleranceTitleLabel: SubtitleLabel! {
        didSet {
            toleranceTitleLabel.text = "Tolerance percentage (%)"
        }
    }
    @IBOutlet weak var toleranceTextField: InputTextField! {
        didSet {
            toleranceTextField.delegate = self
            toleranceTextField.addTarget(self, action: #selector(toleranceTextFieldDidChange), for: .editingChanged)
        }
    }
    
    //Max buttons
    @IBOutlet weak var volumeMaxValueButton: UIButton! {
        didSet {
            volumeMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            volumeMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet weak var toleranceMaxValueButton: UIButton! {
        didSet {
            toleranceMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            toleranceMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    
    // MARK: - Buttons
    @IBOutlet weak var subscribeButton: ActionButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        switch viewModel.followType {
        case .follow:
            navigationItem.title = "Follow trades"
        case .unfollow:
            navigationItem.title = "Unfollow trades"
        case .edit:
            navigationItem.title = "Trading settings"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        switch viewModel.followType {
        case .follow, .edit:
            subscriptionStackView.isHidden = false
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.configure(with: .normal)
        case .unfollow:
            subscriptionStackView.isHidden = true
            subscribeButton.setTitle("Submit", for: .normal)
            subscribeButton.configure(with: .darkClear)
        }
        viewModel.fetch { (result) in
            switch result {
                
            case .success:
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func updateUI() {
        self.accountTypeTitleLabel.text = viewModel.getSelectedAccountType()
        self.typeValueLabel.text = viewModel.getSelectedType()
        self.typeDescriptionLabel.text = viewModel.getSelectedDescription()
        
        switch viewModel.followType {
        case .follow, .edit:
            self.volumeTextField.text = viewModel.volume.toString()
            self.toleranceTextField.text = viewModel.tolerance.toString()
            self.usdTextField.text = viewModel.usd.toString()
        case .unfollow:
            break
        }
        
        //TODO: approximate value
//        self.usdCurrencyValueLabel.text = viewModel.getFixedCurrency()
        
        self.updatedMode()
    }
    
    private func subscribeMethod(completion: @escaping CompletionBlock) {
        showProgressHUD()
        
        switch viewModel.followType {
        case .follow:
            viewModel.subscribe(completion: completion)
        case .unfollow:
            viewModel.unsubscribe(completion: completion)
        case .edit:
            viewModel.update(completion: completion)
        }
    }
    
    private func updatedMode() {
        typeValueLabel.text = viewModel.getSelectedType()
        
        if viewModel.followType == .unfollow { return }
        
        usdStackView.isHidden = true
        volumeStackView.isHidden = true
        usdSubtitleLabel.isHidden = true
        
        switch viewModel.getMode() {
        case .byBalance:
            usdStackView.isHidden = true
            volumeStackView.isHidden = true
        case .percent:
            volumeStackView.isHidden = false
        case .fixed:
            usdStackView.isHidden = false
            usdSubtitleLabel.isHidden = false
        }
    }
    
    @objc private func usdTextFieldDidChange(_ textField: UITextField) {
        //TODO: add USD value
    }

    @objc private func volumeTextFieldDidChange(_ textField: UITextField) {
        //TODO: add %
    }
    
    @objc private func toleranceTextFieldDidChange(_ textField: UITextField) {
        //TODO: add %
    }
    
    private func showFollowTypes() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: "By balance", style: .default) { [weak self] (action) in
            self?.viewModel.changeMode(.byBalance)
            self?.updateUI()
        }
        alert.addAction(firstAction)
        
        let secondAction = UIAlertAction(title: "Percentage", style: .default) { [weak self] (action) in
            self?.viewModel.changeMode(.percent)
            self?.updateUI()
        }
        alert.addAction(secondAction)
        
        let thirdAction = UIAlertAction(title: "Fixed", style: .default) { [weak self] (action) in
            self?.viewModel.changeMode(.fixed)
            self?.updateUI()
        }
        alert.addAction(thirdAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showUnfollowTypes() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: "Manual closing", style: .default) { [weak self] (action) in
            self?.viewModel.changeReason(._none)
            self?.updateUI()
        }
        alert.addAction(firstAction)
        
        let secondAction = UIAlertAction(title: "Close only", style: .default) { [weak self] (action) in
            self?.viewModel.changeReason(.providerCloseOnly)
            self?.updateUI()
        }
        alert.addAction(secondAction)
        
        let thirdAction = UIAlertAction(title: "Close all immediately", style: .default) { [weak self] (action) in
            self?.viewModel.changeReason(.closeAllImmediately)
            self?.updateUI()
        }
        alert.addAction(thirdAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func changeTypeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        switch viewModel.followType {
        case .follow:
            showFollowTypes()
        case .unfollow:
            showUnfollowTypes()
        case .edit:
            showFollowTypes()
        }
    }
    
    @IBAction func selectAccountButtonAction(_ sender: UIButton) {
        
        guard viewModel.tradingAccountListViewModel != nil else { return }
        
        self.view.endEditing(true)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.tradingAccountListViewModel!.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none
            
            tableView.registerNibs(for: viewModel.tradingAccountListViewModel!.cellModelsForRegistration)
            tableView.delegate = viewModel.tradingAccountListDataSource
            tableView.dataSource = viewModel.tradingAccountListDataSource
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    
    @IBAction func subscribeButtonAction(_ sender: UIButton) {
        subscribeMethod { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.viewModel.goToBack()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
        
    @IBAction func volumeMaxButtonAction(_ sender: UIButton) {
        let maxValue = 999.0
        viewModel.volume = maxValue
        volumeTextField.text = viewModel.volume.toString()
    }
    
    @IBAction func toleranceMaxButtonAction(_ sender: UIButton) {
        let maxValue = 20.0
        viewModel.tolerance = maxValue
        toleranceTextField.text = viewModel.tolerance.toString()
    }
}

extension ProgramSubscribeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let newValue = textField.text?.doubleValue else { return }
        
        switch textField {
        case usdTextField:
            viewModel.usd = newValue
        case volumeTextField:
            viewModel.volume = newValue
        case toleranceTextField:
            viewModel.tolerance = newValue
        default:
            break
        }
    }
}

extension ProgramSubscribeViewController: BaseTableViewProtocol {
    
}
