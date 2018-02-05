//
//  ProfileFieldTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct ProfileFieldTableViewCellViewModel {
    var text: String
    var placeholder: String
    var editable: Bool
}

extension ProfileFieldTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProfileFieldTableViewCell) {
        cell.textField.text = text
        cell.textField.placeholder = placeholder
        cell.textField.isUserInteractionEnabled = editable
    }
}
