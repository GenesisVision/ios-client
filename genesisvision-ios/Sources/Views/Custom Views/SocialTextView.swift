//
//  SocialTextView.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 06.12.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialTextViewDelegate: AnyObject {
    func wordRecognized(word: String)
}

class SocialTextView: UITextView {
    
    weak var wordRecognizerDelegate: SocialTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func replaceTagsInText(tags: [PostTag]) {
        guard let text = text, let font = font else { return }
        
        var newText = text
        
        for tag in tags {
            if let tagTitle = tag.title, let tagNumber = tag.number {
                let tagString = "@tag-\(tagNumber.toString())"
                newText = newText.replacingOccurrences(of: tagString, with: tagTitle)
                }
            }
        
        let muttableText = NSMutableAttributedString(string: newText,
                                                     attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white])
        
        for tag in tags {
            if let tagTitle = tag.title {
                let range = (newText as NSString).range(of: tagTitle)
                muttableText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.primary, range: range)
            }
        }
        
        let regex = try! NSRegularExpression(pattern: "#\\w.*?\\b",options: .caseInsensitive)
        for match in regex.matches(in: newText, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: newText.count)) as [NSTextCheckingResult] {
            muttableText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.primary, range: match.range)
        }
        
        attributedText = muttableText
        setupGesturerecognizer()
    }
    
    private func setup() {
        setupGesturerecognizer()
    }
    func setupGesturerecognizer() {
        let tapTextViewGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
        addGestureRecognizer(tapTextViewGesture)
    }
    
    @objc func textViewDidTapped(recognizer: UITapGestureRecognizer) {
        
        guard let myTextView = recognizer.view as? UITextView else { return }
        
        var location = recognizer.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left
        location.y -= myTextView.textContainerInset.top
        
        guard let tapPosition = closestPosition(to: location),
              let wordTextRange = tokenizer.rangeEnclosingPosition(tapPosition, with: .word, inDirection: UITextDirection(rawValue: 1)),
              let sentenceTextRange = tokenizer.rangeEnclosingPosition(tapPosition, with: .sentence, inDirection: UITextDirection(rawValue: 1)) else { return }
        let tappedWord: String = text(in: wordTextRange) ?? ""
        
        let tappedSentence: String = text(in: sentenceTextRange) ?? ""
        let words = tappedSentence.components(separatedBy: .whitespaces)
        
        if let tappedWordFull = words.first(where: { word in
            return tappedWord == word || word.contains(tappedWord)
        }) {
            wordRecognizerDelegate?.wordRecognized(word: tappedWordFull)
        }
    }
}
