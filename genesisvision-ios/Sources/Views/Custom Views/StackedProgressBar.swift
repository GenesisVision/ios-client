//
//  StackedProgressBar.swift
//  genesisvision-ios
//
//  Created by George on 06/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class StackedProgressView: UIView {
    private var freeView: UIView!
    private var investedView: UIView!
    private var requestsView: UIView!
    
    private var totalValue: Double = 1.0
    private var investedValue: Double = 0.0
    private var requestsValue: Double = 0.0
    
    private var progressInvestedColor = UIColor.Font.dark
    private var progressRequestsColor = UIColor.Font.amountPlaceholder
    private var bgColor = UIColor.Font.primary
    
    func setup(totalValue: Double, investedValue: Double, requestsValue: Double) {
        self.totalValue = totalValue
        self.investedValue = investedValue
        self.requestsValue = requestsValue
        
        let width: Double = Double(frame.width)
        let height: Double = Double(frame.height)
        
        let tokenWidth = width / totalValue
        let investedProgressWidth = tokenWidth * investedValue
        let requestsProgressWidth = investedProgressWidth + tokenWidth * requestsValue
        
        investedView?.frame = CGRect(x: 0.0, y: 0.0, width: investedProgressWidth, height: height)
        requestsView?.frame = CGRect(x: 0.0, y: 0.0, width: requestsProgressWidth, height: height)
    }
    
    override func layoutSubviews() {
        self.backgroundColor = .clear
        
        let width: Double = Double(frame.width)
        let height: Double = Double(frame.height)

        let tokenWidth = width / totalValue
        let investedProgressWidth = tokenWidth * investedValue
        let requestsProgressWidth = investedProgressWidth + tokenWidth * requestsValue

        investedView?.frame = CGRect(x: 0.0, y: 0.0, width: investedProgressWidth, height: height)
        requestsView?.frame = CGRect(x: 0.0, y: 0.0, width: requestsProgressWidth, height: height)
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
        
        freeView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height))
        freeView?.backgroundColor = .clear
        freeView?.layer.backgroundColor = bgColor.cgColor
        freeView?.layer.cornerRadius = frame.height / 2
        freeView.clipsToBounds = true
        addSubview(freeView)
        
        requestsView = UIView(frame: CGRect.zero)
        requestsView?.backgroundColor = .clear
        requestsView?.layer.backgroundColor = progressRequestsColor.cgColor
        requestsView?.layer.cornerRadius = frame.height / 2
        requestsView.clipsToBounds = true
        addSubview(requestsView)
        
        investedView = UIView(frame: CGRect.zero)
        investedView?.backgroundColor = .clear
        investedView?.layer.backgroundColor = progressInvestedColor.cgColor
        investedView?.layer.cornerRadius = frame.height / 2
        investedView.clipsToBounds = true
        addSubview(investedView)
    }
}
