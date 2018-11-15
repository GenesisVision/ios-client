//
//  WalletFilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class WalletFilterViewModel {
    
    // MARK: - View Model
    private weak var walletControllerViewModel: WalletControllerViewModel?
    
    enum SectionType {
        case type
        case dateFrom
        case dateTo
        case program
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    var filter: TransactionsFilter?
    
    private var sections: [SectionType] = [.type]
    private var router: WalletFilterRouter!
    private var typeList: [String] = [TransactionsFilter.ModelType.all.rawValue, TransactionsFilter.ModelType.external.rawValue, TransactionsFilter.ModelType._internal.rawValue]
    
    private var walletFilterTypeTableViewCellViewModel: WalletFilterTypeTableViewCellViewModel!
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletFilterTypeTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: WalletFilterRouter, walletControllerViewModel: WalletControllerViewModel) {
        
        self.router = router
        self.walletControllerViewModel = walletControllerViewModel
        
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
        filter?.type = .all
        
        walletControllerViewModel?.filter = filter
    }
    
    func apply(completion: @escaping CompletionBlock) {
        walletControllerViewModel?.filter = filter
        
        walletControllerViewModel?.refresh(completion: completion)
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    // MARK: - Private methods
    private func setup() {
        if let filter = walletControllerViewModel?.filter {
            self.filter = filter
        }
        
        guard let type = filter?.type else { return }
        
        let selectedIndex = typeList.index(of: type.rawValue)
        
        walletFilterTypeTableViewCellViewModel = WalletFilterTypeTableViewCellViewModel(selectedIndex: selectedIndex ?? 0, types: typeList, delegate: self)
    }
}

extension WalletFilterViewModel: WalletFilterTypeTableViewCellProtocol {
    func segmentControlDidChanged(index: Int) {
        if let type = TransactionsFilter.ModelType(rawValue: typeList[index]) {
            filter?.type = type
        }
    }
}

