//
//  ProfileViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProfileViewController: BaseViewControllerWithTableView, UINavigationControllerDelegate {

    // MARK: - View Model
    var viewModel: ProfileViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: ProfileHeaderView! {
        didSet {
            headerView.delegate = self
            headerView.isHidden = true
        }
    }
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Variables
    private var editProfileButton: UIBarButtonItem! {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_profile_edit"), style: .done, target: self, action: #selector(editProfileButtonAction(_:)))
        return barButtonItem
    }
    private var cancelEditProfileButton: UIBarButtonItem! {
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelEditProfileButtonAction(_:)))
        barButtonItem.tintColor = UIColor.Font.red
        return barButtonItem
    }
    private var saveProfileButton: UIBarButtonItem! {
        let barButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveProfileButtonAction(_:)))
        barButtonItem.tintColor = UIColor.Font.primary
        return barButtonItem
    }
    private var signOutButton: UIBarButtonItem! {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_profile_logout"), style: .done, target: self, action: #selector(signOutButtonAction(_:)))
        return barButtonItem
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headerView.setup(with: viewModel.getAvatarURL())
    }
    
    // MARK: - Private methods
    override func fetch() {
        viewModel.getProfile { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                self?.headerView.isHidden = false
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
        
        title = viewModel.title.uppercased()
        navigationItem.title = viewModel.title
    }
    
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: ProfileViewModel.cellModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    private func editProfileStateAction() {
        navigationItem.leftBarButtonItem = saveProfileButton
        navigationItem.rightBarButtonItem = cancelEditProfileButton
        headerView.profileState = viewModel.profileState
    }
    
    private func showProfileStateAction() {
        navigationItem.leftBarButtonItem = editProfileButton
        navigationItem.rightBarButtonItem = signOutButton
        headerView.profileState = viewModel.profileState
    }
    
    private func takePhoto(type: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        
        picker.navigationBar.barTintColor = UIColor.Background.main
        picker.navigationBar.tintColor = UIColor.primary
        picker.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.primary]
        present(picker, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        view.endEditing(true)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] (action) in
            DispatchQueue.main.async {
                self?.takePhoto(type: .camera)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Фотогалерея", style: .default, handler: { [weak self] (action) in
            DispatchQueue.main.async {
                self?.takePhoto(type: .photoLibrary)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler:nil))
        alertController.view.tintColor = UIColor.primary
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func editProfileButtonAction(_ sender: UIButton) {
        hideKeyboard()
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
        hideKeyboard()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row > 0 else { return }
        
        cell.addDashedBottomLine()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func chooseProfilePhotoDidPressOnPhoto(_ view: ProfileHeaderView) {
        takePhoto()
    }
}

//    MARK: UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        viewModel.pickedImage = pickedImage
        headerView.update(avatar: viewModel.pickedImage)
        
        picker.dismiss(animated: true, completion: nil)
    }
}
