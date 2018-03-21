//
//  UILabelExtension.swift
//  genesisvision-ios
//
//  Created by George on 19/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

extension UILabel
{
    func addImage(image: UIImage, imageOffsetX: CGFloat,  afterLabel bolAfterLabel: Bool = false) {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = image
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        let imageOffsetY: CGFloat = attachment.image!.size.height / 2 - 2 //-5.0
        attachment.bounds = CGRect(x: imageOffsetX, y: imageOffsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)

        if (bolAfterLabel) {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        } else {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
