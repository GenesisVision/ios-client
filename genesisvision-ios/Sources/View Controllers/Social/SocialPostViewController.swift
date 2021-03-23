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
    
    private var socialPostCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionView()
    }
    
    private func setup() {
        title = "Post"
    }
    
    private func setupCollectionView() {
        view.addSubview(socialPostCollectionView)
        
        socialPostCollectionView.fillSuperview(padding: UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        
        socialPostCollectionView.dataSource = viewModel.socialPostCollectionViewDataSource
        socialPostCollectionView.delegate = viewModel.socialPostCollectionViewDataSource
        
        if let layout = socialPostCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        socialPostCollectionView.isScrollEnabled = true
        socialPostCollectionView.showsVerticalScrollIndicator = false
        socialPostCollectionView.allowsSelection = true
        socialPostCollectionView.registerNibs(for: viewModel.socialPostCollectionViewDataSource.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: socialPostCollectionView)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch(completion: { [weak self] (result) in
            self?.hideAll()
            self?.reloadData()
        }, refresh: true)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.socialPostCollectionView.reloadData()
        }
    }
}

final class SocialPostViewModel {
    
    var socialPostCollectionViewModel: SocialPostCollectionViewModel!
    var socialPostCollectionViewDataSource: CollectionViewDataSource!
    
    let post: Post?
    let postId: UUID?
    let socialRouter: SocialRouter
    
    init(with router: SocialRouter, delegate: BaseTableViewProtocol, postId: UUID?, post: Post?) {
        self.postId = postId
        self.post = post
        self.socialRouter = router
    }
    
    func fetchPost(completion: @escaping CompletionBlock) {
        guard let postId = postId else { return }
        SocialDataProvider.getPost(postId: postId) { [weak self] (viewModel) in
            if let viewModel = viewModel {
                self?.post = viewModel
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

final class SocialPostCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var skip: Int = 0
    var take: Int = 12
    var totalCount: Int = 0
    
    var selectedIndex: Int = 0

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true
    var showOnlyUsersPosts: Bool = true
        
    let collectionTopInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionBottomInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionLeftInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionRightInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionLineSpacing: CGFloat = Constants.SystemSizes.Cell.lineSpacing
    let collectionInteritemSpacing: CGFloat = Constants.SystemSizes.Cell.interitemSpacing

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return []
    }
    
    var shouldHightlight: Bool = false
    var shouldUnhightlight: Bool = false
    
    init(type: CellActionType) {
        self.type = type
    }
}
