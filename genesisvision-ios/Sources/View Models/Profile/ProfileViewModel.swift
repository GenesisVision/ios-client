//
//  ProfileViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum ProfileFieldType: String, EnumCollection {
    case email = "Email"
    
    case firstName = "First Name"
    case middleName = "Middle Name"
    case lastName = "Last Name"
    
    case birthday = "Birthday"
    case gender = "Gender"
}

final class ProfileViewModel {
    typealias FieldType = ProfileFieldType
    
    enum SectionType {
        case header
        case fields
    }
    
    // MARK: - Variables
    var title: String = "Profile"
    
    private var router: ProfileRouter!
    private var profileModel: ProfileFullViewModel?
    
    var rows: [FieldType] = [.email, .firstName, .middleName, .lastName, .birthday, .gender]
    var sections: [SectionType] = [.fields]
    
    var editableFields = [EditableField<FieldType>]()
    var pickedImage: UIImage?
    var pickedImageURL: URL?
    
    var editableState: EditableState = .show {
        didSet {
            guard editableFields.count > 0 else { return }
            
            for idx in 0...editableFields.count - 1 {
                editableFields[idx].editable = getEditable(for: editableFields[idx].type)
                editableFields[idx].selectable = getSelectable(for: editableFields[idx].type)
            }
        }
    }
    
    weak var textFieldDelegate: UITextFieldDelegate?
    weak var delegate: PhotoHeaderViewDelegate?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FieldWithTextFieldTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProfileRouter, profileModel: ProfileFullViewModel, textFieldDelegate: UITextFieldDelegate) {
        self.router = router
        self.textFieldDelegate = textFieldDelegate
        self.profileModel = profileModel
        
        setupCellViewModel()
    }
    
    // MARK: - Public methods
    func fetchProfile(completion: @escaping CompletionBlock) {
        AuthManager.getProfile(completion: { [weak self] (viewModel) in
            if let profileModel = viewModel {
                self?.profileModel = profileModel
                completion(.success)
            }
            
            completion(.failure(errorType: .apiError(message: nil)))
        }, completionError: completion)
    }
    
    func getAvatarURL() -> URL? {
        guard let avatar = profileModel?.avatar,
            let avatarURL = getFileURL(fileName: avatar)
            else { return nil }
        
        return avatarURL
    }
    
    // MARK: - TableView
    func numberOfSections() -> Int {
        return profileModel != nil ? sections.count : 0
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
            return FieldWithTextFieldTableViewCellViewModel(text: field.text, placeholder: field.placeholder, editable: field.editable, selectable: field.selectable, showAccessory: true, isSecureTextEntry: field.isSecureTextEntry, keyboardType: field.keyboardType, returnKeyType: field.returnKeyType, textContentType: field.textContentType, delegate: textFieldDelegate, valueChanged: { [weak self] (text) in
                guard let type: FieldType = FieldType(rawValue: field.placeholder) else { return }
                
                switch type {
                case .firstName:
                    self?.profileModel?.firstName = text
                case .middleName:
                    self?.profileModel?.middleName = text
                case .lastName:
                    self?.profileModel?.lastName = text
                default:
                    break
                }
            })
        }
    }
    
    func editProfile(completion: @escaping CompletionBlock) {
        editableState = .edit
        completion(.success)
    }
    
    func cancelEditProfile(completion: @escaping CompletionBlock) {
        setupCellViewModel()
        editableState = .show
        fetchProfile(completion: completion)
    }
    
    func saveProfile(completion: @escaping CompletionBlock) {
        saveProfileApi(completion: completion)
    }

    func update(birthdate: Date?) {
        if let idx = editableFields.firstIndex(where: { $0.type == .birthday }) {
            guard let birthdate = birthdate else {
                editableFields[idx].text = ""
                return
            }
            
            profileModel?.birthday = birthdate
            editableFields[idx].text = birthdate.onlyDateFormatString
        }
    }
    
    func update(gender: Bool?) {
        if let idx = editableFields.firstIndex(where: { $0.type == .gender }) {
            guard let gender = gender else {
                editableFields[idx].text = ""
                return
            }
            
            profileModel?.gender = gender
            editableFields[idx].text = gender ? "Male" : "Female"
        }
    }
    
    func didSelect(_ indexPath: IndexPath) -> FieldType? {
        guard editableState == .edit else {
            return nil
        }
        
        let fieldType = rows[indexPath.row]
        
        switch fieldType {
        case .gender, .birthday:
            return fieldType
        default:
            return nil
        }
    }
    
    // MARK: -  Private methods
    private func getFields() -> [FieldType : String] {
        return [.email : profileModel?.email ?? "",
                .firstName : profileModel?.firstName ?? "",
                .middleName : profileModel?.middleName ?? "",
                .lastName : profileModel?.lastName ?? "",
                .birthday : getBirthday(),
                .gender : getGenderValue()]
    }
    
    private func getKeyboardType(for fieldType: FieldType) -> UIKeyboardType {
        switch fieldType {
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }

    private func getTextContentType(for fieldType: FieldType) -> UITextContentType? {
        switch fieldType {
        case .firstName:
            return .name
        case .middleName:
            return .middleName
        case .lastName:
            return .familyName
        default:
            return nil
        }
    }
    
    private func getEditable(for fieldType: FieldType) -> Bool {
        guard editableState == .edit else {
            return false
        }
        
        switch fieldType {
        case .gender, .birthday, .email:
            return false
        default:
            return true
        }
    }
    
    private func getSelectable(for fieldType: FieldType) -> Bool {
        guard editableState == .edit else {
            return false
        }
        
        switch fieldType {
        case .gender, .birthday:
            return true
        default:
            return false
        }
    }
    
    private func setupCellViewModel() {
        var editableFields: [EditableField<FieldType>] = []
        
        FieldType.allValues.forEach { (type) in
            let fields = getFields()
            let key = type.rawValue
            
            let text = fields[type] ?? ""
            let placeholder = key
            let editable = getEditable(for: type)
            let selectable = getSelectable(for: type)
            let isSecureTextEntry = false
            let keyboardType = getKeyboardType(for: type)
            let returnKeyType: UIReturnKeyType = .next
            let textContentType = getTextContentType(for: type)
            
            let editableField = EditableField(text: text, placeholder: placeholder, editable: editable, selectable: selectable, isSecureTextEntry: isSecureTextEntry, type: type, keyboardType: keyboardType, returnKeyType: returnKeyType, textContentType: textContentType, isValid: { (text) -> Bool in
                return text.count > 1
            })
            
            editableFields.append(editableField)
        }
        
        self.editableFields = editableFields
    }
    
    var fullName: String {
        guard let firstName = profileModel?.firstName, let lastName = profileModel?.lastName else { return String.placeholder }
        return firstName + " " + lastName
    }
    
    func getBirthday() -> String {
        guard let date = profileModel?.birthday else { return "" }
        
        return date.onlyDateFormatString
    }
    
    func getBirthdate() -> Date? {
        guard let date = profileModel?.birthday else { return nil }
        
        return date
    }
    
    func getGender() -> Bool? {
        guard let gender = profileModel?.gender else { return nil }
        
        return gender
    }
    
    func getGenderValue() -> String {
        guard let gender = profileModel?.gender else { return "" }
        
        return gender ? "Male" : "Female"
    }
    
    private func saveProfileApi(completion: @escaping CompletionBlock) {
        guard pickedImageURL != nil else {
            self.updateProfileApi(completion: completion)
            return
        }
        
        completion(.success)
    }
    
    private func updateProfileApi(completion: @escaping CompletionBlock) {
        guard let profileModel = profileModel else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let model = UpdatePersonalDetailViewModel(
                                           firstName: profileModel.firstName,
                                           middleName: profileModel.middleName,
                                           lastName: profileModel.lastName,
                                           birthday: profileModel.birthday,
                                           citizenship: nil,
                                           gender: profileModel.gender,
                                           documentId: nil,
                                           phoneNumber: profileModel.phone,
                                           country: profileModel.country,
                                           city: profileModel.city,
                                           address: profileModel.address,
                                           index: nil
                                           )
        
        ProfileDataProvider.updateProfile(model: model) { [weak self] (result) in
            switch result {
            case .success:
                AuthManager.saveProfileViewModel(viewModel: profileModel)
                self?.setupCellViewModel()
                self?.editableState = .show
            case .failure( _):
                break
            }
            
            completion(result)
        }
    }
    
    
}
