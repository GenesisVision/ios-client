//
//  InvestingViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class InvestingViewController: ListViewController {
    typealias ViewModel = InvestingViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        viewModel.fetch()
    }
    
    // MARK: - Methods
    private func setup() {
        viewModel = ViewModel(self)
        
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

extension InvestingViewController: BaseCellProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        print("show all \(type)")
        
        switch type {
        case .investingEvents:
            let vc = BaseViewController()
            vc.title = "Event"
            navigationController?.pushViewController(vc, animated: true)
        case .investingPrograms:
            let vc = BaseViewController()
            vc.title = "Program"
            navigationController?.pushViewController(vc, animated: true)
        case .investingFunds:
            let vc = BaseViewController()
            vc.title = "Fund"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func action(_ type: CellActionType, actionType: ActionType) {
        print("show all \(type)")
        
        switch type {
        case .investingEvents:
            let vc = InvestingEventListViewController()
            vc.title = "Events"
            navigationController?.pushViewController(vc, animated: true)
        case .investingPrograms:
            let vc = InvestingProgramListViewController()
            vc.title = "Programs"
            navigationController?.pushViewController(vc, animated: true)
        case .investingFunds:
            let vc = InvestingFundListViewController()
            vc.title = "Funds"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

class InvestingViewModel: ListVMProtocol {
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [InvestingHeaderTableViewCellViewModel.self,
                CellWithCollectionViewModel<InvestingRequestsViewModel>.self,
                CellWithCollectionViewModel<InvestingEventsViewModel>.self,
                CellWithCollectionViewModel<InvestingProgramsViewModel>.self,
                CellWithCollectionViewModel<InvestingFundsViewModel>.self,
        ]
    }
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
    }
    
    func fetch() {
        viewModels.append(InvestingHeaderTableViewCellViewModel(data: InvestingHeaderData()))
        viewModels.append(CellWithCollectionViewModel(InvestingRequestsViewModel(delegate), delegate: delegate))
        viewModels.append(CellWithCollectionViewModel(InvestingEventsViewModel(delegate), delegate: delegate))
        viewModels.append(CellWithCollectionViewModel(InvestingProgramsViewModel(delegate), delegate: delegate))
        viewModels.append(CellWithCollectionViewModel(InvestingFundsViewModel(delegate), delegate: delegate))
        
        delegate?.didReload()
    }
}
