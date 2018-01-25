//
//  TraderListViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TraderListViewController: BaseViewController {

    @IBOutlet weak var signInButtonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var signInButton: UIButton!
    
    var programsViewModel: TraderListViewModel! {
        didSet {
            programsViewModel.fetch { [weak self] in
                self?.tableView?.reloadData()
            }
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            let authorizedValue = AuthController.isLogin()
            
            signInButtonViewHeightConstraint.constant = authorizedValue ? 0.0 : 76.0
            signInButton.isHidden = authorizedValue
            
            tableView.configure(with: .defaultConfiguration)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Invest"
        
        setupTableView()
        registerForPreviewing()
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.registerNibs(for: [TraderTableViewCell.self])
    }

    func showTraderVC(with traderEntity: TraderEntity) {
        guard let viewController = TraderViewController.storyboardInstance(name: .traders) else { return }
        viewController.traderEntity = traderEntity
        push(viewController: viewController)
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        guard let viewController = SignInViewController.storyboardInstance(name: .auth) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TraderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard programsViewModel.programsCount() >= indexPath.row else {
            return
        }
        
        let traderEntity = programsViewModel.programViewModels[indexPath.row].traderEntity
        
        showTraderVC(with: traderEntity)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = programsViewModel.programViewModels[indexPath.row]
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
        
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programsViewModel.programsCount()
    }
    
}


extension TraderListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = self.tableView.convert(location, from: self.view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let vc = TraderViewController.storyboardInstance(name: .traders) else { return nil }
        vc.traderEntity = programsViewModel.programViewModels[indexPath.row].traderEntity
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = cell.frame
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}
