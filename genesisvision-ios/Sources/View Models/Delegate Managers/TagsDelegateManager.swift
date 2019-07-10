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

class TagsManager: NSObject {
    
    var selectedIdxs: [Int] = []
    
    var values: [ProgramTag]?
    
    override init() {
        super.init()
        
        setup()
    }
    
    private func setup() {
        PlatformManager.shared.getPlatformInfo { [weak self] (platformInfo) in
            guard let tags = platformInfo?.enums?.program?.programTags else { return }
            self?.values = tags
        }
    }
    
    // MARK: - Public methods
    func isSelected(_ idx: Int) -> Bool {
        return selectedIdxs.contains(idx)
    }
    
    func getSelectedValues() -> String {
        let result = selectedIdxs.compactMap { values?[$0].name ?? "" }

        return result.joined(separator: ", ")
    }
    
    func getSelectedTagValues() -> [String] {
        let result = selectedIdxs.compactMap { values?[$0].name ?? "" }
        
        return result
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

final class TagsDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: TagsDelegate?
    
    var manager: TagsManager?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TagTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(_ manager: TagsManager) {
        super.init()
        
        self.manager = manager
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
        return manager?.values?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as? TagTableViewCell, let tag = manager?.values?[indexPath.row], let isSelected = manager?.isSelected(indexPath.row) else {
            let cell = UITableViewCell()
            return cell
        }
        
        cell.configure(tag: tag, selected: isSelected)
        
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


