//
//  DateRangeView.swift
//  genesisvision-ios
//
//  Created by George on 06/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol DateRangeViewProtocol: class {
    var dateRange: FilterDateRangeModel? { get set }

    func applyButtonDidPress(from dateFrom: Date?, to dateTo: Date?)
    func showDatePicker(from dateFrom: Date, to dateTo: Date, isFrom: Bool)
}

class DateRangeView: UIView {
    // MARK: - Variables
    weak var delegate: DateRangeViewProtocol?
    
    var dateRangeType: DateRangeType = .week
    
    var dateFrom: Date? {
        didSet {
            guard let dateFrom = dateFrom else {
                return dateFromTextField.text = "Start date"
            }
            
            dateFromTextField.text = dateFrom.onlyDateFormatString
        }
    }
    var dateTo: Date? {
        didSet {
            guard let dateTo = dateTo else {
                return dateToTextField.text = "Today"
            }
            
            dateToTextField.text = dateTo.onlyDateFormatString
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var dayButton: DateRangeButton! {
        didSet {
            let dateRangeType = DateRangeType.day
            dayButton.setTitle(dateRangeType.getButtonTitle(), for: .normal)
            dayButton.tag = dateRangeType.rawValue
        }
    }
    @IBOutlet weak var weekButton: DateRangeButton! {
        didSet {
            let dateRangeType = DateRangeType.week
            weekButton.setTitle(dateRangeType.getButtonTitle(), for: .normal)
            weekButton.tag = dateRangeType.rawValue
        }
    }
    @IBOutlet weak var monthButton: DateRangeButton! {
        didSet {
            let dateRangeType = DateRangeType.month
            monthButton.setTitle(dateRangeType.getButtonTitle(), for: .normal)
            monthButton.tag = dateRangeType.rawValue
        }
    }
    @IBOutlet weak var yearButton: DateRangeButton! {
        didSet {
            let dateRangeType = DateRangeType.year
            yearButton.setTitle(dateRangeType.getButtonTitle(), for: .normal)
            yearButton.tag = dateRangeType.rawValue
        }
    }
    @IBOutlet weak var allTimeButton: DateRangeButton! {
        didSet {
            let dateRangeType = DateRangeType.allTime
            allTimeButton.setTitle(dateRangeType.getButtonTitle(), for: .normal)
            allTimeButton.tag = dateRangeType.rawValue
        }
    }
    @IBOutlet weak var customButton: DateRangeButton! {
        didSet {
            let dateRangeType = DateRangeType.custom
            customButton.setTitle(dateRangeType.getButtonTitle(), for: .normal)
            customButton.tag = dateRangeType.rawValue
        }
    }
    
    @IBOutlet weak var dateFromTitleLabel: UILabel!
    @IBOutlet weak var dateToTitleLabel: UILabel!
    
    @IBOutlet weak var dateFromTextField: DesignableUITextField! {
        didSet {
            dateFromTextField.addPadding()
            dateFromTextField.backgroundColor = UIColor.DateRangeView.textfieldBg
            dateFromTextField.isUserInteractionEnabled = true
            dateFromTextField.isEnabled = true
            dateFromTextField.delegate = self
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateFromTextFieldEditing))
            tapGesture.numberOfTapsRequired = 1
            dateFromTextField.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var dateToTextField: DesignableUITextField! {
        didSet {
            dateToTextField.addPadding()
            dateToTextField.backgroundColor = UIColor.DateRangeView.textfieldBg
            dateToTextField.isUserInteractionEnabled = true
            dateToTextField.isEnabled = true
            dateToTextField.delegate = self
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateToTextFieldEditing))
            tapGesture.numberOfTapsRequired = 1
            dateToTextField.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var applyButton: ActionButton!
    
    var buttons = [DateRangeButton]()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttons = [dayButton, weekButton, monthButton, yearButton, allTimeButton, customButton]
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setup()
    }
    
    // MARK: - Public methods
    func reset() {
        dateRangeType = .week
        changeDateRangeType()
    }
    // MARK: - Private methods
    private func setup() {
        guard let dateRange = delegate?.dateRange else { return }
        
        dateRangeType = dateRange.dateRangeType
        
        if dateRangeType == .custom {
            self.dateFrom = dateRange.dateFrom
            self.dateTo = dateRange.dateTo
            changeDateRangeType()
            return
        }
        
        changeDateRangeType()
        updateTime()
    }
    private func changeDateRangeType() {
        for button in buttons {
            button.isSelected = false
        }
        
        switch dateRangeType {
        case .day:
            dateTo = Date()
            dateFrom = dateTo?.previousDate()
            dayButton.isSelected = true
        case .week:
            dateTo = Date()
            dateFrom = dateTo?.removeDays(7)
            weekButton.isSelected = true
        case .month:
            dateTo = Date()
            dateFrom = dateTo?.removeMonths(1)
            monthButton.isSelected = true
        case .year:
            dateTo = Date()
            dateFrom = dateTo?.removeYears(1)
            yearButton.isSelected = true
        case .allTime:
            dateFrom = nil
            dateTo = nil
            allTimeButton.isSelected = true
        case .custom:
            if dateTo == nil {
                dateTo = Date()
            }
            if dateFrom == nil {
                dateFrom = dateTo?.removeDays(7)
            }
            customButton.isSelected = true
        }
    }
    
    private func updateTime() {
        delegate?.dateRange?.dateRangeType = dateRangeType
        delegate?.dateRange?.dateFrom = dateFrom
        delegate?.dateRange?.dateTo = dateTo
    }
    
    @objc private func dateFromTextFieldEditing() {
        changeDateRangeTypeButtonAction(customButton)
        
        guard dateRangeType == .custom, let dateTo = dateTo, let dateFrom = dateFrom else { return }
        
        delegate?.showDatePicker(from: dateFrom, to: dateTo, isFrom: true)
    }
    
    @objc private func dateToTextFieldEditing() {
        changeDateRangeTypeButtonAction(customButton)
        
        guard dateRangeType == .custom, let dateTo = dateTo, let dateFrom = dateFrom else {
            return
        }
        
        delegate?.showDatePicker(from: dateFrom, to: dateTo, isFrom: false)
    }
    
    // MARK: - Actions
    @IBAction func changeDateRangeTypeButtonAction(_ sender: UIButton) {
        sender.isSelected = true
        dateRangeType = DateRangeType(rawValue: sender.tag)!
        changeDateRangeType()
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        updateTime()
        
        delegate?.applyButtonDidPress(from: delegate?.dateRange?.dateFrom, to: delegate?.dateRange?.dateTo)
    }
}

extension DateRangeView: BottomSheetControllerProtocol {
    func didHide() {
        
    }
}

extension DateRangeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
