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

var circleHeight: CGFloat = 6.0

class DetailChartTableViewCell: UITableViewCell {

    // MARK: - Variables
    weak var delegate: DetailChartTableViewCellProtocol?
    
    // MARK: - Views
    let markerView = MarkerView()
    let circleView = UIView(frame: CGRect(x: 0, y: 0, width: circleHeight, height: circleHeight))
    
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
            chartView.delegate = self
            chartView.backgroundColor = UIColor.NavBar.grayBackground
            chartView.isUserInteractionEnabled = true
        }
    }
   
    // MARK: - Labels
    @IBOutlet var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = UIColor.Font.dark
        }
    }
    
    @IBOutlet var changesLabel: UILabel! {
        didSet {
            changesLabel.textColor = UIColor.Font.green
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.NavBar.background
        contentView.backgroundColor = UIColor.NavBar.grayBackground
        selectionStyle = .none
        
        circleView.backgroundColor = UIColor.Font.white
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.layer.borderColor = UIColor.Font.dark.cgColor
        circleView.layer.borderWidth = 0.5
        circleView.clipsToBounds = true
        chartView.addSubview(circleView)
        
        markerView.layer.cornerRadius = 6.0
        addSubview(markerView)
        
        hideMarker()
    }
    
    // MARK: - Private methods
    private func hideMarker(value: Bool = true) {
        markerView.isHidden = value
        circleView.isHidden = value
        
        if value {
            chartView.highlightValues(nil)
        }
    }
    
    @IBAction func showFullChart(_ sender: UIButton) {
        delegate?.showFullChartDidPressed()
    }
    
    @objc func segmentSelected(sender: ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")

        hideMarker()
        
        if let type = ChartDurationType(rawValue: sender.selectedSegmentIndex) {
            delegate?.updateChart(with: type)
        }
    }
}

extension DetailChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let date = Date(timeIntervalSince1970: entry.x)
        let dateString = date.dateAndTimeFormatString
        let x = highlight.xPx - 40 < 0
            ? 0
            : highlight.xPx - 40 > chartView.frame.width - 90
            ? chartView.frame.width - 90
            : highlight.xPx - 40
        markerView.frame = CGRect(x: x, y: 0, width: 90, height: 36)
        
        markerView.contentView.backgroundColor = UIColor.Font.dark
        markerView.valueLabel.text = entry.y.rounded(withType: .gvt).toString() + " GVT"
        markerView.dateLabel.text = dateString
        
        circleView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)

        hideMarker(value: false)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        hideMarker()
    }
}
