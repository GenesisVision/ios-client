//
//  NewPostViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 01.12.2020.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class SocialNewPostViewController: BaseViewController {
    
    var viewModel: SocialNewPostViewModel!
    
    
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var sharedPostMainView: UIView! {
        didSet {
            sharedPostMainView.isHidden = true
            sharedPostMainView.backgroundColor = .red
        }
    }
    @IBOutlet weak var sharedPostView: SocialPostView! {
        didSet {
            sharedPostView.isHidden = true
            sharedPostView.backgroundColor = UIColor.Common.darkCell
            sharedPostView.postActionsButton.isHidden = true
        }
    }
    
    @IBOutlet weak var sharedPostmainViewHeightConstraint: NSLayoutConstraint!
    
    private let placeholder = "Share your ideas.\n" +
    "- Use @ to mention a user or a GV asset\n" +
    "- Use # to mention a ticker or add a hashtag"
    
    private let atSign = "@"
    private let hashtagSign = "#"
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textColor = UIColor.Common.darkTextPlaceholder
            textView.text = placeholder
            textView.tintColor = UIColor.Common.primary
            textView.delegate = self
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imagesGallery: ImagesGalleryView! {
        didSet {
            imagesGallery.backgroundColor = .clear
            imagesGallery.isHidden = true
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var publishButton: ActionButton! {
        didSet {
            publishButton.setEnabled(false)
        }
    }
    @IBOutlet weak var attachmentButton: ActionButton! {
        didSet {
            attachmentButton.configure(with: .darkClear)
            let image = UIImage(named: "image_placeholder")?.withRenderingMode(.alwaysTemplate)
            attachmentButton.setImage(image, for: .normal)
            attachmentButton.tintColor = UIColor.Common.white
        }
    }
    
    @IBOutlet weak var atSignButton: ActionButton! {
        didSet {
            atSignButton.configure(with: .custom(options: ActionButtonOptions(borderWidth: 1.0, borderColor: UIColor.Border.forButton, fontSize: 20, bgColor: UIColor.BaseView.bg, textColor: nil, image: nil, rightPosition: nil)))
        }
    }
    
    @IBOutlet weak var hashtagSignButton: ActionButton! {
        didSet {
            hashtagSignButton.configure(with: .custom(options: ActionButtonOptions(borderWidth: 1.0, borderColor: UIColor.Border.forButton, fontSize: 20, bgColor: UIColor.BaseView.bg, textColor: nil, image: nil, rightPosition: nil)))
        }
    }
    
    @IBOutlet weak var assetsTableView: AssetsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if viewModel.mode == .edit {
            title = "Edit post"
            viewModel.fetchPost { [weak self] _ in
                self?.textView.text = self?.viewModel.newPostText
                self?.imagesGallery.isHidden = false
                self?.imagesGallery.viewModels = self?.viewModel.uploadedImages.map({ return ImagesGalleryCollectionViewCellViewModel(imageUrl: $0.imageUrl, resize: PostImageResize(quality: nil, logoUrl: nil, height: 100, width: 100), image: nil, showRemoveButton: true, delegate: self) }) ?? []
            }
        }
        assetsTableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.sharedPost != nil {
            setupSharedPostView()
        }
        scrollView.contentSize.height = (sharedPostView.height + textView.height + imagesGallery.height) * 1.3
    }
    
    private func setup() {
        title = "New post"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(atSignWasAdded), name: .didSelectAssetsTableView, object: nil)
    }
    
    func postViewSizes(post: Post) -> SocialPostViewSizes {
        var textHeight: CGFloat = 0
        var imageHeight: CGFloat = 0
        var tagsViewHeight: CGFloat = 0
        var fullTextViewHeight: CGFloat = 0
        
        if let isEmpty = post.images?.isEmpty, !isEmpty {
            imageHeight = 250
        }
        
        if let text = post.text, !text.isEmpty {
            let textHeightValue = text.height(forConstrainedWidth: UIScreen.main.bounds.width - 20, font: UIFont.getFont(.regular, size: 18))
            
            if textHeightValue < 25 {
                textHeight = 25
            } else if textHeightValue > 25 && textHeightValue < 250 {
                textHeight = textHeightValue
            } else if textHeightValue > 250 {
                textHeight = 250
                fullTextViewHeight = textHeightValue
            }
        }
        
        if let tags = post.tags, !tags.isEmpty {
            tagsViewHeight = 110
        }
        
        return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 0, fullTextViewHeight: fullTextViewHeight)
    }
    
    private func setupSharedPostView() {
        guard let post = viewModel.sharedPost else { return }
        sharedPostView.isHidden = false
        sharedPostMainView.isHidden = false
        sharedPostView.socialPostViewSizes = postViewSizes(post: post)
        if let sizes = sharedPostView.socialPostViewSizes {
            let defaultHeight: CGFloat = 100
            sharedPostmainViewHeightConstraint.constant = sizes.allHeight + defaultHeight
            sharedPostView.height = sizes.allHeight + defaultHeight
        }
        
        if let fullTextViewHeight = sharedPostView.socialPostViewSizes?.fullTextViewHeight, fullTextViewHeight > 250 {
            sharedPostView.socialPostViewSizes?.isExpanded = false
        }
        sharedPostView.updateMiddleViewConstraints()
        
        if let logo = viewModel.sharedPost?.author?.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            sharedPostView.userImageView.kf.indicatorType = .activity
            sharedPostView.userImageView.kf.setImage(with: fileUrl)
        } else {
            sharedPostView.userImageView.image = UIImage.profilePlaceholder
        }
        
        if let userName = viewModel.sharedPost?.author?.username {
            sharedPostView.userNameLabel.text = userName
        }
        
        if let date = viewModel.sharedPost?.date {
            sharedPostView.dateLabel.text = date.dateForSocialPost
        }
        
        if let postImages = post.images, !postImages.isEmpty {
            sharedPostView.galleryView.isHidden = false
            lazy var images = [ImagesGalleryCollectionViewCellViewModel]()
            
            for postImage in postImages {
                if let resizes = postImage.resizes,
                   resizes.count > 1 {
                    let original = resizes.filter({ $0.quality == .original })
                    let hight = resizes.filter({ $0.quality == .high })
                    let medium = resizes.filter({ $0.quality == .medium })
                    let low = resizes.filter({ $0.quality == .low })
                    
                    if let logoUrl = original.first?.logoUrl {
                        images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                               resize: original.first,
                                                                               image: nil,
                                                                               showRemoveButton: false,
                                                                               delegate: nil))
                        continue
                    } else if let logoUrl = hight.first?.logoUrl {
                        images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                               resize: hight.first,
                                                                               image: nil,
                                                                               showRemoveButton: false,
                                                                               delegate: nil))
                        continue
                    } else if let logoUrl = medium.first?.logoUrl {
                        images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                               resize: medium.first,
                                                                               image: nil,
                                                                               showRemoveButton: false,
                                                                               delegate: nil))
                        continue
                    } else if let logoUrl = low.first?.logoUrl {
                        images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                               resize: low.first,
                                                                               image: nil,
                                                                               showRemoveButton: false,
                                                                               delegate: nil))
                    }
                } else if let logoUrl = postImage.resizes?.first?.logoUrl {
                    images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                           resize: postImage.resizes?.first,
                                                                           image: nil,
                                                                           showRemoveButton: false,
                                                                           delegate: nil))
                }
            }
            sharedPostView.galleryView.viewModels = images
        } else {
            sharedPostView.galleryView.isHidden = true
        }
        
        if let text = viewModel.sharedPost?.text {
            sharedPostView.textView.text = text
        }

        var eventPost: Bool = false
        if let tags = post.tags, !tags.isEmpty {
            if (tags.count == 1 && tags.first?.type == .url) || tags.allSatisfy({ $0.type == .url }) {
                sharedPostView.tagsView.isHidden = true
                sharedPostView.eventView.isHidden = true
            } else {
                sharedPostView.tagsView.isHidden = false
                eventPost = tags.contains(where: { $0.type == .event })
                sharedPostView.eventView.isHidden = !eventPost
            }
            sharedPostView.postTags = tags
            sharedPostView.textView.replaceTagsInText(tags: tags)
        } else {
            sharedPostView.tagsView.isHidden = true
            sharedPostView.eventView.isHidden = true
        }
    }
    
    @IBAction func publishButtonAction(_ sender: Any) {
        viewModel.publishPost { [weak self] (result) in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    @IBAction func atSignButtonAction(_ sender: Any) {
        if textView.text == placeholder { textView.text = "" }
        textView.text = textView.text + atSign
        assetsTableView.isHidden = false
        textView.becomeFirstResponder()
    }
    
    @IBAction func hashtagButtonAction(_ sender: Any) {
        if textView.text == placeholder { textView.text = "" }
        textView.text = textView.text + hashtagSign
    }
    
    @IBAction func attachmentButtonAction(_ sender: Any) {
        showImagePicker()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc func atSignWasAdded(notification: Notification) {
        guard let text = notification.userInfo?["text"] as? String else { return }
        textView.text = textView.text.components(separatedBy: " ").dropLast().joined(separator: " ")
        textView.text.append(" @"+text)
        textViewDidChange(textView)
    }
}

extension SocialNewPostViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return attachmentButton
    }
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImageUrl = pickedImageURL, let pickedImage = pickedImage else { return }
        
        viewModel.pickedImages.append(SocialNewPostViewModel.PickedImage(imageUrl: pickedImageUrl.absoluteString, image: pickedImage))
        imagesGallery.viewModels.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: pickedImageUrl.absoluteString, resize: PostImageResize(quality: nil, logoUrl: nil, height: 100, width: 100), image: pickedImage, showRemoveButton: true, delegate: self))
        imagesGallery.isHidden = imagesGallery.viewModels.isEmpty
        viewModel.saveImage(pickedImageUrl) { result in
            self.publishButton.setEnabled(true)
        }
    }
}

extension SocialNewPostViewController: ImagesGalleryCollectionViewCellDelegate {
    func removeImage(imageUrl: String) {
        viewModel.pickedImages.removeAll(where: { $0.imageUrl == imageUrl })
        imagesGallery.viewModels.removeAll(where: { $0.imageUrl == imageUrl })
        imagesGallery.isHidden = imagesGallery.viewModels.isEmpty
        self.publishButton.setEnabled(true)
        if viewModel.pickedImages.isEmpty {
            scrollView.contentSize.height -= imagesGallery.height
        }
    }
}

extension SocialNewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
        textView.textColor = UIColor.Common.darkTextPrimary
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard !textView.text.isEmpty else {
            textView.textColor = UIColor.Common.darkTextPlaceholder
            textView.text = placeholder
            return
        }
        guard let stringFromText = textView.text else {return}
        var newString = stringFromText
        var lastChar = newString.last
        while lastChar == "\n" {
            newString.removeLast()
            lastChar = newString.last
        }
        textView.text = newString
        textViewDidChange(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            return
        }
        
        publishButton.setEnabled(true)
        viewModel.newPostText = textView.text
        
        let maxHeight: CGFloat = 1500.0
        let minHeight: CGFloat = 100.0

        let textHeight = textView.text.height(forConstrainedWidth: UIScreen.main.bounds.width, font: UIFont.systemFont(ofSize: 16)) + 18
        
        if textHeight <= minHeight {
            textViewHeightConstraint.constant = minHeight
        } else {
            textViewHeightConstraint.constant = textHeight
        }
        
        if sharedPostView.isHidden {
            scrollView.contentSize.height = (min(maxHeight, max(minHeight, textHeight)) + imagesGallery.height) * 1.3
        } else {
            scrollView.contentSize.height = (min(maxHeight, max(minHeight, textHeight)) + imagesGallery.height + sharedPostView.height) * 1.3
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let lastWord = textView.text.getLastWord(in: range, with: text) else { return true }
        if lastWord.contains(atSign) {
            assetsTableView.isHidden = false
            var lastWordWithoutaAtSign = lastWord
            lastWordWithoutaAtSign.removeFirst()
            viewModel.fetchAssets(searchWord: lastWordWithoutaAtSign) { assetsArray in
                self.assetsTableView.viewModels.removeAll()
                self.assetsTableView.viewModels = assetsArray
            }
            assetsTableView.reloadTableView()
        } else {
            assetsTableView.isHidden = true
        }
        return true
    }
}


final class SocialNewPostViewModel {
    var sharedPost: Post?
    var newPostText: String?
    
    struct UploadedImage {
        let imageUrl: String
        let imageUDID: String
    }
    
    struct PickedImage {
        let imageUrl: String
        let image: UIImage
    }
    
    enum SocialPostViewModelMode {
        case add
        case edit
    }
    
    var pickedImages: [PickedImage] = [] {
        didSet {
            uploadedImages = uploadedImages.filter({ uploadedImage in
                return pickedImages.contains(where: { $0.imageUrl == uploadedImage.imageUrl })
            })
        }
    }
    var uploadedImages: [UploadedImage] = []
    let mode: SocialPostViewModelMode
    var postId: UUID?
    var userId : UUID?
    
    init(sharedPost: Post?, mode: SocialPostViewModelMode? = nil, postId: UUID? = nil) {
        self.sharedPost = sharedPost
        self.postId = postId
        
        if let mode = mode {
            self.mode = mode
        } else {
            self.mode = .add
        }
    }
    
    func publishPost(completion: @escaping CompletionBlock) {
        if sharedPost == nil {
            switch mode {
            case .add:
                addPost(completion: completion)
            case .edit:
                editPost(completion: completion)
            }
        } else {
            rePost(completion: completion)
        }
    }
    
    private func rePost(completion: @escaping CompletionBlock) {
        lazy var images = [NewPostImage]()
        for (index,image) in uploadedImages.enumerated() {
            images.append(NewPostImage(image: image.imageUDID, position: index))
        }
        let model = RePost(_id: sharedPost?._id, text: newPostText, images: images)
        SocialDataProvider.rePost(model: model, completion: completion)
    }
    
    private func addPost(completion: @escaping CompletionBlock) {
        lazy var images = [NewPostImage]()
        for (index,image) in uploadedImages.enumerated() {
            images.append(NewPostImage(image: image.imageUDID, position: index))
        }
        let model = NewPost(text: newPostText ?? "", postId: nil, userId: userId, images: images)
        SocialDataProvider.addPost(model: model, completion: completion)
    }
    
    private func editPost(completion: @escaping CompletionBlock) {
        guard let postId = postId else { return  completion(.failure(errorType: .apiError(message: "")))}
        lazy var images = [NewPostImage]()
        for (index,image) in uploadedImages.enumerated() {
            images.append(NewPostImage(image: image.imageUDID, position: index))
        }
        let model = EditPost(_id: postId, text: newPostText, images: images)
        SocialDataProvider.editPost(model: model, completion: completion)
    }
    
    func saveImage(_ pickedImageURL: URL, completion: @escaping (CompletionBlock)) {
        BaseDataProvider.uploadImage(imageData: pickedImageURL.dataRepresentation, imageLocation: .social, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString.lowercased() else { return completion(.failure(errorType: .apiError(message: nil))) }
            self?.uploadedImages.append(UploadedImage(imageUrl: pickedImageURL.absoluteString, imageUDID: uuidString))
            completion(.success)
            }, errorCompletion: completion)
    }
    
    func fetchAssets(searchWord : String, complition : @escaping ([SocialAssetsTableViewCellViewModel]) -> ()) {
        SearchDataProvider.get(searchWord.lowercased(), take: ApiKeys.take, completion: { viewModel in
            var assetsArray = [SocialAssetsTableViewCellViewModel]()
            viewModel?.funds?.items.map({ list in
                for i in list {
                    let elem = SocialAssetsTableViewCellViewModel(assetName: i.title, assetImage: i.logoUrl, tagType: .fund, assetURL: i.url)
                    assetsArray.append(elem)
                }
            })
            viewModel?.follows?.items.map({ list in
                for i in list {
                    let elem = SocialAssetsTableViewCellViewModel(assetName: i.title, assetImage: i.logoUrl, tagType: .follow, assetURL: i.url)
                    assetsArray.append(elem)
                }
            })
            viewModel?.programs?.items.map({ list in
                for i in list {
                    let elem = SocialAssetsTableViewCellViewModel(assetName: i.title, assetImage: i.logoUrl, tagType: .program, assetURL: i.url)
                    assetsArray.append(elem)
                }
            })
            viewModel?.managers?.items.map({ list in
                for i in list {
                    let elem = SocialAssetsTableViewCellViewModel(assetName: i.username, assetImage: i.logoUrl, tagType: .user, assetURL: i.url)
                    assetsArray.append(elem)
                }
            })
            complition(assetsArray)
            
        }) { result in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
    
    func fetchPost(completion: @escaping CompletionBlock) {
        guard let postId = postId else { return }
        SocialDataProvider.getPost(postId: postId) { [weak self] (viewModel) in
            if let viewModel = viewModel {
                self?.newPostText = viewModel.text
                
                guard let postImages = viewModel.images else { return }

                for postImage in postImages {
                    if let resizes = postImage.resizes,
                       resizes.count > 1 {
                        let original = resizes.filter({ $0.quality == .original })
                        let hight = resizes.filter({ $0.quality == .high })
                        let medium = resizes.filter({ $0.quality == .medium })
                        let low = resizes.filter({ $0.quality == .low })
                        
                 
                        if let logoUrl = original.first?.logoUrl, let imageId = postImage._id {
                            self?.uploadedImages.append(UploadedImage(imageUrl: logoUrl, imageUDID: imageId))
                            self?.pickedImages.append(PickedImage(imageUrl: logoUrl, image: UIImage()))
                            continue
                        } else if let logoUrl = hight.first?.logoUrl, let imageId = postImage._id {
                            self?.uploadedImages.append(UploadedImage(imageUrl: logoUrl, imageUDID: imageId))
                            self?.pickedImages.append(PickedImage(imageUrl: logoUrl, image: UIImage()))
                            continue
                        } else if let logoUrl = medium.first?.logoUrl, let imageId = postImage._id {
                            self?.uploadedImages.append(UploadedImage(imageUrl: logoUrl, imageUDID: imageId))
                            self?.pickedImages.append(PickedImage(imageUrl: logoUrl, image: UIImage()))
                            continue
                        } else if let logoUrl = low.first?.logoUrl, let imageId = postImage._id {
                            self?.uploadedImages.append(UploadedImage(imageUrl: logoUrl, imageUDID: imageId))
                            self?.pickedImages.append(PickedImage(imageUrl: logoUrl, image: UIImage()))
                        }
                    } else if let logoUrl = postImage.resizes?.first?.logoUrl, let imageId = postImage._id  {
                        self?.uploadedImages.append(UploadedImage(imageUrl: logoUrl, imageUDID: imageId))
                        self?.pickedImages.append(PickedImage(imageUrl: logoUrl, image: UIImage()))
                    }
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
