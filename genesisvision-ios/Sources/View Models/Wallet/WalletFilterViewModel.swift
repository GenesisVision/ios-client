//
//  WalletFilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import TTRangeSlider

final class WalletFilterViewModel {
    
    // MARK: - View Model
    private weak var transactionsFilter: TransactionsFilter?
    
    enum SectionType {
        case type
        case dateFrom
        case dateTo
        case program
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    private var sections: [SectionType] = [.type]
    private var router: WalletFilterRouter!
    private var typeList: [String] = [TransactionsFilter.ModelType.all.rawValue, TransactionsFilter.ModelType.external.rawValue, TransactionsFilter.ModelType._internal.rawValue]
    
    var selectedTypeIndex = 0
    private var walletFilterTypeTableViewCellViewModel: WalletFilterTypeTableViewCellViewModel!
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletFilterTypeTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: WalletFilterRouter, transactionsFilter: TransactionsFilter) {
        
        self.router = router
        self.transactionsFilter = transactionsFilter
        
        setup()
    }
    
    // MARK: - Public methods
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel {
        let type = sections[indexPath.section]
        switch type {
        case .type:
            return walletFilterTypeTableViewCellViewModel
        default:
            return walletFilterTypeTableViewCellViewModel
        }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func reset() {
        selectedTypeIndex = 0
    }
    
    func apply(completion: @escaping CompletionBlock) {
        
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    // MARK: - Private methods
    private func setup() {
        walletFilterTypeTableViewCellViewModel = WalletFilterTypeTableViewCellViewModel(selectedIndex: selectedTypeIndex, types: typeList, delegate: nil)
    }
}

