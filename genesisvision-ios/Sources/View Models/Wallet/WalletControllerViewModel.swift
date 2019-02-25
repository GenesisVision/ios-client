//
//  WalletControllerViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

class Person {
    var name: String = ""
    var child: Person?
    
    func a() {
        let a = Person()
        
    }
    
}
final class WalletControllerViewModel {
    
    enum SectionType {
        case header
        case transactions
    }
    
    // MARK: - Variables
    var title: String = "Wallet"
    
    private var sections: [SectionType] = [.header, .transactions]

    var router: WalletRouter!
//    private var transactions = [WalletTransactionTableViewCellViewModel]()
    private weak var reloadDataProtocol: ReloadDataProtocol?

    var walletTabmanViewModel: WalletTabmanViewModel?
    
    var dateFrom: Date?
    var dateTo: Date?
    
    var bottomViewType: BottomViewType = .sort
    
    var isLoading: Bool = false
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var skip = 0            //offset
    var take = ApiKeys.take
    var totalCount = 0      //total count of programs
    
    // MARK: - Init
    init(withRouter router: WalletRouter) {
        self.router = router
        self.reloadDataProtocol = router.topViewController() as? ReloadDataProtocol
        
        walletTabmanViewModel = WalletTabmanViewModel(withRouter: router)
    }
}


// MARK: - Navigation
extension WalletControllerViewModel {
    func showDetail(at indexPath: IndexPath) {
//        guard let model: WalletTransactionTableViewCellViewModel = model(at: indexPath) as? WalletTransactionTableViewCellViewModel,
//            let program = model.walletTransaction.program,
//            let programId = program.id
//            else { return }
//        
//        router.show(routeType: .showProgramDetails(programId: programId.uuidString))
    }
    
    func showProgramList() {
        router.show(routeType: .programList)
    }
}
