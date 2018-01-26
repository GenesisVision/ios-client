//
//  ProfileViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    var viewModel: ProfileViewModel!
    
    // MARK: - Variables
    var signOutButton: UIBarButtonItem?
    
    var profile: ProfileEntity {
        guard let profileEntity = UserEntity.value.currentProfile else {
            fatalError("Authorization error")
        }
        
        return profileEntity
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        signOutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(signOutButtonAction(_:)))
        navigationItem.rightBarButtonItem = signOutButton
        
        title = isInvestorApp
            ? "Investor Profile"
            : "Manager Profile"
    }
    
    // MARK: - Actions
    @IBAction func signOutButtonAction(_ sender: UIButton) {
        viewModel.signOut()
    }
}
