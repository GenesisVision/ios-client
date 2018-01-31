//
//  RouterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class FilterViewModel {
    
    // MARK: - Variables
    private var router: FilterRouter!
    private var filterModel: InvestmentsFilter?
    
    // MARK: - Init
    init(withRouter router: FilterRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func reset() {
        router.show(routeType: .reset)
    }
    
    func apply() {
        
    }
    
    func updateFilter(managerId: UUID? = nil,
                      brokerId: UUID? = nil,
                      brokerTradeServerId: UUID? = nil,
                      investMaxAmountFrom: Double? = nil,
                      investMaxAmountTo: Double? = nil,
                      sorting: InvestmentsFilter.Sorting? = nil,
                      skip: Int? = nil,
                      take: Int? = nil) {
        filterModel = InvestmentsFilter(managerId: managerId,
                                        brokerId: brokerId,
                                        brokerTradeServerId: brokerTradeServerId,
                                        investMaxAmountFrom: investMaxAmountFrom,
                                        investMaxAmountTo: investMaxAmountTo,
                                        sorting: sorting,
                                        skip: skip,
                                        take: take)
    }
}



