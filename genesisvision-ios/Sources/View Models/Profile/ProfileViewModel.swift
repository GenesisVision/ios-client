//
//  ProfileViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum FieldType: String, EnumCollection {
    case firstName = "First Name"
    case middleName = "Middle Name"
    case lastName = "Last Name"
    
    case documentType = "Document Type"
    case documentNumber = "Document Number"
    
    case country = "Country"
    case city = "City"
    case address = "Address"
    
    case phone = "Phone"
    case birthday = "Birthday"
    case gender = "Gender"
    case avatar = "Avatar"
    case email = "Email"
}

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
    private var profileModel: ProfileFullViewModel?
    private var editProfileModel: ProfileFullViewModel?
    
    var editableFields: [EditableField]!
    var pickedImage: UIImage?
    var pickedImageURL: URL?
    
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
            for idx in 0...editableFields.count - 1 {
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
                self?.profileModel = profileModel
                completion(.success)
            }
            
            completion(.failure(reason: nil))
        }
    }
    
    func getName() -> String {
        guard let firstName = profileModel?.firstName,
            let lastName = profileModel?.lastName
            else { return "" }
        
        let username = firstName + " " + lastName
        
        return username
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
            return ProfileFieldTableViewCellViewModel(text: field.text, placeholder: field.placeholder, editable: field.editable, keyboardType: field.keyboardType, textContentType: field.textContentType, valueChanged: { [weak self] (text) in
                let type: FieldType = FieldType(rawValue: field.placeholder)!
                switch type {
                case .firstName:
                    self?.profileModel?.firstName = text
                case .middleName:
                    self?.profileModel?.middleName = text
                case .lastName:
                    self?.profileModel?.lastName = text
                    
                case .country:
                    self?.profileModel?.country = text
                case .city:
                    self?.profileModel?.city = text
                case .address:
                    self?.profileModel?.address = text
                    
                case .documentNumber:
                    self?.profileModel?.documentNumber = text
                case .documentType:
                    self?.profileModel?.documentType = text
                    
                case .phone:
                    self?.profileModel?.phone = text
                case .birthday:
                    self?.profileModel?.birthday = Date() //TODO:
                case .gender:
                    self?.profileModel?.gender = text == "Male" ? true : false
                case .email:
                    self?.profileModel?.email = text
                    
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
    
    private func getFields() -> [FieldType : String] {
        return [.firstName : profileModel?.firstName ?? "",
                .middleName : profileModel?.middleName ?? "",
                .lastName : profileModel?.lastName ?? "",
                .documentType : profileModel?.lastName ?? "",
                .documentNumber : profileModel?.documentNumber ?? "",
                .country : profileModel?.country ?? "",
                .city : profileModel?.city ?? "",
                .address : profileModel?.address ?? "",
                .phone : profileModel?.phone ?? "",
                .birthday : getBirthday(),
                .gender : getGender(),
                .email : profileModel?.email ?? ""]
    }
    
    private func getKeyboardTypes(for fieldType: FieldType) -> UIKeyboardType {
        switch fieldType {
        case .email:
            return .emailAddress
        case .gender:
            return .asciiCapableNumberPad
        default:
            return .default
        }
    }
    
    private func getTextContentTypes(for fieldType: FieldType) -> UITextContentType? {
        switch fieldType {
        case .address:
            return .fullStreetAddress
        case .country:
            return .countryName
        case .city:
            return .addressCity
        case .firstName:
            return .name
        case .middleName:
            return .middleName
        case .lastName:
            return .familyName
        case .phone:
            return .telephoneNumber
        default:
            return nil
        }
    }
    
    private func setupCellViewModel() {
        if let profileModel = profileModel {
            profileHeaderTableViewCellViewModel = ProfileHeaderTableViewCellViewModel(profileModel: profileModel, editable: false, delegate: delegate)
            
            var editableFields: [EditableField] = []
            
            FieldType.allValues.forEach { (type) in
                let fields = getFields()
                let key = type.rawValue
                
                let text = fields[type] ?? ""
                let placeholder = key.capitalized
                let editable = profileState == .edit
                let keyboardType = getKeyboardTypes(for: type)
                let textContentType = getTextContentTypes(for: type)
                
                let editableField = EditableField(text: text, placeholder: placeholder, editable: editable, keyboardType: keyboardType, textContentType: textContentType, isValid: { (text) -> Bool in
                    return text.count > 1
                })
                
                editableFields.append(editableField)
            }
            
            self.editableFields = editableFields
        }
    }
    
    var fullName: String {
        guard let firstName = profileModel?.firstName, let lastName = profileModel?.lastName else { return String.placeholder }
        return firstName + " " + lastName
    }
    
    func getBirthday() -> String {
        guard let date = profileModel?.birthday else { return "" }
        
        return date.defaultFormatString
    }
    
    func getGender() -> String {
        guard let gender = profileModel?.gender else { return "" }
        
        return gender ? "Male" : "Female"
    }
    
    private func saveProfileApi(completion: @escaping CompletionBlock) {
        if let pickedImageURL = pickedImageURL {
            FilesAPI.apiFilesUploadPost(uploadedFile: pickedImageURL) { (result, error) in
                print(result ?? "")
                completion(.failure(reason: nil))
            }
        }
        
        let model = UpdateProfileViewModel(userName: editProfileModel?.userName,
                                           firstName: editProfileModel?.firstName,
                                           middleName: editProfileModel?.middleName,
                                           lastName: editProfileModel?.lastName,
                                           documentType: editProfileModel?.documentType,
                                           documentNumber: editProfileModel?.documentNumber,
                                           country: editProfileModel?.country,
                                           city: editProfileModel?.city,
                                           address: editProfileModel?.address,
                                           phone: editProfileModel?.phone,
                                           birthday: editProfileModel?.birthday,
                                           gender: editProfileModel?.gender,
                                           avatar: editProfileModel?.avatar)
        

        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }

        isInvestorApp
            ? InvestorAPI.apiInvestorProfileUpdatePost(authorization: token, model: model) { (error) in
                ResponseHandler.handleApi(error: error, completion: completion)
                }
            : ManagerAPI.apiManagerProfileUpdatePost(authorization: token, model: model) { (error) in
                ResponseHandler.handleApi(error: error, completion: completion)
        }
    }
}
