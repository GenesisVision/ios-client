//
//  CreateProgramThirdViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum CreateProgramThirdFieldType: String, EnumCollection {
    case dateFrom = "Start Date"
    case depositAmount = "Deposit Amount (GVT)"
    
    case successFee = "Success Fee %"
    case managementFee = "Management Fee %"
    
    case tokenName = "Token Name"
    case tokenSymbol = "Token Symbol"
}

final class CreateProgramThirdViewModel {//: ViewModelWithTableView {
//    typealias FieldType = CreateProgramThirdFieldType
//    var tableViewDataSourceAndDelegate: TableViewDataSourceAndDelegate!
//
//    enum SectionType {
//        case header
//        case fields
//    }
//
//    // MARK: - Variables
    public private(set) var title: String = "Step 3".uppercased()
//    public private(set) var buttonTitleText: String = "Create Program".uppercased()
//
//    private var tabmanViewModel: CreateProgramTabmanViewModel!
//    private var router: TabmanRouter!
//
    var temparyNewInvestmentRequest: TemparyNewInvestmentRequest?
    var pickedImageURL: URL?
//
//    var rows: [FieldType] = [.dateFrom, .depositAmount, .successFee, .managementFee, .tokenName, .tokenSymbol]
//    var sections: [SectionType] = [.fields]
//
//    var editableFields = [EditableField<FieldType>]()
//    weak var textFieldDelegate: UITextFieldDelegate?
//
//    /// Return view models for registration cell Nib files
//    var cellModelsForRegistration: [CellViewAnyModel.Type] {
//        return [FieldWithTextFieldTableViewCellViewModel.self]
//    }
//
    // MARK: - Init
    init(withRouter router: TabmanRouter, tabmanViewModel: CreateProgramTabmanViewModel, temparyNewInvestmentRequest: TemparyNewInvestmentRequest? = nil, textFieldDelegate: UITextFieldDelegate) {
//        self.router = router
//        self.tabmanViewModel = tabmanViewModel
//        self.textFieldDelegate = textFieldDelegate
        self.temparyNewInvestmentRequest = temparyNewInvestmentRequest

//        setupCellViewModel()
    }
//
//    // MARK: - Public methods
//    func createProgram(completion: @escaping (_ programId: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
//
//        guard let temparyNewInvestmentRequest = temparyNewInvestmentRequest,
//            let brokerTradeServerId = temparyNewInvestmentRequest.brokerTradeServerId,
//            let tradePlatformPassword = temparyNewInvestmentRequest.tradePlatformPassword,
//            let depositAmount = temparyNewInvestmentRequest.depositAmount,
//            let leverage = temparyNewInvestmentRequest.leverage,
//            let tokenName = temparyNewInvestmentRequest.tokenName,
//            let tokenSymbol = temparyNewInvestmentRequest.tokenSymbol,
//            let title = temparyNewInvestmentRequest.title,
//            let period = temparyNewInvestmentRequest.period
//            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
//
////        let newInvestmentRequest = NewProgramRequest(brokerTradeServerId: brokerTradeServerId,
////                                                        tradePlatformPassword: tradePlatformPassword,
////                                                        depositAmount: depositAmount,
////                                                        leverage: leverage,
////                                                        tokenName: tokenName,
////                                                        tokenSymbol: tokenSymbol,
////                                                        dateFrom: temparyNewInvestmentRequest.dateFrom,
////                                                        dateTo: temparyNewInvestmentRequest.dateTo,
////                                                        logo: temparyNewInvestmentRequest.logo,
////                                                        title: title,
////                                                        description: temparyNewInvestmentRequest.description,
////                                                        feeManagement: temparyNewInvestmentRequest.feeManagement,
////                                                        feeSuccess: temparyNewInvestmentRequest.feeSuccess,
////                                                        investMinAmount: temparyNewInvestmentRequest.investMinAmount,
////                                                        investMaxAmount: temparyNewInvestmentRequest.investMaxAmount,
////                                                        period: period)
//
////        guard let pickedImageURL = pickedImageURL else {
////            ProgramDataProvider.createProgram(with: newInvestmentRequest, completion: completion, errorCompletion: errorCompletion)
////            return
////        }
////
////        BaseDataProvider.uploadImage(imageURL: pickedImageURL, completion: { (imageID) in
////            newInvestmentRequest.logo = imageID
////            ProgramDataProvider.createProgram(with: newInvestmentRequest, completion: completion, errorCompletion: errorCompletion)
////            }, errorCompletion: errorCompletion)
//    }
//
//    // MARK: - TableView
//    func numberOfSections() -> Int {
//        return sections.count
//    }
//
//    func numberOfRows(in section: Int) -> Int {
//        switch sections[section] {
//        case .header:
//            return 1
//        case .fields:
//            return editableFields.count
//        }
//    }
//
//    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
//        let type = sections[indexPath.section]
//
//        switch type {
//        case .header:
//            return nil
//        case .fields:
//            let field = editableFields[indexPath.row]
//            return FieldWithTextFieldTableViewCellViewModel(text: field.text, placeholder: field.placeholder, editable: field.editable, selectable: field.selectable, showAccessory: false, isSecureTextEntry: field.isSecureTextEntry, keyboardType: field.keyboardType, returnKeyType: field.returnKeyType, textContentType: field.textContentType, delegate: textFieldDelegate, valueChanged: { [weak self] (text) in
//                guard let type: FieldType = FieldType(rawValue: field.placeholder) else { return }
//                switch type {
//                case .dateFrom:
//                    self?.temparyNewInvestmentRequest?.dateFrom = Date()
//                case .depositAmount:
//                    self?.temparyNewInvestmentRequest?.depositAmount = Double(text)
//                case .successFee:
//                    self?.temparyNewInvestmentRequest?.feeSuccess = Double(text)
//                case .managementFee:
//                    self?.temparyNewInvestmentRequest?.feeManagement = Double(text)
//                case .tokenName:
//                    self?.temparyNewInvestmentRequest?.tokenName = text
//                case .tokenSymbol:
//                    self?.temparyNewInvestmentRequest?.tokenSymbol = text
//                }
//            })
//        }
//    }
//
//    // MARK: -  Private methods
//    private func getFields() -> [FieldType : String] {
//        return [.dateFrom : "",
//                .depositAmount : "",
//                .successFee : "",
//                .managementFee : "",
//                .tokenName : "",
//                .tokenSymbol : ""]
//    }
//
//    private func getKeyboardType(for fieldType: FieldType) -> UIKeyboardType {
//        switch fieldType {
//        case .depositAmount, .successFee, .managementFee:
//            return .numberPad
//        default:
//            return .default
//        }
//    }
//
//    private func getReturnKeyType(for fieldType: FieldType) -> UIReturnKeyType {
//        switch fieldType {
//        case .tokenSymbol:
//            return .done
//        default:
//            return .next
//        }
//    }
//
//    private func getEditable(for fieldType: FieldType) -> Bool {
//        switch fieldType {
//        case .dateFrom:
//            return false
//        default:
//            return true
//        }
//    }
//
//    private func getSelectable(for fieldType: FieldType) -> Bool {
//        switch fieldType {
//        case .dateFrom:
//            return true
//        default:
//            return false
//        }
//    }
//
//    private func setupCellViewModel() {
//        tableViewDataSourceAndDelegate = TableViewDataSourceAndDelegate(viewModel: self)
//
//        var editableFields: [EditableField<FieldType>] = []
//
//        FieldType.allValues.forEach { (type) in
//            let fields = getFields()
//            let key = type.rawValue
//
//            let text = fields[type] ?? ""
//            let placeholder = key
//            let editable = getEditable(for: type)
//            let selectable = getSelectable(for: type)
//            let isSecureTextEntry = false
//            let keyboardType = getKeyboardType(for: type)
//            let returnKeyType = getReturnKeyType(for: type)
//            let textContentType: UITextContentType? = nil
//
//            let editableField = EditableField(text: text, placeholder: placeholder, editable: editable, selectable: selectable, isSecureTextEntry: isSecureTextEntry, type: type, keyboardType: keyboardType, returnKeyType: returnKeyType, textContentType: textContentType, isValid: { (text) -> Bool in
//                return text.count > 1
//            })
//
//            editableFields.append(editableField)
//        }
//
//        self.editableFields = editableFields
//    }
//
//    // MARK: - Public methods
//    func update(dateFrom: Date?) {
//        if let idx = editableFields.index(where: { $0.type == .dateFrom }) {
//            guard let dateFrom = dateFrom else {
//                editableFields[idx].text = ""
//                return
//            }
//
//            temparyNewInvestmentRequest?.dateFrom = dateFrom
//            editableFields[idx].text = dateFrom.dateAndTimeFormatString
//        }
//    }
//
//    func didSelect(_ indexPath: IndexPath) -> FieldType? {
//        let fieldType = rows[indexPath.row]
//
//        switch fieldType {
//        case .dateFrom:
//            return fieldType
//        default:
//            return nil
//        }
//    }
//
//    // MARK: - Navigation
//    func showSuccess(programId: String? = nil) {
//        guard let programId = programId, let router = router as? CreateProgramTabmanRouter else { return }
//        router.show(routeType: .successCreate(programId))
//    }
}
