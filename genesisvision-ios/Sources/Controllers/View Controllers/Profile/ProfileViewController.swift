//
//  ProfileViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    var profile: ProfileEntity {
        guard let profileEntity = UserEntity.value.currentProfile else {
            fatalError("Authorization error")
        }
        
        return profileEntity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        AuthController.signOutWithTransition()
    }
}
