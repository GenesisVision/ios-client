//
//  UserEntity.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

final class UserEntity: TemplatableObject, TemplateEntityProtocol {
    
    enum UserStatus: String {
        case complete
        case requiresCompletion
        case unknown
    }
    
    @objc dynamic var id: Int = 0
    @objc dynamic var remoteId: Int = 0
    
    @objc dynamic var photoURL: String?
    
    @objc dynamic var userName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    
    @objc dynamic var phoneNumber: String?
    @objc dynamic var email: String = ""
    
    @objc dynamic var token: String?
    @objc dynamic var statusValue: String = ""
    
    var status: UserStatus {
        get {
            return UserStatus(rawValue: statusValue) ?? .unknown
        }
        set {
            realmWrite {
                statusValue = newValue.rawValue
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var fullName: String {
        return firstName + " " + lastName
    }
}

extension UserEntity {
    static var templateEntity: UserEntity {
        
        let userNames = ["brkj1", "kjhdfs@lkj", "k-kwerwe"]
        let firstNames = ["Ivan", "Petr", "Anton"]
        let lastNames = ["Ivanov", "Petrov", "Antonov"]
        
        let phones = ["+79998887766", nil]
        let emails = ["1@2.ru", "2@2.ru", "3@2.ru", "4@2.ru"]
        let photos = ["http://yandex.ru/logo.png", nil]
        
        let entity = UserEntity()
        entity.photoURL = photos.rand!
        
        entity.userName = userNames.rand!
        entity.firstName = firstNames.rand!
        entity.lastName = lastNames.rand!
        
        entity.phoneNumber = phones.rand!
        entity.email = emails.rand!
        entity.token = "qwe23rffesfw"
        
        return entity
    }
}

