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
    
    enum RowType {
        case news
        case emergency
    }
    
    // MARK: - Variables
    var title: String = "Notifications settings"
    
    private var sections: [SectionType] = []
    
    private var generalRows: [RowType] = []
    
    private var router: Router!
    
    var settingsGeneralViewModels = [CellViewAnyModel]()
    var settingsProgramsViewModels = [NotificationsSettingsProgramTableViewCellViewModel]()
    var settingsFundsViewModels = [NotificationsSettingsFundTableViewCellViewModel]()
    var settingsManagersViewModels = [NotificationsSettingsManagerTableViewCellViewModel]()
    
    var assetType: AssetType = .program
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [NotificationsSettingsProgramTableViewCellViewModel.self,
                NotificationsSettingsFundTableViewCellViewModel.self,
                NotificationsSettingsManagerTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: Router, notificationSettingList: NotificationSettingList?) {
        self.router = router
        
        guard let notificationSettingList = notificationSettingList else { return }
        
        setup(notificationSettingList)
    }
    
    
    // MARK: - Public methods
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel {
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
    
    func getRowType(for indexPath: IndexPath) -> RowType {
        let type = sections[indexPath.section]
        switch type {
        case .general:
            return generalRows[indexPath.row]
        default:
            return .news
        }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .general:
            return generalRows.count
        case .programs:
            return settingsProgramsViewModels.count
        case .funds:
            return settingsFundsViewModels.count
        case .managers:
            return settingsManagersViewModels.count
        }
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    // MARK: - Private methods
    private func setup(_ notificationSettingList: NotificationSettingList) {
        var tableViewCellViewModel: CellViewAnyModel?
        
        if notificationSettingList.settingsGeneral != nil {
            sections.append(.general)
            generalRows = [.news, .emergency]
        }
        
        if let settings = notificationSettingList.settingsProgram {
            sections.append(.programs)
            
            for setting in settings {
                let settingsViewModel = NotificationsSettingsProgramTableViewCellViewModel(setting: setting)
                settingsProgramsViewModels.append(settingsViewModel)
            }
        }
        
        if let settings = notificationSettingList.settingsFund {
            sections.append(.funds)
            
            for setting in settings {
                let settingsViewModel = NotificationsSettingsFundTableViewCellViewModel(setting: setting)
                settingsFundsViewModels.append(settingsViewModel)
            }
        }
        
        if let settings = notificationSettingList.settingsManager {
            sections.append(.managers)
            
            for setting in settings {
                let settingsViewModel = NotificationsSettingsManagerTableViewCellViewModel(setting: setting)
                settingsManagersViewModels.append(settingsViewModel)
            }
        }
    }
}
