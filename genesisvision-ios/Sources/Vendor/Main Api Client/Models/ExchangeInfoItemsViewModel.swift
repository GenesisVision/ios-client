//
// ExchangeInfoItemsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ExchangeInfoItemsViewModel: Codable {


    public var items: [ExchangeInfo]?

    public var total: Int?
    public init(items: [ExchangeInfo]? = nil, total: Int? = nil) { 
        self.items = items
        self.total = total
    }

}
