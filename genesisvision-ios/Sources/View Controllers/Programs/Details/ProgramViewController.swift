//
//  ProgramViewController.swift
//  genesisvision-ios
//
//  Created by George on 28/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: ProgramViewModel!
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
    
    var headerViewController: ProgramHeaderViewController?
    var detailsTabmanViewController: ProgramTabmanViewController?
    
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
        if let programHeaderViewController = segue.destination as? ProgramHeaderViewController,
            segue.identifier == "ProgramHeaderViewControllerSegue" {
            self.viewModel?.router?.programHeaderViewController = programHeaderViewController
            programHeaderViewController.delegate = self
            self.headerViewController = programHeaderViewController
        } else if let tabmanViewController = segue.destination as? ProgramTabmanViewController,
            segue.identifier == "ProgramTabmanViewControllerSegue" {
            
            tabmanViewController.programInfoViewControllerProtocol = self
            
            let router = ProgramTabmanRouter(parentRouter: self.viewModel.router, tabmanViewController: tabmanViewController)
            let viewModel = ProgramTabmanViewModel(withRouter: router, programId: self.viewModel.programId, tabmanViewModelDelegate: tabmanViewController)
            viewModel.favoriteStateUpdatedProtocol = self
            tabmanViewController.viewModel = viewModel
            
            self.viewModel?.router?.programDetailsTabmanViewController = tabmanViewController
            detailsTabmanViewController = tabmanViewController
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    // MARK: - Public methods
    func hideHeader(_ value: Bool) {
        let scrollOffset = CGPoint(x: 0.0, y: value ? minHeaderHeight - topConstant * 2 : -topConstant)
        scrollView.setContentOffset(scrollOffset, animated: true)
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
                
                if let programDetailsFull = self?.viewModel.programDetailsFull {
                    self?.detailsTabmanViewController?.setup(programDetailsFull)
                    self?.headerViewController?.configure(programDetailsFull)
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
        self.viewModel?.changeFavorite(value: isFavorite, request: true) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                self?.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
}

extension ProgramViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)

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
            if let viewModel = viewModel.router.programDetailsTabmanViewController?.viewModel {
                for controller in viewModel.viewControllers {
                    if let vc = controller as? BaseViewControllerWithTableView {
                        vc.tableView?.isScrollEnabled = yOffset >= detailsView.frame.origin.y - topConstant * 2
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        animateHeaderView(scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateHeaderView(scrollView.contentOffset.y)
    }
    
    private func animateHeaderView(_ contentOffsetY: CGFloat) {
        let yOffset = contentOffsetY + topConstant
        let headerHeight = headerViewConstraint.constant - topConstant
        
        if self.headerViewConstraint.constant > minHeaderHeight {
            animateHeader(minHeaderHeight)
        } else {
            hideHeader(true)

            if headerHeight - yOffset >= 0 && yOffset >= 0 {
                headerViewController?.changeColorAlpha(offset: yOffset / headerHeight)
            }
        }
    }
    
    func animateHeader(_ minHeaderHeight: CGFloat) {
        self.headerViewConstraint.constant = minHeaderHeight
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension ProgramViewController: FavoriteStateUpdatedProtocol {
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
extension ProgramViewController: FavoriteStateChangeProtocol {
    var filterDateRangeModel: FilterDateRangeModel? {
        return dateRangeModel
    }
    
    func didChangeFavoriteState(with assetID: String, value: Bool, request: Bool) {
        showProgressHUD()
        viewModel.changeFavorite(value: value, request: request) { (result) in
            
        }
    }
}

extension ProgramViewController: DetailProtocol {
    func didRequestCanceled(_ last: Bool) {
        fetch()
    }
    
    func didWithdrawn() {
        fetch()
    }
    
    func didInvested() {
        fetch()
    }
}

// MARK: - ReloadDataProtocol
extension ProgramViewController: ReloadDataProtocol {
    func didReloadData() {
        if let programDetailsFull = viewModel.programDetailsFull {
            headerViewController?.configure(programDetailsFull)
        }
        
        if AuthManager.isLogin(), let isFavorite = self.viewModel?.isFavorite {
            self.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        }
    }
}

// MARK: - ProgramHeaderViewControllerProtocol
extension ProgramViewController: ProgramHeaderViewControllerProtocol {
    func aboutLevelButtonDidPress() {
        let aboutLevelView = AboutLevelView.viewFromNib()
        aboutLevelView.delegate = self
        
        aboutLevelView.configure(viewModel.programDetailsFull?.rating, level: viewModel.programDetailsFull?.level)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.lineViewIsHidden = true
        bottomSheetController.initializeHeight = 270
        bottomSheetController.addContentsView(aboutLevelView)
        bottomSheetController.present()
    }
}

// MARK: - AboutLevelViewProtocol
extension ProgramViewController: AboutLevelViewProtocol {
    func aboutLevelsButtonDidPress() {
        bottomSheetController.dismiss()
        
        viewModel.showAboutLevels()
    }
}

