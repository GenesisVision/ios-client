//
//  TemplateEntityProtocol.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

protocol TemplateEntityProtocol {
    var isTemplate: Bool { get set }
    static var templateEntity: Self { get }
}
