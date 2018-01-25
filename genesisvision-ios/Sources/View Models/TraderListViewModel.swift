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
    
    var dataType: DataType = .api
    
    var skip = 0    //offset
    var take = 10   //count of programs
    
    var investmentProgramViewModels = [InvestmentProgramTableViewCellModel]()
    
    func fetch(completion:@escaping () -> Void) {
        switch dataType {
        case .api:
            let filter = InvestmentsFilter(managerId: nil, brokerId: nil, brokerTradeServerId: nil, investMaxAmountFrom: nil, investMaxAmountTo: nil, sorting: .byRatingAsc, skip: skip, take: take)
            apiInvestmentPrograms(withFilter: filter, completion: { [weak self] (investmentPrograms) in
                var investmentProgramViewModels = [InvestmentProgramTableViewCellModel]()
                
                for investmentProgram in investmentPrograms {
                    let entity = InvestmentProgramEntity()
                    entity.traslation(fromInvestmentProgram: investmentProgram)
                    let traderTableViewCellModel = InvestmentProgramTableViewCellModel(investmentProgramEntity: entity)
                    investmentProgramViewModels.append(traderTableViewCellModel)
                }
                
                self?.investmentProgramViewModels = investmentProgramViewModels
                completion()
            })
        case .fake:
            fakeInvestmentPrograms { [weak self] (investmentProgramViewModels) in
                self?.investmentProgramViewModels = investmentProgramViewModels
                completion()
            }
        }
    }
    
    func fetchMore(completion:@escaping () -> Void) {
        skip += take
        fetch(completion: completion)
    }
    
    func refresh(completion:@escaping () -> Void) {
        skip = 0
        fetch(completion: completion)
    }
    
    func programsCount() -> Int {
        return investmentProgramViewModels.count
    }
    
    func getProgram(atIndex index: Int) -> InvestmentProgramTableViewCellModel {
        return investmentProgramViewModels[index]
    }
    
    // MARK: - Private methods
    
    private func apiInvestmentPrograms(withFilter filter: InvestmentsFilter, completion: @escaping (_ traderCellModels: [InvestmentProgram]) -> Void) {
        InvestorAPI.apiInvestorInvestmentsPostWithRequestBuilder(filter: filter).execute { (response, error) in
            guard response != nil && response?.statusCode == 200 else {
                return ErrorHandler.handleApiError(error: error, completion: { (result) in print(result) })
            }

            guard let investmentProgramViewModels = response?.body?.investments else {
                return completion([])
            }
            
            completion(investmentProgramViewModels)
        }
    }
    
    private func fakeInvestmentPrograms(completion: (_ traderCellModels: [InvestmentProgramTableViewCellModel]) -> Void) {
        var cellModels = [InvestmentProgramTableViewCellModel]()
        
        for _ in 0..<Constants.TemplatesCounts.traders {
            cellModels.append(InvestmentProgramTableViewCellModel(investmentProgramEntity: InvestmentProgramEntity.templateEntity))
        }
        
        completion(cellModels)
    }
}
