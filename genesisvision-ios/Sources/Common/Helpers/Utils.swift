//
//  Utils.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 12.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import AVFoundation

func getFileURL(fileName: String) -> URL? {
    return URL(string: Constants.Api.filePath + fileName)
}

func feedback(style: UIImpactFeedbackStyle = .light) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}

func networkActivity(show: Bool = true) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = show
}

func getPeriodLeft(endOfPeriod: Date) -> (Int, String?) {
    let seconds = endOfPeriod.interval(ofComponent: .second, fromDate: Date())

    let minutes = seconds / 60
    let hours = minutes / 60
    let days = hours / 24
    
    let periodLeftTimeString: String? = days > 0 ? "days" : hours > 0 ? "hours" : minutes > 0 ? "minutes" : seconds >= 0 ? "seconds" : nil
    let periodLeftValue: Int = days > 0 ? days : hours > 0 ? hours : minutes > 0 ? minutes : seconds >= 0 ? seconds : -1
    
    return (periodLeftValue, periodLeftTimeString)
}

func getDecimalCount(for currencyValue: String?) -> Int {
    guard let currencyValue = currencyValue,
        let currency = InvestmentProgramDetails.Currency(rawValue: currencyValue) else { return 2 }
    
    var currencyType: CurrencyType = .gvt
    
    switch currency {
    case .usd, .eur:
        currencyType = .other
    case .eth, .btc:
        currencyType = .crypto
    case .gvt:
        currencyType = .gvt
    default:
        currencyType = .other
    }
    
    return currencyType.rawValue
}

enum LineStyle {
    case solid, dashed
}

func addLine(to view: UIView, start p0: CGPoint, end p1: CGPoint, style: LineStyle, color: UIColor) {
    if let sublayers = view.layer.sublayers {
        for layer in sublayers {
            if layer.name == Constants.Keys.addedLineLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = 1.0
    shapeLayer.name = Constants.Keys.addedLineLayer
    shapeLayer.lineJoin = kCALineJoinRound
    
    if style == .dashed {
        shapeLayer.lineDashPattern = [2, 6]
    }
   
    let path = CGMutablePath()
    path.addLines(between: [p0, p1])
    shapeLayer.path = path
    view.layer.addSublayer(shapeLayer)
}

func convertToImage(with view: UIView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    defer { UIGraphicsEndImageContext() }
    if let context = UIGraphicsGetCurrentContext() {
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    return nil
}

func startTimer() -> Bool {
    switch UIDevice().type {
    case .iPhone5, .iPhone5S, .iPhone6, .iPhone6plus:
        return false
    default:
        return true
    }
}

func getVersion() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    let build = dictionary["CFBundleVersion"] as! String
    return "\(version)(\(build))"
}

func getDeviceInfo() -> String {
    var text = ""
    
    let systemVersion = UIDevice.current.systemVersion
    text.append("iOS: \(systemVersion)\n")
    print(text)
    
    let model = UIDevice.current.type.rawValue
    text.append("Device: \(model)")
    print(text)
    
    return text
}

func getFeedbackSubject() -> String {
    return "iOS Feedback " + getVersion()
}
