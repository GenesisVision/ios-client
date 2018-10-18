//
//  ManagerViewController.swift
//  genesisvision-ios
//
//  Created by George on 26/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ManagerViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: ManagerViewModel!
    var isLoading: Bool = false
    // MARK: - Variables
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    var minHeaderHeight: CGFloat = 200.0 {
        didSet {
            self.headerViewConstraint.constant = minHeaderHeight
        }
    }
    var topConstant: CGFloat = 44.0 + 20.0// + 20.0
    
    @IBOutlet weak var headerViewConstraint: NSLayoutConstraint!
    
    var managerHeaderViewController: ManagerHeaderViewController?
    var managerDetailsTabmanViewController: ManagerDetailsTabmanViewController?
    
    @IBOutlet weak var managerDetailsView: UIView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressHUD()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let height = UIScreen.main.bounds.size.height
        self.minHeaderHeight = height / 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let managerHeaderViewController = segue.destination as? ManagerHeaderViewController,
            segue.identifier == "ManagerHeaderViewControllerSegue" {
            self.viewModel?.router?.managerHeaderViewController = managerHeaderViewController
            self.managerHeaderViewController = managerHeaderViewController
        } else if let tabmanViewController = segue.destination as? ManagerDetailsTabmanViewController,
            segue.identifier == "ManagerDetailsTabmanViewControllerSegue" {
            
            let router = ManagerDetailsRouter(parentRouter: self.viewModel.router, tabmanViewController: tabmanViewController)
            let viewModel = ManagerDetailsViewModel(withRouter: router, managerId: self.viewModel.managerId, tabmanViewModelDelegate: tabmanViewController)
            tabmanViewController.viewModel = viewModel
            
            self.viewModel?.router?.managerDetailsTabmanViewController = tabmanViewController
            managerDetailsTabmanViewController = tabmanViewController
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    // MARK: - Private methods
    private func setup() {
        showProgressHUD()
        setupUI()
        fetch()
    }
    
    private func fetch() {
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            self?.isLoading = false
            
            switch result {
            case .success:
                if let managerProfileDetails = self?.viewModel.managerProfileDetails {
                    self?.managerDetailsTabmanViewController?.setup(managerProfileDetails)
                    self?.managerHeaderViewController?.configure(managerProfileDetails)
                }
            default:
                break
            }
        }
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -topConstant).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension ManagerViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        let yOffset = scrollView.contentOffset.y + topConstant
        
        let alpha = yOffset / (self.scrollView.contentSize.height - self.scrollView.frame.size.height + topConstant)
        self.navigationController!.view.backgroundColor = UIColor.Cell.bg.withAlphaComponent(alpha)
        
        let headerHeight = headerViewConstraint.constant - 64.0
        if headerHeight - yOffset >= 0 {
            managerHeaderViewController?.changeColorAlpha(offset: yOffset / headerHeight)
        }
        
        if yOffset < 0 {
            self.headerViewConstraint.constant += abs(yOffset)
            
            if self.headerViewConstraint.constant > 400.0 && !self.isLoading {
                self.scrollView.panGestureRecognizer.isEnabled = false
                self.scrollView.panGestureRecognizer.isEnabled = true
                
                self.isLoading = true
                self.pullToRefresh()
            }
        } else if yOffset > 0 && self.headerViewConstraint.constant >= minHeaderHeight {
            self.headerViewConstraint.constant -= yOffset/100
            if self.headerViewConstraint.constant < minHeaderHeight {
                self.headerViewConstraint.constant = minHeaderHeight
            }
        }
        
        if let managerDetailsTabmanViewController = managerDetailsTabmanViewController {
            managerDetailsTabmanViewController.scrollEnabled = false
            
            if yOffset - (minHeaderHeight - topConstant) == managerDetailsTabmanViewController.view.frame.origin.y {
                managerDetailsTabmanViewController.scrollEnabled = true
            }
        }
        
        if scrollView == self.scrollView {
            if let viewModel = viewModel.router.managerDetailsTabmanViewController?.viewModel {
                for controller in viewModel.viewControllers {
                    if let vc = controller as? BaseViewControllerWithTableView {
                        print(managerDetailsView.frame.origin.y)
                        print(yOffset)
                        
                        vc.tableView?.isScrollEnabled = yOffset >= managerDetailsView.frame.origin.y - 44.0 - 44.0
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerViewConstraint.constant > minHeaderHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerViewConstraint.constant > minHeaderHeight {
            animateHeader()
        }
    }
    
    func animateHeader() {
        self.headerViewConstraint.constant = minHeaderHeight
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
