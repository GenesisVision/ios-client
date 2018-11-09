//
//  FilterTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 09/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

struct FilterTableViewCellViewModel {
    var title: String
    var detail: String?
}

extension FilterTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterTableViewCell) {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail ?? ""
    }
}
