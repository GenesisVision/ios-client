//
//  Object+Singletone.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 23.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

protocol ObjectSingletone: class {
    init()
}

extension ObjectSingletone where Self: Object {
    static var value: Self {
        let object = mainRealm.objects(Self.self).first
        if let value = object {
            return value
        } else {
            let value = Self()
            
            mainRealm.realmWrite {
                mainRealm.add(value)
            }
            
            return value
        }
    }
}

