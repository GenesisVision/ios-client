//
//  PlateTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 27/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

// Working from xib only
class PlateTableViewCell: UITableViewCell {

    enum RoundType {
    case none, top, bottom, all

        var cornersType: UIRectCorner? {
            switch self {
            case .top:
                return [.topLeft, .topRight]
            case .bottom:
                return [.bottomLeft, .bottomRight]
            case .all:
                return .allCorners
            case .none:
                return []
            }
        }
    }

    var bgColor: UIColor = .white {
        didSet {
            shape.fillColor = bgColor.cgColor
        }
    }
        
    private var plateAppearanceValue: PlateTableViewCellAppearance? {
        didSet {
            updateAppearance()
        }
    }

  // For UIAppearance proxy
    @objc dynamic var plateAppearance: PlateTableViewCellAppearance? {
        set {
            plateAppearanceValue = newValue
        }
        get {
            return plateAppearanceValue
        }
    }

    var highlighting: Bool = true
    
    var roundType: RoundType = .all {
        didSet {
            if oldValue != roundType {
                updateAppearance()
            }
        }
    }

    var shouldHaveVerticalMargin: Bool = true {
        didSet {
            if oldValue != shouldHaveVerticalMargin {
                updateAppearance()
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            updateRoundShape()
        }
    }

    private let shape: CAShapeLayer = CAShapeLayer()

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        layer.insertSublayer(shape, at: 0)

        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateSelection(shouldSelect: selected || isHighlighted)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateSelection(shouldSelect: highlighted || isSelected)
    }

    func updateSelection(shouldSelect: Bool) {
        guard highlighting else { return }
        alpha = shouldSelect ? 0.8 : 1.0
    }

    private func updateAppearance() {
        guard let plateAppearance = plateAppearanceValue else {
            return
        }
        
        shape.fillColor = bgColor.cgColor

        var newMargins = UIEdgeInsets.zero
        newMargins.left += plateAppearance.horizontalMarginValue
        newMargins.right += plateAppearance.horizontalMarginValue

        if shouldHaveVerticalMargin {
            newMargins.top += plateAppearance.verticalMarginValues
            newMargins.bottom += plateAppearance.verticalMarginValues
        }

        contentView.layoutMargins = newMargins
        updateRoundShape()
    }

    private func updateRoundShape() {
        guard let plateAppearance = plateAppearanceValue else { return }

        var verticalMarginValues: CGFloat = 0
        if shouldHaveVerticalMargin {
            verticalMarginValues = plateAppearance.verticalMarginValues
        }

        let frame = CGRect(x: plateAppearance.horizontalMarginValue,
                           y: verticalMarginValues,
                           width: self.frame.width - plateAppearance.horizontalMarginValue * 2,
                           height: self.frame.height - verticalMarginValues * 2)

        let path: UIBezierPath
        if let cornersType = roundType.cornersType {
            path = UIBezierPath(roundedRect: frame,
                              byRoundingCorners: cornersType,
                              cornerRadii: CGSize(width: plateAppearance.cornerRadius,
                                                  height: plateAppearance.cornerRadius))
        } else {
            path = UIBezierPath(rect: frame)
        }

        let mask = CAShapeLayer()
        mask.path = path.cgPath

        contentView.layer.mask = mask
        shape.path = path.cgPath
    }
}
