//
//  ProfileObject.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProfileObject {
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let documentType: String?
    let documentNumber: String?
    let country: String?
    let city: String?
    let address: String?
    let phone: String?
    let birthday: Date?
    let gender: Bool?
    let avatar: String?
    let email: String?
    let balance: Double?
}

extension ProfileObject {

    init(profileFullViewModel: ProfileFullViewModel) {
        firstName = profileFullViewModel.firstName
        middleName = profileFullViewModel.middleName
        self.lastName = profileFullViewModel.lastName
        self.documentType = profileFullViewModel.documentType
        self.documentNumber = profileFullViewModel.documentNumber
        self.country = profileFullViewModel.country
        self.city = profileFullViewModel.city
        self.address = profileFullViewModel.address
        self.phone = profileFullViewModel.phone
        self.birthday = profileFullViewModel.birthday
        self.gender = profileFullViewModel.gender
        self.avatar = profileFullViewModel.avatar
        self.email = profileFullViewModel.email
        self.balance = profileFullViewModel.balance
    }
    
    init(profileShortViewModel: ProfileShortViewModel) {
        self.email = profileShortViewModel.email
        self.balance = profileShortViewModel.balance
        
        self.firstName = nil
        self.middleName = nil
        self.lastName = nil
        self.documentType = nil
        self.documentNumber = nil
        self.country = nil
        self.city = nil
        self.address = nil
        self.phone = nil
        self.birthday = nil
        self.gender = false
        self.avatar = nil
    }
}
