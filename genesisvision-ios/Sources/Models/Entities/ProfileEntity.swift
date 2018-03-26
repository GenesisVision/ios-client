//
//  ProfileEntity.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class ProfileEntity {

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
    
    @objc dynamic var statusValue: String = ""

    
}
