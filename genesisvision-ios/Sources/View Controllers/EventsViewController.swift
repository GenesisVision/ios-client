//
//  EventsViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class EventsViewController: BaseViewController {
    // MARK: - Variables
    fileprivate var delegateManager: EventsDelegateManager!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        delegateManager = EventsDelegateManager()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            
//            layout.headerReferenceSize = CGSize(width: 0, height: 50)
        }
        
        collectionView.register(UINib.init(nibName: "PortfolioEventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PortfolioEventCollectionViewCell")
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = delegateManager
        collectionView.dataSource = delegateManager
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
}


final class EventsDelegateManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioEventCollectionViewCell", for: indexPath as IndexPath) as! PortfolioEventCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.6, height: collectionView.frame.height - 16.0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UITableView else { return }
        
        let yOffset = scrollView.contentOffset.y
        
        let window = UIApplication.shared.windows[0] as UIWindow
        if let dashboardViewController = window.rootViewController as? DashboardViewController,
            let assetsViewController = dashboardViewController.assetsViewController,
            let pageboyDataSource = assetsViewController.pageboyDataSource,
            let controllers = pageboyDataSource.controllers {
            for controller in controllers {
                if let vc = controller as? BaseViewControllerWithTableView {
                    vc.tableView?.isScrollEnabled = yOffset > -44.0
                }
            }
        } else if let rootViewController = window.rootViewController,
            rootViewController is UINavigationController,
            let dashboardViewController = rootViewController.childViewControllers.first as? DashboardViewController,
            let assetsViewController = dashboardViewController.assetsViewController,
            let pageboyDataSource = assetsViewController.pageboyDataSource,
            let controllers = pageboyDataSource.controllers {
            for controller in controllers {
                if let vc = controller as? BaseViewControllerWithTableView {
                    vc.tableView?.isScrollEnabled = yOffset > -44.0
                }
            }
        }
    }
}
