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
}

extension DashboardWalletsTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardWalletsTableViewCell) {
        guard let walletSummary = walletSummary else { return }
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
    
    private let titleLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private let walletSummaryLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private let chartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
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
        
        topView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor, size: CGSize(width: 0, height: 80))
        
        tableView.anchor(top: topView.bottomAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor)
    }
    
    private func overlaySecondLayer() {
        topView.addSubview(titleLabel)
        topView.addSubview(walletSummaryLabel)
        topView.addSubview(chartView)
        
        titleLabel.anchor(top: topView.topAnchor, leading: topView.leadingAnchor, bottom: topView.bottomAnchor, trailing: nil, size: CGSize(width: 60, height: 0))
        walletSummaryLabel.anchor(top: topView.topAnchor, leading: titleLabel.trailingAnchor, bottom: topView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0), size: CGSize(width: 100, height: 0))
        chartView.anchor(top: nil, leading: nil, bottom: nil, trailing: topView.trailingAnchor)
        chartView.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
        chartView.anchorSize(size: CGSize(width: 80, height: 80))
    }
}
