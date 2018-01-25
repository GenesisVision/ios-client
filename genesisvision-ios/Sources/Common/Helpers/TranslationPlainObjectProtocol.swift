//
//  TranslationPlainObjectProtocol.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

protocol PlainObjectTranslation {
    associatedtype Value = CellViewModel //TODO: !!!!
    // Would be Realm class to ref to something
    associatedtype Parent = Object
    
    static func translate(of plainObjects: [Value], to parent: Parent?)
    static func addToRealm(plainObject: Value, to parent: Parent?)
}

extension PlainObjectTranslation {
    static func translate(of plainObjects: [Value], to parent: Parent?) {
        plainObjects.forEach({
            addToRealm(plainObject: $0, to: parent)
        })
    }
}
