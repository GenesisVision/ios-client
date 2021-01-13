//
//  SocialMediaViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 01.12.2020.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit


class SocialMediaViewController: BaseViewController {
    
    var viewModel: SocialMediaViewModel!
    
    private var mediaFeedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                self?.reloadData()
            case .failure(errorType: let errorType):
                break
            }
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(mediaFeedCollectionView)
        
        mediaFeedCollectionView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        mediaFeedCollectionView.dataSource = viewModel.socialMediaCollectionViewDataSource
        mediaFeedCollectionView.delegate = viewModel.socialMediaCollectionViewDataSource
        
        if let layout = mediaFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        mediaFeedCollectionView.isScrollEnabled = true
        mediaFeedCollectionView.showsHorizontalScrollIndicator = false
        mediaFeedCollectionView.indicatorStyle = .black
        mediaFeedCollectionView.allowsSelection = false
        mediaFeedCollectionView.registerNibs(for: viewModel.socialMediaCollectionViewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: mediaFeedCollectionView)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.mediaFeedCollectionView.reloadData()
        }
    }
    
}

final class SocialMediaViewModel {
    
    var socialMediaCollectionViewModel: SocialMediaCollectionViewModel!
    var socialMediaCollectionViewDataSource: CollectionViewDataSource!
    
    init() {
        socialMediaCollectionViewModel = SocialMediaCollectionViewModel(type: .social, title: "")
        socialMediaCollectionViewDataSource = CollectionViewDataSource(socialMediaCollectionViewModel)
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        socialMediaCollectionViewModel.fetch(completion: completion)
    }
}

final class SocialMediaCollectionViewModel: CellViewModelWithCollection {
    var type: CellActionType

    var canPullToRefresh: Bool = true
    
    var title: String
    
    enum SectionType {
        case addPost
        case feed
        case media
        case users
    }
    
    var sections: [SectionType] = [.addPost]
    
    var viewModels = [CellViewAnyModel]()
    
    let collectionTopInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionBottomInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionLeftInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionRightInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionLineSpacing: CGFloat = Constants.SystemSizes.Cell.lineSpacing
    let collectionInteritemSpacing: CGFloat = Constants.SystemSizes.Cell.interitemSpacing
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SocialMediaAddPostCollectionViewCellViewModel.self,
                SocialMediaFeedCollectionViewCellViewModel.self]
    }
    
    init(type: CellActionType, title: String) {
        self.type = type
        self.title = title
    }
    
    
    func fetch(completion: @escaping CompletionBlock) {
        
        AuthManager.getProfile { [weak self] (viewModel) in
            var imageUrl = ""
            if let url = viewModel?.logoUrl {
                imageUrl = url
            }
            let firstCellViewModel = SocialMediaAddPostCollectionViewCellViewModel(imageUrl: imageUrl, delegate: self)
            self?.viewModels.removeAll(where: { $0 is SocialMediaAddPostCollectionViewCellViewModel })
            self?.viewModels.append(firstCellViewModel)
            completion(.success)
        } completionError: { _ in
            completion(.failure(errorType: .apiError(message: "")))
        }
        
    }
    
    
    func fetchSocialFeeds(completion: @escaping CompletionBlock) {
        
        //live
        SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: true, skip: 0, take: 1) { [weak self] (postsViewModel) in
            if let viewModel = postsViewModel, let total = postsViewModel?.total {
                let viewModel = SocialMediaFeedCollectionViewCellViewModel(title: "Live", post: )
            }
            completion(.success)
        } errorCompletion: { _ in }
        
        //hot
        SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: true, showLiked: nil, showOnlyUsersPosts: nil, skip: 0, take: 1) { [weak self] (postsViewModel) in
            if let viewModel = postsViewModel, let total = postsViewModel?.total {
            }
            completion(.success)
        } errorCompletion: { _ in }
        
        //feed
        SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: nil, skip: 0, take: 1) { [weak self] (postsViewModel) in
            if let viewModel = postsViewModel, let total = postsViewModel?.total {
            }
            completion(.success)
        } errorCompletion: { _ in }
        
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        
        switch type {
        case .addPost:
            return viewModels.first{ $0 is SocialMediaAddPostCollectionViewCellViewModel }
        case .feed:
            break
        case .media:
            break
        case .users:
            break
        }
        return nil
    }
    
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        
        let type = sections[indexPath.section]
        
        switch type {
        case .addPost:
            let spacing: CGFloat = collectionLeftInset + collectionRightInset
            return CGSize(width: frame.width - spacing, height: 50)
        case .feed:
            break
        case .media:
            break
        case .users:
            break
        }
        return .zero
    }
    
    func insetForSection(for section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionTopInset, left: collectionLeftInset, bottom: collectionBottomInset, right: collectionRightInset)
    }
    
    func minimumLineSpacing(for section: Int) -> CGFloat {
        return collectionLineSpacing
    }
    
    func minimumInteritemSpacing(for section: Int) -> CGFloat {
        return collectionInteritemSpacing
    }
    
    func numberOfRows(in section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
}

extension SocialMediaCollectionViewModel: SocialMediaAddPostCollectionViewCellProtocol {
    func shareIdeasButtonPressed() {
        
    }
}
