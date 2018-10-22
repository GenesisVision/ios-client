//
//  CreateProgramFirstViewController.swift
//  genesisvision-ios
//
//  Created by George on 10/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateProgramFirstViewController: BaseViewControllerWithTableView {
    // MARK: - View Model
    var viewModel: CreateProgramFirstViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: PhotoHeaderView! {
        didSet {
            headerView.editableState = .edit
            headerView.delegate = self
            headerView.isHidden = false
        }
    }
    
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
//        navigationItem.title = viewModel.title  
        
        showInfiniteIndicator(value: false)
    }
    
    private func setupTableConfiguration() {
//        tableView.configure(with: .defaultConfiguration)
//        tableView.delegate = viewModel.tableViewDataSourceAndDelegate
//        tableView.dataSource = viewModel.tableViewDataSourceAndDelegate
//        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction func nextButtonAction(_ sender: UIButton) {
//        viewModel.nextStep()
    }
}

extension CreateProgramFirstViewController: PhotoHeaderViewDelegate {
    func didPressOnPhotoButton(_ view: PhotoHeaderView) {
        view.endEditing(true)
        
        showImagePicker()
    }
}

extension CreateProgramFirstViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return headerView.choosePhotoView.choosePhotoButton
    }
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        viewModel.pickedImage = pickedImage
        viewModel.pickedImageURL = pickedImageURL
        
        DispatchQueue.main.async {
            self.headerView.updateAvatar(url: pickedImageURL)
        }
    }
}

extension CreateProgramFirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if IQKeyboardManager.sharedManager().canGoNext {
            IQKeyboardManager.sharedManager().goNext()
        } else {
            IQKeyboardManager.sharedManager().resignFirstResponder()
        }
        
        return false
    }
}
