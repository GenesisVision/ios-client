//
//  ReferralInfoViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 28.10.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class ReferralInfoViewController: BaseViewControllerWithTableView {
    
    var viewModel: ReferralInfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        tableView.configure(with: .defaultConfiguration)

        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
        tableView.backgroundColor = UIColor.Cell.headerBg
        setupPullToRefresh(scrollView: tableView)
    }
}

final class ReferralInfoViewModel: ViewModelWithListProtocol {
    
    enum SectionType {
        case link
        case statistics
    }
    
    var canPullToRefresh: Bool = true
    
    var viewModels: [CellViewAnyModel] = []
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
}
