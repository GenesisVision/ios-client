//
//  UITableViewCellExtension.swift
//  genesisvision-ios
//
//  Created by George on 22/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewCell

extension UITableViewCell {
    func addDashedBottomLine() {
        addLine(to: self, start: CGPoint(x: 16, y: 0), end: CGPoint(x: frame.size.width - 16, y: 0), style: .dashed, color: UIColor.Cell.separator)
    }
    
    func addSolidBottomLine() {
        addLine(to: self, start: CGPoint(x: 0, y: 0), end: CGPoint(x: frame.size.width, y: 0), style: .solid, color: UIColor.Cell.separator)
    }

    func willDisplay(_ transform: Bool = false, alpha: Bool = true) {
//        DispatchQueue.main.async {
//            if transform {
//                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            }
//            if alpha {
//                self.alpha = 0.0
//            }
//            UIView.animate(withDuration: 0.3) {
//                self.transform = .identity
//                self.alpha = 1.0
//            }
//        }
    }
    
    func didHighlight() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.alpha = 0.8
            self.transform = self.transform.scaledBy(x: 0.96, y: 0.96)
        }, completion: nil)
    }
    
    func didUnhighlight() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.alpha = 1
            self.transform = .identity
        }, completion: nil)
    }
}
