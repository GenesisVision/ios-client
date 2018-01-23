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
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            let authorizedValue = AuthController.isLogin()
            
            signInButtonViewHeightConstraint.constant = authorizedValue ? 0.0 : 76.0
            signInButton.isHidden = authorizedValue
            
            tableView.configure(with: .defaultConfiguration)
        }
    }
    
    var traders = [TraderTableViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Invest"
        
        setupTableView()
        registerForPreviewing()
        fillData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.registerNibs(for: [TraderTableViewCell.self])
    }
    
    private func fillData() {
        for index in 0..<Constants.TemplatesCounts.traders {
            traders.append(TraderTableViewCellModel(traderEntity: TraderEntity.templateEntity, index: index))
        }
        
        tableView.reloadData()
    }

    func showTraderVC(with traderEntity: TraderEntity) {
        guard let viewController = TraderViewController.storyboardInstance(name: .traders) else { return }
        viewController.traderEntity = traderEntity
        push(viewController: viewController)
    }
}

extension TraderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard traders.count >= indexPath.row else {
            return
        }
        
        let traderEntity = traders[indexPath.row].traderEntity
        
        showTraderVC(with: traderEntity)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = traders[indexPath.row]
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
        
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traders.count
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        guard let viewController = SignInViewController.storyboardInstance(name: .auth) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}


extension TraderListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = self.tableView.convert(location, from: self.view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let vc = TraderViewController.storyboardInstance(name: .traders) else { return nil }
        vc.traderEntity = traders[indexPath.row].traderEntity
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = cell.frame
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}
