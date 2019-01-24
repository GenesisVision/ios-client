//
//  CreateNotificationViewController.swift
//  genesisvision-ios
//
//  Created by George on 26/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class CreateNotificationViewController: BaseViewController {
    
    var viewModel: CreateNotificationViewModel!
    
    var enteredProfitValue: Double = 0.0 {
        didSet {
            viewModel.enteredProfitValue = enteredProfitValue
            updateUI()
        }
    }
    
    // MARK: - Labels
    @IBOutlet weak var typeTitleLabel: SubtitleLabel! {
        didSet {
            typeTitleLabel.text = "Type"
        }
    }
    
    @IBOutlet weak var levelTitleLabel: SubtitleLabel! {
        didSet {
            levelTitleLabel.text = "Select level"
        }
    }
    
    @IBOutlet weak var profitTitleLabel: SubtitleLabel! {
        didSet {
            profitTitleLabel.text = "Enter amount"
        }
    }
    
    @IBOutlet weak var profitAmountValueLabel: TitleLabel! {
        didSet {
            profitAmountValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    
    // MARK: - Views
    @IBOutlet var levelButtons: [LevelFilterButton]!
    
    @IBOutlet weak var numpadHeightConstraint: NSLayoutConstraint! {
        didSet {
            numpadHeightConstraint.constant = 0.0
        }
    }
    
    @IBOutlet weak var numpadBackView: UIView! {
        didSet {
            numpadBackView.isHidden = true
            numpadBackView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideNumpadView))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.delegate = self
            numpadBackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.isUserInteractionEnabled = true
            numpadView.delegate = self
            numpadView.type = .number
        }
    }
    
    @IBOutlet weak var typeStackView: UIStackView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTypeButtonAction))
            tapGesture.numberOfTapsRequired = 1
            typeStackView.isUserInteractionEnabled = true
            typeStackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var profitStackView: UIStackView! {
        didSet {
            profitStackView.isHidden = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showNumPadButtonAction))
            tapGesture.numberOfTapsRequired = 1
            profitStackView.isUserInteractionEnabled = true
            profitStackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var levelStackView: UIStackView! {
        didSet {
            levelStackView.isHidden = true
        }
    }
    
    // MARK: - TextFields
    @IBOutlet weak var typeTextField: DesignableUITextField! {
        didSet {
            typeTextField.setClearButtonWhileEditing()
            typeTextField.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var createButton: ActionButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        createButton.setEnabled(false)
        setupButtons()
        updateUI()
    }
    
    private func setupButtons() {
        var idx = 1
        levelButtons.forEach { (btn) in
            btn.setTitle("\(idx)", for: .normal)
            btn.tag = idx
            idx += 1
        }
        
        updateLevelButtons()
    }
    
    private func updateLevelButtons() {
        levelButtons.forEach { (btn) in
            btn.isSelected = btn.tag == viewModel.selectedLevel ? true : false
        }
    }
    
    private func updateUI() {
        typeTextField.text = viewModel.selectedType.rawValue
        
        levelStackView.isHidden = viewModel.selectedType == .profit
        profitStackView.isHidden = viewModel.selectedType == .level
        
        createButton.setEnabled(viewModel.createButtonEnabled())
    }
    
    @objc private func showNumPadButtonAction() {
        self.view.endEditing(true)
        
        numpadHeightConstraint.constant = 212.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.numpadBackView.layoutIfNeeded()
        })
    }
    
    @objc private func hideNumpadView() {
        numpadHeightConstraint.constant = 0.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.numpadBackView.layoutIfNeeded()
        })
    }
    
    private func createMethod() {
        showProgressHUD()
        
        viewModel.createNotification { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func showTypes() {
        self.view.endEditing(true)
        
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        
        var selectedIndexRow = viewModel.selectedTypeIndex
        let values = viewModel.typeValues
        
        let pickerViewValues: [[String]] = [values.map { $0 }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndexRow)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            selectedIndexRow = index.row
            self?.viewModel.updateSelectedTypeIndex(selectedIndexRow)
            
            self?.updateUI()
        }
        
        alert.addAction(title: "Ok", style: .cancel)
        
        alert.show()
    }
    
    @objc private func showTypeButtonAction() {
        showTypes()
    }
    
    // MARK: - Actions
    @IBAction func createButtonAction(_ sender: UIButton) {
        createMethod()
    }
    
    @IBAction func changeSelectedLevelButtonAction(_ sender: UIButton) {
        viewModel.selectedLevel = sender.tag
        updateLevelButtons()
    }
}

extension CreateNotificationViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        return viewModel.maxProfitAmount
    }
    
    var minAmount: Double? {
        return viewModel.minProfitAmount
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return -1
    }
    
    var currency: CurrencyType? {
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.profitAmountValueLabel
    }
    
    var enteredAmountValue: Double {
        return enteredProfitValue
    }
    
    func textLabelDidChange(value: Double?) {
        guard let value = value else { return }
        
        numpadView.isEnable = true
        enteredProfitValue = value
    }
}

extension CreateNotificationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
