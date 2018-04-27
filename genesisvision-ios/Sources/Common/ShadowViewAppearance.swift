//
//  ShadowViewAppearance.swift
//  genesisvision-ios
//
//  Created by George on 27/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

@objc
class ShadowViewAppearance: NSObject {
  var shadowOpacity: Float
  var shadowColor: UIColor
  var shadowRadius: CGFloat

  init(shadowOpacity: Float, shadowColor: UIColor, shadowRadius: CGFloat) {
    self.shadowOpacity = shadowOpacity
    self.shadowColor = shadowColor
    self.shadowRadius = shadowRadius
  }
}
