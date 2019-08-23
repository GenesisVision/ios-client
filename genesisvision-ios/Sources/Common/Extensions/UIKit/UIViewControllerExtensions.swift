//
//  UIViewControllerExtensions.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import SafariServices
import UIKit.UIViewController
import PKHUD

extension UIViewController {
    private class func mainStoryboardInstancePrivate<T: UIViewController>(_ name: String) -> T? {
        let storyboard = UIStoryboard(name: name, bundle: nil)

        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T
    }
    
    class func storyboardInstance(_ name: StoryboardNames) -> Self? {
        return mainStoryboardInstancePrivate(name.rawValue.capitalized)
    }
    
    
    // MARK: - Alerts
    func showAlertWithTitle(_ style: UIAlertController.Style = .alert, title: String?, message: String, actionTitle: String?, cancelTitle: String?, handler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.view.tintColor = UIColor.Cell.headerBg
        
        if actionTitle != nil {
            let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
                if handler != nil {
                    handler!()
                }
            }
            alert.addAction(action)
        }
        
        if cancelTitle != nil {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (UIAlertAction) in
                if cancelHandler != nil {
                    cancelHandler!()
                }
            }
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showSettingsAlert(_ message: String) {
        let alert = UIAlertController(title: String.Alerts.PrivacySettings.alertTitle, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.Cell.headerBg
        alert.addAction(UIAlertAction(title: String.Alerts.PrivacySettings.settingsButtonText, style: .default, handler: { [weak self] (_ action: UIAlertAction) -> Void in
            self?.openUrl(with: UIApplication.openSettingsURLString)
        }))
        alert.addAction(UIAlertAction(title: String.Alerts.cancelButtonText, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showNewVersionAlert(_ newVersion: String) {
        let message = String.Alerts.NewVersionUpdate.alertMessage + "\(newVersion)"
        let alert = UIAlertController(title: String.Alerts.NewVersionUpdate.alertTitle, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.Cell.headerBg
        alert.addAction(UIAlertAction(title: String.Alerts.NewVersionUpdate.updateButtonText, style: .default, handler: { [weak self] (_ action: UIAlertAction) -> Void in
            self?.openUrl(with: Urls.appStoreAddress)
        }))
        
        alert.addAction(UIAlertAction(title: String.Alerts.NewVersionUpdate.skipThisVersionButtonText, style: .default, handler: { (_ action: UIAlertAction) -> Void in
            DispatchQueue.main.async {
                print("Skip this version: " + newVersion)
                UserDefaults.standard.set(newVersion, forKey: UserDefaultKeys.skipThisVersion)
                UserDefaults.standard.synchronize()
            }
        }))
        
        alert.addAction(UIAlertAction(title: String.Alerts.cancelButtonText, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showTwoFactorEnableAlert(completion: @escaping (_ enable: Bool) -> Void) {
        let message = String.Alerts.TwoFactorEnable.alertMessage
        let alertController = UIAlertController(title: String.Alerts.TwoFactorEnable.alertTitle, message: message, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.Cell.headerBg
        
        alertController.addAction(UIAlertAction(title: String.Alerts.TwoFactorEnable.enableButtonText, style: .default, handler: { (_ action: UIAlertAction) -> Void in
            NotificationCenter.default.post(name: .twoFactorEnable, object: nil)
            completion(true)
        }))
        
        alertController.addAction(UIAlertAction(title: String.Alerts.TwoFactorEnable.cancelButtonText, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithDelay(text: String?, delay: Double, didShowed: (() -> Swift.Void)?) {
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.Cell.headerBg
        
        present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            alertController.dismiss(animated: true, completion: {
                if didShowed != nil {
                    didShowed!()
                }
            })
        }
    }
    
    func openUrl(with urlAddress: String) {
        if let url = URL(string: urlAddress), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    // MARK: - PKHUD
    func showTooltipHUD(withText text: String = "") {
        showAlertWithTitle(title: "", message: text, actionTitle: String.Alerts.okButtonText, cancelTitle: nil, handler: nil, cancelHandler: nil)
    }
    
    func showProgressHUD(onView: UIView? = nil) {
        self.view.showProgressHUD(onView: onView)
    }

    func hideHUD() {
        self.view.hideHUD()
    }
    
    func showErrorHUD(subtitle: String? = nil) {
        self.view.showErrorHUD(subtitle: subtitle)
    }
    
    func showSuccessHUD(title: String? = nil, subtitle: String? = nil, completion: ((Bool) -> Void)? = nil) {
        self.view.showSuccessHUD(title: title, subtitle: subtitle, completion: completion)
    }

    func showHUD(type: HUDContentType) {
        self.view.showHUD(type: type)
    }

    func showFlashHUD(type: HUDContentType, delay: TimeInterval? = nil) {
        self.view.showFlashHUD(type: type, delay: delay)
    }
    
    // MARK: - Keyboard
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    func present(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openSafariVC(with url: URL) {
        let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        safariViewController.preferredBarTintColor = UIColor.BaseView.bg
//        safariViewController.preferredControlTintColor = UIColor.primary
        if #available(iOS 11.0, *) {
            safariViewController.dismissButtonStyle = .close
        }
        safariViewController.modalPresentationStyle = .overFullScreen
        present(viewController: safariViewController)
    }
    
    func openSafariVC(with urlAddress: String) {
        guard let url = URL(string: urlAddress) else { return }
        
        openSafariVC(with: url)
    }
    
    func showActionSheet(with title: String?,
                         message: String?,
                         firstActionTitle: String?,
                         firstHandler: (() -> Void)?,
                         secondActionTitle: String? = nil,
                         secondHandler: (() -> Void)? = nil,
                         thirdActionTitle: String? = nil,
                         thirdHandler: (() -> Void)? = nil,
                         fourthActionTitle: String? = nil,
                         fourthHandler: (() -> Void)? = nil,
                         cancelTitle: String?,
                         cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.Cell.headerBg
        
        if let actionTitle = firstActionTitle {
            let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
                if firstHandler != nil {
                    firstHandler!()
                }
            }
            alert.addAction(action)
        }
        
        if let actionTitle = secondActionTitle {
            let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
                if secondHandler != nil {
                    secondHandler!()
                }
            }
            alert.addAction(action)
        }
        
        if let actionTitle = thirdActionTitle {
            let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
                if thirdHandler != nil {
                    thirdHandler!()
                }
            }
            alert.addAction(action)
        }
        
        if let actionTitle = fourthActionTitle {
            let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
                if fourthHandler != nil {
                    fourthHandler!()
                }
            }
            alert.addAction(action)
        }
        
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (UIAlertAction) in
                if cancelHandler != nil {
                    cancelHandler!()
                }
            }
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func errorHandle(with errorMessageType: ErrorMessageType, hud: Bool = false) {
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
