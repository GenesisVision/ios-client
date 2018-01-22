//
//  TemplateModelCollection.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

protocol TemplateModelCollectionDelegate: class {
    func templateModelCollectionDidUpdateData()
}

struct TemplateModelCollection<T: TemplateEntityProtocol> where T: Object {
    
    enum Content {
        case dataCollection(DataModelCollection<T>)
        case list(List<T>)
        case empty
        
        var count: Int {
            switch self {
            case let .dataCollection(model):
                return model.count
            case let .list(list):
                return list.count
            case .empty:
                return 0
            }
        }
        
        subscript(index: Int) -> T {
            switch self {
            case let .dataCollection(model):
                return model[index]
            case let .list(list):
                return list[index]
            case .empty:
                return T.templateEntity
            }
        }
    }
    
    var content: Content {
        didSet {
            delegate?.templateModelCollectionDidUpdateData()
        }
    }
    
    private var values: List<T>
    
    weak var delegate: TemplateModelCollectionDelegate?
    
    init(templatesCount: Int = 5) {
        content = Content.empty
        values = List<T>()
        generateFakeData(templatesCount: templatesCount)
    }
    
    init(dataCollection: DataModelCollection<T>, templatesCount: Int = 5) {
        content = Content.dataCollection(dataCollection)
        values = List<T>()
        generateFakeData(templatesCount: templatesCount)
    }
    
    init(list: List<T>, templatesCount: Int = 5) {
        content = Content.list(list)
        values = List<T>()
        generateFakeData(templatesCount: templatesCount)
    }
    
    private func generateFakeData(templatesCount: Int) {
        Array(repeating: T.templateEntity, count: templatesCount).forEach({
            values.append($0)
        })
    }
    
    // MARK: - Properties
    
    var count: Int {
        if isLoading && content.count == 0 {
            return values.count
        } else {
            return content.count
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            delegate?.templateModelCollectionDidUpdateData()
        }
    }
    
    // MARK: - Functionality
    
    subscript(index: Int) -> T {
        if content.count == 0 && values.count == 0 {
            assertionFailure("Content & values are empty")
        }
        return content.count == 0 ? values[index] : content[index]
    }
}
