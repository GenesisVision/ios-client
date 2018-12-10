//
//  InRequestsDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol InRequestsDelegateManagerProtocol: class {
    func didCanceledRequest(completionResult: CompletionResult)
    func didSelectRequest(at indexPath: IndexPath)
}

final class InRequestsDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    weak var inRequestsDelegate: InRequestsDelegateManagerProtocol?
    var requestSelectable: Bool = true
    
    var inRequestsCellModelsForRegistration: [CellViewAnyModel.Type] {
        return [InRequestsTableViewCellViewModel.self]
    }
    
    var programRequests: ProgramRequests?
    
    // MARK: - Lifecycle
    override init() {
        super.init()
    }
    
    // MARK: - Private methods
    private func cancelRequest(at indexPath: IndexPath) {
        if let request = programRequests?.requests?[indexPath.row], let canCancel = request.canCancelRequest, let requestid = request.id?.uuidString, canCancel {
            ProgramRequestDataProvider.cancelRequest(requestId: requestid) { [weak self] (result) in
                self?.inRequestsDelegate?.didCanceledRequest(completionResult: result)
            }
        }
    }
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if requestSelectable {
            inRequestsDelegate?.didSelectRequest(at: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programRequests?.requests?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let programRequests = programRequests?.requests else {
            return TableViewCell()
        }
        
        let programRequest = programRequests[indexPath.row]
        let model = InRequestsTableViewCellViewModel(programRequest: programRequest)
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let programRequests = programRequests?.requests else {
            return false
        }
        
        let programRequest = programRequests[indexPath.row]
        return programRequest.canCancelRequest ?? false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cancelRowAction = UITableViewRowAction(style: .normal, title: "Cancel") { [weak self] (action, indexPath) in
            self?.cancelRequest(at: indexPath)
        }
        cancelRowAction.backgroundColor = UIColor.Cell.redTitle
        
        return [cancelRowAction]
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
