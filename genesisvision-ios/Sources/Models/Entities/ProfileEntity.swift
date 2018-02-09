//
//  ProfileEntity.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

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
    case balance = "Balance"
}

final class ProfileEntity: Object {

    @objc dynamic var firstName: String?
    @objc dynamic var middleName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var documentType: String?
    @objc dynamic var documentNumber: String?
    @objc dynamic var country: String?
    @objc dynamic var city: String?
    @objc dynamic var address: String?
    @objc dynamic var phone: String?
    @objc dynamic var birthday: Date?
    @objc dynamic var gender: Bool = false
    @objc dynamic var avatar: String?
    @objc dynamic var email: String?
    @objc dynamic var balance: Double = 0.0
    
    @objc dynamic var statusValue: String = ""

    var fullName: String {
        guard let firstName = firstName, let lastName = lastName else { return String.placeholder }
        return firstName + " " + lastName
    }
    
    func getFieldsCount() -> Int {
        return getFields().count
    }
    
    func getFields() -> [FieldType : String] {
        return [.firstName : firstName ?? "",
                .middleName : middleName ?? "",
                .lastName : lastName ?? "",
                .documentType : lastName ?? "",
                .documentNumber : documentNumber ?? "",
                .country : country ?? "",
                .city : city ?? "",
                .address : address ?? "",
                .phone : phone ?? "",
                .birthday : getBirthday(),
                .gender : getGender(),
                .email : email ?? ""]
    }
    
    func getKeyboardTypes(for fieldType: FieldType) -> UIKeyboardType {
        switch fieldType {
        case .email:
            return .emailAddress
        case .gender:
            return .asciiCapableNumberPad
        default:
            return .default
        }
    }
    
    func getTextContentTypes(for fieldType: FieldType) -> UITextContentType? {
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
    
    func getBirthday() -> String {
        guard let date = birthday else { return "" }
        
        return date.defaultFormatString
    }
    
    func getGender() -> String {
        return gender ? "Male" : "Female"
    }
}

extension ProfileEntity {
    static var templateEntity: ProfileEntity {
        
        let templates = ["Tamplate1", "Template2", "Template3"]
        
        let logos = ["https://goo.gl/images/tR9X4d", nil]
        
        let entity = ProfileEntity()
        entity.firstName = templates.rand!
        entity.middleName = templates.rand!
        entity.lastName = templates.rand!
        entity.documentType = templates.rand!
        entity.documentNumber = templates.rand!
        entity.country = templates.rand!
        entity.city = templates.rand!
        entity.address = templates.rand!
        entity.phone = templates.rand!
        entity.birthday = Date()
        entity.gender = true
        entity.avatar = logos.rand!
        entity.email = templates.rand!
        entity.balance = [0.0, 20.0, 30.0, 1.0].rand!
        
        return entity
    }
    
    func traslation(fromProfileModel profileModel: ProfileFullViewModel) {
        self.firstName = profileModel.firstName ?? nil
        self.middleName = profileModel.middleName ?? nil
        self.lastName = profileModel.lastName ?? nil
        self.documentType = profileModel.documentType ?? nil
        self.documentNumber = profileModel.documentNumber ?? nil
        self.country = profileModel.country ?? nil
        self.city = profileModel.city ?? nil
        self.address = profileModel.address ?? nil
        self.phone = profileModel.phone ?? nil
        self.birthday = profileModel.birthday ?? nil
        self.gender = profileModel.gender ?? true
        self.avatar = profileModel.avatar ?? nil
        self.email = profileModel.email ?? nil
        self.balance = profileModel.balance ?? 0.0
    }
}
