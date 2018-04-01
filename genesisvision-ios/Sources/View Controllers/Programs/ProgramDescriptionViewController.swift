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
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.backgroundColor = UIColor.NavBar.grayBackground
        }
    }
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - View Model
    var viewModel: ProgramDescriptionViewModel! {
        didSet {
            title = viewModel.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
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
        
        view.backgroundColor = UIColor.NavBar.grayBackground
        
        fillData()
    }
    
    private func fillData() {
        programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logoURL = getFileURL(fileName: viewModel.getProgramLogo()) {
            programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        programTitleLabel.text = viewModel.getProgramTitle()
        descriptionTextView.text = viewModel.getProgramDescription()
        managerNameLabel.text = viewModel.getProgramManagerUsername()
        
        programLogoImageView.levelLabel.text = viewModel.getProgramLevelText()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        viewModel.closeVC()
    }
}
