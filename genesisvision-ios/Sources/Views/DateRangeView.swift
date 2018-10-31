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
            changeDateRangeType()
        }
    }
    
    var dateFrom: Date? {
        didSet {
            dateFromTextField.text = dateFrom?.onlyDateFormatString
        }
    }
    var dateTo: Date? {
        didSet {
            dateToTextField.text = dateTo?.onlyDateFormatString
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
        correctTime()
    }
    
    // MARK: - Private methods
    private func changeDateRangeType() {
        dateTo = Date()
        
        dateToTextField.isUserInteractionEnabled = false
        dateFromTextField.isUserInteractionEnabled = false
        
        dayButton.isSelected = false
        weekButton.isSelected = false
        monthButton.isSelected = false
        yearButton.isSelected = false
        customButton.isSelected = false
        
        switch selectedDateRangeType {
        case .day:
            dateFrom = dateTo?.previousDate()
            dayButton.isSelected = true
        case .week:
            dateFrom = dateTo?.removeDays(7)
            weekButton.isSelected = true
        case .month:
            dateFrom = dateTo?.removeMonths(1)
            monthButton.isSelected = true
        case .year:
            dateFrom = dateTo?.removeYears(1)
            yearButton.isSelected = true
        case .custom:
            if dateFrom == nil {
                dateFrom = dateTo?.removeDays(7)
            }
            dateToTextField.isUserInteractionEnabled = true
            dateFromTextField.isUserInteractionEnabled = true
            customButton.isSelected = true
        }
    }
    
    private func correctTime() {
        guard var dateFrom = self.dateFrom, var dateTo = self.dateTo else { return }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        switch selectedDateRangeType {
        case .custom:
            dateFrom.setTime(hour: 0, min: 0, sec: 0)
            dateTo.setTime(hour: 0, min: 0, sec: 0)
            
            let hour = calendar.component(.hour, from: dateTo)
            let min = calendar.component(.minute, from: dateTo)
            let sec = calendar.component(.second, from: dateTo)
            dateFrom.setTime(hour: hour, min: min, sec: sec)
            dateTo.setTime(hour: hour, min: min, sec: sec)
            dateFrom = dateFrom.removeDays(1)
        default:
            let hour = calendar.component(.hour, from: dateTo)
            let min = calendar.component(.minute, from: dateTo)
            let sec = calendar.component(.second, from: dateTo)
            dateFrom.setTime(hour: hour, min: min, sec: sec)
            dateTo.setTime(hour: hour, min: min, sec: sec)
        }
        
        PlatformManager.shared.dateRangeType = selectedDateRangeType
        PlatformManager.shared.dateFrom = dateFrom
        PlatformManager.shared.dateTo = dateTo
    }
    
    // MARK: - Actions
    @IBAction func textFieldEditing(sender: UITextField) {
        sender.resignFirstResponder()
        
        guard selectedDateRangeType == .custom, let dateTo = dateTo, let dateFrom = dateFrom else {
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
        correctTime()
        
        guard let dateFrom = PlatformManager.shared.dateFrom, let dateTo = PlatformManager.shared.dateTo else { return }
        
        delegate?.applyButtonDidPress(with: dateFrom, dateTo: dateTo)
    }
}
