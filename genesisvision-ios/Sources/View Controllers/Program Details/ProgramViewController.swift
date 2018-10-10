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
    
    var programHeaderViewController: ProgramHeaderViewController?
    var programDetailsTabmanViewController: ProgramDetailsTabmanViewController?
    
    private var favoriteBarButtonItem: UIBarButtonItem!
    private var notificationsBarButtonItem: UIBarButtonItem!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if let programHeaderViewController = segue.destination as? ProgramHeaderViewController,
            segue.identifier == "ProgramHeaderViewControllerSegue" {
            self.programHeaderViewController = programHeaderViewController
        } else if let tabmanViewController = segue.destination as? ProgramDetailsTabmanViewController,
            segue.identifier == "ProgramDetailsTabmanViewControllerSegue" {
            
            tabmanViewController.programDetailViewControllerProtocol = self
            
            let router = ProgramDetailsRouter(parentRouter: self.viewModel.router, tabmanViewController: tabmanViewController)
            let viewModel = ProgramDetailsViewModel(withRouter: router, programId: self.viewModel.programId, tabmanViewModelDelegate: tabmanViewController)
            viewModel.programDetailsProtocol = tabmanViewController
            tabmanViewController.viewModel = viewModel

            programDetailsTabmanViewController = tabmanViewController
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                if let programDetailsFull = self?.viewModel.programDetailsFull {
                    self?.programDetailsTabmanViewController?.viewModel.programDetailsFull = programDetailsFull
                    self?.programHeaderViewController?.configure(programDetailsFull)
                }
            default:
                break
            }
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -topConstant).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func setupUI() {
        favoriteBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_favorite_icon"), style: .done, target: self, action: #selector(favoriteButtonAction))
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
        
        navigationItem.rightBarButtonItems = [notificationsBarButtonItem, favoriteBarButtonItem]
    }
    
    @objc func notificationsButtonAction() {
        viewModel.showNotifications()
    }
    
    // MARK: - IBActions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        guard let isFavorite = self.programDetailsTabmanViewController?.viewModel.isFavorite else { return }
        favoriteBarButtonItem.image = !isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        
        showProgressHUD()
        self.programDetailsTabmanViewController?.viewModel.changeFavorite() { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                if let programId = self?.programDetailsTabmanViewController?.viewModel.programId {
                    self?.programDetailsTabmanViewController?.programDetailViewControllerProtocol?.programDetailDidChangeFavoriteState(with: programId, value: !isFavorite, request: false)
                }
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
        
        let alpha = yOffset / (self.scrollView.contentSize.height - self.scrollView.frame.size.height + topConstant)
        self.navigationController!.view.backgroundColor = UIColor.Cell.bg.withAlphaComponent(alpha)
        if alpha > 0.7 {
            self.navigationController?.view.backgroundColor = .red
        }
        
        
        if 158 - yOffset >= 0 {
            print(yOffset)
            programHeaderViewController?.changeColorAlpha(offset: yOffset / 158)
        }

        if yOffset < 0 {
            self.headerViewConstraint.constant += abs(yOffset)
        } else if yOffset > 0 && self.headerViewConstraint.constant >= minHeaderHeight {
            self.headerViewConstraint.constant -= yOffset/100
            if self.headerViewConstraint.constant < minHeaderHeight {
                self.headerViewConstraint.constant = minHeaderHeight
            }
        }
        
        if let programDetailsTabmanViewController = programDetailsTabmanViewController {
            programDetailsTabmanViewController.scrollEnabled = false
            
            if yOffset - (minHeaderHeight - topConstant) == programDetailsTabmanViewController.view.frame.origin.y {
                programDetailsTabmanViewController.scrollEnabled = true
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

extension ProgramViewController: ProgramDetailsProtocol {
    func didFavoriteStateUpdated() {
        DispatchQueue.main.async {
            guard AuthManager.isLogin() else { return }
            guard let isFavorite = self.programDetailsTabmanViewController?.viewModel.isFavorite else { return }
            
            guard self.favoriteBarButtonItem != nil else {
                self.favoriteBarButtonItem = UIBarButtonItem(image: isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon"), style: .done, target: self, action: #selector(self.favoriteButtonAction(_:)))
                self.navigationItem.rightBarButtonItems = [self.notificationsBarButtonItem, self.favoriteBarButtonItem]
                return
            }
            
            self.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        }
    }
}

extension ProgramViewController: ProgramDetailViewControllerProtocol {
    func programDetailDidChangeFavoriteState(with programID: String, value: Bool, request: Bool) {
        
    }
}
