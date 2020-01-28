//
//  TradingInfoTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 24.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

struct ProgramInfoTableViewCellViewModel {
    let asset: ProgramDetailsFull
    let assetId: String?
    weak var delegate: TradingInfoViewProtocol?
}

extension ProgramInfoTableViewCellViewModel: CellViewModel {
    func setup(on cell: TradingInfoTableViewCell) {
        cell.configure(asset, assetId: assetId, delegate: delegate)
    }
}

struct FundInfoTableViewCellViewModel {
    let asset: FundDetailsFull
    let assetId: String?
    weak var delegate: TradingInfoViewProtocol?
}

extension FundInfoTableViewCellViewModel: CellViewModel {
    func setup(on cell: TradingInfoTableViewCell) {
        cell.configure(asset, assetId: assetId, delegate: delegate)
    }
}

struct FollowInfoTableViewCellViewModel {
    let asset: FollowDetailsFull
    let assetId: String?
    weak var delegate: TradingInfoViewProtocol?
}

extension FollowInfoTableViewCellViewModel: CellViewModel {
    func setup(on cell: TradingInfoTableViewCell) {
        cell.configure(asset, assetId: assetId, delegate: delegate)
    }
}

class TradingInfoTableViewCell: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var stackView: UIStackView!
    
    var cellContentView: TradingInfoContentView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    func loadContentView() {
        stackView.removeAllArrangedSubviews()
        cellContentView = TradingInfoContentView.viewFromNib()
        stackView.addArrangedSubview(cellContentView)
    }
    
    // MARK: - Public methods
    func configure(_ asset: ProgramDetailsFull?, assetId: String?, delegate: TradingInfoViewProtocol?) {
        loadContentView()
        cellContentView.assetType = .program
        cellContentView.configure(program: asset, assetId: assetId, delegate: delegate)
    }
    
    func configure(_ asset: FollowDetailsFull?, assetId: String?, delegate: TradingInfoViewProtocol?) {
        loadContentView()
        cellContentView.assetType = .follow
        cellContentView.configure(follow: asset, assetId: assetId, delegate: delegate)
    }
    
    func configure(_ asset: FundDetailsFull?, assetId: String?, delegate: TradingInfoViewProtocol?) {
        loadContentView()
        cellContentView.assetType = .fund
        cellContentView.configure(fund: asset, assetId: assetId, delegate: delegate)
    }
}

