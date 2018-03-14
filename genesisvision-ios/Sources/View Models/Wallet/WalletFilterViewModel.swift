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
    private weak var walletControllerViewModel: WalletControllerViewModel?
    
    enum SectionType {
        case type
        case dateFrom
        case dateTo
        case program
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    var filterProgramId: String?
    var modelType: TransactionsFilter.ModelType = .all
    
    private var sections: [SectionType] = [.type]
    private var router: WalletFilterRouter!
    private var typeList: [String] = [TransactionsFilter.ModelType.all.rawValue, TransactionsFilter.ModelType.external.rawValue, TransactionsFilter.ModelType._internal.rawValue]
    
    private var walletFilterTypeTableViewCellViewModel: WalletFilterTypeTableViewCellViewModel!
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
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
        modelType = .all
        
        walletControllerViewModel?.modelType = modelType
        walletControllerViewModel?.filterProgramId = filterProgramId
    }
    
    func apply(completion: @escaping CompletionBlock) {
        walletControllerViewModel?.modelType = modelType
        walletControllerViewModel?.filterProgramId = filterProgramId
        
        walletControllerViewModel?.refresh(completion: completion)
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    // MARK: - Private methods
    private func setup() {
        if let type = walletControllerViewModel?.modelType {
            modelType = type
        }
        
        filterProgramId = walletControllerViewModel?.filterProgramId
        let selectedIndex = typeList.index(of: modelType.rawValue)
        
        walletFilterTypeTableViewCellViewModel = WalletFilterTypeTableViewCellViewModel(selectedIndex: selectedIndex ?? 0, types: typeList, delegate: self)
    }
}

extension WalletFilterViewModel: WalletFilterTypeTableViewCellProtocol {
    func segmentControlDidChanged(index: Int) {
        if let type = TransactionsFilter.ModelType(rawValue: typeList[index]) {
            modelType = type
        }
    }
}

