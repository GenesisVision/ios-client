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
    var router: ProgramRouter!
    var programDetailsFull: ProgramDetailsFull?
    var chartDurationType: ChartDurationType = .week
    
    // MARK: - Init
    init(withRouter router: ProgramRouter, programDetailsFull: ProgramDetailsFull) {
        self.router = router
        self.programDetailsFull = programDetailsFull
    }
    
    func dismissVC() {
        UserDefaults.standard.set(false, forKey: UserDefaults.restrictRotation)
        router.closeVC()
    }
    
    // MARK: - Public methods
    var title: String {
        return programDetailsFull?.title ?? ""
    }
    
    var subtitle: String? {
        guard let username = programDetailsFull?.manager?.username else {
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
        if let currency = programDetailsFull?.currency?.rawValue {
            return currency
        }
        
        return ""
    }
}

