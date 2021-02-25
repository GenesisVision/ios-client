//
//  ProfilePrivacyViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 18.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class ProfilePrivacyViewController: BaseViewController, DropDownFieldDelegate {
    var viewModel: ProfilePrivacyViewModel!
    
    private let fieldsView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.spacing = 10
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    
    private let updateButton: ActionButton = {
        let button = ActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.setEnabled(false)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSettings()
    }
    
    private func setup() {
        title = "Privacy"
        view.addSubview(fieldsView)
        view.addSubview(updateButton)
        
        fieldsView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10))
        fieldsView.anchorSize(size: CGSize(width: 0, height: 240))
        
        updateButton.addTarget(self, action: #selector(updateButtonAction), for: .touchUpInside)
        
        updateButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20), size: CGSize(width: 0, height: 50))
    }
    
    private func setupSettings() {
        fieldsView.removeAllArrangedSubviews()
        
        if let post = viewModel.newSettings.first(where: { (key, value) in return key == .post }) {
            let dropView = DropDownField()
            dropView.configure(id: viewModel.settingsUUIDs[post.key] ?? "", fieldDelegate: self,
                               topLabelText: "Who can post to my wall", titleLabelText: post.value.rawValue)
            fieldsView.addArrangedSubview(dropView)
        }
        
        if let view = viewModel.newSettings.first(where: { (key, value) in return key == .view }) {
            let dropView = DropDownField()
            dropView.configure(id: viewModel.settingsUUIDs[view.key] ?? "", fieldDelegate: self,
                               topLabelText: "Who can view comments on my posts", titleLabelText: view.value.rawValue)
            fieldsView.addArrangedSubview(dropView)
        }
        
        if let comment = viewModel.newSettings.first(where: { (key, value) in return key == .comment }) {
            let dropView = DropDownField()
            dropView.configure(id: viewModel.settingsUUIDs[comment.key] ?? "", fieldDelegate: self,
                               topLabelText: "Who can comments on my posts", titleLabelText: comment.value.rawValue)
            fieldsView.addArrangedSubview(dropView)
        }
    }
    
    @objc private func updateButtonAction() {
        showProgressHUD()
        viewModel.update { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func checkUpdateButtonAction() {
        updateButton.setEnabled(viewModel.newSettings != viewModel.currentSettings)
    }
    
    func droDownFieldPressed(uuidString: String, titleString: String) {
        viewModel.currentChangingUUID = uuidString
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 150.0
        bottomSheetController.addNavigationBar(titleString)
        
        bottomSheetController.addDefaultTableView(registerNibs: [SelectableTableViewCellViewModel.self], delegate: self, dataSource: self)
        bottomSheetController.present()
    }
}

extension ProfilePrivacyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrivacyRestrictType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(PrivacyRestrictType.allCases[indexPath.row].rawValue, selected: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bottomSheetController.dismiss()
        guard let setting = viewModel.settingsUUIDs.first(where: { $1 == viewModel.currentChangingUUID }) else { return }
        let type = PrivacyRestrictType.allCases[indexPath.row]
        viewModel.newSettings[setting.key] = type
        setupSettings()
        checkUpdateButtonAction()
    }
}

enum PrivacyRestrictType: String, CaseIterable {
    case all = "All users"
    case me = "Only me"
}

final class ProfilePrivacyViewModel {
    
    enum ProfilePrivacySettings: String {
        case post = "Post"
        case view = "View"
        case comment = "Comment"
    }
    
    public private(set) var currentSettings: [ProfilePrivacySettings: PrivacyRestrictType] = [.post: .all, .view: .all, .comment: .all]
    public private(set) var settingsUUIDs: [ProfilePrivacySettings: String] = [
        .post: UUID().uuidString,
        .view: UUID().uuidString,
        .comment: UUID().uuidString]
    
    var currentChangingUUID: String = ""
    var newSettings: [ProfilePrivacySettings: PrivacyRestrictType] = [:]
    
    init(profile: ProfileFullViewModel) {
        if let whoCanCommentOnMyPosts = profile.whoCanCommentOnMyPosts,
           let whoCanPostToMayWall = profile.whoCanPostToMayWall,
           let whoCanViewCommentsOnMyPosts = profile.whoCanViewCommentsOnMyPosts {
            
            switch whoCanCommentOnMyPosts {
            case .allUsers:
                currentSettings[.comment] = .all
            case .onlyMe:
                currentSettings[.comment] = .me
            }
            
            switch whoCanViewCommentsOnMyPosts {
            case .allUsers:
                currentSettings[.view] = .all
            case .onlyMe:
                currentSettings[.view] = .me
            }
            
            switch whoCanPostToMayWall {
            case .allUsers:
                currentSettings[.post] = .all
            case .onlyMe:
                currentSettings[.post] = .me
            }
            
            newSettings = currentSettings
        }
    }
    
    func update(completion: @escaping CompletionBlock) {
        guard let post = newSettings[.post], let view = newSettings[.view], let comment = newSettings[.comment] else { return completion(.failure(errorType: .apiError(message: ""))) }
        
        
        
        var whoCanPostToMayWall: SocialViewMode?
        var whoCanViewCommentsOnMyPosts: SocialViewMode?
        var whoCanCommentOnMyPosts: SocialViewMode?
        
        switch post {
        case .all:
            whoCanPostToMayWall = .allUsers
        case .me:
            whoCanPostToMayWall = .onlyMe
        }
        
        switch view {
        case .all:
            whoCanViewCommentsOnMyPosts = .allUsers
        case .me:
            whoCanViewCommentsOnMyPosts = .onlyMe
        }
        
        switch comment {
        case .all:
            whoCanCommentOnMyPosts = .allUsers
        case .me:
            whoCanCommentOnMyPosts = .onlyMe
        }
        
        ProfileDataProvider.updateSocialPrivacy(whoCanPostToMayWall: whoCanPostToMayWall, whoCanViewCommentsOnMyPosts: whoCanViewCommentsOnMyPosts, whoCanCommentOnMyPosts: whoCanCommentOnMyPosts, completion: completion)
    }
}
