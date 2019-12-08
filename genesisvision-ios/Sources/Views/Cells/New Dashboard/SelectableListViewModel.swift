//
//  BaseListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 05.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class SelectableListViewModel<T>: ListVMProtocol {
    var viewModels = [CellViewAnyModel]()
    var canPullToRefresh: Bool = false

    var items: [T] = []
    var selectedIndex: Int = 0
    var selected: T?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SelectableTableViewCellViewModel.self]
    }
    
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?, items: [T], selected: T?) {
        self.delegate = delegate
        self.items = items
        
        updateSelectedIndex()
    }
    
    func updateSelectedIndex() {
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selected = items[indexPath.row]
        
        delegate?.didSelect(.none, index: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        if isDebug {
            print(item)
        }
        let isSelected = indexPath.row == selectedIndex
        cell.configure("Test cell", selected: isSelected)

        return cell
    }
    
    func didSelect(at indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selected = items[selectedIndex]
    }
    
    func modelsCount() -> Int {
        return items.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else {
            return BaseTableViewCell()
        }

        return cell
    }
}

