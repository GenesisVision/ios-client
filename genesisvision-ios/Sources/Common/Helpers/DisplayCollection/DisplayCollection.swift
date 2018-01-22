//
//  DisplayCollection.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 17.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

protocol DisplayCollection {
    var numberOfSections: Int { get }
    static var modelsForRegistration: [CellViewAnyModel.Type] { get }
    
    func numberOfRows(in section: Int) -> Int
    func model(for indexPath: IndexPath) -> CellViewAnyModel
}

protocol DisplayCollectionAction {
    func didSelect(indexPath: IndexPath)
}

extension DisplayCollection {
    var numberOfSections: Int {
        return 1
    }
}

