//
//  TraderEntity.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

final class TraderEntity: TemplatableObject, TemplateEntityProtocol {
    @objc dynamic var photoURL: String?
    @objc dynamic var level: Int = 1
    
    @objc dynamic var currency: String = Currency.gvt.rawValue
    
    @objc dynamic var userName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    
    @objc dynamic var deposit: Int = 0
    @objc dynamic var trades: Int = 0
    @objc dynamic var weeks: Int = 0
    @objc dynamic var profit: Int  = 0

    @objc dynamic var phoneNumber: String?
    @objc dynamic var email: String = ""
    
    func getCurrency() -> Currency {
        return Currency(rawValue: currency)!
    }
    
    var fullName: String {
        return firstName + " " + lastName
    }
}

extension TraderEntity {
    static var templateEntity: TraderEntity {
        
        let userNames = ["brkj1", "kjhdfs@lkj", "k-kwerwe"]
        let firstNames = ["Ivan", "Petr", "Anton"]
        let lastNames = ["Ivanov", "Petrov", "Antonov"]

        let phones = ["+79998887766", nil]
        let emails = ["1@2.ru", "2@2.ru", "3@2.ru", "4@2.ru"]
        let photos = ["http://yandex.ru/logo.png", nil]
        
        let deposits = Int(arc4random_uniform(UInt32(100000)))
        let levels = [1, 2, 3, 4, 5, 6, 7]
        let profit = [24, -13, 21, 25, 78, 0, -45]
        let currency: [Currency] = [.gvt, .btc, .eth]
        let trade = Int(arc4random_uniform(UInt32(100)))
        let weeks = Int(arc4random_uniform(UInt32(10)))
        
        let entity = TraderEntity()
        entity.photoURL = photos.rand!
        entity.level = levels.rand!
        entity.userName = userNames.rand!
        entity.firstName = firstNames.rand!
        entity.lastName = lastNames.rand!
        entity.deposit = deposits
        entity.trades = trade
        entity.weeks = weeks
        entity.profit = profit.rand!
        entity.currency = currency.rand!.rawValue
        entity.phoneNumber = phones.rand!
        entity.email = emails.rand!
        
        return entity
    }
}
