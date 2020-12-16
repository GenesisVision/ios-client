//
//  DashboardInvestmentLimitsTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 26.11.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

struct DashboardInvestmentLimitsTableViewCellViewModel {
    let investmentLimit: LimitWithoutKyc
    weak var delegate: BaseTableViewProtocol?
    let verificationStatus: UserVerificationStatus?
}

extension DashboardInvestmentLimitsTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardInvestmentLimitsTableViewCell) {
        cell.delegate = delegate
        
        if let invested = investmentLimit.invested, let limit = investmentLimit.limit, let _ = investmentLimit.currency {
            
            cell.limitCurrentValueLabel.text = invested.toString() + " $"
            
            cell.limitUpperBoundValue.text = limit.toString() + " $"
            
            let progress = invested / limit
            
            cell.limitProgressView.setProgress(section: 0, to: Float(progress))
        }
        
        if let verificationStatus = verificationStatus, verificationStatus == .underReview {
            cell.removeLimitButton.configure(with: .darkClear)
            cell.removeLimitButton.setTitle("Under Review", for: .normal)
            cell.removeLimitButton.isUserInteractionEnabled = false
        }
    }
}


class DashboardInvestmentLimitsTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var infoButton: TooltipButton!
    @IBOutlet weak var spentLabel: SubtitleLabel! {
        didSet {
            spentLabel.text = "Spent"
        }
    }
    
    @IBOutlet weak var limitCurrentValueLabel: TitleLabel!
    
    @IBOutlet weak var limitUpperBoundValue: TitleLabel! {
        didSet {
            limitUpperBoundValue.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var limitProgressView: MultiProgressView! {
        didSet {
            limitProgressView.lineCap = .round
            limitProgressView.cornerRadius = 2.0
            limitProgressView.backgroundColor = UIColor.ProgressView.trackTint
        }
    }
    
    @IBOutlet weak var removeLimitButton: ActionButton! {
        didSet {
            removeLimitButton.setTitle("Remove the limit", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        limitProgressView.dataSource = self
        titleLabel.text = "Investment limit"
        loaderView.stopAnimating()
        loaderView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        delegate?.action(.dashboardInvestLimitInfo, actionType: .showLimitInfo)
    }
    @IBAction func removeLimitButtonAction(_ sender: Any) {
        delegate?.action(.dashboardInvestLimitInfo, actionType: .removeInvestLimit)
    }
    
}

extension DashboardInvestmentLimitsTableViewCell: MultiProgressViewDataSource {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 1
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        
        sectionView.backgroundColor = UIColor.ProgressView.progressTint
        return sectionView
    }
}
