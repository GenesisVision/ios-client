//
//  FundViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class FundViewModel {
    // MARK: - Variables
    var fundId: String!
    var fundDetailsFull: FundDetailsFull?
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    var isFavorite: Bool {
        return fundDetailsFull?.personalDetails?.isFavorite ?? false
    }
    
    var router: FundRouter!
    
    // MARK: - Init
    init(withRouter router: Router, fundId: String, fundViewController: FundViewController) {
        self.fundId = fundId
        self.reloadDataProtocol = fundViewController
        self.router = FundRouter(parentRouter: router, navigationController: nil, fundViewController: fundViewController)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fundFavoriteStateChangeNotification(notification:)), name: .fundFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .fundFavoriteStateChange, object: nil)
    }
    
    func showNotificationSettings() {
        router.show(routeType: .notificationSettings(assetId: fundId, title: fundDetailsFull?.publicInfo?.title ?? "Fund Settings"))
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        FundsDataProvider.get(fundId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return }
            self?.fundDetailsFull = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
    
    // MARK: - Public methods
    func changeFavorite(value: Bool? = nil, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            fundDetailsFull?.personalDetails?.isFavorite = value
            return completion(.success)
        }
        
        guard
            let personalDetails = fundDetailsFull?.personalDetails,
            let isFavorite = personalDetails.isFavorite,
            let assetId = fundId
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        FundsDataProvider.favorites(isFavorite: isFavorite, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                self?.fundDetailsFull?.personalDetails?.isFavorite = !isFavorite
            case .failure(let errorType):
                print(errorType)
                self?.fundDetailsFull?.personalDetails?.isFavorite = isFavorite
            }
            
            completion(result)
        }
    }
    
    @objc private func fundFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["fundId"] as? String, assetId == fundId {
            changeFavorite(value: isFavorite) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
    
}
