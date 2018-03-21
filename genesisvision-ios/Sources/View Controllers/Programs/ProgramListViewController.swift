//
//  ProgramListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor.init(white: 1, alpha: 0).cgColor,
            UIColor.white.cgColor
        ]
        backgroundColor = UIColor.clear
    }
}

class ProgramListViewController: BaseViewControllerWithTableView {
    
    // MARK: - Variables
    private var signInButtonEnable: Bool = false
    private var filtersBarButtonItem: UIBarButtonItem?
    
    // MARK: - View Model
    var viewModel: InvestmentProgramListViewModel!
    
    // MARK: - Buttons
    @IBOutlet var signInButton: UIButton!
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupSignInButton()
            setupTableConfiguration()
        }
    }
    
    // MARK: - Views
    @IBOutlet var gradientView: GradientView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Private methods
    private func setupSignInButton() {
        signInButtonEnable = viewModel.signInButtonEnable()
        
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
        filtersBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_filters_icon"), style: .done, target: self, action: #selector(filtersButtonAction(_:)))
        navigationItem.rightBarButtonItem = filtersBarButtonItem
        
        title = viewModel.title.uppercased()
        navigationItem.title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_navbar_left_logo"), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    private func setupTableConfiguration() {
        tableView.contentInset.bottom = signInButtonEnable ? signInButton.frame.height + 16.0 + 16.0 : 0.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: InvestmentProgramListViewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: InvestmentProgramListViewModel.viewModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    private func reloadData() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    private func updateSortHeaderView() {
        guard let title = self.viewModel.headerTitle(for: 0) else {
            return
        }
        
        let header = self.tableView.headerView(forSection: 0) as! SortHeaderView
        header.sortButton.setTitle(title, for: .normal)
        
        showProgressHUD()
        fetch()
    }
    
    override func fetch() {
        viewModel.refresh { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                break
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
    override func fetchMore() {
        canFetchMoreResults = false
        self.viewModel.fetchMore { [weak self] (result) in
            self?.canFetchMoreResults = true
            switch result {
            case .success:
                break
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    // MARK: - Actions
    @IBAction func signInButtonAction(_ sender: UIButton) {
        viewModel.showSignInVC()
    }
    
    @IBAction func filtersButtonAction(_ sender: UIButton) {
        viewModel.showFilterVC()
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
        if (viewModel.modelsCount() - indexPath.row) == Constants.Api.fetchThreshold && canFetchMoreResults {
            fetchMore()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = viewModel.headerTitle(for: section) else {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView() as SortHeaderView
        header.sortButton.setTitle(title, for: .normal)
        header.delegate = self
        
        return header
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
}


extension ProgramListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = tableView.convert(location, from: view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition),
            let vc = viewModel.getDetailViewController(with: indexPath),
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

extension ProgramListViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

extension ProgramListViewController: SortHeaderViewProtocol {
    func sortButtonDidPress() {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        
        guard let selectedValue = viewModel.filter?.sorting else { return }
        
        let values = sortingValues
        let pickerViewValues: [[String]] = [values.map { $0 }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: sortingKeys.index(of: selectedValue) ?? 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.viewModel.filter?.sorting = sortingKeys[index.row]
            self.updateSortHeaderView()
        }
        
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
}
