//
//  FundViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: FundViewModel!
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
    
    var fundHeaderViewController: FundHeaderViewController?
    var fundDetailsTabmanViewController: FundDetailsTabmanViewController?
    
    @IBOutlet weak var detailsView: UIView!
    private var favoriteBarButtonItem: UIBarButtonItem!
    private var notificationsBarButtonItem: UIBarButtonItem!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressHUD()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
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
        if let fundHeaderViewController = segue.destination as? FundHeaderViewController,
            segue.identifier == "FundHeaderViewControllerSegue" {
            self.viewModel?.router?.fundHeaderViewController = fundHeaderViewController
            self.fundHeaderViewController = fundHeaderViewController
        } else if let tabmanViewController = segue.destination as? FundDetailsTabmanViewController,
            segue.identifier == "FundDetailsTabmanViewControllerSegue" {
            
            tabmanViewController.fundInfoViewControllerProtocol = self
            
            let router = FundDetailsRouter(parentRouter: self.viewModel.router, tabmanViewController: tabmanViewController)
            let viewModel = FundDetailsViewModel(withRouter: router, fundId: self.viewModel.fundId, tabmanViewModelDelegate: tabmanViewController)
            viewModel.favoriteStateUpdatedProtocol = self
            tabmanViewController.viewModel = viewModel
            
            self.viewModel?.router?.fundDetailsTabmanViewController = tabmanViewController
            fundDetailsTabmanViewController = tabmanViewController
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
                if AuthManager.isLogin(), let isFavorite = self?.viewModel?.isFavorite {
                    self?.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
                }
                
                if let fundDetailsFull = self?.viewModel.fundDetailsFull {
                    self?.fundDetailsTabmanViewController?.setup(fundDetailsFull)
                    self?.fundHeaderViewController?.configure(fundDetailsFull)
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
        
        guard AuthManager.isLogin() else { return }
        
        if let isFavorite = self.viewModel?.isFavorite {
            favoriteBarButtonItem = UIBarButtonItem(image: isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon"), style: .done, target: self, action: #selector(favoriteButtonAction))
        }
        
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
        
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
    }
    
    @objc func notificationsButtonAction() {
        viewModel.showNotifications()
    }
    
    // MARK: - IBActions
    @objc func favoriteButtonAction() {
        guard let isFavorite = self.viewModel?.isFavorite else { return }
        self.favoriteBarButtonItem.image = !isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        
        
        showProgressHUD()
        self.viewModel?.changeFavorite() { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                if let fundId = self?.fundDetailsTabmanViewController?.viewModel.fundId {
                    self?.fundDetailsTabmanViewController?.fundInfoViewControllerProtocol?.didChangeFavoriteState(with: fundId, value: !isFavorite, request: false)
                }
            case .failure(let errorType):
                self?.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
}

extension FundViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        let yOffset = scrollView.contentOffset.y + topConstant
        
        let alpha = yOffset / (self.scrollView.contentSize.height - self.scrollView.frame.size.height + topConstant)
        self.navigationController!.view.backgroundColor = UIColor.Cell.bg.withAlphaComponent(alpha)
   
        let headerHeight = headerViewConstraint.constant - 64.0
        if headerHeight - yOffset >= 0 {
            fundHeaderViewController?.changeColorAlpha(offset: yOffset / headerHeight)
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
        
        if let fundDetailsTabmanViewController = fundDetailsTabmanViewController {
            fundDetailsTabmanViewController.scrollEnabled = false
            
            if yOffset - (minHeaderHeight - topConstant) == fundDetailsTabmanViewController.view.frame.origin.y {
                fundDetailsTabmanViewController.scrollEnabled = true
            }
        }
        
        if scrollView == self.scrollView {
            if let viewModel = viewModel.router.fundDetailsTabmanViewController?.viewModel {
                for controller in viewModel.viewControllers {
                    if let vc = controller as? BaseViewControllerWithTableView {
                        print(detailsView.frame.origin.y)
                        print(yOffset)
                        
                        vc.tableView?.isScrollEnabled = yOffset >= detailsView.frame.origin.y - 44.0 - 44.0
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

extension FundViewController: FavoriteStateUpdatedProtocol {
    func didFavoriteStateUpdated() {
        DispatchQueue.main.async {
            guard AuthManager.isLogin() else { return }
            guard let isFavorite = self.viewModel?.isFavorite else { return }
            
            guard self.favoriteBarButtonItem != nil else {
                self.favoriteBarButtonItem = UIBarButtonItem(image: isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon"), style: .done, target: self, action: #selector(self.favoriteButtonAction))
                self.navigationItem.rightBarButtonItems = [self.favoriteBarButtonItem]
                return
            }
            
            self.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        }
    }
}

// MARK: - FavoriteStateChangeProtocol
extension FundViewController: FavoriteStateChangeProtocol {
    func didChangeFavoriteState(with fundID: String, value: Bool, request: Bool) {
        
    }
}

extension FundViewController: DetailProtocol {
    func didRequestCanceled(_ last: Bool) {
        if let viewModel = fundDetailsTabmanViewController?.viewModel {
            viewModel.didRequestCanceled(last)
        }
    }
    
    func didWithdrawn() {
        if let viewModel = fundDetailsTabmanViewController?.viewModel {
            viewModel.didWithdrawn()
        }
    }
    
    func didInvested() {
        if let viewModel = fundDetailsTabmanViewController?.viewModel {
            viewModel.didInvested()
        }
    }
}

