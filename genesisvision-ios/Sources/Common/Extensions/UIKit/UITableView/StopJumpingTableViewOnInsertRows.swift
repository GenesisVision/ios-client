//
//  StopJumpingTableViewOnInsertRows.swift
//  genesisvision-ios
//
//  Created by George on 03/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    func reloadDataSmoothly() {
//        self.reloadSections(IndexSet(integer: 1), with: .fade)
        
//        let range = NSMakeRange(0, self.numberOfSections)
//        let sections = NSIndexSet(indexesIn: range)
//        self.reloadSections(sections as IndexSet, with: .none)
        
//        UIView.setAnimationsEnabled(false)
//        self.reloadData()
//        UIView.setAnimationsEnabled(true)
//
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.reloadData() })
    }
}
