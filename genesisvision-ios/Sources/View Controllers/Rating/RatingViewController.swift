//
//  RatingViewController.swift
//  genesisvision-ios
//
//  Created by George on 03/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class RatingViewController: BaseTabmanViewController<RatingTabmanViewModel> {
    
    private var infoBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        
        infoBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_info"), style: .done, target: self, action: #selector(aboutLevelsButtonAction(_:)))
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func updatedItems() {
        dataSource = viewModel.dataSource
        bar.items = viewModel.items
        reloadPages()
    }
    
    // MARK: - IBAction
    @objc @IBAction func aboutLevelsButtonAction(_ sender: UIButton) {
        viewModel.showAboutLevels()
    }
}
