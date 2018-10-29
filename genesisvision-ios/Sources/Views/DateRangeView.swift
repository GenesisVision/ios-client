//
//  DateRangeView.swift
//  genesisvision-ios
//
//  Created by George on 06/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol DateRangeViewProtocol: class {
    func applyButtonDidPress(with dateFrom: Date, dateTo: Date)
    func showDatePicker(with dateFrom: Date?, dateTo: Date)
}

class DateRangeView: UIView {
    // MARK: - Variables
    weak var delegate: DateRangeViewProtocol?
    
    var selectedDateRangeType: DateRangeType = .week {
        didSet {
            dateTo = Date()
            updateDateFromMethod()
        }
    }
    
    var dateFrom: Date = Date().removeDays(7) {
        didSet {
            dateFromTextField.text = dateFrom.onlyDateFormatString
        }
    }
    var dateTo: Date = Date() {
        didSet {
            dateToTextField.text = dateTo.onlyDateFormatString
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
    
    @IBOutlet var dateFromTitleLabel: UILabel!
    @IBOutlet var dateToTitleLabel: UILabel!
    
    @IBOutlet var dateFromTextField: DesignableUITextField! {
        didSet {
            dateFromTextField.addPadding()
            dateFromTextField.backgroundColor = UIColor.DateRangeView.textfieldBg
        }
    }
    @IBOutlet var dateToTextField: DesignableUITextField! {
        didSet {
            dateToTextField.addPadding()
            dateToTextField.backgroundColor = UIColor.DateRangeView.textfieldBg
        }
    }
    @IBOutlet var applyButton: ActionButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedDateRangeType = .week
    }
    
    // MARK: - Private methods
    private func updateDateFromMethod() {
        dateToTextField.isUserInteractionEnabled = false
        dateFromTextField.isUserInteractionEnabled = false
        
        dayButton.isSelected = false
        weekButton.isSelected = false
        monthButton.isSelected = false
        yearButton.isSelected = false
        customButton.isSelected = false
        
        switch selectedDateRangeType {
        case .day:
            dateFrom = dateTo.previousDate()
            dayButton.isSelected = true
        case .week:
            dateFrom = dateTo.removeDays(7)
            weekButton.isSelected = true
        case .month:
            dateFrom = dateTo.removeMonths(1)
            monthButton.isSelected = true
        case .year:
            dateFrom = dateTo.removeYears(1)
            yearButton.isSelected = true
        case .custom:
            dateToTextField.isUserInteractionEnabled = true
            dateFromTextField.isUserInteractionEnabled = true
            dateFrom = dateTo.removeDays(7)
            customButton.isSelected = true
        }
        
        updateTime()
    }
    
    private func updateTime() {
        dateTo.setTime(hour: 0, min: 0, sec: 0)
        dateFrom.setTime(hour: 0, min: 0, sec: 0)
//        switch selectedDateRangeType {
//        case .custom:
//            dateTo.setTime(hour: 0, min: 0, sec: 0)
//            dateFrom.setTime(hour: 23, min: 59, sec: 59)
//        default:
//            let calendar = Calendar.current
//            let hour = calendar.component(.hour, from: dateTo)
//            let min = calendar.component(.minute, from: dateTo)
//            let sec = calendar.component(.second, from: dateTo)
//            dateFrom.setTime(hour: hour, min: min, sec: sec)
//        }
    }
    
    // MARK: - Actions
    @IBAction func textFieldEditing(sender: UITextField) {
        sender.resignFirstResponder()
        
        guard selectedDateRangeType == .custom else {
            return
        }
        
        if sender == dateFromTextField {
            delegate?.showDatePicker(with: dateFrom, dateTo: dateTo)
        } else {
            delegate?.showDatePicker(with: nil, dateTo: dateTo)
        }
    }
    
    @IBAction func changeDateRangeTypeButtonAction(_ sender: UIButton) {
        sender.isSelected = true
        selectedDateRangeType = DateRangeType(rawValue: sender.tag)!
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        delegate?.applyButtonDidPress(with: dateFrom, dateTo: dateTo)
    }
}
