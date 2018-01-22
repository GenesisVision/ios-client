//
//  TemplatableObject.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

class TemplatableObject: Object {
    @objc dynamic var isTemplate: Bool = false
    override class func ignoredProperties() -> [String] {
        return ["isTemplate"]
    }
}
