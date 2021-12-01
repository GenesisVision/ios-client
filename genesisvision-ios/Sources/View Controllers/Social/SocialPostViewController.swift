//
//  SocialPostViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 18.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class SocialPostViewController: BaseViewController {
    
    var viewModel: SocialPostViewModel!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPost { [weak self] _ in
            self?.reloadData()
        }
    }
    
    private func setup() {
        title = "Post"
        setupUI()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.configure(with: .defaultConfiguration)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerClass(for: SocialFeedTableViewCell.self)
        tableView.registerClass(for: SocialCommentTableViewCell.self)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SocialPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = viewModel.sections[section]
        
        switch type {
        case .post:
            return 1
        case .comments:
            return viewModel.commentsViewModels.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = viewModel.sections[indexPath.section]
        
        switch type {
        case .post:
            guard let model = viewModel.post else {
                return TableViewCell() }
            return tableView.dequeueReusableCell(withModel: model, for: indexPath)
        case .comments:
            guard let model = viewModel.commentsViewModels[safe: indexPath.row] else {
                return TableViewCell() }

            return tableView.dequeueReusableCell(withModel: model, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let type = viewModel.sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = viewModel.sections[indexPath.section]
        
        switch type {
        case .post:
            guard let model = viewModel.post else { return 0.0 }
            return model.cellSize(spacing: 0, frame: tableView.frame).height
        case .comments:
            guard let model = viewModel.commentsViewModels[safe: indexPath.row] else { return 0.0 }
            return model.cellSize(spacing: 0, frame: tableView.frame).height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = viewModel.sections[indexPath.section]
        
        switch type {
        case .post:
            guard let model = viewModel.post else { return 0.0 }
            return model.cellSize(spacing: 0, frame: tableView.frame).height
        case .comments:
            guard let model = viewModel.commentsViewModels[safe: indexPath.row] else { return 0.0 }
            return model.cellSize(spacing: 0, frame: tableView.frame).height
        }
    }
}

extension SocialPostViewController: BaseTableViewProtocol {
    
}

final class SocialPostViewModel {
    
    enum SectionType {
        case post
        case comments
    }
    
    var sections: [SectionType] = [.post, .comments]
    
    var post: SocialFeedTableViewCellViewModel?
    var commentsViewModels: [SocialCommentTableViewCellViewModel] = []
    let postId: UUID?
    let socialRouter: SocialRouter
    
    init(with router: SocialRouter, delegate: BaseTableViewProtocol, postId: UUID?, post: Post?) {
        self.postId = postId ?? post?._id
        self.socialRouter = router
        if let post = post {
            self.post = SocialFeedTableViewCellViewModel(post: post, cellDelegate: self)
        }
    }
    
    func fetchPost(completion: @escaping CompletionBlock) {
        guard let postId = postId else { return }
        SocialDataProvider.getPost(postId: postId) { [weak self] (viewModel) in
            if let viewModel = viewModel {
                self?.post = SocialFeedTableViewCellViewModel(post: viewModel, cellDelegate: self)
                if let comments = viewModel.comments {
                    self?.commentsViewModels = comments.map({ return SocialCommentTableViewCellViewModel(post: $0, delegate: self) })
                }
                completion(.success)
            }
            completion(.failure(errorType: .apiError(message: "")))
        } errorCompletion: { (result) in
            switch result {
            case .success:
                break
            case .failure(errorType: let errorType):
                completion(.failure(errorType: errorType))
            }
        }
    }
}

extension SocialPostViewModel: SocialCommentTableViewCellDelegate {
    func replyButtonPressed(postId: UUID) {
    }
}


extension SocialPostViewModel: SocialFeedCollectionViewCellDelegate {
    func likeTouched(postId: UUID) {
        
    }
    
    func shareTouched(postId: UUID) {
        
    }
    
    func commentTouched(postId: UUID) {
        
    }
    
    func tagPressed(tag: PostTag) {
        
    }
    
    func userOwnerPressed(postId: UUID) {
        
    }
    
    func postActionsPressed(postId: UUID) {
        
    }
    
    func undoDeletion(postId: UUID) {
        
    }
    
    
}
