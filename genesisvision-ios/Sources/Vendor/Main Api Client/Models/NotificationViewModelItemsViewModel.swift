//
// NotificationViewModelItemsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct NotificationViewModelItemsViewModel: Codable {


    public var items: [NotificationViewModel]?

    public var total: Int?
    public init(items: [NotificationViewModel]? = nil, total: Int? = nil) { 
        self.items = items
        self.total = total
    }

}
