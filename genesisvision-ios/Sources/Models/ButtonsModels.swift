//
//  ButtonsModels.swift
//  genesisvision-ios
//
//  Created by Gregory on 28.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit


struct KlineIntervalButton {
    let title: KlinesChartIntervalLabels
    let interval: BinanceKlineInterval
    var isCurrent: Bool = false
}

class ButtonWithURL : UIButton {
    var url : String?
    
    convenience init(url : String) {
        self.init()
        self.url = url
    }
}
