//
//  DetailChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

protocol DetailChartTableViewCellProtocol: class {
    func showFullChartDidPressed()
    func updateChart(with type: ChartDurationType)
}

class DetailChartTableViewCell: UITableViewCell {

    // MARK: - Variables
    weak var delegate: DetailChartTableViewCellProtocol?
    
    // MARK: - Views
    @IBOutlet var viewForChartView: UIView!
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl! {
        didSet {
            segmentedControl.segmentStyle = .textOnly
            segmentedControl.insertSegment(withTitle: "1D", at: 0)
            segmentedControl.insertSegment(withTitle: "1W", at: 1)
            segmentedControl.insertSegment(withTitle: "1M", at: 2)
            segmentedControl.insertSegment(withTitle: "3M", at: 3)
            segmentedControl.insertSegment(withTitle: "6M", at: 4)
            segmentedControl.insertSegment(withTitle: "1Y", at: 5)
            segmentedControl.insertSegment(withTitle: "All", at: 6)
            segmentedControl.selectedSegmentIndex = 6
            segmentedControl.underlineSelected = true
            segmentedControl.height = 21
            
            let textAttributes = [NSAttributedStringKey.font: UIFont.getFont(.regular, size: 16), NSAttributedStringKey.foregroundColor: UIColor.Font.light]
            let textHighlightAttributes = [NSAttributedStringKey.font: UIFont.getFont(.regular, size: 16), NSAttributedStringKey.foregroundColor: UIColor.primary]
            let textSelectAttributes = [NSAttributedStringKey.font: UIFont.getFont(.regular, size: 16), NSAttributedStringKey.foregroundColor: UIColor.primary]

            segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
            segmentedControl.setTitleTextAttributes(textHighlightAttributes, for: .highlighted)
            segmentedControl.setTitleTextAttributes(textSelectAttributes, for: .selected)
            
            segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        }
    }
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.backgroundColor = UIColor.NavBar.grayBackground
            chartView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Labels
    @IBOutlet var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = UIColor.Font.dark
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.NavBar.background
        contentView.backgroundColor = UIColor.NavBar.grayBackground
        selectionStyle = .none
    }
    
    // MARK: - Private methods
    @IBAction func showFullChart(_ sender: UIButton) {
        delegate?.showFullChartDidPressed()
    }
    
    @objc func segmentSelected(sender: ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")

        if let type = ChartDurationType(rawValue: sender.selectedSegmentIndex) {
            delegate?.updateChart(with: type)
        }
    }
}
