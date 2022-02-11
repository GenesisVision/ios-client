//
//  String+LastWord.swift
//  genesisvision-ios
//
//  Created by Gregory on 11.02.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation


extension String {
    func getLastWord(in range: NSRange, with text : String) -> String? {
        let nsString = self as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: text)
        let array = newString?.components(separatedBy: " ")
        let lastWord = array?.last
        return lastWord
    }
}
