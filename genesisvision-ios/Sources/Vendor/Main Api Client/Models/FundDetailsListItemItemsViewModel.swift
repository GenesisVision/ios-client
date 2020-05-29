//
// FundDetailsListItemItemsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct FundDetailsListItemItemsViewModel: Codable {


    public var items: [FundDetailsListItem]?

    public var total: Int?
    public init(items: [FundDetailsListItem]? = nil, total: Int? = nil) { 
        self.items = items
        self.total = total
    }

}
