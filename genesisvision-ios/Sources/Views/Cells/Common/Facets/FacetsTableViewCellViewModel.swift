//
//  FacetsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 19/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct FacetsTableViewCellViewModel {
    let facetsViewModel: ListViewModelProtocolWithFacets?
}

extension FacetsTableViewCellViewModel: CellViewModel {
    func setup(on cell: FacetsTableViewCell) {
        
        if let facetsViewModel = facetsViewModel {
            cell.viewModel = facetsViewModel
        }
    }
}


