//
// FollowDetailsListItemItemsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct FollowDetailsListItemItemsViewModel: Codable {


    public var items: [FollowDetailsListItem]?

    public var total: Int?
    public init(items: [FollowDetailsListItem]? = nil, total: Int? = nil) { 
        self.items = items
        self.total = total
    }

}
