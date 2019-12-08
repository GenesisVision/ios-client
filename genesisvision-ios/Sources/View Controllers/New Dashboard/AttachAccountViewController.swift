//
//  AttachAccountViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class AttachAccountViewController: BaseModalViewController {
    typealias ViewModel = AttachAccountViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: AttachStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //FIXIT: add bar item for close
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        let attachAction: () -> Void = {
            print("attachAction")
        }
        stackView.configure(attachAction)
        viewModel = AttachAccountViewModel(self)
    }
    
    // MARK: - Actions
    @IBAction func attachAccountButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectExchangeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.exchangeListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.exchangeListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.exchangeListDataSource
            tableView.dataSource = viewModel.exchangeListDataSource
            tableView.reloadData()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
}

extension AttachAccountViewController: BaseCellProtocol {
    func didSelect(_ type: DidSelectType, index: Int) {
        switch type {
        case .exchange:
            stackView.exchangeView.textLabel.text = viewModel.exchangeListViewModel.selected
        default:
            break
        }
        
        bottomSheetController.dismiss()
    }
}

class AttachAccountViewModel {
    // MARK: - Variables
    var exchangeListViewModel: ExchangeListViewModel!
    var exchangeListDataSource: TableViewDataSource<ExchangeListViewModel>!
    
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
        
        let exchanges = ["Binance"]
        exchangeListViewModel = ExchangeListViewModel(delegate, items: exchanges, selected: nil)
        exchangeListDataSource = TableViewDataSource(exchangeListViewModel)
    }
}
