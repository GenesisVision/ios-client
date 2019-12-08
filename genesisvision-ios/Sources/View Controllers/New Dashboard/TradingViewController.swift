//
//  TradingViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingViewController: ListViewController {
    typealias ViewModel = TradingViewModel
    
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

extension TradingViewController: BaseCellProtocol {
    func action(_ type: CellActionType, actionType: ActionType) {
        print("show all \(type)")
        
        switch type {
        case .tradingEvents:
            let vc = TradingEventListViewController()
            vc.title = "Events"
            navigationController?.pushViewController(vc, animated: true)
        case .tradingPublicList:
            switch actionType {
            case .showAll:
                let vc = TradingPublicListViewController()
                vc.title = "Public"
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case .tradingPrivateList:
            switch actionType {
            case .showAll:
                let vc = TradingPrivateListViewController()
                vc.title = "Private"
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        print("show all \(type)")
        
        switch type {
        case .tradingEvents:
            let vc = BaseViewController()
            vc.title = "Event"
            navigationController?.pushViewController(vc, animated: true)
        case .tradingPublicList:
            let vc = BaseViewController()
            vc.title = "Public"
            navigationController?.pushViewController(vc, animated: true)
        case .tradingPrivateList:
            let vc = BaseViewController()
            vc.title = "Private"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

class TradingViewModel: ListVMProtocol {
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TradingHeaderTableViewCellViewModel.self,
                CellWithCollectionViewModel<TradingPublicShortListViewModel>.self,
                CellWithCollectionViewModel<TradingPrivateShortListViewModel>.self]
    }
    
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
    }
    
    func fetch() {
        viewModels.append(TradingHeaderTableViewCellViewModel(data: TradingHeaderData()))
        viewModels.append(CellWithCollectionViewModel(TradingEventsViewModel(delegate), delegate: delegate))
        viewModels.append(CellWithCollectionViewModel(TradingPublicShortListViewModel(delegate), delegate: delegate))
        viewModels.append(CellWithCollectionViewModel(TradingPrivateShortListViewModel(delegate), delegate: delegate))
        
        delegate?.didReload()
    }
}

