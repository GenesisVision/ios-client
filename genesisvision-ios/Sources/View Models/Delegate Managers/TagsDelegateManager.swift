//
//  TagsDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 08/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

protocol TagsDelegate: class {
    func didSelectTag()
}

protocol FilterTagsManager: class {
    var selectedIdxs: [Int] { get set }

    func isSelected(_ idx: Int) -> Bool
    func getSelectedValues() -> String
    func getSelectedTagValues() -> [String]
    func changeTag(at index: Int)
    func numberOfRowsInSection(_ section: Int) -> Int
    func reset()
}

extension FilterTagsManager {
    func isSelected(_ idx: Int) -> Bool {
        return selectedIdxs.contains(idx)
    }
    
    func reset() {
        selectedIdxs = []
    }
    
    func changeTag(at index: Int) {
        if let idx = selectedIdxs.firstIndex(of: index) {
            _ = selectedIdxs.remove(at: idx)
        } else {
            selectedIdxs.append(index)
        }
    }
}

class TagManager: NSObject, FilterTagsManager {
    var values: [Tag]?
    var selectedIdxs: [Int] = []
    
    override init() {
        super.init()
        
        setup()
    }
    
    private func setup() {
        PlatformManager.shared.getPlatformInfo { [weak self] (platformInfo) in
            
            guard let values = platformInfo?.assetInfo?.programInfo?.tags else { return }
            
            self?.values = values
        }
    }
    
    // MARK: - Public methods
    func numberOfRowsInSection(_ section: Int) -> Int {
        let count = values?.count
        return count ?? 0
    }
    
    func getSelectedValues() -> String {
        let result = selectedIdxs.compactMap { values?[$0].name ?? "" }
        
        return result.joined(separator: ", ")
    }
    
    func getSelectedTagValues() -> [String] {
        let result = selectedIdxs.compactMap { values?[$0].name ?? "" }
        
        return result
    }

}

class PlatformAssetManager: NSObject, FilterTagsManager {
    var values: [PlatformAsset]?
    var selectedIdxs: [Int] = []
    
    override init() {
        super.init()
        
        setup()
    }
    
    private func setup() {
        PlatformManager.shared.getPlatformInfo { [weak self] (platformInfo) in
            
            guard let values = platformInfo?.assetInfo?.fundInfo?.assets else { return }
            
            self?.values = values
        }
    }
    
    // MARK: - Public methods
    func numberOfRowsInSection(_ section: Int) -> Int {
        let count = values?.count
        return count ?? 0
    }
    
    func getSelectedValues() -> String {
        let result = selectedIdxs.compactMap { values?[$0].name ?? "" }
        
        return result.joined(separator: ", ")
    }
    
    func getSelectedTagValues() -> [String] {
        let result = selectedIdxs.compactMap { values?[$0].asset ?? "" }
        
        return result
    }
}

final class TagsDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: TagsDelegate?
    
    var manager: FilterTagsManager?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TagTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(_ filterType: FilterType) {
        super.init()
        
        switch filterType {
        case .programs:
            self.manager = TagManager()
        case .funds:
            self.manager = PlatformAssetManager()
        default:
            break
        }
    }
    
    func reset() {
        manager?.reset()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        manager?.changeTag(at: indexPath.row)
        
        delegate?.didSelectTag()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as? TagTableViewCell, let isSelected = manager?.isSelected(indexPath.row) else {
            let cell = UITableViewCell()
            return cell
        }
        
        if let manager = manager as? TagManager, let value = manager.values?[indexPath.row] {
            cell.configure(isSelected, tag: value)
        } else if let manager = manager as? PlatformAssetManager, let value = manager.values?[indexPath.row] {
            cell.configure(isSelected, asset: value)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.bg
        }
    }
}


