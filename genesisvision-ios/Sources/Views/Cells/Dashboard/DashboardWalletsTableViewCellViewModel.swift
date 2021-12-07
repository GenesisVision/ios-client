//
//  DashboardWalletsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 18.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct DashboardWalletsTableViewCellViewModel {
    let walletSummary: WalletSummary?
    let ratesModel: RatesModel?
    weak var delegate: BaseTableViewProtocol?
}

extension DashboardWalletsTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardWalletsTableViewCell) {
        guard let walletSummary = walletSummary else { return }
        
        cell.delegate = delegate
        
        if let available = walletSummary.grandTotal?.available,
           let currency = walletSummary.grandTotal?.currency, let total = walletSummary.grandTotal?.total {
            cell.walletSummaryLabel.text = total.toString() + " " + currency.rawValue
            let percent = total == 0.0 ? 0.0 : available / total
            cell.progressChartView.setProgress(to: percent, withAnimation: true)
        }
        
        if let wallets = walletSummary.wallets {
            cell.viewModels = wallets.map({
            let amountInPlatformCurrency = getAmountForPlatformCurrency(fromAmount: $0.available, fromCurrency: $0.currency?.rawValue)
            return WalletTableViewCellViewModel(wallet: $0, totalAmountInPlatformCurrency: amountInPlatformCurrency) })
        }
    }
    
    private func getAmountForPlatformCurrency(fromAmount: Double?, fromCurrency: String?) -> Double? {
        guard let fromAmount = fromAmount, let fromCurrency = fromCurrency, let rates = ratesModel?.rates, let rate = rates[getPlatformCurrencyType().rawValue]?.first(where: {$0.currency == fromCurrency })?.rate else { return nil }
        return fromAmount/rate
    }
}

class DashboardWalletsTableViewCell: UITableViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let titleLabel: LargeTitleLabel = {
        let label = LargeTitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Wallet"
        return label
    }()
    
    let walletSummaryLabel: LargeTitleLabel = {
        let label = LargeTitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let progressChartView: CircularProgressView = {
        let view = CircularProgressView()
        view.percentTextEnable = true
        view.foregroundStrokeColor = UIColor.primary
        view.percentTextFont = UIFont.getFont(.bold, size: 11.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewModels: [WalletTableViewCellViewModel] = [] {
        didSet {
            tableView.configure(with: .defaultConfiguration)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.registerNibs(for: [WalletTableViewCellViewModel.self])
            tableView.reloadData()
        }
    }
    
    weak var delegate: BaseTableViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.BaseView.bg
        backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
        
        setupLayers()
    }
    
    private func setupLayers() {
        overlayZeroLayer()
        overlayFirstLayer()
        overlaySecondLayer()
    }
    
    private func overlayZeroLayer() {
        contentView.addSubview(mainView)
        
        mainView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    private func overlayFirstLayer() {
        mainView.addSubview(topView)
        mainView.addSubview(tableView)
        
        topView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor, size: CGSize(width: 0, height: 55))
        
        tableView.anchor(top: topView.bottomAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, size: CGSize(width: 0, height: 300))
    }
    
    private func overlaySecondLayer() {
        topView.addSubview(titleLabel)
        topView.addSubview(walletSummaryLabel)
        topView.addSubview(progressChartView)
        
        titleLabel.anchor(top: topView.topAnchor, leading: topView.leadingAnchor, bottom: topView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: 60, height: 0))
        progressChartView.anchor(top: nil, leading: nil, bottom: nil, trailing: topView.trailingAnchor, padding: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
        progressChartView.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
        progressChartView.anchorSize(size: CGSize(width: 50, height: 50))
        walletSummaryLabel.anchor(top: topView.topAnchor, leading: titleLabel.trailingAnchor, bottom: topView.bottomAnchor, trailing: progressChartView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10))

    }
}

extension DashboardWalletsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModels[safe: indexPath.row] else {
            return TableViewCell() }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.BaseView.bg
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.action(.dashboardWallets, actionType: .showAll)
    }
}
