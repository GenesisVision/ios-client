//
//  TraderListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum DataType {
    case api
    case fake
}

class TraderListViewModel {
    
    var dataType: DataType = .fake
    
    var programViewModels = [TraderTableViewCellModel]()
    
    func fetch(completion:@escaping () -> Void) {
        switch dataType {
        case .api:
            let filter = InvestmentsFilter(managerId: nil, brokerId: nil, brokerTradeServerId: nil, investMaxAmountFrom: nil, investMaxAmountTo: nil, sorting: nil, skip: nil, take: nil)
            apiInvestmentPrograms(withFilter: filter, completion: { [weak self] (cellModels) in
                guard let programs = cellModels else {
                    return
                }
                
                self?.programViewModels = programs
                
                completion()
            })
        case .fake:
            fakeInvestmentPrograms { [weak self] (cellModels) in
                self?.programViewModels = cellModels
                completion()
            }
        }
    }
    
    func programsCount() -> Int {
        return programViewModels.count
    }
    
    // MARK: - Private methods
    
    private func apiInvestmentPrograms(withFilter filter: InvestmentsFilter, completion: @escaping (_ traderCellModels: [TraderTableViewCellModel]?) -> Void) {
        InvestorAPI.apiInvestorInvestmentsPostWithRequestBuilder(filter: filter).execute { (response, error) in
            guard response != nil && response?.statusCode == 200 else {
                return ErrorHandler.handleApiError(error: error, completion: { (result) in print(result) })
            }

            guard let investmentProgramViewModels = response?.body?.investments else {
                return completion(nil)
            }
            
            print(investmentProgramViewModels)
            
            var cellModels = [TraderTableViewCellModel]()
            
            for investmentProgramViewModel in investmentProgramViewModels {
                print(investmentProgramViewModel)
                cellModels.append(TraderTableViewCellModel(traderEntity: TraderEntity.templateEntity, index: 0)) //TODO: add binding
            }
            
            completion(cellModels)
        }
    }
    
    private func fakeInvestmentPrograms(completion: (_ traderCellModels: [TraderTableViewCellModel]) -> Void) {
        var cellModels = [TraderTableViewCellModel]()
        
        for index in 0..<Constants.TemplatesCounts.traders {
            cellModels.append(TraderTableViewCellModel(traderEntity: TraderEntity.templateEntity, index: index))
        }
        
        completion(cellModels)
    }
}
