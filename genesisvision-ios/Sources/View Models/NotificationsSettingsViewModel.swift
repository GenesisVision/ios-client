//
//  NotificationsSettingsViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

final class NotificationsSettingsViewModel {
    
    // MARK: - View Model
    enum SectionType {
        case general
        case programs
        case funds
        case managers
    }
    
    // MARK: - Variables
    var title: String = "Notifications settings"
    
    private var sections: [SectionType] = []
    
    private var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var settingsGeneralViewModels = [NotificationsSettingsGeneralTableViewCellViewModel]()
    var settingsProgramsViewModels = [NotificationsSettingsProgramTableViewCellViewModel]()
    var settingsFundsViewModels = [NotificationsSettingsFundTableViewCellViewModel]()
    var settingsManagersViewModels = [NotificationsSettingsManagerTableViewCellViewModel]()
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [NotificationsSettingsGeneralTableViewCellViewModel.self,
                NotificationsSettingsProgramTableViewCellViewModel.self,
                NotificationsSettingsFundTableViewCellViewModel.self,
                NotificationsSettingsManagerTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: Router, notificationSettingList: NotificationSettingList? = nil, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        
        guard let notificationSettingList = notificationSettingList else { return }
        
        setup(notificationSettingList)
    }
    
    
    // MARK: - Public methods
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .general:
            return settingsGeneralViewModels[indexPath.row]
        case .programs:
            return settingsProgramsViewModels[indexPath.row]
        case .funds:
            return settingsFundsViewModels[indexPath.row]
        case .managers:
            return settingsManagersViewModels[indexPath.row]
        }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return 20.0
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .general:
            return settingsGeneralViewModels.count
        case .programs:
            return settingsProgramsViewModels.count
        case .funds:
            return settingsFundsViewModels.count
        case .managers:
            return settingsManagersViewModels.count
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .programs:
        //TODO: show program settings
            break
        case .funds:
            //TODO: show fund settings
            break
        case .managers:
            //TODO: show manager settings
            break
        default:
            break
        }
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        NotificationsDataProvider.getSettings(completion: { [weak self] (notificationSettingList) in
            guard let notificationSettingList = notificationSettingList else { return ErrorHandler.handleApiError(error: nil, completion: completion) }
            
            self?.setup(notificationSettingList)
            completion(.success)
        }, errorCompletion: completion)
    }
    
    // MARK: - Private methods
    private func setup(_ notificationSettingList: NotificationSettingList) {
        if let settings = notificationSettingList.settingsGeneral, settings.count > 0 {
            sections.append(.general)
            
            settings.forEach({ (setting) in
                let settingsViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: setting)
                settingsGeneralViewModels.append(settingsViewModel)
            })
        }
        
        if let settings = notificationSettingList.settingsProgram, settings.count > 0 {
            sections.append(.programs)
            
            settings.forEach({ (setting) in
                let settingsViewModel = NotificationsSettingsProgramTableViewCellViewModel(setting: setting)
                settingsProgramsViewModels.append(settingsViewModel)
            })
        }
        
        if let settings = notificationSettingList.settingsFund, settings.count > 0 {
            sections.append(.funds)
            
            settings.forEach({ (setting) in
                let settingsViewModel = NotificationsSettingsFundTableViewCellViewModel(setting: setting)
                settingsFundsViewModels.append(settingsViewModel)
            })
        }
        
        if let settings = notificationSettingList.settingsManager, settings.count > 0 {
            sections.append(.managers)
            
            settings.forEach({ (setting) in
                let settingsViewModel = NotificationsSettingsManagerTableViewCellViewModel(setting: setting)
                settingsManagersViewModels.append(settingsViewModel)
            })
        }
        
        reloadDataProtocol?.didReloadData()
    }
}
