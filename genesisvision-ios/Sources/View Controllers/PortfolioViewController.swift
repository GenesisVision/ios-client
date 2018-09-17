//
//  PortfolioViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class PortfolioViewController: BaseViewController {

    var vc: UIViewController!
    
    @IBOutlet weak var chartViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inRequeststViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Public methods
    func updateViewConstraints(_ yOffset: CGFloat) {
        
    }
    // MARK: - Private methods

}
