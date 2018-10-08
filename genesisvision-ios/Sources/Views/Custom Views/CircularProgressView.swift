//
//  CircularProgressView.swift
//  genesisvision-ios
//
//  Created by George on 05/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {

    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    //MARK: Public
    public var clockwise: Bool = true
    public var lineWidth: CGFloat = 2
    public var foregroundStrokeColor: UIColor = UIColor.primary
    public var backgroundStrokeColor: UIColor = UIColor.primary.withAlphaComponent(0.2)

    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        progress = Float(progressConstant > 1
            ? 1
            : progressConstant < 0
            ? 0
            : progressConstant)
        
        foregroundLayer.strokeEnd = CGFloat(progress)

        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = 0.5
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
        }
    }


    //MARK: Private
    private var progress: Float = 0
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()

    private func drawBackgroundLayer() {
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.fillColor = nil
        self.layer.addSublayer(backgroundLayer)
    }

    private func drawForegroundLayer() {
        foregroundLayer.lineCap = kCALineCapRound
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = nil
        foregroundLayer.strokeEnd = 0.0
        self.layer.addSublayer(foregroundLayer)
    }

    private func setup() {
        drawBackgroundLayer()
        drawForegroundLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let foregroundPath = UIBezierPath(arcCenter: center, radius: center.x, startAngle: clockwise ? startAngle : endAngle, endAngle: clockwise ? endAngle : startAngle, clockwise: clockwise)
        foregroundLayer.path = foregroundPath.cgPath
        foregroundLayer.strokeColor = foregroundStrokeColor.cgColor

        let backgroundPath = UIBezierPath(arcCenter: center, radius: center.x, startAngle: CGFloat(0), endAngle: 2 * CGFloat.pi, clockwise: clockwise)
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.strokeColor = backgroundStrokeColor.cgColor
    }
}
