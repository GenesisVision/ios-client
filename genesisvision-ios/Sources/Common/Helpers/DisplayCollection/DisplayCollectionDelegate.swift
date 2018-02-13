//
//  DisplayCollectionDelegate.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 17.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import SafariServices

protocol DisplayCollectionDelegate: class {
    func updateUI()
    func open(url: URL)
}

extension UIViewController: DisplayCollectionDelegate {
    func updateUI() {
        if let tableView = self.value(forKey: "tableView") as? UITableView {
            tableView.reloadData()
        }
    }
    
    func open(url: URL) {
        let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        present(viewController: safariViewController)
    }
}

