//
// BasePlatformAssetItemsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BasePlatformAssetItemsViewModel: Codable {


    public var items: [BasePlatformAsset]?

    public var total: Int?
    public init(items: [BasePlatformAsset]? = nil, total: Int? = nil) { 
        self.items = items
        self.total = total
    }

}
