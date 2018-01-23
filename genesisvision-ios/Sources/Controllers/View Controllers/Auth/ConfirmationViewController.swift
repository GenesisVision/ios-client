//
//  ConfirmationViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ConfirmationViewController: BaseViewController {

    @IBOutlet var confirmationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Confirmation"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func confirmationButtonAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

}
