//
//  WalletViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewController {

    var viewModel: WalletViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let balance = viewModel.getBalance()
        navigationItem.title = String(describing: balance) + " GVT"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    private func setup() {
        title = "Wallet"
 
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                let balance = self?.viewModel.getBalance()
                self?.navigationItem.title = String(describing: balance) + " GVT"
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
}
