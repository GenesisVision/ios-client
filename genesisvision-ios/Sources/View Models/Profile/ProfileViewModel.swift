//
//  ProfileViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class ProfileViewModel {
    enum SectionType {
        case profile
        case socialLinks
    }
    
    enum RowType: String {
        case avatar = ""
        case email = "Email"
        case username = "Username"
        case about = "About"
        case twitter = "Twitter"
        case telegram = "Telegram"
        case facebook = "Facebook"
        case linkedin = "LinkedIn"
        case youtube = "YouTube"
        case wechat = "WeChat"
    }
    
    // MARK: - Variables
    var title: String = "Profile"
    
    private var router: ProfileRouter!
    
    var profileModel: ProfileFullViewModel? {
        didSet {
            username = profileModel?.userName
            about = profileModel?.about
        }
    }
    var socialLinksViewModel: SocialLinksViewModel? {
        didSet {
            socialLinksViewModel?.socialLinks?.forEach({ (model) in
                if let type = model.type, let value = model.value {
                    socialLinks[type] = value
                }
            })
        }
    }
    
    var sections: [SectionType] = [.profile, .socialLinks]
    var rows: [SectionType : [RowType]] = [.profile : [.avatar, .email, .username, .about],
                                           .socialLinks : [.twitter, .telegram, .facebook, .linkedin, .youtube, .wechat, .email]]
    
    var pickedImage: UIImage?
    var pickedImageURL: URL?
    
    var username: String?
    var about: String?
    
    var avatarURL: URL? {
        guard let avatar = profileModel?.logoUrl,
            let avatarURL = getFileURL(fileName: avatar)
            else { return nil }
        
        return avatarURL
    }
    
    var socialLinks = [SocialLinkType : String]()
    
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    weak var textFieldDelegate: UITextFieldDelegate?
    weak var delegate: PhotoHeaderViewDelegate?
    
    // MARK: - Init
    init(withRouter router: ProfileRouter, profileModel: ProfileFullViewModel) {
        self.router = router
        self.profileModel = profileModel
    }
    
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetchProfile { [weak self] (result) in
            switch result {
            case .success:
                self?.fetchSocialLinks { (result) in
                    switch result {
                    case .success:
                        completion(.success)
                    default:
                        completion(result)
                    }
                }
            default:
                completion(result)
            }
        }
    }
    private func fetchProfile(completion: @escaping CompletionBlock) {
        AuthManager.getProfile(completion: { [weak self] (viewModel) in
            guard let profileModel = viewModel else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
                
            self?.profileModel = profileModel
            completion(.success)
        }, completionError: completion)
    }
    
    private func fetchSocialLinks(completion: @escaping CompletionBlock) {
        ProfileDataProvider.getSocialLinks(completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.socialLinksViewModel = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func getAvatarURL() -> URL? {
        guard let avatar = profileModel?.logoUrl,
            let avatarURL = getFileURL(fileName: avatar)
            else { return nil }
        
        return avatarURL
    }
    
    func sectionType(at indexPath: IndexPath) -> SectionType? {
        let sectionType = sections[indexPath.section]
        return sectionType
    }
    
    func rowType(at indexPath: IndexPath) -> RowType? {
        let sectionType = sections[indexPath.section]
        
        guard let rows = rows[sectionType] else { return nil }
        
        return rows[indexPath.row]
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return 60.0
        }
    }
    func headerTitle(for section: Int) -> String? {
        guard sections.count > 0 else { return nil }
        
        let type = sections[section]
        switch type {
        case .profile:
            return nil
        case .socialLinks:
            return "Social links"
        }
    }
    
    // MARK: - TableView
    func save(completion: @escaping CompletionBlock) {
        saveSocialLinks { (result) in
            print(result)
        }
        saveProfile { (result) in
            switch result {
            case .success:
                completion(.success)
            default:
                completion(result)
            }
        }
    }
    
    func saveSocialLinks(completion: @escaping CompletionBlock) {
        let links = socialLinks.map { UpdateSocialLinkViewModel(type: $0.key, value: $0.value) }
        let model = UpdateSocialLinksViewModel(links: links)
        ProfileDataProvider.updateSocialLinks(model: model, completion: completion)
    }
    
    func saveProfile(completion: @escaping CompletionBlock) {
        let model = UpdateProfileViewModel(userName: username, about: about)
        ProfileDataProvider.updateProfile(model: model, completion: completion)
    }
    
    func saveProfilePhoto(completion: @escaping CompletionBlock) {
        guard let pickedImageUrl = pickedImageURL else {
            return completion(.failure(errorType: .apiError(message: nil)))
        }
        
        BaseDataProvider.uploadImage(imageData: pickedImageUrl.dataRepresentation, imageLocation: ._default, completion: { (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            ProfileDataProvider.updateProfileAvatar(fileId: uuidString, completion: { [weak self] (result) in
                switch result {
                case .success:
                    self?.profileModel?.logoUrl = uuidString
                    completion(.success)
                case .failure(let errorType):
                    print(errorType)
                    break
                }
            })
        }, errorCompletion: completion)
    }
}
