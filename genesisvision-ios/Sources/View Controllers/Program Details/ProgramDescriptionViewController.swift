//
//  ProgramDescriptionViewController.swift
//  genesisvision-ios
//
//  Created by George on 22/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

class ProgramDescriptionViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var programLogoImageView: ProfileImageView!
    @IBOutlet weak var programTitleLabel: UILabel!
    @IBOutlet weak var managerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var closeButton: ActionButton!
    
    // MARK: - View Model
    var viewModel: ProgramDescriptionViewModel! {
        didSet {
            navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    private func setupUI() {
        
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeButtonAction(_:)))
        swipeGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        setupNavigationBar(with: .gray)
        
        fillData()
    }
    
    private func fillData() {
        programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let fileUrl = getFileURL(fileName: viewModel.getProgramLogo()) {
            programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            programLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.placeholder)
        }
        
        programTitleLabel.text = viewModel.getProgramTitle()
        descriptionLabel.text = viewModel.getProgramDescription()
        managerNameLabel.text = viewModel.getProgramManagerUsername()
        
        programLogoImageView.levelButton.setTitle(viewModel.getProgramLevelText(), for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        viewModel.closeVC()
    }
}
