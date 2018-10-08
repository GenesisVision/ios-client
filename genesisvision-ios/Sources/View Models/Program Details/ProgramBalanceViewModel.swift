//
//  ProgramBalanceViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class ProgramBalanceViewModel {
    enum SectionType {
        case chart
    }
    
    // MARK: - Variables
    var title: String = "Balance".uppercased()
    var programId: String?
    
    var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var dataType: DataType = .api

    private var programBalanceChart: ProgramBalanceChart?
    
    private var sections: [SectionType] = [.chart]
    
    // MARK: - Init
    init(withRouter router: Router, programId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.programId = programId
        self.reloadDataProtocol = reloadDataProtocol
    }
}

// MARK: - TableView
extension ProgramBalanceViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramBalanceChartTableViewCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
}

// MARK: - Fetch
extension ProgramBalanceViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> ProgramBalanceChartTableViewCellViewModel? {
        guard let programBalanceChart = programBalanceChart else { return nil }
        return ProgramBalanceChartTableViewCellViewModel(programBalanceChart: programBalanceChart)
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let programId = programId else { return completion(.failure(errorType: .apiError(message: nil))) }
            ProgramDataProvider.getProgramBalanceChart(with: programId, completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                
                self?.programBalanceChart = viewModel
                
                completion(.success)
            }, errorCompletion: completion)
        case .fake:
            break
        }
    }
}
