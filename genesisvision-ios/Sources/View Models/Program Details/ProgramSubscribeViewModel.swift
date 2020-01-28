//
//  ProgramSubscribeViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 02.05.19.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class ProgramSubscribeViewModel {
    
    enum FollowType {
        case follow
        case edit
        case unfollow
    }
    // MARK: - Variables
    var title: String = ""
    var assetId: String?
    var programCurrency: CurrencyType?
    var labelPlaceholder: String = "0"
    
    var followType: FollowType = .follow
    
    var attachToSignal: AttachToSignalProvider!
    var reasonMode: SignalDetachMode = ._none
    
    var signalSubscription: SignalSubscription?
    
    var tradingAccountListViewModel: TradingAccountListViewModel!
    var tradingAccountListDataSource: TableViewDataSource!
    
    var tradingAccounts: ItemsViewModelTradingAccountDetails? {
        didSet {
            if let items = tradingAccounts?.items, !items.isEmpty {
                tradingAccountListViewModel = TradingAccountListViewModel(delegate, items: items, selectedIndex: 0)
                tradingAccountListDataSource = TableViewDataSource(tradingAccountListViewModel)
            }
        }
    }
    
    private var router: ProgramInfoRouter!
    private weak var detailProtocol: ReloadDataProtocol?
    weak var delegate: BaseTableViewProtocol?
    
    var usd: Double {
        get {
            guard let value = signalSubscription?.fixedVolume else { return 0.0 }
            return value
        }
        set {
            signalSubscription?.fixedVolume = newValue
        }
    }
    
    var volume: Double {
        get {
            guard let value = signalSubscription?.percent else { return 0.0 }
            return value
        }
        set {
            signalSubscription?.percent = newValue
        }
    }
    
    var tolerance: Double {
        get {
            guard let value = signalSubscription?.openTolerancePercent else { return 0.0 }
            return value
        }
        set {
            signalSubscription?.openTolerancePercent = newValue
        }
    }
    
    
    // MARK: - Init
    init(withRouter router: ProgramInfoRouter,
         assetId: String,
         tradingAccountId: UUID? = nil,
         сurrency: CurrencyType? = nil,
         signalSubscription: SignalSubscription? = nil,
         tradingAccounts: ItemsViewModelTradingAccountDetails? = nil,
         detailProtocol: ReloadDataProtocol?,
         followType: FollowType,
         delegate: BaseTableViewProtocol?) {
        
        self.router = router
        self.assetId = assetId
        self.detailProtocol = detailProtocol
        self.followType = followType
        self.tradingAccounts = tradingAccounts
        self.signalSubscription = signalSubscription ?? SignalSubscription(subscriberInfo: nil,
                                                                           asset: nil,
                                                                           status: nil,
                                                                           subscriptionDate: nil,
                                                                           unsubscriptionDate: nil,
                                                                           hasSignalAccount: nil,
                                                                           hasActiveSubscription: nil,
                                                                           isExternal: nil,
                                                                           mode: .byBalance,
                                                                           detachMode: nil,
                                                                           percent: 10,
                                                                           openTolerancePercent: 0.5,
                                                                           fixedVolume: 100,
                                                                           fixedCurrency: .usd,
                                                                           totalProfit: nil,
                                                                           totalVolume: nil)
    
        var fixedCurrency: AttachToSignalProvider.FixedCurrency?
        if let fixedCurrencyValue = signalSubscription?.fixedCurrency?.rawValue {
            fixedCurrency = AttachToSignalProvider.FixedCurrency(rawValue: fixedCurrencyValue)
        }
        var accountId: UUID?
        if let tradingAccountId = signalSubscription?.subscriberInfo?.tradingAccountId {
            accountId = tradingAccountId
        } else if let tradingAccountId = tradingAccountId {
            accountId = tradingAccountId
        }
        
        self.attachToSignal = AttachToSignalProvider(tradingAccountId: accountId,
                                                     mode: signalSubscription?.mode,
                                                     percent: signalSubscription?.percent,
                                                     openTolerancePercent: signalSubscription?.openTolerancePercent,
                                                     fixedVolume: signalSubscription?.fixedVolume,
                                                     fixedCurrency: fixedCurrency)
        
        self.reasonMode = ._none
        
        if let сurrency = сurrency, let fixedCurrency =
            AttachToSignalProvider.FixedCurrency(rawValue: сurrency.rawValue) {
            self.attachToSignal.fixedCurrency = fixedCurrency
        }
    }
    
    // MARK: - Public methods
    func getSelectedDescription() -> String {
        switch followType {
        case .follow, .edit:
            return getSelectedTypeDescription()
        case .unfollow:
            return getSelectedReasonDescription()
        }
    }
    
    func getSelectedType() -> String {
        switch followType {
        case .follow, .edit:
            return getSelectedMode()
        case .unfollow:
            return getSelectedReason()
        }
    }
    
    func getSelectedAccountType() -> String {
        guard let login = tradingAccountListViewModel.selected()?.login, let currency = tradingAccountListViewModel.selected()?.currency?.rawValue else { return "" }
        return login + " | " + currency
    }
    
    func getFixedCurrency() -> String {
        guard let fixedCurrency = signalSubscription?.fixedCurrency else { return "" }
        
        return fixedCurrency.rawValue
    }
    
    func getMode() -> SubscriptionMode {
        return signalSubscription?.mode ?? .byBalance
    }
    func changeMode(_ mode: SubscriptionMode) {
        signalSubscription?.mode = mode
    }

    func getReason() -> SignalDetachMode {
        return reasonMode
    }
    
    func changeReason(_ mode: SignalDetachMode) {
        reasonMode = mode
    }
    
    // MARK: - Private methods
    private func getSelectedMode() -> String {
        guard let mode = signalSubscription?.mode else { return "" }
        
        switch mode {
        case .byBalance:
            return "By balance"
        case .percent:
            return "Percentage"
        case .fixed:
            return "Fixed"
        }
    }
    
    private func getSelectedTypeDescription() -> String {
        guard let mode = signalSubscription?.mode else { return "" }
        
        switch mode {
        case .byBalance:
            return "The volume of the opened positions is proportional to the balance of the signal provider and an investor."
        case .percent:
            return "Positions are opened according to the percentage of the volume of positions opened by the signal provider."
        case .fixed:
            return "Each new position is opened at a fixed amount."
        }
    }
    
    private func getSelectedReason() -> String {
        switch reasonMode {
        case ._none:
            return "Manual closing"
        case .closeAllImmediately:
            return "Close all immediately"
        case .providerCloseOnly:
            return "Close only"
        }
    }
    
    private func getSelectedReasonDescription() -> String {
        switch reasonMode {
        case ._none:
            return "An investor at any time can perform a manual closing of all of the open positions."
        case .closeAllImmediately:
            return "Instant closing of all open positions."
        case .providerCloseOnly:
            return "New trades do not open, open positions are closed as the manager closes them."
        }
    }

    
    // MARK: - Navigation
    func subscribe(completion: @escaping CompletionBlock) {
        attachToSignal.fixedVolume = signalSubscription?.fixedVolume
        attachToSignal.percent = signalSubscription?.percent
        attachToSignal.openTolerancePercent = signalSubscription?.openTolerancePercent

        if let fixedCurrency = signalSubscription?.fixedCurrency {
            attachToSignal.fixedCurrency = AttachToSignalProvider.FixedCurrency(rawValue: fixedCurrency.rawValue)
        }
        if let mode = signalSubscription?.mode {
            attachToSignal.mode = SubscriptionMode(rawValue: mode.rawValue)
        }
        if let tradingAccountId = tradingAccountListViewModel.selected()?.id {
            attachToSignal.tradingAccountId = tradingAccountId
        }
        
        guard let assetId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
        SignalDataProvider.attach(on: assetId, model: attachToSignal, completion: completion)
    }
    
    func update(completion: @escaping CompletionBlock) {
        attachToSignal.fixedVolume = signalSubscription?.fixedVolume
        attachToSignal.percent = signalSubscription?.percent
        attachToSignal.openTolerancePercent = signalSubscription?.openTolerancePercent

        if let fixedCurrency = signalSubscription?.fixedCurrency {
            attachToSignal.fixedCurrency = AttachToSignalProvider.FixedCurrency(rawValue: fixedCurrency.rawValue)
        }
        if let mode = signalSubscription?.mode {
            attachToSignal.mode = SubscriptionMode(rawValue: mode.rawValue)
        }
        
        if let tradingAccountId = tradingAccountListViewModel.selected()?.id {
            attachToSignal.tradingAccountId = tradingAccountId
        }
        
        guard let assetId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        SignalDataProvider.update(with: assetId, model: attachToSignal, completion: completion)
    }
    
    func unsubscribe(completion: @escaping CompletionBlock) {
        guard let assetId = assetId, let tradingAccountId = tradingAccountListViewModel.selected()?.id else { return completion(.failure(errorType: .apiError(message: nil))) }
    
        let model = DetachFromSignalProvider(tradingAccountId: tradingAccountId, mode: reasonMode)
        SignalDataProvider.detach(with: assetId, model: model, completion: completion)
    }
    
    func goToBack() {
        detailProtocol?.didReloadData()

        //FIXME: fixedCurrency
        if self.attachToSignal.fixedCurrency != nil {
            router.goToSecond()
        } else {
            router.goToBack()
        }
    }
    
    func close() {
        router.closeVC()
    }
}
