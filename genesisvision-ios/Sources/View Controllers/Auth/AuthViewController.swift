//
//  AuthViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class AuthViewController: BaseViewController {

    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Auth"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        guard let viewController = SignInViewController.storyboardInstance(name: .auth) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        guard let viewController = SignUpViewController.storyboardInstance(name: .auth) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
