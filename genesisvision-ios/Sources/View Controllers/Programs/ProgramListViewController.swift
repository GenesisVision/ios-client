//
//  ProgramListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramListViewController: BaseViewControllerWithTableView {
    
    // MARK: - Variables
    private var signInButtonEnable: Bool = false
    private var tournamentBarButtonItem: UIBarButtonItem?
    
    // MARK: - View Model
    var viewModel: ProgramListViewModelProtocol!
    
    // MARK: - Outlets
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.isTranslucent = false
        searchBar.backgroundColor = UIColor.BaseView.bg
        searchBar.barTintColor = UIColor.primary
        searchBar.tintColor = UIColor.primary
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupSignInButton()
            setupTableConfiguration()
        }
    }
    
    // MARK: - Views
    @IBOutlet var gradientView: GradientView! {
        didSet {
            gradientView.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let viewModel = viewModel as? FavoriteProgramListViewModel, viewModel.needToRefresh {
            fetch()
        }
    }
    
    // MARK: - Private methods
    private func setupSignInButton() {
        if let viewModel = viewModel as? ProgramListViewModel {
            signInButtonEnable = viewModel.signInButtonEnable
        }
        
        signInButton.isHidden = !signInButtonEnable
        gradientView.isHidden = !signInButtonEnable
    }
    
    private func setup() {
        registerForPreviewing()
        
        showProgressHUD()
        fetch()
        setupUI()
    }
    
    private func setupUI() {
        bottomViewType = viewModel.bottomViewType
        
        sortButton.setTitle(self.viewModel?.sortingDelegateManager.sortTitle(), for: .normal)
        
        if signInButtonEnable {
            showNewVersionAlertIfNeeded(self)
        }
        
//        PlatformManager.getPlatformInfo(completion: { [weak self] (model) in
//            guard let isTournamentActive = model?.isTournamentActive, isTournamentActive else { return }
//
//            self?.tournamentBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_trophy_icon"), style: .done, target: self, action: #selector(self?.tournamentButtonAction(_:)))
//            self?.tournamentBarButtonItem?.tintColor = UIColor.Tournament.bg
//            self?.navigationItem.rightBarButtonItem = self?.tournamentBarButtonItem
//        })
        
        tabBarItem.title = viewModel.title

        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        }
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = signInButtonEnable ? signInButton.frame.height + 16.0 + 16.0 : 0.0
        
        tableView.isScrollEnabled = false
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()

            UIView.setAnimationsEnabled(false)
            self.tableView?.reloadData()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    private func sortMethod() {
        bottomSheetController = BottomSheetController()
        
        bottomSheetController.addNavigationBar("Sort by", buttonTitle: "High to Low", buttonSelectedTitle: "Low to High", buttonAction: #selector(highToLowButtonAction), buttonTarget: self, buttonSelected: viewModel.highToLowValue)
        
        bottomSheetController.addTableView { [weak self] tableView in
            tableView.delegate = self?.viewModel.sortingDelegateManager
            tableView.dataSource = self?.viewModel.sortingDelegateManager
            tableView.separatorStyle = .none
        }
        
        viewModel.sortingDelegateManager.tableViewProtocol = self
        bottomSheetController.present()
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
    
    // MARK: - Actions
    @IBAction func tournamentButtonAction(_ sender: UIButton) {
        if let viewModel = viewModel as? ProgramListViewModel {
            viewModel.showTournamentVC()
        }
    }
    
    @objc func highToLowButtonAction() {
        viewModel.highToLowValue = !viewModel.highToLowValue
        bottomSheetController.dismiss()
    }
}

extension ProgramListViewController {
    override func sortButtonAction() {
        sortMethod()
    }
    
    override func filterButtonAction() {
        if let viewModel = viewModel as? ProgramListViewModel {
            viewModel.showFilterVC()
        }
    }
    
    override func signInButtonAction() {
        if let viewModel = viewModel as? ProgramListViewModel {
            viewModel.showSignInVC()
        }
    }
}

extension ProgramListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.modelsCount() >= indexPath.row else {
            return
        }
        
        viewModel.showDetail(at: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
        }

        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showInfiniteIndicator(value: viewModel.fetchMore(at: indexPath.row))
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
}


// MARK: - UIViewControllerPreviewingDelegate
extension ProgramListViewController: UIViewControllerPreviewingDelegate {
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
extension ProgramListViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

// MARK: - ProgramDetailViewControllerProtocol
extension ProgramListViewController: ProgramDetailViewControllerProtocol {
    func programDetailDidChangeFavoriteState(with programID: String, value: Bool, request: Bool) {
        showProgressHUD()
        viewModel.changeFavorite(value: value, programId: programID, request: request) { [weak self] (result) in
            self?.hideAll()
        }
    }
}

extension ProgramListViewController {
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = viewModel.noDataText()
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark,
                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 25)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    override func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let imageName = viewModel.noDataImageName() {
            return UIImage(named: imageName)
        }
        
        return UIImage.noDataPlaceholder
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = viewModel.noDataButtonTitle()
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.white,
                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 14)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension ProgramListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text, !searchText.isEmpty && searchText != viewModel.searchText || searchText.isEmpty && !viewModel.searchText.isEmpty else {
            return
        }
        
        viewModel.searchText = searchText
        
        updateData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchBar.text = ""
        
        guard let searchText = searchBar.text, !viewModel.searchText.isEmpty else {
            return
        }
        
        viewModel.searchText = searchText
        
        updateData()
    }
}

extension ProgramListViewController: SortingDelegate {
    func didSelectSorting(at indexPath: IndexPath) {
        bottomSheetController.dismiss()
    }
}

extension ProgramListViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        scrollView.isScrollEnabled = scrollView.contentOffset.y > -44.0
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            scrollView.isScrollEnabled = scrollView.contentOffset.y > -44.0
        } else {
            scrollView.isScrollEnabled = true
        }
    }
}
