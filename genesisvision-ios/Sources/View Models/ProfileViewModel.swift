//
//  ProfileViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProfileViewModel {
    
    enum SectionType {
        case header
        case fields
    }
    
    // MARK: - Variables
    var title: String = isInvestorApp ? "Investor Profile" : "Manager Profile"
    
    private var router: ProfileRouter!
    private var profileEntity: ProfileEntity?
    
    var sections: [SectionType] = [.header, .fields]
    
    weak var delegate: ProfileHeaderTableViewCellDelegate?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProfileHeaderTableViewCellViewModel.self,
                ProfileFieldTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProfileRouter) {
        self.router = router
        
        NotificationCenter.default.addObserver(self, selector: #selector(signOutNotification(notification:)), name: .signOut, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .signOut, object: nil)
    }
    
    // MARK: - Public methods
    func getProfile(completion: @escaping CompletionBlock) {
        AuthManager.getProfile { [weak self] (viewModel) in
            if let profileModel = viewModel {
                self?.profileEntity = ProfileEntity()
                self?.profileEntity?.traslation(fromProfileModel: profileModel)
                completion(.success)
            }
            
            completion(.failure(reason: nil))
        }
    }
    
    // MARK: - TableView
    /// Return view models for registration cell Nib files
    func registerNibs() -> [CellViewAnyModel.Type] {
        return [WalletHeaderTableViewCellViewModel.self,
                WalletTransactionTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header Nib files
    func registerHeaderNibs() -> [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    func numberOfSections() -> Int {
        return profileEntity != nil ? sections.count : 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 1
        case .fields:
            return profileEntity?.getFields().count ?? 0
        }
    }
    
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return ProfileHeaderTableViewCellViewModel(profileEntity: profileEntity ?? ProfileEntity.templateEntity, editable: false, delegate: delegate)
        case .fields:
            if let fields = profileEntity?.getFields() {
                let keys = Array(fields.keys)
                let placeholder = keys[indexPath.row]
                let value = fields[placeholder]
                
                let viewModel = ProfileFieldTableViewCellViewModel(text: value ?? "", placeholder: placeholder.capitalized, editable: false)
                
                return viewModel
            }
            
            return ProfileFieldTableViewCellViewModel(text: "", placeholder: "", editable: false)
        }
    }
    
    // MARK: - Navigation
    func editProfile() {

    }
    
    func signOut() {
        AuthManager.authorizedToken = nil
        router.show(routeType: .signOut)
    }
    
    @objc private func signOutNotification(notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .signOut, object: nil)
        signOut()
    }
}
