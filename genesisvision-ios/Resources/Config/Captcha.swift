//
//  Captcha.swift
//  genesisvision-ios
//
//  Created by George on 16/04/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import Foundation
import CommonCrypto

func captcha_hash(_ route: String, nonce: String, difficulty: Int, completion: (_ sha: String) -> Void) {
    var prefix = 0
    
    let zerosCounts = Array(repeating: "0", count: difficulty)
    let fCounts = Array(repeating: "f", count: 64 - difficulty)
    let diffSting = (zerosCounts as NSArray).componentsJoined(by: "") + (fCounts as NSArray).componentsJoined(by: "")
    
    let start = Date()
    
    while true {
        let sha = prefix.toString() + nonce + route
        let shaHash = sha.sha256()
        
        if shaHash.compare(diffSting, options: .literal) == .orderedAscending {
            let time = Date().timeIntervalSince(start)
            print("\(Int(time)) seconds")
            return completion(prefix.toString())
        }
        
        prefix += 1
    }
}

extension String {
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}
