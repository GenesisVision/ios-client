//
//  DetailProtocol.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 02.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

protocol DetailProtocol: class {
    func didInvested()
    func didWithdrawn()
    func didRequestCanceled(_ last: Bool)
}
