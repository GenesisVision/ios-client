//
//  BaseListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 05.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class SelectableListViewModel<T>: ViewModelWithListProtocol {
    var viewModels = [CellViewAnyModel]()
    var canPullToRefresh: Bool = false

    var items: [T] = []
    var selectedIndex: Int = 0
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SelectableTableViewCellViewModel.self]
    }
    
    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?, items: [T], selectedIndex: Int = 0) {
        self.delegate = delegate
        self.items = items
        self.selectedIndex = selectedIndex
    }
    
    func selected() -> T? {
        return items[selectedIndex]
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedIndex = indexPath.row
        
        delegate?.didSelect(.none, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else {
            return UITableViewCell()
        }

        let isSelected = indexPath.row == selectedIndex
        cell.configure("Test cell", selected: isSelected)

        return cell
    }
    
    func didSelect(at indexPath: IndexPath) {
        selectedIndex = indexPath.row
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
            let cell = BaseTableViewCell()
            cell.loaderView.stopAnimating()
            cell.contentView.backgroundColor = UIColor.BaseView.bg
            cell.backgroundColor = UIColor.BaseView.bg
            return cell
        }

        return cell
    }
    
    
}

