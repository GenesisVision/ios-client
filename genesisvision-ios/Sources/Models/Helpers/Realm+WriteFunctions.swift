//
//  Realm+WriteFunctions.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    public func realmWrite(_ block: (() -> Void)) {
        if isInWriteTransaction {
            block()
        } else {
            do {
                try write(block)
            } catch {
                NotificationCenter.default.post(name: .RealmWritingErrorNotifications,
                                                object: nil)
                assertionFailure("Realm write error: \(error)")
            }
        }
    }
}

func realmWrite(realm: Realm = mainRealm, _ block: (() -> Void)) {
    realm.realmWrite(block)
}
