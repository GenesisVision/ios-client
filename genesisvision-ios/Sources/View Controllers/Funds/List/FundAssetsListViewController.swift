//
//  FundAssetsListViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 19.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

protocol AssetListSelectedProtocol {
    func assetSelected(asset: PlatformAsset)
}

class FundAssetsListViewController: BaseViewControllerWithTableView {
    
    var viewModel: FundAssetsListViewModel!
    
    var assetListSelectedDelegate: AssetListSelectedProtocol?
    
    override var tableView: UITableView! {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add asset"
        setupTableConfiguration()
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        let rect = CGRect(x: tableView.frame.minX, y: tableView.frame.minY, width: tableView.width, height: 60)
        let headerView = SearchHeaderView(frame: rect)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.searchFieldDelegate = self
        
        self.view.addSubview(headerView)
        
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 50))
    }
    
    private func setupTableConfiguration() {
        tableView.removeFromSuperview()
        tableView = UITableView(frame: .zero, style: tableViewStyle)
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.fillSuperview(padding: UIEdgeInsets(top: 70, left: 10, bottom: 10, right: 10))
        
        tableView.roundCorners(with: 10)
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
}

extension FundAssetsListViewController: SearchHeaderTextChangedProtocol {
    func textChanged(text: String) {
        guard !text.isEmpty else { return }
        
        viewModel.filterAssets(text: text)
    }
    
}

extension FundAssetsListViewController: BaseTableViewProtocol {
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value: value)
    }
    
    func didReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        guard let cellViewModel = cellViewModel as? FundAssetsListTableViewCellViewModel, let assetModel = cellViewModel.assetModel else { return }
        navigationController?.popViewController(animated: true)
        assetListSelectedDelegate?.assetSelected(asset: assetModel)
    }
}



final class FundAssetsListViewModel: ListViewModelWithPaging {
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    typealias CellViewModel = FundAssetsListTableViewCellViewModel
    
    var canFetchMoreResults: Bool = false
    
    var canPullToRefresh: Bool = false
    
    var skip: Int = 0
    
    var viewModels: [CellViewAnyModel] = []
    
    var copyViewModels: [CellViewAnyModel] = []
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundAssetsListTableViewCellViewModel.self]
    }
    var assets: [PlatformAsset] = [PlatformAsset]()
    
    weak var delegate: BaseTableViewProtocol?
    
    init(delegate: BaseTableViewProtocol) {
        self.delegate = delegate
        
        
        PlatformManager.shared.getPlatformAssets { [weak self] (model) in
            if let assets = model?.assets {
                self?.assets = assets
                self?.updateAssets()
            }
        }
    }
    
    func updateAssets() {
        var models = [FundAssetsListTableViewCellViewModel]()
        
        assets.sort { $0.asset ?? "" < $1.asset ?? "" }
        assets.sort { $0.mandatoryFundPercent! > $1.mandatoryFundPercent! }
        
        assets.forEach { (asset) in
            models.append(FundAssetsListTableViewCellViewModel(assetModel: asset))
        }
        
        viewModels = models
        copyViewModels = models
        delegate?.didReload()
    }
    
    func filterAssets(text: String) {
        viewModels = copyViewModels
        
        viewModels = viewModels.filter { (viewModel) -> Bool in
            guard let viewModel = viewModel as? FundAssetsListTableViewCellViewModel else { return false }
            
            if let contains = viewModel.assetModel?.asset?.lowercased().contains(text.lowercased()), contains {
                return true
            } else if let contains = viewModel.assetModel?.name?.lowercased().contains(text.lowercased()), contains {
                return true
            } else {
                return false
            }
        }
        delegate?.didReload()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        return viewModels[indexPath.row]
    }
    
    func numberOfRows(in section: Int) -> Int {
        viewModels.count
    }
    
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.none, cellViewModel: viewModels[indexPath.row])
    }
}
