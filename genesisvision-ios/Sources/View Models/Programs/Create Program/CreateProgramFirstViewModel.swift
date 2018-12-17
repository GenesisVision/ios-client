//
//  CreateProgramFirstViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

enum CreateProgramFirstFieldType: String, EnumCollection {
    case title = "Title"
    case desc = "Description"
}

class TemparyNewInvestmentRequest: Codable {
    var brokerTradeServerId: UUID?
    var tradePlatformPassword: String?
    var depositAmount: Double?
    var leverage: Int?
    var tokenName: String?
    var tokenSymbol: String?
    var dateFrom: Date?
    var dateTo: Date?
    var logo: String?
    var title: String?
    var description: String?
    var feeManagement: Double?
    var feeSuccess: Double?
    var investMinAmount: Double?
    var investMaxAmount: Double?
    var period: Int?
}

final class CreateProgramFirstViewModel {//: ViewModelWithTableView {
//    typealias FieldType = CreateProgramFirstFieldType
//    
//    var tableViewDataSourceAndDelegate: TableViewDataSourceAndDelegate!
//    
//    enum SectionType {
//        case header
//        case fields
//    }
//    
//    // MARK: - Variables
//    var title: String = "Step 1".uppercased()
//    
//    private var tabmanViewModel: CreateProgramTabmanViewModel!
//    private var router: TabmanRouter!
//    
    var temparyNewInvestmentRequest: TemparyNewInvestmentRequest?
//
//    var rows: [FieldType] = [.title, .desc]
//    var sections: [SectionType] = [.fields]
//    
//    var editableFields = [EditableField<FieldType>]()
    var pickedImage: UIImage?
    var pickedImageURL: URL?
//    
//    weak var textFieldDelegate: UITextFieldDelegate?
//    weak var photoHeaderViewDelegate: PhotoHeaderViewDelegate?
//    
//    /// Return view models for registration cell Nib files
//    var cellModelsForRegistration: [CellViewAnyModel.Type] {
//        return [FieldWithTextFieldTableViewCellViewModel.self,
//                FieldWithTextViewTableViewCellViewModel.self]
//    }
//    
//    // MARK: - Init
    init(withRouter router: TabmanRouter, tabmanViewModel: CreateProgramTabmanViewModel, temparyNewInvestmentRequest: TemparyNewInvestmentRequest? = nil, textFieldDelegate: UITextFieldDelegate) {
//        self.router = router
//        self.tabmanViewModel = tabmanViewModel
//        self.textFieldDelegate = textFieldDelegate
        self.temparyNewInvestmentRequest = TemparyNewInvestmentRequest()
        
//        setupCellViewModel()
    }
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
//            guard let type: FieldType = FieldType(rawValue: field.placeholder) else { return nil }
//        
//            switch type {
//            case .title:
//                return FieldWithTextFieldTableViewCellViewModel(text: field.text, placeholder: field.placeholder, editable: field.editable, selectable: field.selectable, showAccessory: false, isSecureTextEntry: field.isSecureTextEntry, keyboardType: field.keyboardType, returnKeyType: field.returnKeyType, textContentType: field.textContentType, delegate: textFieldDelegate, valueChanged: { [weak self] (text) in
//                    self?.temparyNewInvestmentRequest?.title = text
//                })
//            case .desc:
//                return FieldWithTextViewTableViewCellViewModel(text: field.text, placeholder: field.placeholder, editable: field.editable, selectable: field.selectable, showAccessory: false, keyboardType: field.keyboardType, returnKeyType: field.returnKeyType, textContentType: field.textContentType, valueChanged: { [weak self] (text) in
//                    self?.temparyNewInvestmentRequest?.description = text
//                })
//            }
//        }
//    }
//    
//    // MARK: -  Private methods
//    private func getFields() -> [FieldType : String] {
//        return [.title : "",
//                .desc : ""]
//    }
//
//    private func getReturnKeyType(for fieldType: FieldType) -> UIReturnKeyType {
//        switch fieldType {
//        case .desc:
//            return .default
//        default:
//            return .next
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
//            let editable = true
//            let selectable = false
//            let isSecureTextEntry = false
//            let keyboardType: UIKeyboardType = .default
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
//    // MARK: - Navigation
//    func nextStep() {
//        if let router = router as? CreateProgramTabmanRouter {
//            router.next(with: temparyNewInvestmentRequest, pickedImageURL: pickedImageURL)
//        }
//    }
}
