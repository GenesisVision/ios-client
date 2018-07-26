//
//  CreateProgramSecondViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum CreateProgramSecondFieldType: String, EnumCollection {
    case password = "Password"
    case confirmPassword = "Confirm Password"
    
    case brokerServer = "Broker Server"
    case leverage = "Leverage"
    case periodLength = "Period Length %"
}

final class CreateProgramSecondViewModel: ViewModelWithTableView {
    typealias FieldType = CreateProgramSecondFieldType
    var tableViewDataSourceAndDelegate: TableViewDataSourceAndDelegate!
    
    enum SectionType {
        case header
        case fields
    }
    
    // MARK: - Variables
    public private(set) var title: String = "Step 2".uppercased()
    
    private var tabmanViewModel: CreateProgramTabmanViewModel!
    private var router: TabmanRouter!
    
    var temparyNewInvestmentRequest: TemparyNewInvestmentRequest?
    var brokersViewModel: BrokersViewModel?
    
    var selectedBrokerTradeServer: BrokerTradeServer?
    var selectedBrokerServerIndex: Int {
        guard let selectedBrokerTradeServer = selectedBrokerTradeServer,
            let brokers = brokersViewModel?.brokers,
            let idx = brokers.index(where: {$0.brokerId == selectedBrokerTradeServer.brokerId}) else {
                return 0
        }
        
        return idx
    }
    
    var selectedBrokerTradeServerLeverageIndex: Int = 0 {
        didSet {
            if let idx = editableFields.index(where: { $0.type == .leverage }) {
                let value = brokerServerLeverageValues()[selectedBrokerTradeServerLeverageIndex]
                
                temparyNewInvestmentRequest?.leverage = value
                editableFields[idx].text = value.toString()
            }
        }
    }
    
    var periodLenthValues: [Int] = [1, 2, 3, 5, 7, 10, 14]
    var selectedPeriodLenghtIndex: Int = 0 {
        didSet {
            if let idx = editableFields.index(where: { $0.type == .periodLength }) {
                let value = periodLenthValues[selectedPeriodLenghtIndex]
                
                temparyNewInvestmentRequest?.period = value
                editableFields[idx].text = value.toString()
            }
        }
    }
    
    var rows: [FieldType] = [.password, .confirmPassword, .brokerServer, .leverage, .periodLength]
    var sections: [SectionType] = [.fields]

    var editableFields = [EditableField<FieldType>]()
    weak var textFieldDelegate: UITextFieldDelegate?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FieldWithTextFieldTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: TabmanRouter, tabmanViewModel: CreateProgramTabmanViewModel, temparyNewInvestmentRequest: TemparyNewInvestmentRequest? = nil, textFieldDelegate: UITextFieldDelegate, brokersViewModel: BrokersViewModel? = nil) {
        self.router = router
        self.tabmanViewModel = tabmanViewModel
        self.textFieldDelegate = textFieldDelegate
        self.temparyNewInvestmentRequest = temparyNewInvestmentRequest
        self.brokersViewModel = brokersViewModel
        
        setupCellViewModel()
    }
    
    // MARK: - TableView
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 1
        case .fields:
            return editableFields.count
        }
    }
    
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        
        switch type {
        case .header:
            return nil
        case .fields:
            let field = editableFields[indexPath.row]
            return FieldWithTextFieldTableViewCellViewModel(text: field.text, placeholder: field.placeholder, editable: field.editable, selectable: field.selectable, showAccessory: false, isSecureTextEntry: field.isSecureTextEntry, keyboardType: field.keyboardType, returnKeyType: field.returnKeyType, textContentType: field.textContentType, delegate: textFieldDelegate, valueChanged: { [weak self] (text) in
                
                guard let type: FieldType = FieldType(rawValue: field.placeholder) else { return }
                switch type {
                case .password, .confirmPassword:
                    self?.temparyNewInvestmentRequest?.tradePlatformPassword = text
                default:
                    break
                    
                }
            })
        }
    }
    
    func didSelect(_ indexPath: IndexPath) -> FieldType? {
        let fieldType = rows[indexPath.row]
        
        switch fieldType {
        case .brokerServer, .leverage, .periodLength:
            return fieldType
        default:
            return nil
        }
    }
    
    // MARK: -  Private methods
    private func getFields() -> [FieldType : String] {
        return [.password : "",
                .confirmPassword : "",
                .brokerServer : "",
                .leverage : "",
                .periodLength : ""]
    }
    
    private func getKeyboardType(for fieldType: FieldType) -> UIKeyboardType {
        switch fieldType {
        case .leverage, .periodLength:
            return .numberPad
        default:
            return .default
        }
    }
    
    private func getReturnKeyType(for fieldType: FieldType) -> UIReturnKeyType {
        switch fieldType {
        case .periodLength:
            return .done
        default:
            return .next
        }
    }
    
    private func getIsSecureTextEntry(for fieldType: FieldType) -> Bool {
        switch fieldType {
        case .password, .confirmPassword:
            return true
        default:
            return false
        }
    }
    
    private func getEditable(for fieldType: FieldType) -> Bool {
        switch fieldType {
        case .brokerServer, .leverage, .periodLength:
            return false
        default:
            return true
        }
    }
    
    private func getSelectable(for fieldType: FieldType) -> Bool {
        switch fieldType {
        case .brokerServer, .leverage, .periodLength:
            return true
        default:
            return false
        }
    }
    
    private func setupCellViewModel() {
        tableViewDataSourceAndDelegate = TableViewDataSourceAndDelegate(viewModel: self)
        
        var editableFields: [EditableField<FieldType>] = []
        
        FieldType.allValues.forEach { (type) in
            let fields = getFields()
            let key = type.rawValue
            
            let text = fields[type] ?? ""
            let placeholder = key
            let editable = getEditable(for: type)
            let selectable = getSelectable(for: type)
            let isSecureTextEntry = getIsSecureTextEntry(for: type)
            let keyboardType = getKeyboardType(for: type)
            let returnKeyType = getReturnKeyType(for: type)
            let textContentType: UITextContentType? = nil
            
            let editableField = EditableField(text: text, placeholder: placeholder, editable: editable, selectable: selectable, isSecureTextEntry: isSecureTextEntry, type: type, keyboardType: keyboardType, returnKeyType: returnKeyType, textContentType: textContentType, isValid: { (text) -> Bool in
                return text.count > 1
            })
            
            editableFields.append(editableField)
        }
        
        self.editableFields = editableFields
    }
    
    // MARK: - Public methods
    func updateTradeServerIndex(_ selectedIndex: Int) {
        guard let brokersViewModel = brokersViewModel,
            let brokers = brokersViewModel.brokers else {
                return
        }
        
        for found in brokers.enumerated() {
            if found.offset == selectedIndex {
                selectedBrokerTradeServer = found.element
                
                if let idx = editableFields.index(where: { $0.type == .brokerServer }),
                    let selectedBrokerTradeServer = selectedBrokerTradeServer,
                    let brokerId = selectedBrokerTradeServer.id,
                    let name = selectedBrokerTradeServer.name {
                    temparyNewInvestmentRequest?.brokerTradeServerId = brokerId
                    editableFields[idx].text = name
                }
            }
        }
    }
    
    // MARK: - Picker View Values
    func brokerServerValues() -> [String] {
        guard let brokersViewModel = brokersViewModel,
            let brokers = brokersViewModel.brokers else {
            return []
        }
        
        return brokers.map { $0.name ?? "" }
    }
    
    func brokerServerLeverageValues() -> [Int] {
        guard let selectedBrokerTradeServer = selectedBrokerTradeServer,
            let leverages = selectedBrokerTradeServer.leverages else {
            return []
        }
        
        return leverages
    }
    
    // MARK: - Navigation
    func nextStep() {
        if let router = router as? CreateProgramTabmanRouter {
            router.next(with: temparyNewInvestmentRequest)
        }
    }
}
