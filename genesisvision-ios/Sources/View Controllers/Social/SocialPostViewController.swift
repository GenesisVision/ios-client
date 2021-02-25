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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "Post"
    }
}

final class SocialPostViewModel {
    
    let post: Post?
    let postId: UUID?
    
    
    init(postId: UUID?, post: Post?) {
        self.postId = postId
        self.post = post
    }
}
