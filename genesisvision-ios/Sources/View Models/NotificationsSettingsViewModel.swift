//
//  NotificationsSettingsViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

enum NotificationSettingsType {
    case all
    case program
    case fund
    case manager
}

final class NotificationsSettingsViewModel {
    
    // MARK: - View Model
    enum SectionType {
        case general
        case programs
        case funds
        case managers
        case custom
    }
    
    // MARK: - Variables
    var title: String = "Notifications settings"
    
    private var sections: [SectionType] = []
    
    var type: NotificationSettingsType = .all
    var assetId: String?
    
    private var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var settingsGeneralViewModels = [NotificationsSettingsGeneralTableViewCellViewModel]()
    var settingsProgramsViewModels = [NotificationsSettingsProgramTableViewCellViewModel]()
    var settingsFundsViewModels = [NotificationsSettingsFundTableViewCellViewModel]()
    var settingsManagersViewModels = [NotificationsSettingsManagerTableViewCellViewModel]()
    var settingsCustomViewModels = [NotificationsSettingsCustomTableViewCellViewModel]()
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [NotificationsSettingsCustomTableViewCellViewModel.self,
                NotificationsSettingsGeneralTableViewCellViewModel.self,
                NotificationsSettingsProgramTableViewCellViewModel.self,
                NotificationsSettingsFundTableViewCellViewModel.self,
                NotificationsSettingsManagerTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Init
    init(withRouter router: Router, notificationSettingList: NotificationSettingList? = nil, reloadDataProtocol: ReloadDataProtocol?, type: NotificationSettingsType, assetId: String? = nil, title: String = "Notifications settings") {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        self.type = type
        self.assetId = assetId
        self.title = title
        
        guard let notificationSettingList = notificationSettingList else { return }
        
        setup(notificationSettingList)
    }
    
    
    // MARK: - Public methods
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        guard sections.count > 0 else { return nil }
        
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
        case .custom:
            return settingsCustomViewModels[indexPath.row]
        }
    }
    
    func removeModel(at indexPath: IndexPath) {
        guard sections.count > 0 else { return }
        
        let type = sections[indexPath.section]
        switch type {
        case .custom:
            settingsCustomViewModels.remove(at: indexPath.row)
            if settingsCustomViewModels.count == 0 {
                sections.remove(at: indexPath.section)
            }
        default:
            break
        }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func didHighlightRow(at indexPath: IndexPath) -> Bool {
        guard indexPath.section > 0 else { return false }
        guard (model(for: indexPath) as? NotificationsSettingsCustomTableViewCellViewModel) != nil else { return true }
        
        return false
    }
    
    func headerTitle(for section: Int) -> String? {
        guard sections.count > 0 else { return nil }
        
        let type = sections[section]
        switch type {
        case .general:
            return nil
        case .programs:
            return "Programs"
        case .funds:
            return "Funds"
        case .managers:
            return "Users"
        case .custom:
            return "Custom"
        }
    }
    
    func removeCustomSetting(at indexPath: IndexPath) {
        if let settingsCustomViewModel = model(for: indexPath) as? NotificationsSettingsCustomTableViewCellViewModel, let settingId = settingsCustomViewModel.setting._id?.uuidString {

            removeNotification(settingId) { [weak self] (result) in
                switch result {
                case .success:
                    self?.removeModel(at: indexPath)
                    self?.reloadDataProtocol?.didReloadData()
                case .failure(let errorType):
                    print(errorType)
                }
            }
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        guard sections.count > 0 else { return 0.0 }
        
        let type = sections[section]
        switch type {
        case .general:
            return 0.0
        default:
            return 78.0
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard sections.count > 0 else { return 0 }
        
        switch sections[section] {
        case .general:
            return settingsGeneralViewModels.count
        case .programs:
            return settingsProgramsViewModels.count
        case .funds:
            return settingsFundsViewModels.count
        case .managers:
            return settingsManagersViewModels.count
        case .custom:
            return settingsCustomViewModels.count
        }
    }
    
    func canEditRow(at indexPath: IndexPath) -> Bool {
        guard indexPath.section > 0, type != .all else {
            return false
        }
        
        return true
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard sections.count > 0 else { return }
        
        switch sections[indexPath.section] {
        case .programs:
            guard let viewModel = model(for: indexPath) as? NotificationsSettingsProgramTableViewCellViewModel, let assetId = viewModel.setting.assetId?.uuidString, let title = viewModel.setting.title else { return }
            router.showAssetNotificationsSettings(assetId, title: title, type: .program)
        case .funds:
            guard let viewModel = model(for: indexPath) as? NotificationsSettingsFundTableViewCellViewModel, let assetId = viewModel.setting.assetId?.uuidString, let title = viewModel.setting.title else { return }
            router.showAssetNotificationsSettings(assetId, title: title, type: .fund)
        case .managers:
            break
        case .custom:
            break
        default:
            break
        }
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    func createNotification() {
        if let assetId = assetId {
            router.showCreateNotification(assetId, reloadDataProtocol: self)
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        sections = []
        
        switch type {
        case .all:
            NotificationsDataProvider.getSettings(completion: { [weak self] (notificationSettingList) in
                guard let notificationSettingList = notificationSettingList else { return ErrorHandler.handleApiError(error: nil, completion: completion) }
                
                self?.setup(notificationSettingList)
                self?.reloadDataProtocol?.didReloadData()
                
                completion(.success)
                }, errorCompletion: completion)
        case .program:
            NotificationsDataProvider.getSettings(programId: assetId, completion: { [weak self] (notificationSettingList) in
                guard let notificationSettingList = notificationSettingList else { return ErrorHandler.handleApiError(error: nil, completion: completion) }
                
                self?.setup(program: notificationSettingList)
                self?.reloadDataProtocol?.didReloadData()
                
                completion(.success)
            }, errorCompletion: completion)
        case .fund:
            NotificationsDataProvider.getSettings(fundId: assetId, completion: { [weak self] (notificationSettingList) in
                guard let notificationSettingList = notificationSettingList else { return ErrorHandler.handleApiError(error: nil, completion: completion) }
                
                self?.setup(fund: notificationSettingList)
                self?.reloadDataProtocol?.didReloadData()
                
                completion(.success)
            }, errorCompletion: completion)
        case .manager:
            break
        }
    }
    
    // MARK: - Private methods
    private func setup(_ notificationSettingList: NotificationSettingList) {
        setup(generals: notificationSettingList.settingsGeneral)
        setup(programs: notificationSettingList.settingsProgram)
        setup(funds: notificationSettingList.settingsFund)
        setup(managers: notificationSettingList.settingsManager)
    }
    
    private func setup(program notificationSettingList: ProgramNotificationSettingList) {
        setup(generalsProgram: notificationSettingList.settingsGeneral)
        setup(customs: notificationSettingList.settingsCustom)
    }
    
    private func setup(fund notificationSettingList: FundNotificationSettingList) {
        setup(generalsFund: notificationSettingList.settingsGeneral)
    }
    
    private func setup(customs settings: [NotificationSettingViewModel]?) {
        settingsCustomViewModels.removeAll()
        
        if let settings = settings, settings.count > 0 {
            sections.append(.custom)
            
            settings.forEach({ (setting) in
                let settingsViewModel = NotificationsSettingsCustomTableViewCellViewModel(setting: setting, settingsProtocol: self)
                settingsCustomViewModels.append(settingsViewModel)
            })
        }
    }
    
    private func setup(programs settings: [ProgramNotificationSettingList]?) {
        settingsProgramsViewModels.removeAll()
        
        if let settings = settings, settings.count > 0 {
            sections.append(.programs)
            
            settings.forEach({ (setting) in
                let settingsViewModel = NotificationsSettingsProgramTableViewCellViewModel(setting: setting)
                settingsProgramsViewModels.append(settingsViewModel)
            })
        }
    }
    
    private func setup(funds settings: [FundNotificationSettingList]?) {
        settingsFundsViewModels.removeAll()
        
        if let settings = settings, settings.count > 0 {
            sections.append(.funds)
            
            settings.forEach({ (setting) in
                let settingsViewModel = NotificationsSettingsFundTableViewCellViewModel(setting: setting)
                settingsFundsViewModels.append(settingsViewModel)
            })
        }
    }
    
    private func setup(managers settings: [ManagerNotificationSettingList]?) {
        settingsManagersViewModels.removeAll()
        
        if let settings = settings, settings.count > 0 {
            sections.append(.managers)
            
            settings.forEach({ (setting) in
                let settingsViewModel = NotificationsSettingsManagerTableViewCellViewModel(setting: setting)
                settingsManagersViewModels.append(settingsViewModel)
            })
        }
    }
    
    private func setup(generals settingsGeneral: [NotificationSettingViewModel]?) {
        sections.append(.general)
        
        settingsGeneralViewModels.removeAll()
        
        var newsAndUpdatesSetting = NotificationSettingViewModel(_id: nil, isEnabled: false, assetId: nil, managerId: nil, type: .platformNewsAndUpdates, conditionType: .empty, conditionAmount: 0)
        
        var emergencySettings = NotificationSettingViewModel(_id: nil, isEnabled: false, assetId: nil, managerId: nil, type: .platformEmergency, conditionType: .empty, conditionAmount: 0)
        
        if let settings = settingsGeneral, settings.count > 0 {
            settings.forEach({ (setting) in
                if let type = setting.type {
                    switch type {
                    case .platformNewsAndUpdates:
                        newsAndUpdatesSetting._id = setting._id
                        newsAndUpdatesSetting.isEnabled = setting.isEnabled
                    case .platformEmergency:
                        emergencySettings._id = setting._id
                        emergencySettings.isEnabled = setting.isEnabled
                    default:
                        break
                    }
                }
            })
        }
        
        let firstSettingViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: newsAndUpdatesSetting, settingsProtocol: self)
        settingsGeneralViewModels.append(firstSettingViewModel)
        
        let secondSettingsViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: emergencySettings, settingsProtocol: self)
        settingsGeneralViewModels.append(secondSettingsViewModel)
    }
    
    private func setup(generalsProgram settingsGeneral: [NotificationSettingViewModel]?) {
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return }
        
        sections.append(.general)
        
        settingsGeneralViewModels.removeAll()
        
        var programNewsAndUpdates = NotificationSettingViewModel(_id: nil, isEnabled: false, assetId: uuid, managerId: nil, type: .programNewsAndUpdates, conditionType: .empty, conditionAmount: 0)
        
        var programEndOfPeriod = NotificationSettingViewModel(_id: nil, isEnabled: false, assetId: uuid, managerId: nil, type: .programEndOfPeriod, conditionType: .empty, conditionAmount: 0)
        
        if let settings = settingsGeneral, settings.count > 0 {
            settings.forEach({ (setting) in
                if let type = setting.type {
                    switch type {
                    case .programNewsAndUpdates:
                        programNewsAndUpdates._id = setting._id
                        programNewsAndUpdates.assetId = setting.assetId
                        programNewsAndUpdates.isEnabled = setting.isEnabled
                    case .programEndOfPeriod:
                        programEndOfPeriod._id = setting._id
                        programEndOfPeriod.assetId = setting.assetId
                        programEndOfPeriod.isEnabled = setting.isEnabled
                    default:
                        break
                    }
                }
            })
        }
        
        let firstSettingViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: programNewsAndUpdates, settingsProtocol: self)
        settingsGeneralViewModels.append(firstSettingViewModel)
        
        let secondSettingsViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: programEndOfPeriod, settingsProtocol: self)
        settingsGeneralViewModels.append(secondSettingsViewModel)
    }
    
    private func removeNotification(_ settingId: String?, completion: @escaping CompletionBlock) {
        NotificationsDataProvider.removeSetting(settingId: settingId, completion: completion)
    }
    
    private func setup(generalsFund settingsGeneral: [NotificationSettingViewModel]?) {
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return }
        
        sections.append(.general)
        
        settingsGeneralViewModels.removeAll()
        
        var fundNewsAndUpdates = NotificationSettingViewModel(_id: nil, isEnabled: false, assetId: uuid, managerId: nil, type: .fundNewsAndUpdates, conditionType: .empty, conditionAmount: 0)
        
        var fundRebalancing = NotificationSettingViewModel(_id: nil, isEnabled: false, assetId: uuid, managerId: nil, type: .fundRebalancing, conditionType: .empty, conditionAmount: 0)
        
        if let settings = settingsGeneral, settings.count > 0 {
            settings.forEach({ (setting) in
                if let type = setting.type {
                    switch type {
                    case .fundNewsAndUpdates:
                        fundNewsAndUpdates._id = setting._id
                        fundNewsAndUpdates.assetId = setting.assetId
                        fundNewsAndUpdates.isEnabled = setting.isEnabled
                    case .fundRebalancing:
                        fundRebalancing._id = setting._id
                        fundRebalancing.assetId = setting.assetId
                        fundRebalancing.isEnabled = setting.isEnabled
                    default:
                        break
                    }
                }
            })
        }
        
        let firstSettingViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: fundNewsAndUpdates, settingsProtocol: self)
        settingsGeneralViewModels.append(firstSettingViewModel)
        
        let secondSettingsViewModel = NotificationsSettingsGeneralTableViewCellViewModel(setting: fundRebalancing, settingsProtocol: self)
        settingsGeneralViewModels.append(secondSettingsViewModel)
    }
}

extension NotificationsSettingsViewModel: NotificationsSettingsProtocol {
    func didAdd(type: NotificationType?) {
        router.currentController?.showProgressHUD()
        
        let type = NotificationsAPI.ModelType_addNotificationsSettings(rawValue: type?.rawValue ?? "")
        
        NotificationsDataProvider.addSetting(assetId: assetId, type: type, completion: { [weak self] (uuidString) in
            self?.router.currentController?.hideHUD()
                        
            if let uuidString = uuidString, let type = type {
                var viewModel = self?.settingsGeneralViewModels.first(where: { $0.setting.type?.rawValue == type.rawValue })
                viewModel?.setting._id = UUID(uuidString: uuidString)
            }
        }) { [weak self] (result) in
            self?.router.currentController?.hideHUD()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
                ErrorHandler.handleError(with: errorType, viewController: self?.router.currentController, hud: true)
            }
        }
    }
    
    func didChange(enable: Bool, settingId: String?) {
        router.currentController?.showProgressHUD()
        
        NotificationsDataProvider.enableSetting(settingId: settingId, enable: enable, completion: { [weak self] (result) in
            self?.router.currentController?.hideHUD()
            
            if let result = result {
                print(result)
            }
        }) { [weak self] (result) in
            self?.router.currentController?.hideHUD()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
                ErrorHandler.handleError(with: errorType, viewController: self?.router.currentController, hud: true)
            }
        }
    }
    
    func didRemove(settingId: String?) {
        router.currentController?.showProgressHUD()
        
        removeNotification(settingId) { [weak self] (result) in
            switch result {
            case .success:
                self?.router.currentController?.hideHUD()
            case .failure(let errorType):
                print(errorType)
                ErrorHandler.handleError(with: errorType, viewController: self?.router.currentController, hud: true)
            }
        }
    }
    
    func didAdd(assetId: String?, type: NotificationType?, conditionType: NotificationSettingConditionType?, conditionAmount: Double?) {
    
        router.currentController?.showProgressHUD()
        
        let type = NotificationsAPI.ModelType_addNotificationsSettings(rawValue: type?.rawValue ?? "")
        let conditionType = NotificationsAPI.ConditionType_addNotificationsSettings(rawValue: conditionType?.rawValue ?? "")
        
        NotificationsDataProvider.addSetting(assetId: assetId, type: type, conditionType: conditionType, conditionAmount: conditionAmount, completion: { [weak self] (result) in
            self?.router.currentController?.hideHUD()
            
            if let result = result {
                print(result)
            }
        }) { [weak self] (result) in
            self?.router.currentController?.hideHUD()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
                ErrorHandler.handleError(with: errorType, viewController: self?.router.currentController, hud: true)
            }
        }
    }
}

extension NotificationsSettingsViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { (result) in
            print(result)
        }
    }
}
