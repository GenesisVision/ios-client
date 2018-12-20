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
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
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
    
    func headerTitle(for section: Int) -> String? {
        let type = sections[section]
        switch type {
        case .general:
            return nil
        case .programs:
            return "Programs"
        case .funds:
            return "Funds"
        case .managers:
            return "Managers"
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        let type = sections[section]
        switch type {
        case .general:
            return 0.0
        default:
            return 78.0
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
            router.showNotificationList()
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
        sections = [.general]
        
        settingsGeneralViewModels.removeAll()
        settingsProgramsViewModels.removeAll()
        settingsFundsViewModels.removeAll()
        settingsManagersViewModels.removeAll()
        
        let newsAndUpdatesSetting = NotificationSettingViewModel(id: nil, isEnabled: false, assetId: nil, managerId: nil, type: NotificationSettingViewModel.ModelType.platformNewsAndUpdates, conditionType: NotificationSettingViewModel.ConditionType.empty, conditionAmount: 0)
        
        let emergencySettings = NotificationSettingViewModel(id: nil, isEnabled: false, assetId: nil, managerId: nil, type: NotificationSettingViewModel.ModelType.platformEmergency, conditionType: NotificationSettingViewModel.ConditionType.empty, conditionAmount: 0)
        
        if let settings = notificationSettingList.settingsGeneral, settings.count > 0 {
            settings.forEach({ (setting) in
                if let type = setting.type {
                    switch type {
                    case .platformNewsAndUpdates:
                        newsAndUpdatesSetting.id = setting.id
                        newsAndUpdatesSetting.isEnabled = setting.isEnabled
                    case .platformEmergency:
                        emergencySettings.id = setting.id
                        emergencySettings.isEnabled = setting.isEnabled
                    default:
                        break
                    }
                }
            })
        }
        
        let newsAndUpdatesSettingViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: newsAndUpdatesSetting, settingsProtocol: self)
        settingsGeneralViewModels.append(newsAndUpdatesSettingViewModel)
        
        let emergencySettingsViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: emergencySettings, settingsProtocol: self)
        settingsGeneralViewModels.append(emergencySettingsViewModel)
        
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

extension NotificationsSettingsViewModel: NotificationsSettingsProtocol {
    func didAdd(type: NotificationSettingViewModel.ModelType?) {

        let type = NotificationsAPI.ModelType_v10NotificationsSettingsAddPost(rawValue: type?.rawValue ?? "")
        
        NotificationsDataProvider.addSetting(type: type, completion: { [weak self] (uuidString) in
            if let uuidString = uuidString, let type = type {
                switch type {
                case .platformNewsAndUpdates:
                    self?.settingsGeneralViewModels.first?.setting.id = UUID(uuidString: uuidString)
                case .platformEmergency:
                    self?.settingsGeneralViewModels.last?.setting.id = UUID(uuidString: uuidString)
                default:
                    break
                }
            }
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
            }
        }
    }
    
    func didChange(enable: Bool, settingId: String?) {
        NotificationsDataProvider.enableSetting(settingId: settingId, enable: enable, completion: { (result) in
            if let result = result {
                print(result)
            }
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
            }
        }
    }
    
    func didRemove(settingId: String?) {
        NotificationsDataProvider.removeSetting(settingId: settingId) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
            }
        }
    }
    
    func didAdd(assetId: String?, type: NotificationSettingViewModel.ModelType?, conditionType: NotificationSettingViewModel.ConditionType?, conditionAmount: Double?) {
        
        let type = NotificationsAPI.ModelType_v10NotificationsSettingsAddPost(rawValue: type?.rawValue ?? "")
        let conditionType = NotificationsAPI.ConditionType_v10NotificationsSettingsAddPost(rawValue: conditionType?.rawValue ?? "")
        
        NotificationsDataProvider.addSetting(assetId: assetId, type: type, conditionType: conditionType, conditionAmount: conditionAmount, completion: { (result) in
            if let result = result {
                print(result)
            }
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
            }
        }
    }
}
