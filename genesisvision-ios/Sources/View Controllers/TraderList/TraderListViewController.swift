//
//  TraderListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TraderListViewController: BaseViewController {

    var authorizedValue: Bool = false
    
    // MARK: - View Model
    var viewModel: InvestmentProgramListViewModel! {
        didSet {
            viewModel.fetch { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            }
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var signInButton: UIButton!
    
    // MARK: - Variables
    @IBOutlet weak var signInButtonViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            setupSignInButton()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Invest"
        
        setupTableView()
        registerForPreviewing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSignInButton()
    }
    
    // MARK: - Private methods
    private func setupSignInButton() {
        //if authorize status not change then return
        guard authorizedValue != viewModel.isLogin() || signInButton.isHidden != authorizedValue else {
            return
        }
        
        authorizedValue = viewModel.isLogin()
        
        signInButtonViewHeightConstraint.constant = authorizedValue ? 0.0 : 76.0
        signInButton.isHidden = authorizedValue
        var tableViewConfiguration: TableViewConfiguration = .defaultConfig
        tableViewConfiguration.bottomInset = authorizedValue ? 0.0 : 76.0 + 16.0
        tableViewConfiguration.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        tableView.configure(with: .custom(tableViewConfiguration))
    }
    
    private func setupTableView() {
        tableView.registerNibs(for: [TraderTableViewCell.self])
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        viewModel.showSignInVC()
    }
}

extension TraderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.programsCount() >= indexPath.row else {
            return
        }
        
        let programEntity = viewModel.getProgram(atIndex: indexPath.row).investmentProgramEntity

        viewModel.showProgramDetail(with: programEntity)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = viewModel.getProgram(atIndex: indexPath.row)
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsIn(section: section)
    }
}


extension TraderListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = self.tableView.convert(location, from: self.view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let vc = viewModel.getProgramDetailViewController(withIndex: indexPath.row) else { return nil }
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = cell.frame
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}
