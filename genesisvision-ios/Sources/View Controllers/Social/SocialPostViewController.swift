//
//  SocialPostViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 18.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit
//MARK: - Контроллер конкретного поста
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if replyInputTextField.imageGallery.viewModels.isEmpty {
            replyInputTextField.attachmentButton.isHidden = false
            replyInputTextField.imageGallery.isHidden = true
        } else {
            replyInputTextField.attachmentButton.isHidden = true
            replyInputTextField.imageGallery.isHidden = false
        }
    }
    
    private func fetchData() {
        viewModel.fetchPost { [weak self] _ in
            if let isCommentForPostShowing = self?.viewModel.isCommentForPostShowing, let postHeight = self?.viewModel.post?.postViewSizes().allHeight {
                if isCommentForPostShowing {
                    self?.tableView.contentOffset.y = postHeight
                }
            }
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
        if let canComment = viewModel.post?.post.personalDetails?.canComment, canComment {
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
        } else {
            view.addSubview(tableView)
            tableView.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.bottomAnchor,
                             trailing: view.trailingAnchor)
        }
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

extension SocialPostViewController: ImagePickerPresentable, ImagesGalleryCollectionViewCellDelegate {
    var choosePhotoButton: UIButton {
        replyInputTextField.attachmentButton
    }
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImageUrl = pickedImageURL, let pickedImage = pickedImage else { return }
        viewModel.pickedImages.append(SocialPostViewModel.PickedImage(imageUrl: pickedImageUrl.absoluteString, image: pickedImage))
        replyInputTextField.imageGallery.viewModels.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: pickedImageUrl.absoluteString, resize: PostImageResize(quality: nil, logoUrl: nil, height: 100, width: 100), image: pickedImage, showRemoveButton: true, delegate: self))
        replyInputTextField.imageGallery.isHidden = replyInputTextField.imageGallery.viewModels.isEmpty
        viewModel.saveImage(pickedImageUrl) { result in
        }
    }
}

extension SocialPostViewController: ReplyInputFieldDelegate {
    func attachmentButtonPressed() {
        showImagePicker()
    }
    
    func sendButtonPressed() {
        if replyInputTextField.mode == .add {
            viewModel.addPost(postText: replyInputTextField.textField.text ?? "") { [weak self] _ in
                self?.setupViewAfterSendButtonPressed()
            }
        } else {
            viewModel.editPost(postText: replyInputTextField.textField.text ?? "") { result in
                self.setupViewAfterSendButtonPressed()
                self.replyInputTextField.mode = .add
            }
        }
    }
    
    func setupViewAfterSendButtonPressed() {
        fetchData()
        replyInputTextField.textField.text = ""
        replyInputTextField.imageGallery.viewModels.removeAll()
        viewModel.pickedImages.removeAll()
        replyInputTextField.imageGallery.isHidden = true
        removeButtonPressed()
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
    //MARK: - Размер поста
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


extension SocialPostViewController: SocialPostViewModelDelegate {
    func showPostActions(postActions: [SocialPostAction], postId: UUID, postLink: String) {
        showPostMenu(actions: postActions, postId: postId, postLink: postLink)
    }
}

extension SocialPostViewController: SocialPostActionsMenuPresenable {
    func actionSelected(action: SocialPostAction) {
        switch action {
        case .edit(let postId):
            viewModel.editButtonPressed(postId: postId) { viewModel in
                replyInputTextField.mode = .edit
                replyInputTextField.textField.becomeFirstResponder()
                replyInputTextField.textField.text = viewModel.post.text
                
                guard let image = viewModel.post.images?.first else { return }
                guard let resizes = image.resizes else { return }
                let original = resizes.filter({ $0.quality == .original })
                let high = resizes.filter({ $0.quality == .high })
                if let logoUrl = original.first?.logoUrl {
                    let postImage = ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl, resize: original.first, image: nil, showRemoveButton: true, delegate: self)
                    replyInputTextField.imageGallery.viewModels = [postImage]
                } else if let logoUrl = high.first?.logoUrl {
                    let postImage = ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl, resize: original.first, image: nil, showRemoveButton: true, delegate: self)
                    replyInputTextField.imageGallery.viewModels = [postImage]
                }
            }
            
        case .share(let postLink):
            viewModel.socialRouter.share(postLink)
        case .copyLink(postLink: let postLink):
            UIPasteboard.general.string = postLink
            showBottomSheet(.success, title: "Your post link was copied to the clipboard successfully")
        case .delete(let postId):
            viewModel.deletePost(postId: postId) { [weak self] (result) in
                switch result {
                case .success:
                    if let _ = self?.viewModel.commentsViewModels.first(where: { $0.post._id == postId }) {
                    } else {
                        self?.viewModel.socialRouter.popViewController(animated: true)
                    }
                    self?.viewModel.fetchPost { [weak self] (result) in
                        switch result {
                        case .success:
                            self?.reloadData()
                        case .failure(errorType: _):
                            break
                        }
                    }
                case .failure(errorType: let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        case .report(let postId):
            viewModel.socialRouter.show(routeType: .reportPost(postId: postId))
        case .pin(let postId):
            viewModel.pinPost(postId: postId) { [weak self] (result) in
                switch result {
                case .success:
                    self?.pullToRefresh()
                case .failure(errorType: let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        case .unpin(let postId):
            viewModel.pinPost(postId: postId) { [weak self] (result) in
                switch result {
                case .success:
                    self?.pullToRefresh()
                case .failure(errorType: let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        }
    }
}

protocol SocialPostViewModelDelegate: AnyObject {
    func showPostActions(postActions: [SocialPostAction], postId: UUID, postLink: String)
}

final class SocialPostViewModel {
    
    enum SectionType {
        case post
        case comments
    }
    
    var sections: [SectionType] = [.post, .comments]
    
    var replyingPost: Post?
    
    var isCommentForPostShowing = false
    
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
    var commentforEdittingId : UUID?
    let socialRouter: SocialRouter
    weak var delegate: (BaseTableViewProtocol & SocialPostViewModelDelegate)?
    
    init(with router: SocialRouter, delegate: BaseTableViewProtocol & SocialPostViewModelDelegate, postId: UUID?, post: Post?) {
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
                self?.createViewModel(comments: viewModel.comments ?? [])
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
    
    func pinPost(postId: UUID, completion: @escaping CompletionBlock) {
        guard let viewModel = commentsViewModels.first(where: { $0.post._id == postId }), let pinned = viewModel.post.isPinned else { return }

        pinned ? SocialDataProvider.unpin(postId: postId, completion: completion) : SocialDataProvider.pin(postId: postId, completion: completion)
    }
    
    func deletePost(postId: UUID, completion: @escaping CompletionBlock) {
        SocialDataProvider.deletePost(postId: postId, completion: completion)
    }
    
    func editButtonPressed(postId: UUID, complition : (SocialCommentTableViewCellViewModel) -> ()) {
        commentforEdittingId = postId
        guard let viewModel = commentsViewModels.first(where: { $0.post._id == postId }) else { return }
        guard let image = viewModel.post.images?.first, let resizes = image.resizes, let imageId = image._id else {
            complition(viewModel)
            return }
        let original = resizes.filter({ $0.quality == .original })
        let high = resizes.filter({ $0.quality == .high })
        if let logoUrl = original.first?.logoUrl {
            pickedImages.append(PickedImage(imageUrl: logoUrl, image: UIImage()))
            uploadedImages.append(UploadedImage(imageUrl: logoUrl, imageUDID: imageId))
        } else if let logoUrl = high.first?.logoUrl {
            pickedImages.append(PickedImage(imageUrl: logoUrl, image: UIImage()))
            uploadedImages.append(UploadedImage(imageUrl: logoUrl, imageUDID: imageId))
        }
        complition(viewModel)
    }
    
    func postActionsForPost(postId: UUID) -> [SocialPostAction] {
        var postActions: [SocialPostAction] = []
        
        guard let viewModel = commentsViewModels.first(where: { $0.post._id == postId }) else { return postActions }
        
        let profileId = UserDefaults.standard.string(forKey: UserDefaultKeys.profileID)
        
        if profileId != viewModel.post.author?._id?.uuidString {
            postActions.append(.report(postId: postId))
        }
        
        if let canDelete = viewModel.post.personalDetails?.canDelete, canDelete {
            postActions.append(.delete(postId: postId))
        }
        
        if let canEdit = viewModel.post.personalDetails?.canEdit, canEdit {
            postActions.append(.edit(postId: postId))
        }
        
        guard let url = viewModel.post.url else { return postActions }
        
        postActions.append(contentsOf: [.copyLink(postLink: url), .share(postLink: url)])
        
        return postActions
    }
    
    private func createViewModel(comments: [Post]) {
        commentsViewModels = comments.map({ return SocialCommentTableViewCellViewModel(post: $0, delegate: self) })
    }
    
    func saveImage(_ pickedImageURL: URL, completion: @escaping (CompletionBlock)) {
        BaseDataProvider.uploadImage(imageData: pickedImageURL.dataRepresentation, imageLocation: .social, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString.lowercased() else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedImages.append(UploadedImage(imageUrl: pickedImageURL.absoluteString, imageUDID: uuidString))
            completion(.success)
            }, errorCompletion: completion)
    }
    //MARK: - regex
    func addPost(postText: String, completion: @escaping CompletionBlock) {
//        let images = uploadedImages.map({ NewPostImage(image: $0.imageUDID, position: 0) })
        lazy var images = [NewPostImage]()
        for (index,image) in uploadedImages.enumerated() {
            images.append(NewPostImage(image: image.imageUDID, position: index))
        }
        var newPostText = postText
        if let replyingPostAuthor = replyingPost?.author?.url, !replyingPostAuthor.isEmpty {
            let userTag = "@\(replyingPostAuthor) (user) "
            newPostText = userTag + newPostText
        }
        let model = NewPost(text: newPostText, postId: post?.post._id, userId: replyingPost?._id, images: images)
        
        SocialDataProvider.addPost(model: model, completion: completion)
    }
    
    func editPost(postText: String, completion: @escaping CompletionBlock) {
        guard let postId = commentforEdittingId else { return  completion(.failure(errorType: .apiError(message: "")))}
        lazy var images = [NewPostImage]()
        for (index,image) in uploadedImages.enumerated() {
            images.append(NewPostImage(image: image.imageUDID, position: index))
        }
        let model = EditPost(_id: postId, text: postText, images: images)
        SocialDataProvider.editPost(model: model, completion: completion)
    }
}

extension SocialPostViewModel: SocialCommentTableViewCellDelegate {
    func commentTagPressed(tag: PostTag) {
        guard let tagType = tag.type else { return }
        switch tagType {
        case .program:
            guard let assetId = tag.assetDetails?._id, let assetType = tag.assetDetails?.assetType else { return }
            socialRouter.showAssetDetails(with: assetId.uuidString, assetType: assetType)
        case .fund:
            guard let assetId = tag.assetDetails?._id, let assetType = tag.assetDetails?.assetType else { return }
            socialRouter.showAssetDetails(with: assetId.uuidString, assetType: assetType)
        case .follow:
            guard let assetId = tag.assetDetails?._id, let assetType = tag.assetDetails?.assetType else { return }
            socialRouter.showAssetDetails(with: assetId.uuidString, assetType: assetType)
        case .user:
            guard let userId = tag.userDetails?._id?.uuidString else { return }
            socialRouter.showUserDetails(with: userId)
        case .asset:
            break
        case .event:
            break
        case .url:
            guard let url = tag.link?.url else { return }
            socialRouter.showSafari(with: url)
        default:
            break
        }
    }
    
    func replyButtonPressed(postId: UUID) {
        replyingPost = commentsViewModels.first(where: { $0.post._id == postId })?.post
        delegate?.didReload()
    }
}


extension SocialPostViewModel: SocialFeedCollectionViewCellDelegate {
    func imagePressed(postId: UUID, index: Int, image: ImagesGalleryCollectionViewCellViewModel) {
        if let postImages = post?.post.images, !postImages.isEmpty {
            var imagesUrls: [String: PostImageResize?] = [:]
            
            for postImage in postImages {
                if let resizes = postImage.resizes,
                   resizes.count > 1 {
                    let original = resizes.filter({ $0.quality == .original })
                    let hight = resizes.filter({ $0.quality == .high })
                    let medium = resizes.filter({ $0.quality == .medium })
                    let low = resizes.filter({ $0.quality == .low })
                    
                    if let logoUrl = original.first?.logoUrl {
                        imagesUrls[logoUrl] = original.first
                        continue
                    } else if let logoUrl = hight.first?.logoUrl {
                        imagesUrls[logoUrl] = hight.first
                        continue
                    } else if let logoUrl = medium.first?.logoUrl {
                        imagesUrls[logoUrl] = medium.first
                        continue
                    } else if let logoUrl = low.first?.logoUrl {
                        imagesUrls[logoUrl] = low.first
                    }
                } else if let logoUrl = postImage.resizes?.first?.logoUrl {
                    imagesUrls[logoUrl] = postImage.resizes?.first
                }
            }
            
            let onlyImagesUrls = imagesUrls.map({ $0.key })
            let index = Int(onlyImagesUrls.firstIndex(of: image.imageUrl) ?? 0)
            socialRouter.show(routeType: .showImages(index: index, imagesUrls: onlyImagesUrls.compactMap({ return URL(string: $0) }), images: [UIImage]()))
        }
        
    }
    
    func likeTouched(postId: UUID) {
        SocialDataProvider.getPost(postId: postId) { (post) in
            if let isLiked = post?.personalDetails?.isLiked {
                isLiked ? SocialDataProvider.unlikePost(postId: postId) { _ in } : SocialDataProvider.likePost(postId: postId) { _ in }
            }
        } errorCompletion: { _ in }
    }
    
    func shareTouched(postId: UUID) {
        
    }
    
    func commentTouched(postId: UUID) {
        
    }
    
    func tagPressed(tag: PostTag) {
        guard let tagType = tag.type else { return }
        switch tagType {
        case .program:
            guard let assetId = tag.assetDetails?._id, let assetType = tag.assetDetails?.assetType else { return }
            socialRouter.showAssetDetails(with: assetId.uuidString, assetType: assetType)
        case .fund:
            guard let assetId = tag.assetDetails?._id, let assetType = tag.assetDetails?.assetType else { return }
            socialRouter.showAssetDetails(with: assetId.uuidString, assetType: assetType)
        case .follow:
            guard let assetId = tag.assetDetails?._id, let assetType = tag.assetDetails?.assetType else { return }
            socialRouter.showAssetDetails(with: assetId.uuidString, assetType: assetType)
        case .user:
            guard let userId = tag.userDetails?._id?.uuidString else { return }
            socialRouter.showUserDetails(with: userId)
        case .asset:
            let tabType : SocialMainFeedTabType = .live
            socialRouter.show(routeType: .socialFeedWithTag(tabType: tabType, tag: tag))
        case .event:
            break
        case .url:
            guard let url = tag.link?.url else { return }
            socialRouter.showSafari(with: url)
        default:
            break
        }
    }
    
    func userOwnerPressed(postId: UUID) {
        
    }
    
    func postActionsPressed(postId: UUID, postActions: [SocialPostAction]?, postLink: String?) {
        delegate?.showPostActions(postActions: postActions ?? [SocialPostAction](), postId: postId, postLink: postLink ?? "")
    }
    
    func commentActionsPressed(postId: UUID) {
        guard let viewModel = commentsViewModels.first(where: { $0.post._id == postId }) else { return }
        let postActions = postActionsForPost(postId: postId)
        var postLink: String = ""

        if let url = viewModel.post.url {
            postLink = ApiKeys.socialPostsPath + url
        }
        delegate?.showPostActions(postActions: postActions, postId: postId, postLink: postLink)
    }
    
    func undoDeletion(postId: UUID) {
        
    }
    
    func imagePressed(imageUrl: URL) {
        
    }
    
    func touchExpandButton(postId: UUID) {
    }
    
    func isExpandedPost(postId: UUID) -> Bool {
        true
    }
    func openPost(postId: UUID) {
        
    }
}
