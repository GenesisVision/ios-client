//
//  ValitableFields.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 23.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

protocol ValidableFields {
    var validateFields: [Validation.ValidateField] { get }
}
