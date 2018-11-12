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
    
    var minHeaderHeight: CGFloat = 200.0
    var topConstant: CGFloat = 0.0
    
    @IBOutlet weak var headerViewConstraint: NSLayoutConstraint!
    
    var headerViewController: ManagerHeaderViewController?
    var detailsTabmanViewController: ManagerTabmanViewController?
    
    @IBOutlet weak var detailsView: UIView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressHUD()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.headerViewConstraint.constant = minHeaderHeight
        self.navigationController?.isNavigationBarHidden = false
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
            self.headerViewController = managerHeaderViewController
        } else if let tabmanViewController = segue.destination as? ManagerTabmanViewController,
            segue.identifier == "ManagerTabmanViewControllerSegue" {
            
            let router = ManagerTabmanRouter(parentRouter: self.viewModel.router, tabmanViewController: tabmanViewController)
            let viewModel = ManagerTabmanViewModel(withRouter: router, managerId: self.viewModel.managerId, tabmanViewModelDelegate: tabmanViewController)
            tabmanViewController.viewModel = viewModel
            
            self.viewModel?.router?.managerDetailsTabmanViewController = tabmanViewController
            detailsTabmanViewController = tabmanViewController
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
                    self?.detailsTabmanViewController?.setup(managerProfileDetails)
                    self?.headerViewController?.configure(managerProfileDetails)
                }
            default:
                break
            }
        }
    }
    
    private func setupUI() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        topConstant = 44.0 + statusBarHeight
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -topConstant).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    // MARK: - Public methods
    func hideHeader(_ value: Bool) {
        let scrollOffset = CGPoint(x: 0.0, y: value ? minHeaderHeight - topConstant * 2 : -topConstant)
        scrollView.setContentOffset(scrollOffset, animated: true)
    }
}

extension ManagerViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        if scrollView.contentOffset.y >= minHeaderHeight - topConstant * 2 {
            scrollView.setContentOffset(CGPoint(x: 0.0, y: minHeaderHeight - topConstant * 2), animated: false)
            return
        }
        
        let yOffset = scrollView.contentOffset.y + topConstant
        
        let headerHeight = headerViewConstraint.constant - topConstant
        if headerHeight - yOffset >= 0 && yOffset >= 0 {
            headerViewController?.changeColorAlpha(offset: yOffset / headerHeight)
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
            self.headerViewConstraint.constant -= abs(yOffset)
            if self.headerViewConstraint.constant < minHeaderHeight {
                self.headerViewConstraint.constant = minHeaderHeight
            }
        }
        
        if scrollView == self.scrollView {
            if let viewModel = viewModel.router.managerDetailsTabmanViewController?.viewModel {
                for controller in viewModel.viewControllers {
                    if let vc = controller as? BaseViewControllerWithTableView {
                        vc.tableView?.isScrollEnabled = yOffset >= detailsView.frame.origin.y - topConstant * 2
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerViewConstraint.constant > minHeaderHeight {
            animateHeader(minHeaderHeight)
        }
        
//        headerViewController?.changeColorAlpha(offset: scrollView.contentOffset.y + topConstant / headerViewConstraint.constant - topConstant)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerViewConstraint.constant > minHeaderHeight {
            animateHeader(minHeaderHeight)
        }
        
//        headerViewController?.changeColorAlpha(offset: scrollView.contentOffset.y + topConstant / headerViewConstraint.constant - topConstant)
    }
    
    func animateHeader(_ minHeaderHeight: CGFloat) {
        self.headerViewConstraint.constant = minHeaderHeight
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
