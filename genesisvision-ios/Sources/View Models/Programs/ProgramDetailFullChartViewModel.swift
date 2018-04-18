//
//  ProgramDetailFullChartViewModel.swift
//  genesisvision-ios
//
//  Created by George on 12/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class ProgramDetailFullChartViewModel {
    // MARK: - Variables
    var router: Router!
    var investmentProgramDetails: InvestmentProgramDetails?
    var chartDurationType: ChartDurationType = .week
    
    // MARK: - Init
    init(withRouter router: ProgramDetailFullChartRouter, investmentProgramDetails: InvestmentProgramDetails) {
        self.router = router
        self.investmentProgramDetails = investmentProgramDetails
    }
    
    func dismissVC() {
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.restrictRotation)
        router.closeVC()
    }
    
    // MARK: - Public methods
    var title: String {
        return investmentProgramDetails?.title ?? ""
    }
    
    var subtitle: String? {
        guard let username = investmentProgramDetails?.manager?.username else {
            return nil
        }
        
        return "by " + username
    }
    
    func getAllChartDurationTypes() -> [String] {
        return chartDurationType.allCases
    }
    
    func getSelectedChartDurationTypes() -> Int {
        return chartDurationType.rawValue
    }
    
    func selectChartDurationTypes(index: Int) {
        if let chartDurationType = ChartDurationType(rawValue: index) {
            self.chartDurationType = chartDurationType
        }
    }
    
    func getCurrencyValue() -> String {
        if let currency = investmentProgramDetails?.currency?.rawValue {
            return currency
        }
        
        return ""
    }
}

