//
// MediaPostItemsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct MediaPostItemsViewModel: Codable {


    public var items: [MediaPost]?

    public var total: Int?
    public init(items: [MediaPost]? = nil, total: Int? = nil) { 
        self.items = items
        self.total = total
    }

}