//
// TransactionDetailsActions.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct TransactionDetailsActions: Codable {


    public var canResend: Bool?

    public var canCancel: Bool?
    public init(canResend: Bool? = nil, canCancel: Bool? = nil) { 
        self.canResend = canResend
        self.canCancel = canCancel
    }

}
