//
//  ProfileViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProfileViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: ProfileViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Variables
    private var editProfileButton: UIBarButtonItem! {
        return UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editProfileButtonAction(_:)))
    }
    private var cancelEditProfileButton: UIBarButtonItem! {
        return UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelEditProfileButtonAction(_:)))
    }
    private var saveProfileButton: UIBarButtonItem! {
        return UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveProfileButtonAction(_:)))
    }
    private var signOutButton: UIBarButtonItem! {
        return UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(signOutButtonAction(_:)))
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private methods
    private func fetch() {
        viewModel.getProfile { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
    
    private func setup() {
        fetch()
        setupUI()
    }
    
    private func setupUI() {
        showProfileStateAction()
        
        title = viewModel.title
    }
    
    private func setupTableConfiguration() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: ProfileViewModel.cellModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    override func pullToRefresh() {
        fetch()
    }
    
    private func editProfileStateAction() {
        navigationItem.leftBarButtonItem = saveProfileButton
        navigationItem.rightBarButtonItem = cancelEditProfileButton
    }
    
    private func showProfileStateAction() {
        navigationItem.leftBarButtonItem = editProfileButton
        navigationItem.rightBarButtonItem = signOutButton
    }
    
    // MARK: - Actions
    @IBAction func editProfileButtonAction(_ sender: UIButton) {
        showProgressHUD()
        viewModel.editProfile { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.editProfileStateAction()
                self?.tableView.reloadData()
            case .failure:
                print("Error")
            }
        }
    }
    
    @IBAction func cancelEditProfileButtonAction(_ sender: UIButton) {
        viewModel.cancelEditProfile { [weak self] (result) in
            switch result {
            case .success:
                self?.showProfileStateAction()
                self?.tableView.reloadData()
            case .failure:
                print("Error")
            }
        }
    }
    
    @IBAction func saveProfileButtonAction(_ sender: UIButton) {
        showProgressHUD()
        viewModel.saveProfile { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.showProfileStateAction()
                self?.tableView.reloadData()
            case .failure(let reason):
                self?.showErrorHUD(subtitle: reason)
            }
        }
    }
    
    @IBAction func signOutButtonAction(_ sender: UIButton) {
        viewModel.signOut()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
}

extension ProfileViewController: ProfileHeaderTableViewCellDelegate {
    func chooseProfilePhotoCellDidPressOnPhoto(_ cell: ProfileHeaderTableViewCell) {
        //take photo
    }
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func chooseProfilePhotoDidPressOnPhoto(_ cell: ProfileHeaderView) {
        //take photo
    }
}
