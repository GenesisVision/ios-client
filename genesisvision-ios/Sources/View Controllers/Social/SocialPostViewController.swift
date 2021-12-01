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
    
    private let replyInputTextField: ReplyInputField = {
        let view = ReplyInputField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        viewModel.fetchPost { [weak self] _ in
            self?.reloadData()
        }
    }
    
    private func setup() {
        title = "Post"
        replyInputTextField.configure(viewModels: [], delegate: self)
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
        view.addSubview(replyInputTextField)
        
        tableView.anchor(top: view.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: replyInputTextField.topAnchor,
                         trailing: view.trailingAnchor)
        
        replyInputTextField.anchor(top: tableView.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   trailing: view.trailingAnchor)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.replyInputTextField.replierView.configure(replingPost: self.viewModel.replyingPost, delegate: self)
            self.tableView.reloadData()
        }
    }
}

extension SocialPostViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        replyInputTextField.attachmentButton
    }
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImageUrl = pickedImageURL, let pickedImage = pickedImage else { return }
        viewModel.pickedImages.append(SocialPostViewModel.PickedImage(imageUrl: pickedImageUrl.absoluteString, image: pickedImage))
        let viewModels = viewModel.pickedImages.map({ return ImagesGalleryCollectionViewCellViewModel(imageUrl: $0.imageUrl, resize: PostImageResize(quality: nil, logoUrl: nil, height: 100, width: 100), image: $0.image, showRemoveButton: true, delegate: replyInputTextField) })
        replyInputTextField.imageGallery.viewModels = viewModels
        replyInputTextField.imageGallery.isHidden = viewModels.isEmpty
        viewModel.saveImage(pickedImageUrl) { result in
        }
    }
}

extension SocialPostViewController: ReplyInputFieldDelegate {
    func attachmentButtonPressed() {
        showImagePicker()
    }
    
    func sendButtonPressed() {
        viewModel.addPost(postText: replyInputTextField.textField.text ?? "") { [weak self] _ in
            self?.fetchData()
        }
    }
    
    func removeImage(imageUrl: String) {
        viewModel.pickedImages.removeAll(where: { $0.imageUrl == imageUrl })
        let viewModels = viewModel.pickedImages.map({ return ImagesGalleryCollectionViewCellViewModel(imageUrl: $0.imageUrl, resize: PostImageResize(quality: nil, logoUrl: nil, height: 100, width: 100), image: $0.image, showRemoveButton: true, delegate: replyInputTextField) })
        replyInputTextField.imageGallery.viewModels = viewModels
        replyInputTextField.imageGallery.isHidden = viewModels.isEmpty
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
        
        switch type {
        case .post:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            view.translatesAutoresizingMaskIntoConstraints = true
            let label = TitleLabel()
            label.font = UIFont.getFont(.semibold, size: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = viewModel.commentsViewModels.count.toString() + " comments"
            view.addSubview(label)
            label.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
            view.isHidden = viewModel.commentsViewModels.isEmpty
            return view
        case .comments:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }
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
    func didReload() {
        reloadData()
    }
}

extension SocialPostViewController: ReplierViewDelegate {
    func removeButtonPressed() {
        viewModel.replyingPost = nil
        replyInputTextField.replierView.configure(replingPost: nil, delegate: self)
        reloadData()
    }
}

final class SocialPostViewModel {
    
    enum SectionType {
        case post
        case comments
    }
    
    var sections: [SectionType] = [.post, .comments]
    
    var replyingPost: Post?
    
    var post: SocialFeedTableViewCellViewModel?
    
    struct UploadedImage {
        let imageUrl: String
        let imageUDID: String
    }
    
    struct PickedImage {
        let imageUrl: String
        let image: UIImage
    }
    
    var pickedImages: [PickedImage] = [] {
        didSet {
            uploadedImages = uploadedImages.filter({ uploadedImage in
                return pickedImages.contains(where: { $0.imageUrl == uploadedImage.imageUrl })
            })
        }
    }
    var uploadedImages: [UploadedImage] = []
    
    var commentsViewModels: [SocialCommentTableViewCellViewModel] = []
    let postId: UUID?
    let socialRouter: SocialRouter
    weak var delegate: BaseTableViewProtocol?
    
    init(with router: SocialRouter, delegate: BaseTableViewProtocol, postId: UUID?, post: Post?) {
        self.postId = postId ?? post?._id
        self.socialRouter = router
        self.delegate = delegate
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
    
    func saveImage(_ pickedImageURL: URL, completion: @escaping (CompletionBlock)) {
        BaseDataProvider.uploadImage(imageData: pickedImageURL.dataRepresentation, imageLocation: .social, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedImages.append(UploadedImage(imageUrl: pickedImageURL.absoluteString, imageUDID: uuidString))
            completion(.success)
            }, errorCompletion: completion)
    }
    
    func addPost(postText: String, completion: @escaping CompletionBlock) {
        let images = uploadedImages.map({ NewPostImage(image: $0.imageUDID, position: 0) })
        let model = NewPost(text: postText, postId: post?.post._id, userId: replyingPost?._id, images: images)
        SocialDataProvider.addPost(model: model, completion: completion)
    }
}

extension SocialPostViewModel: SocialCommentTableViewCellDelegate {
    func replyButtonPressed(postId: UUID) {
        replyingPost = commentsViewModels.first(where: { $0.post._id == postId })?.post
        delegate?.didReload()
    }
}


extension SocialPostViewModel: SocialFeedCollectionViewCellDelegate {
    func imagePressed(postId: UUID, index: Int, image: ImagesGalleryCollectionViewCellViewModel) {
    }
    
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
    
    func imagePressed(imageUrl: URL) {
        
    }
    
}
