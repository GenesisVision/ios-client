//
//  ManagerInfoViewModel.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class ManagerInfoViewModel: ViewModelWithListProtocol {
    enum SectionType {
        case details
    }
    enum RowType {
        case header
        case info
        case social
        case about
    }
    
    // MARK: - Variables
    var title: String = "Info"
    
    var canPullToRefresh: Bool = true
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    private var router: Router
    
    var managerId: String!
    
    public private(set) var publicProfile: PublicProfile? {
        didSet {
            if let isEmpty = publicProfile?.assets?.isEmpty, !isEmpty, !rows.contains(.info) {
                rows.insert(.info, at: 1)
            }
            
            if let isEmpty = publicProfile?.about?.isEmpty, !isEmpty, !rows.contains(.about) {
                rows.append(.about)
            }
        }
    }

    private var sections: [SectionType] = [.details]
    private var rows: [RowType] = [.header, .social]
    
    
    var viewModels: [CellViewAnyModel] = []
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DefaultTableViewCellViewModel.self,
                SocialInfoLinksTableViewCellViewModel.self,
                ManagerTableViewCellViewModel.self,
                ManagerSocialTableViewCellViewModel.self]
    }
    weak var delegate: BaseTableViewProtocol?
    // MARK: - Init
    init(withRouter router: Router,
         managerId: String? = nil,
         delegate: BaseTableViewProtocol? = nil) {
        self.router = router
        
        if let managerId = managerId {
            self.managerId = managerId
        }
        
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return Constants.headerHeight
        }
    }
    
    func numberOfSections() -> Int {
        guard publicProfile != nil else {
            return 0
        }
        
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let sectionType = sections[section]
        
        switch sectionType {
        case .details:
            return rows.count
        }
    }
}

// MARK: - Navigation
extension ManagerInfoViewModel {
    // MARK: - Public methods
}

// MARK: - Fetch
extension ManagerInfoViewModel {
    // MARK: - Public methods
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        guard let publicProfile = publicProfile else {
            return nil
        }
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .details:
            let rowType = rows[indexPath.row]
            switch rowType {
            case .header:
                return ManagerTableViewCellViewModel(profile: publicProfile, selectable: false, delegate: self)
            case .info:
                guard let socialLinks = publicProfile.socialLinks else { return nil }
                return SocialInfoLinksTableViewCellViewModel(socialLinks: socialLinks, delegate: self)
            case .about:
                guard let about = publicProfile.about else { return nil }
                return DefaultTableViewCellViewModel(title: "About", subtitle: about)
            case .social:
                guard let followersCount = publicProfile.followers, let followingCount = publicProfile.following else { return nil }
                return ManagerSocialTableViewCellViewModel(followersCount: followersCount, followingCount: followingCount, delegate: self)
            }
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        UsersDataProvider.get(with: self.managerId, completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.publicProfile = viewModel
            
            completion(.success)
            }, errorCompletion: completion)
    }
    
    func updateDetails(with publicProfile: PublicProfile) {
        self.publicProfile = publicProfile
        self.delegate?.didReload()
    }
}

extension ManagerInfoViewModel: ManagerSocialTableViewCellDelegate {
    func followersTapped() {
        guard let userId = publicProfile?._id, let followers = publicProfile?.followers, followers > 0 else { return }
        router.showFollowersList(with: userId)
    }
    
    func followingTapped() {
        guard let userId = publicProfile?._id, let following = publicProfile?.following, following > 0 else { return  }
        router.showFollowingList(with: userId)
    }
}

extension ManagerInfoViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.delegate?.didReload()
        }
    }
}


extension ManagerInfoViewModel: SocialInfoLinksTableViewCellDelegate {
    func socialLinkPressed(link: String) {
        router.showSafari(with: link)
    }
}

extension ManagerInfoViewModel: DetailManagerTableViewCellDelegate {
    func followPressed(userId: UUID, followed: Bool) {
        followed ?
            SocialDataProvider.unfollow(userId: userId, completion: { _ in })
            : SocialDataProvider.follow(userId: userId, completion: { _ in })
    }
}
