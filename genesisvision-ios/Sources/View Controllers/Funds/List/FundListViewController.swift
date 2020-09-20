//
//  FundListViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundListViewController: BaseViewControllerWithTableView {
    
    // MARK: - Variables
    private var signInButtonEnable: Bool = false
    private var infoBarButtonItem: UIBarButtonItem!
    
    // MARK: - View Model
    var viewModel: ListViewModel!
    var topTableViewModel: WeeklyChallangeTableViewModel!
    weak var searchProtocol: SearchViewControllerProtocol?
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    @IBOutlet weak var topTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gvWeeklyChallngeTableView: UITableView!
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSignInButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarDidScrollToTop(_:)), name: .tabBarDidScrollToTop, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .tabBarDidScrollToTop, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tabBarDidScrollToTop, object: nil)
    }
    
    // MARK: - Private methods
    private func setupSignInButton() {
        signInButtonEnable = viewModel.signInButtonEnable
        signInButton.isHidden = !(signInButtonEnable && searchProtocol == nil)
    }
    
    private func setup() {
        viewModel.assetListDelegateManager.delegate = self
        registerForPreviewing()

        setupUI()
    }
    
    private func setupUI() {
        noDataTitle = viewModel.noDataText()
        noDataButtonTitle = viewModel.noDataButtonTitle()
        if let imageName = viewModel.noDataImageName() {
            noDataImage = UIImage(named: imageName)
        }
        
        navigationItem.title = viewModel.title
        
        if !viewModel.gvFundsWeeklyTop {
            topTableViewHeightConstraint.constant = 0
            NSLayoutConstraint.activate([topTableViewHeightConstraint])
        } else {
            setupChallengeTableView()
            topTableViewModel?.fetchData()
        }
        
        bottomViewType = searchProtocol == nil ? viewModel.bottomViewType : .none
        
        if signInButtonEnable {
            showNewVersionAlertIfNeeded(self)
        }
    }
    
    private func setupChallengeTableHeader() {
        let rect = CGRect(x: gvWeeklyChallngeTableView.frame.minX, y: gvWeeklyChallngeTableView.frame.minY, width: gvWeeklyChallngeTableView.width, height: 30)
        let view = UILabel(frame: rect)
        view.font = UIFont.getFont(.semibold, size: 16)
        view.text = "    Last's week challange winner"
        
        gvWeeklyChallngeTableView.tableHeaderView = view
    }
    
    private func setupMainTableHeader() {
        let rect = CGRect(x: tableView.frame.minX, y: tableView.frame.minY, width: tableView.width, height: 30)
        let view = UILabel(frame: rect)
        view.font = UIFont.getFont(.semibold, size: 16)
        
        view.text = "    All funds"
        
        tableView.tableHeaderView = view
    }
    
    private func setupChallengeTableView() {
        infoBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(infoButtonPressed))
        infoBarButtonItem.image = #imageLiteral(resourceName: "img_info")
        navigationItem.rightBarButtonItem = infoBarButtonItem
        
        gvWeeklyChallngeTableView.configure(with: .custom(TableViewConfiguration(
            topInset: 0,
            bottomInset: 20,
            estimatedRowHeight: 140,
            rowHeight: UITableView.automaticDimension,
            separatorInsetLeft: 16.0,
            separatorInsetRight: 16.0
        )))
        
        gvWeeklyChallngeTableView.delegate = topTableViewModel?.dataSource
        gvWeeklyChallngeTableView.dataSource = topTableViewModel?.dataSource
        gvWeeklyChallngeTableView.registerNibs(for: topTableViewModel.cellModelsForRegistration)
        gvWeeklyChallngeTableView.isScrollEnabled = false
        gvWeeklyChallngeTableView.separatorStyle = .none
        setupChallengeTableHeader()
        setupMainTableHeader()
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = signInButtonEnable ? 82.0 : 0.0
        
        tableView.delegate = self.viewModel?.assetListDelegateManager
        tableView.dataSource = self.viewModel?.assetListDelegateManager
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        if viewModel.canPullToRefresh {
            setupPullToRefresh(scrollView: tableView)
        }
    }
    
    @objc private func infoButtonPressed() {
        openSafariVC(with: Urls.gvWeeklyChallengeBlog)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadDataSmoothly()
        }
    }
    
    override func fetch() {
        viewModel.refresh { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    override func updateData(from dateFrom: Date?, to dateTo: Date?) {
//        viewModel.filterModel.dateRangeModel.dateFrom = dateFrom
//        viewModel.filterModel.dateRangeModel.dateTo = dateTo
        
        showProgressHUD()
        fetch()
    }
}

final class WeeklyChallangeTableViewModel: ListViewModelWithPaging {
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    typealias CellViewModel = FundTableViewCellViewModel
    
    var canFetchMoreResults: Bool = false
    
    var canPullToRefresh: Bool = false
    
    var skip: Int = 0
    
    var viewModels: [CellViewAnyModel] = []
    
    var weeklyTopFundModel: FundDetailsListItem? {
        didSet {
            setupViewModels()
        }
    }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundTableViewCellViewModel.self]
    }
    
    weak var delegate: BaseTableViewProtocol?
    
    init(delegate: BaseTableViewProtocol) {
        self.delegate = delegate        
    }
        
    func fetchData() {
        
        FundsDataProvider.getWeeklyWinner(completion: { (viewModel) in
            if let viewModel = viewModel {
                self.weeklyTopFundModel = viewModel
            }
        }) { (result) in
            switch result {
                
            case .success:
                break
            case .failure(errorType: _):
                break
            }
        }
        
    }
    
    private func setupViewModels() {
        guard let viewModel = self.weeklyTopFundModel else { return }
        viewModels.append(FundTableViewCellViewModel(asset: viewModel, filterProtocol: nil, favoriteProtocol: nil))
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

extension FundListViewController {
    override func filterButtonAction() {
        viewModel.showFilterVC(listViewModel: viewModel, filterModel: viewModel.filterModel, filterType: .funds, sortingType: .funds)
    }
    
    override func signInButtonAction() {
        viewModel.showSignInVC()
    }
}

extension FundListViewController: DelegateManagerProtocol {
    func delegateManagerTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.model(for: indexPath) as? FundTableViewCellViewModel, let assetId = model.asset._id?.uuidString else { return }
        searchProtocol?.didSelect(assetId, assetType: .fund)
    }
    
    func delegateManagerTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showInfiniteIndicator(value: viewModel.fetchMore(at: indexPath))
    }
    
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
    
    func delegateManagerScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDragging(scrollView)
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension FundListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = tableView.convert(location, from: view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition),
            let vc = viewModel.getDetailsViewController(with: indexPath),
            let cell = tableView.cellForRow(at: indexPath)
            else { return nil }
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = view.convert(cell.frame, from: tableView)
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}

// MARK: - ReloadDataProtocol
extension FundListViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
        tabmanBarItems?.forEach({ $0.badgeValue = "\(viewModel.totalCount)" })
    }
}

// MARK: - FavoriteStateChangeProtocol
extension FundListViewController: FavoriteStateChangeProtocol {
    var filterDateRangeModel: FilterDateRangeModel? {
        return dateRangeModel
    }
    
    func didChangeFavoriteState(with assetID: String, value: Bool, request: Bool) {
        showProgressHUD()
        viewModel.changeFavorite(value: value, assetId: assetID, request: request) { [weak self] (result) in
            self?.hideAll()
            
            if let isFavorite = self?.viewModel?.filterModel.isFavorite, isFavorite {
                self?.fetch()
            }
        }
    }
}

extension FundListViewController: BaseTableViewProtocol {
    func didReload() {
        DispatchQueue.main.async {
            self.gvWeeklyChallngeTableView.reloadData()
            self.gvWeeklyChallngeTableView.isScrollEnabled = false
        }
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        guard let cellViewModel = cellViewModel as?FundTableViewCellViewModel, let assetId = cellViewModel.asset._id?.uuidString  else { return }
        viewModel.showDetail(with: assetId)
    }
}
