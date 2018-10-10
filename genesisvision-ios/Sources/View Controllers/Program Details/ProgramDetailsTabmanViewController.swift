//
//  ProgramDetailsTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIBarButtonItem

protocol ProgramDetailViewControllerProtocol: class {
    func programDetailDidChangeFavoriteState(with programID: String, value: Bool, request: Bool)
}

class ProgramDetailsTabmanViewController: BaseTabmanViewController<ProgramDetailsViewModel> {
    
    // MARK: - Variables
    weak var programDetailViewControllerProtocol: ProgramDetailViewControllerProtocol?
    var scrollEnabled: Bool = true {
        didSet {
            //TODO:
        }
    }
    
    private var favoriteBarButtonItem: UIBarButtonItem!
    
    // MARK: - IBActions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        let isFavorite = viewModel.isFavorite
        favoriteBarButtonItem.image = !isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        
        showProgressHUD()
        viewModel.changeFavorite() { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                if let programId = self?.viewModel.programId {
                    self?.programDetailViewControllerProtocol?.programDetailDidChangeFavoriteState(with: programId, value: !isFavorite, request: false)
                }
            case .failure(let errorType):
                self?.favoriteBarButtonItem.image = isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
}

extension ProgramDetailsTabmanViewController: ReloadDataProtocol {
    func didReloadData() {
        if let viewModel = viewModel {
            viewModel.reloadDetails()
        }
    }
}

extension ProgramDetailsTabmanViewController: ProgramDetailsProtocol {
    func didFavoriteStateUpdated() {
        DispatchQueue.main.async {
            guard AuthManager.isLogin() else { return }
            
            guard self.favoriteBarButtonItem != nil else {
                self.favoriteBarButtonItem = UIBarButtonItem(image: self.viewModel.isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon"), style: .done, target: self, action: #selector(self.favoriteButtonAction(_:)))
                self.navigationItem.rightBarButtonItem = self.favoriteBarButtonItem
                return
            }
            
            self.favoriteBarButtonItem.image = self.viewModel.isFavorite ? #imageLiteral(resourceName: "img_favorite_icon_selected") : #imageLiteral(resourceName: "img_favorite_icon")
        }
    }
}

extension ProgramDetailsTabmanViewController: ProgramDetailProtocol {
    func didRequestCanceled(_ last: Bool) {
        if let viewModel = viewModel {
            viewModel.didRequestCanceled(last)
        }
    }
    
    func didWithdrawn() {
        if let viewModel = viewModel {
            viewModel.didWithdrawn()
        }
    }
    
    func didInvested() {
        if let viewModel = viewModel {
            viewModel.didInvested()
        }
    }
}
