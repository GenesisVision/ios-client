//
//  ProfileViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ProfileViewController: BaseViewControllerWithTableView, UINavigationControllerDelegate {
    // MARK: - View Model
    var viewModel: ProfileViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: PhotoHeaderView! {
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        headerView.setup(with: viewModel.getAvatarURL())
        headerView.isHidden = false
        reloadData()
    }
    
    // MARK: - Private methods
    override func fetch() {
        viewModel.fetchProfile { [weak self] (result) in
            DispatchQueue.main.async {
                self?.hideAll()
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.headerView.setup(with: self?.viewModel.getAvatarURL())
                        self?.headerView.isHidden = false
                        self?.reloadData()
                    }
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self)
                }
            }
        }
    }
    
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        showProfileStateAction()
        
        navigationItem.title = viewModel.title
        
        showInfiniteIndicator(value: false)
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
 
        fetch()
    }
    
    private func editProfileStateAction() {
        navigationItem.leftBarButtonItem = saveProfileButton
        navigationItem.rightBarButtonItem = cancelEditProfileButton
        headerView.editableState = viewModel.editableState
        tableView.bounces = false
    }
    
    private func showProfileStateAction() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = editProfileButton
        headerView.editableState = viewModel.editableState
        tableView.bounces = true
    }
    
    private func update(gender value: Bool) {
        viewModel.update(gender: value)
        UIView.setAnimationsEnabled(false)
        let indexPath = IndexPath(row: 5, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
    }
    
    private func selectGender() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.Cell.headerBg
       
        let maleAction = UIAlertAction(title: "Male", style: .default) { [weak self] (UIAlertAction) in
            self?.update(gender: true)
        }
        let femaleAction = UIAlertAction(title: "Female", style: .default) { [weak self] (UIAlertAction) in
            self?.update(gender: false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if let gender = viewModel.getGender() {
            if gender {
                maleAction.isEnabled = false
            } else {
                femaleAction.isEnabled = false
            }
        }
        
        alert.addAction(maleAction)
        alert.addAction(femaleAction)
        alert.addAction(cancelAction)
        
        let rowIndex = viewModel.numberOfRows(in: 0)
        if let cell = tableView.cellForRow(at: IndexPath(row: rowIndex - 1, section: 0)) {
            alert.popoverPresentationController?.sourceView = cell
            alert.popoverPresentationController?.sourceRect = cell.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func selectBirthdate() {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.Cell.headerBg
        
        var components = DateComponents()
        components.year = -Constants.Profile.minYear
        let maxDate = Calendar.current.date(byAdding: components, to: Date())

        alert.addDatePicker(mode: .date, date: self.viewModel.getBirthdate(), minimumDate: nil, maximumDate: maxDate) { [weak self] date in
            self?.viewModel.update(birthdate: date)
            UIView.setAnimationsEnabled(false)
            let indexPath = IndexPath(row: 4, section: 0)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
            UIView.setAnimationsEnabled(true)
        }
        
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction func editProfileButtonAction(_ sender: UIButton) {
        hideKeyboard()
        
        viewModel.editProfile { [weak self] (result) in
            switch result {
            case .success:
                self?.editProfileStateAction()
                self?.reloadData()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    @IBAction func cancelEditProfileButtonAction(_ sender: UIButton) {
        hideKeyboard()
        
        viewModel.cancelEditProfile { [weak self] (result) in
            switch result {
            case .success:
                self?.headerView.setup(with: self?.viewModel.getAvatarURL())
                self?.showProfileStateAction()
                self?.reloadData()
            case .failure:
                print("Error")
            }
        }
    }
    
    @IBAction func saveProfileButtonAction(_ sender: UIButton) {
        hideKeyboard()
        showProgressHUD()
        
        viewModel.saveProfile { [weak self] (result) in
            DispatchQueue.main.async {
                self?.hideAll()
                
                switch result {
                case .success:
                    self?.showSuccessHUD(completion: { (success) in
                        self?.showProfileStateAction()
                        self?.reloadData()
                    })
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let fieldType = viewModel.didSelect(indexPath) else {
            return
        }
        
        switch fieldType {
        case .birthday:
            selectBirthdate()
        case .gender:
            selectGender()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return TableViewCell()
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

extension ProfileViewController: PhotoHeaderViewDelegate {
    func didPressOnPhotoButton(_ view: PhotoHeaderView) {
        view.endEditing(true)
        
        showImagePicker()
    }
}

extension ProfileViewController: ImagePickerPresentable {
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

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        } else {
            IQKeyboardManager.shared.resignFirstResponder()
        }
        
        return false
    }
}

