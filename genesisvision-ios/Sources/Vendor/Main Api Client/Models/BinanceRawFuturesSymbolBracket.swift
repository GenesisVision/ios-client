//
// BinanceRawFuturesSymbolBracket.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawFuturesSymbolBracket: Codable {


    public var symbolOrPair: String?

    public var brackets: [BinanceRawFuturesBracket]?
    public init(symbolOrPair: String? = nil, brackets: [BinanceRawFuturesBracket]? = nil) { 
        self.symbolOrPair = symbolOrPair
        self.brackets = brackets
    }

}
