//
//  TradingPrivateListViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingPrivateListViewController: ListViewController {
    typealias ViewModel = TradingPrivateListViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    
    private var addNewBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        viewModel.fetch()
    }
    
    // MARK: - Methods
    private func setup() {
        addNewBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_add_photo_icon"), style: .done, target: self, action: #selector(addNewButtonAction))
        navigationItem.rightBarButtonItems = [addNewBarButtonItem]
        
        viewModel = ViewModel(self)
        
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    @objc private func addNewButtonAction() {
        showActionSheet(with: nil,
                    message: nil,
                    firstActionTitle: "Create account",
                    firstHandler: { [weak self] in
                        guard let vc = CreateAccountViewController.storyboardInstance(.dashboard) else { return }
                        vc.title = "Create account"
                        let nav = BaseNavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true, completion: nil)
        },
                    secondActionTitle: "Attach account",
                    secondHandler: { [weak self] in
                        guard let vc = AttachAccountViewController.storyboardInstance(.dashboard) else { return }
                        vc.title = "Attach account"
                        let nav = BaseNavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true, completion: nil)
        },
                    thirdActionTitle: "Make program",
                    thirdHandler: { [weak self] in
                        guard let vc = MakeProgramViewController.storyboardInstance(.dashboard) else { return }
                        vc.title = "Make program"
                        let nav = BaseNavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true, completion: nil)
        },
                    fourthActionTitle: "Make signal",
                    fourthHandler: { [weak self] in
                        guard let vc = MakeSignalViewController.storyboardInstance(.dashboard) else { return }
                        vc.title = "Make signal"
                        let nav = BaseNavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true, completion: nil)
        },
                    cancelTitle: "Cancel",
                    cancelHandler: nil)
    }
}

extension TradingPrivateListViewController: BaseCellProtocol {
    func didSelect(_ type: CellActionType, cellViewModel viewModel: CellViewAnyModel?) {
        
    }
}

class TradingPrivateListViewModel: ListVMProtocol {
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundTableViewCellViewModel.self]
    }
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
    }
    
    func fetch() {
        let viewModel = FundTableViewCellViewModel(asset: FundDetails(totalAssetsCount: 1, topFundAssets: [FundAssetPercent(asset: "title", name: "name", percent: 10, icon: nil)], statistic: nil, personalDetails: nil, dashboardAssetsDetails: nil, id: nil, logo: nil, url: nil, color: nil, title: "title", description: "Descr", status: .active, creationDate: Date(), manager: nil, chart: nil), delegate: nil)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        viewModels.append(viewModel)
        
        delegate?.didReload()
    }
}
