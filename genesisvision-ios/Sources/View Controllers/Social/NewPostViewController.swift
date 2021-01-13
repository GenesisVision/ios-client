//
//  NewPostViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 01.12.2020.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class NewPostViewController: BaseModalViewController {
    
    var viewModel: NewPostViewModel!
    
    @IBOutlet weak var sharedPostView: SocialPostView! {
        didSet {
            sharedPostView.isHidden = true
            sharedPostView.backgroundColor = UIColor.Common.darkCell
        }
    }
    
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
        }
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.sharedPost != nil {
            setupSharedPostView()
        }
    }
    
    private func setup() {
        title = "New post"
    }
    
    private func setupSharedPostView() {
        sharedPostView.isHidden = false
        
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
        
        if let image = viewModel.sharedPost?.images?.first, let logo = image.resizes?.last?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            sharedPostView.postImageView.isHidden = false
            sharedPostView.postImageView.kf.indicatorType = .activity
            sharedPostView.postImageView.kf.setImage(with: fileUrl)
        } else {
            sharedPostView.postImageView.isHidden = true
        }
        
        if let text = viewModel.sharedPost?.text {
            sharedPostView.textView.text = text
        }
    }
    
    @IBAction func publishButtonAction(_ sender: Any) {
        viewModel.publishPost { [weak self] (result) in
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    @IBAction func atSignButtonAction(_ sender: Any) {
        textView.text = textView.text + atSign
    }
    
    @IBAction func hashtagButtonAction(_ sender: Any) {
        textView.text = textView.text + hashtagSign
    }
    
    @IBAction func attachmentButtonAction(_ sender: Any) {
        
    }
}

extension NewPostViewController: UITextViewDelegate {
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
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            return
        }
        publishButton.setEnabled(true)
        viewModel.newPostText = textView.text
    }
}


final class NewPostViewModel {
    var sharedPost: Post?
    var newPostText: String?
    var newPostImages: [NewPostImage]?
    
    init(sharedPost: Post?) {
        self.sharedPost = sharedPost
    }
    
    func publishPost(completion: @escaping CompletionBlock) {
        sharedPost == nil ? addPost(completion: completion) : rePost(completion: completion)
    }
    
    private func rePost(completion: @escaping CompletionBlock) {
        let model = RePost(_id: sharedPost?._id, text: newPostText, images: [])
        SocialDataProvider.rePost(model: model, completion: completion)
    }
    
    private func addPost(completion: @escaping CompletionBlock) {
        let model = NewPost(text: newPostText, postId: nil, userId: nil, images: [])
        SocialDataProvider.addPost(model: model, completion: completion)
    }
}
