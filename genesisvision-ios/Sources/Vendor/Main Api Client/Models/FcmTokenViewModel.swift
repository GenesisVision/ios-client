//
// FcmTokenViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct FcmTokenViewModel: Codable {


    public var token: String

    public var platform: AppPlatform?
    public init(token: String, platform: AppPlatform? = nil) { 
        self.token = token
        self.platform = platform
    }

}
