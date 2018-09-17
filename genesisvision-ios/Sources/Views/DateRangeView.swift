//
//  DateRangeView.swift
//  genesisvision-ios
//
//  Created by George on 06/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol DateRangeViewProtocol: class {
    func applyButtonDidPress(with dateRangeType: DateRangeType, dateRangeFrom: Date, dateRangeTo: Date)
    func showDatePicker(with dateRangeFrom: Date?, dateRangeTo: Date)
}

class DateRangeView: UIView {
    // MARK: - Variables
    weak var delegate: DateRangeViewProtocol?
    
    var selectedDateRangeType: DateRangeType = .day {
        didSet {
            dateRangeTo = Date()
            updateDateFromMethod()
        }
    }
    
    var dateRangeFrom: Date = Date().previousDate() {
        didSet {
            dateRangeFromTextField.text = dateRangeFrom.onlyDateFormatString
        }
    }
    var dateRangeTo: Date = Date() {
        didSet {
            dateRangeToTextField.text = dateRangeTo.onlyDateFormatString
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet var dayButton: DateRangeButton! {
        didSet {
            dayButton.tag = DateRangeType.day.rawValue
        }
    }
    @IBOutlet var weekButton: DateRangeButton! {
        didSet {
            weekButton.tag = DateRangeType.week.rawValue
        }
    }
    @IBOutlet var monthButton: DateRangeButton! {
        didSet {
            monthButton.tag = DateRangeType.month.rawValue
        }
    }
    @IBOutlet var yearButton: DateRangeButton! {
        didSet {
            yearButton.tag = DateRangeType.year.rawValue
        }
    }
    @IBOutlet var customButton: DateRangeButton! {
        didSet {
            customButton.tag = DateRangeType.custom.rawValue
        }
    }
    
    @IBOutlet var dateRangeFromTitleLabel: UILabel!
    @IBOutlet var dateRangeToTitleLabel: UILabel!
    
    @IBOutlet var dateRangeFromTextField: DesignableUITextField! {
        didSet {
            dateRangeFromTextField.backgroundColor = UIColor.DateRangeView.textfieldBg
        }
    }
    @IBOutlet var dateRangeToTextField: DesignableUITextField! {
        didSet {
            dateRangeToTextField.backgroundColor = UIColor.DateRangeView.textfieldBg
        }
    }
    @IBOutlet var applyButton: UIButton! {
        didSet {
            applyButton.setTitleColor(UIColor.Cell.title, for: .normal)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedDateRangeType = .day
    }
    
    // MARK: - Private methods
    private func updateDateFromMethod() {
        dateRangeToTextField.isUserInteractionEnabled = false
        dateRangeFromTextField.isUserInteractionEnabled = false
        
        dayButton.isSelected = false
        weekButton.isSelected = false
        monthButton.isSelected = false
        yearButton.isSelected = false
        customButton.isSelected = false
        
        switch selectedDateRangeType {
        case .day:
            dateRangeFrom = dateRangeTo.previousDate()
            dayButton.isSelected = true
        case .week:
            dateRangeFrom = dateRangeTo.removeDays(7)
            weekButton.isSelected = true
        case .month:
            dateRangeFrom = dateRangeTo.removeMonths(1)
            monthButton.isSelected = true
        case .year:
            dateRangeFrom = dateRangeTo.removeYears(1)
            yearButton.isSelected = true
        case .custom:
            dateRangeToTextField.isUserInteractionEnabled = true
            dateRangeFromTextField.isUserInteractionEnabled = true
            dateRangeFrom = dateRangeTo.previousDate()
            customButton.isSelected = true
        }
    }
    
    // MARK: - Actions
    @IBAction func textFieldEditing(sender: UITextField) {
        sender.resignFirstResponder()
        
        guard selectedDateRangeType == .custom else {
            return
        }
        
        if sender == dateRangeFromTextField {
            delegate?.showDatePicker(with: dateRangeFrom, dateRangeTo: dateRangeTo)
        } else {
            delegate?.showDatePicker(with: nil, dateRangeTo: dateRangeTo)
        }
    }
    
    @IBAction func changeDateRangeTypeButtonAction(_ sender: UIButton) {
        sender.isSelected = true
        selectedDateRangeType = DateRangeType(rawValue: sender.tag)!
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        delegate?.applyButtonDidPress(with: selectedDateRangeType, dateRangeFrom: dateRangeFrom, dateRangeTo: dateRangeTo)
    }
}
