//
//  SelectedChartAssetsView.swift
//  genesisvision-ios
//
//  Created by George on 11/01/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

protocol SelectedChartAssetsViewProtocol: AnyObject {
    func assetViewDidClose()
}

class SelectedChartAssetsView: UIView {
    // MARK: - Variables
    weak var delegate: SelectedChartAssetsViewProtocol?
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    @IBOutlet weak var dateLabel: SubtitleLabel! {
        didSet {
            dateLabel.font = UIFont.getFont(.regular, size: 14)
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
 
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
        
        setupTableConfiguration()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipsToBounds = true
        self.roundCorners([.topLeft, .topRight], radius: Constants.SystemSizes.cornerSize)
    }
    
    // MARK: - Public Methods
    func configure(configurationHandler: ((UITableView) -> Void)) {
        configurationHandler(tableView)
    }
    
    // MARK: - Private methods
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.assetViewDidClose()
    }
}

