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
    public var percentTextEnable: Bool = false
    public var clockwise: Bool = true
    public var lineWidth: CGFloat = 2
    public var foregroundStrokeColor: UIColor? {
        didSet {
            self.layoutSubviews()
        }
    }
    public var backgroundStrokeColor: UIColor? {
        return foregroundStrokeColor?.withAlphaComponent(0.2)
    }
//    public var backgroundStrokeColor: UIColor? {
//        didSet {
//            self.layoutSubviews()
//        }
//        get {
//
//        }
//    }

    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        guard progress != progressConstant else { return }
        
        progress = progressConstant > 1.0
            ? 1.0
            : progressConstant < 0.0
                ? 0.0
                : progressConstant
        
        let percentText = (progress * 100).rounded(toPlaces: 0).toString() + "%"
        percentLabel.text = percentText
        percentLabel.sizeToFit()
        
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
    public private(set) var progress: Double = 0
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let percentLabel: TitleLabel = {
        let percentLabel = TitleLabel()
        percentLabel.font = UIFont.getFont(.regular, size: 12.0)
        return percentLabel
    }()

    private func drawBackgroundLayer() {
        backgroundLayer.lineCap = CAShapeLayerLineCap.round
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.fillColor = nil
        self.layer.addSublayer(backgroundLayer)
    }

    private func drawForegroundLayer() {
        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = nil
        foregroundLayer.strokeEnd = 0.0
        self.layer.addSublayer(foregroundLayer)
    }
    
    private func addTextLabel() {
        self.addSubview(percentLabel)
    }

    private func setup() {
        drawBackgroundLayer()
        drawForegroundLayer()
        addTextLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        percentLabel.center = center
        percentLabel.isHidden = !percentTextEnable
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let foregroundPath = UIBezierPath(arcCenter: center, radius: center.x, startAngle: clockwise ? startAngle : endAngle, endAngle: clockwise ? endAngle : startAngle, clockwise: clockwise)
        foregroundLayer.path = foregroundPath.cgPath
        if let foregroundStrokeColor = foregroundStrokeColor {
            foregroundLayer.strokeColor = foregroundStrokeColor.cgColor
        }

        let backgroundPath = UIBezierPath(arcCenter: center, radius: center.x, startAngle: CGFloat(0), endAngle: 2 * CGFloat.pi, clockwise: clockwise)
        backgroundLayer.path = backgroundPath.cgPath
        if let backgroundStrokeColor = backgroundStrokeColor {
            backgroundLayer.strokeColor = backgroundStrokeColor.cgColor
        }
    }
}
