//
//  ProfileViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum ProfileState {
    case show
    case edit
}

final class ProfileViewModel {
    
    enum SectionType {
        case header
        case fields
    }
    
    // MARK: - Variables
    var title: String = "Profile"
    
    private var router: ProfileRouter!
    private var profileEntity: ProfileEntity?
    private var editProfileEntity: ProfileEntity?
    
    var editableFields: [EditableField]!
    var pickedImage: UIImage?
    
    class EditableField {
        var text: String
        var placeholder: String
        var editable: Bool
        var keyboardType: UIKeyboardType?
        var textContentType: UITextContentType?
        
        var isValid: (String) -> Bool
        
        init(text: String, placeholder: String, editable: Bool, keyboardType: UIKeyboardType?, textContentType: UITextContentType?, isValid: @escaping (String) -> Bool) {
            self.text = text
            self.placeholder = placeholder
            self.editable = editable
            self.keyboardType = keyboardType
            self.textContentType = textContentType
            self.isValid = isValid
        }
    }
    
    var sections: [SectionType] = [.fields]
    var profileState: ProfileState = .show {
        didSet {
            for idx in 1...editableFields.count - 1 {
                editableFields[idx].editable = profileState == .edit
            }
        }
    }
    
    weak var tableCellDelegate: ProfileHeaderTableViewCellDelegate?
    weak var delegate: ProfileHeaderViewDelegate?
    
    
    var profileHeaderTableViewCellViewModel: ProfileHeaderTableViewCellViewModel?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProfileFieldTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProfileRouter) {
        self.router = router
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .signOut, object: nil)
    }
    
    // MARK: - Public methods
    func getProfile(completion: @escaping CompletionBlock) {
        AuthManager.getProfile { [weak self] (viewModel) in
            if let profileModel = viewModel {
                self?.profileEntity = ProfileEntity()
                self?.profileEntity?.traslation(fromProfileModel: profileModel)
                completion(.success)
            }
            
            completion(.failure(reason: nil))
        }
    }
    
    func getName() -> String {
        guard let firstName = profileEntity?.firstName,
            let lastName = profileEntity?.lastName
            else { return "" }
        
        let username = firstName + " " + lastName
        
        return username
    }
    
    func getAvatarURL() -> URL? {
        guard let avatar = profileEntity?.avatar,
            let avatarURL = getFileURL(fileName: avatar)
            else { return nil }
        
        return avatarURL
    }
    
    // MARK: - TableView
    func numberOfSections() -> Int {
        return profileEntity != nil ? sections.count : 0
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
            return ProfileFieldTableViewCellViewModel(text: field.text, placeholder: field.placeholder, editable: field.editable, keyboardType: field.keyboardType, textContentType: field.textContentType, valueChanged: { [weak self] (text) in
                let type: FieldType = FieldType(rawValue: field.placeholder)!
                switch type {
                case .firstName:
                    self?.profileEntity?.firstName = text
                case .middleName:
                    self?.profileEntity?.middleName = text
                case .lastName:
                    self?.profileEntity?.lastName = text
                    
                case .country:
                    self?.profileEntity?.country = text
                case .city:
                    self?.profileEntity?.city = text
                case .address:
                    self?.profileEntity?.address = text
                    
                case .documentNumber:
                    self?.profileEntity?.documentNumber = text
                case .documentType:
                    self?.profileEntity?.documentType = text
                    
                case .phone:
                    self?.profileEntity?.phone = text
                case .birthday:
                    self?.profileEntity?.birthday = Date() //TODO:
                case .gender:
                    self?.profileEntity?.gender = text == "Male" ? true : false
                case .email:
                    self?.profileEntity?.email = text
                    
                default:
                    break
                }
            })
            
        }
    }
    
    func editProfile(completion: @escaping CompletionBlock) {
        profileState = .edit
        completion(.success)
    }
    
    
    func cancelEditProfile(completion: @escaping CompletionBlock) {
        profileState = .show
        completion(.success)
    }
    
    func saveProfile(completion: @escaping CompletionBlock) {
        profileState = .show
        saveProfileApi(completion: completion)
    }
    
    // MARK: - Navigation
    func signOut() {
        AuthManager.authorizedToken = nil
        router.show(routeType: .signOut)
    }
    
    @objc private func signOutNotification(notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .signOut, object: nil)
        signOut()
    }
    
    
    // MARK: -  Private methods
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(signOutNotification(notification:)), name: .signOut, object: nil)
        
        getProfile { [weak self] (result) in
            switch result {
            case .success:
                self?.setupCellViewModel()
            case .failure:
                print("Error")
            }
        }
    }
    
    private func setupCellViewModel() {
        profileHeaderTableViewCellViewModel = ProfileHeaderTableViewCellViewModel(profileEntity: profileEntity ?? ProfileEntity.templateEntity, editable: false, delegate: delegate)
        
        if let profileEntity = profileEntity {
            var editableFields: [EditableField] = []
            
            FieldType.allValues.forEach { (type) in
                let fields = profileEntity.getFields()
                let key = type.rawValue
                
                let text = fields[type] ?? ""
                let placeholder = key.capitalized
                let editable = profileState == .edit
                let keyboardType = profileEntity.getKeyboardTypes(for: type)
                let textContentType = profileEntity.getTextContentTypes(for: type)
                
                let editableField = EditableField(text: text, placeholder: placeholder, editable: editable, keyboardType: keyboardType, textContentType: textContentType, isValid: { (text) -> Bool in
                    return text.count > 1
                })
                
                editableFields.append(editableField)
            }
            
            self.editableFields = editableFields
        }
    }
    
    private func saveProfileApi(completion: @escaping CompletionBlock) {
//        let model = UpdateProfileViewModel(firstName: profileEntity?.firstName,
//                                           middleName: profileEntity?.middleName,
//                                           lastName: profileEntity?.lastName,
//                                           documentType: profileEntity?.documentType,
//                                           documentNumber: profileEntity?.documentNumber,
//                                           country: profileEntity?.country,
//                                           city: profileEntity?.city,
//                                           address: profileEntity?.address,
//                                           phone: profileEntity?.phone,
//                                           birthday: profileEntity?.birthday,
//                                           gender: profileEntity?.gender,
//                                           avatar: profileEntity?.avatar)
//        
//        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }
//        
//        isInvestorApp
//            ? InvestorAPI.apiInvestorProfileUpdatePost(authorization: token, model: model) { (error) in
//                ResponseHandler.handleApi(error: error, completion: completion)
//                }
//            : ManagerAPI.apiManagerProfileUpdatePost(authorization: token, model: model) { (error) in
//                ResponseHandler.handleApi(error: error, completion: completion)
//        }
    }
}
