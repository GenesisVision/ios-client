//
//  ReachabilityManager.swift
//  genesisvision-ios
//
//  Created by George on 30/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Reachability
import PKHUD

class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    let reachability = Reachability()!
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }

    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }

}
