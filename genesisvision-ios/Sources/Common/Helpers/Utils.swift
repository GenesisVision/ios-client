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
    
    if fileName.contains("https://") {
        return URL(string: fileName)
    } else {
        return URL(string: ApiKeys.filePath + fileName)
    }
}

func isPictureURL(url: String) -> Bool {
    if !url.isEmpty, (url.contains(".png") || url.contains(".jpg")) {
        return true
    } else {
        return false
    }
}

func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}

func notificationFeedback(style: UINotificationFeedbackGenerator.FeedbackType = .success) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(style)
}

func networkActivity(show: Bool = true) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = show
}

func getPeriodLeft(endOfPeriod: Date) -> (Int, String?) {
    let seconds = endOfPeriod.interval(ofComponent: .second, fromDate: Date())

    let minutes = seconds / 60
    let hours = minutes / 60
    let days = hours / 24
    
    let periodLeftTimeString: String? = days > 0 ? "days" : hours > 0 ? "hours" : minutes > 0 ? "min" : seconds >= 0 ? "sec" : nil
    let periodLeftValue: Int = days > 0 ? days : hours > 0 ? hours : minutes > 0 ? minutes : seconds >= 0 ? seconds : -1
    
    return (periodLeftValue, periodLeftTimeString)
}

func getPeriodDuration(from minutes: Int) -> String? {
    let hours = minutes / 60
    let days = hours / 24
    let weeks = days / 7
    let months = days / 31
    
    let periodLeftTimeString: String = months > 0 ? "m" : weeks > 0 ? "w" : days > 0 ? "d" : hours > 0 ? "h" : minutes > 0 ? "min" : ""
    let periodLeftValue: Int = months > 0 ? months : weeks > 0 ? weeks : days > 0 ? days : hours > 0 ? hours : minutes > 0 ? minutes : -1
    
    return periodLeftValue > 0 ? "\(periodLeftValue) " + periodLeftTimeString : nil
}

func getDecimalCount(for currencyType: CurrencyType?) -> Int {
    guard let currencyType = currencyType else { return 2 }

    return currencyType.currencyLenght
}

enum LineStyle {
    case solid, dashed
}

func getChangePercent(oldValue: Double, newValue: Double) -> String {
    let percentText = oldValue > 0.0 ? (Double(newValue - oldValue) / oldValue * 100.0).rounded(with: .undefined).toString() : "∞"
    return percentText + "%"
    
}

func getChangePercent(oldValue: Double, newValue: Double) -> Double {
    let percent = oldValue > 0.0 ? Double(newValue - oldValue) / oldValue * 100.0 : 0.0
    return percent
}

func addLine(to view: UIView, start p0: CGPoint, end p1: CGPoint, style: LineStyle, color: UIColor) {
    if let sublayers = view.layer.sublayers {
        for layer in sublayers {
            if layer.name == Keys.addedLineLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = 1.0
    shapeLayer.name = Keys.addedLineLayer
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    
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
    return "\(version)"
}

func getBuild() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let build = dictionary["CFBundleVersion"] as! String
    return "\(build)"
}

func getFullVersion() -> String {
    return "\(getVersion())(\(getBuild()))"
}

func getDeviceInfo() -> String {
    var text = ""
    
    let systemVersion = UIDevice.current.systemVersion
    text.append("iOS: \(systemVersion)\n")
    
    let model = UIDevice.current.type.rawValue
    text.append("Device: \(model)")
    
    return text
}

func getFeedbackSubject() -> String {
    return "iOS Feedback " + getFullVersion()
}

func newVersionIsAvailable(_ lastVersion: String) -> Bool {
    if let skipThisVersion = UserDefaults.standard.object(forKey: UserDefaultKeys.skipThisVersion) as? String, skipThisVersion == lastVersion {
        print("SkipThisVersion: \(skipThisVersion)")
        return false
    }
    
    let currentVersionArray = getVersion().components(separatedBy: ".")
    let lastVersionArray = lastVersion.components(separatedBy: ".")
    
    return versionIsOld(currentVersionArray: currentVersionArray, lastVersionArray: lastVersionArray, idx: 0)
}

func versionIsOld(currentVersionArray: [String], lastVersionArray: [String], idx: Int) -> Bool {
    guard idx < 3, let currentIntVal = Int(currentVersionArray[idx]), let lastIntVal = Int(lastVersionArray[idx]) else { return false }
    
    if currentIntVal == lastIntVal {
        return versionIsOld(currentVersionArray: currentVersionArray, lastVersionArray: lastVersionArray, idx: idx + 1)
    } else {
        return currentIntVal < lastIntVal
    }
}

func showNewVersionAlertIfNeeded(_ viewController: UIViewController) {
    PlatformManager.shared.getPlatformInfo(completion: { (model) in
        guard let platformInfo = model,
            let iOSVersion = platformInfo.appVersionInfo?.iOS,
            let lastVersion = iOSVersion.lastVersion,
            newVersionIsAvailable(lastVersion) else { return }
        
        viewController.showNewVersionAlert(lastVersion)
    })
}

func showTwoFactorEnableAlertIfNeeded(_ viewController: UIViewController, completion: @escaping (_ enable: Bool) -> Void) {
    AuthManager.getTwoFactorStatus(completion: { (model) in
        let launchedBefore = UserDefaults.standard.bool(forKey: UserDefaultKeys.launchedBefore)
        
        guard let twoFactorEnabled = model.twoFactorEnabled, !twoFactorEnabled, !launchedBefore else { return completion(false) }
        
        print("First launch")
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.launchedBefore)
        
        viewController.showTwoFactorEnableAlert(completion: completion)
    }) { (result) in
        switch result {
        case .success:
            break
        case .failure(let errorType):
            ErrorHandler.handleError(with: errorType)
        }
    }
}

var selectedPlatformCurrency: String {
    get {
        guard let currency = UserDefaults.standard.string(forKey: UserDefaultKeys.selectedCurrency) else {
            UserDefaults.standard.set(CurrencyType.usdt.rawValue, forKey: UserDefaultKeys.selectedCurrency)
            return CurrencyType.usdt.rawValue
        }
        
        return currency
    }
    set {
        UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.selectedCurrency)
    }
}

func getPlatformCurrencyType() -> Currency {
    if let currency = Currency(rawValue: selectedPlatformCurrency) {
        return currency
    }
    
    return .usdt
}

