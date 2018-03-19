//
//  ConfirmationViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ConfirmationViewController: BaseViewController {

    var viewModel: ConfirmationViewModel!
    
    // MARK: - Buttons
    @IBOutlet var confirmationButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Actions
    @IBAction func confirmationButtonAction(_ sender: UIButton) {
        viewModel.confirmationButtonAction()
    }

}
