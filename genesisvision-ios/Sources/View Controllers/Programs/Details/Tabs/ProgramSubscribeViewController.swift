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
            usdTitleLabel.text = "USD equivalent*"
        }
    }
    @IBOutlet weak var usdTextField: InputTextField! {
        didSet {
            usdTextField.delegate = self
            usdTextField.addTarget(self, action: #selector(usdTextFieldDidChange), for: .editingChanged)
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
    
    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.isHidden = true
            disclaimerLabel.text = "* The minimum order size on Binance is 10 USDT"
            disclaimerLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var subscribeButton: ActionButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.followType == .follow ? "Follow trades" : "Unfollow trades"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        subscriptionStackView.isHidden = viewModel.followType == .unfollow
        subscribeButton.setTitle(viewModel.followType == .follow ? "Subscribe" : "Submit", for: .normal)
        subscribeButton.configure(with: viewModel.followType == .follow ? .normal : .darkClear)
        
        updateUI()
    }
    
    
    private func updateUI() {
        self.typeValueLabel.text = viewModel.getSelected()
        self.typeDescriptionLabel.text = viewModel.getSelectedDescription()
        
        if viewModel.followType == .follow {
            self.volumeTextField.text = viewModel.volume.toString()
            self.toleranceTextField.text = viewModel.tolerance.toString()
            self.usdTextField.text = viewModel.usd.toString()
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
        }
    }
    
    private func updatedMode() {
        typeValueLabel.text = viewModel.getSelected()
        
        guard viewModel.followType == .follow else { return }
        
        usdStackView.isHidden = true
        volumeStackView.isHidden = true
        disclaimerLabel.isHidden = true
        
        switch viewModel.getMode() {
        case .byBalance:
            usdStackView.isHidden = true
            volumeStackView.isHidden = true
        case .percent:
            volumeStackView.isHidden = false
        case .fixed:
            usdStackView.isHidden = false
            disclaimerLabel.isHidden = false
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
        alert.view.tintColor = UIColor.Cell.headerBg
        
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
        alert.view.tintColor = UIColor.Cell.headerBg
        
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
        }
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
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
