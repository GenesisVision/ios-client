//
//  ManagerInfoViewModel.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class ManagerInfoViewModel {
    enum SectionType {
        case details
    }
    enum RowType {
        case header
        case info
        case about
    }
    
    // MARK: - Variables
    var title: String = "Info"
    
    private var router: Router
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var managerId: String!
    
    public private(set) var publicProfile: PublicProfile?

    private var sections: [SectionType] = [.details]
    private var rows: [RowType] = [.header, .info, .about]
    
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DefaultTableViewCellViewModel.self, ManagerTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: Router,
         managerId: String? = nil,
         reloadDataProtocol: ReloadDataProtocol? = nil) {
        self.router = router
        
        if let managerId = managerId {
            self.managerId = managerId
        }
        
        self.reloadDataProtocol = reloadDataProtocol
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
            return 30.0
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
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard let publicProfile = publicProfile else {
            return nil
        }
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .details:
            let rowType = rows[indexPath.row]
            switch rowType {
            case .header:
                return ManagerTableViewCellViewModel(profile: publicProfile, selectable: false)
            case .info:
                guard let assets = publicProfile.assets else { return nil }
                return  DefaultTableViewCellViewModel(title: "Assets", subtitle: assets.joined(separator: " | "))
            case .about:
                guard let about = publicProfile.about else { return nil }
                return DefaultTableViewCellViewModel(title: "About", subtitle: about)
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
        self.reloadDataProtocol?.didReloadData()
    }
}

extension ManagerInfoViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
    }
}
