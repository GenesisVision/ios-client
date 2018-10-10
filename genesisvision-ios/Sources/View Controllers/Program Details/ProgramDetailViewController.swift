
//
//  ProgramDetailViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProgramDetailViewController: BaseViewControllerWithTableView {

    let buttonHeight: CGFloat = 45.0
    let buttonBottom: CGFloat = 40.0
    
    // MARK: - View Model
    var viewModel: ProgramDetailViewModel! {
        didSet {
            title = viewModel.getNickname()
            
            if viewModel.programDetailsFull == nil {
                updateData()
            }
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var investButton: ActionButton! {
        didSet {
            investButton.isHidden = true
        }
    }
    @IBOutlet var withdrawButton: ActionButton! {
        didSet {
            withdrawButton.isHidden = true
        }
    }
    
    // MARK: - Views
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var gradientView: GradientView! {
        didSet {
            gradientView.isHidden = true
        }
    }
    
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        
        setup()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideAll()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        showInfiniteIndicator(value: false)
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
//        tableView.bounces = false
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        setupPullToRefresh(scrollView: tableView)
    }
    
    override func fetch() {
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.reloadData()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.setupUI()
            self.tableView?.reloadData()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        print(touches)
    }
    
    // MARK: - Public methods
    func updateDetails(with programDetailsFull: ProgramDetailsFull) {
        viewModel.updateDetails(with: programDetailsFull)
        reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func investButtonAction(_ sender: UIButton) {
        viewModel.availableInvestment > 0
            ? viewModel.invest()
            : showAlertWithTitle(title: "", message: String.Alerts.noAvailableTokens, actionTitle: "OK", cancelTitle: nil, handler: nil, cancelHandler: nil)
        
    }
    
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        viewModel.withdraw()
    }
}

extension ProgramDetailViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
        }

        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.Cell.headerBg
    }
}

extension ProgramDetailViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}
