//
//  NavigationTitleView.swift
//  genesisvision-ios
//
//  Created by George on 16/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class NavigationTitleView: UIView {
    var currencyTitleButton: StatusButton = {
        let selectedCurrency = getSelectedCurrency()
        
        let currencyTitleButton = StatusButton(type: .system)
        currencyTitleButton.frame = CGRect(x: 0, y: 0, width: 73, height: 18)
        currencyTitleButton.setTitle(selectedCurrency, for: .normal)
        currencyTitleButton.setTitleColor(UIColor.Cell.title, for: .normal)
        currencyTitleButton.bgColor = UIColor.Cell.bg
        currencyTitleButton.contentEdge = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        
        currencyTitleButton.sizeToFit()
        
        return currencyTitleButton
    }()
    
    private var contentOffset: CGFloat = 0 {
        didSet {
            currencyTitleButton.frame.origin.y = titleVerticalPositionAdjusted(by: contentOffset)
        }
    }
    var scrollEnabled = false
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(currencyTitleButton)
        clipsToBounds = true
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        sizeToFit()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if #available(iOS 11.0, *) {
            return super.sizeThatFits(size)
        } else {
            let height = (typedSuperview() as? UINavigationBar)?.bounds.height ?? 0.0
            let currencyTitleButtonSize = currencyTitleButton.sizeThatFits(CGSize(width: size.width, height: height))
            return CGSize(width: min(currencyTitleButtonSize.width, size.width), height: height)
        }
    }
    
    private func layoutSubviews_10() {
        guard let navBar = typedSuperview() as? UINavigationBar else { return }
        let center = convert(navBar.center, from: navBar)
        let size = currencyTitleButton.sizeThatFits(bounds.size)
        let x = max(bounds.minX, center.x - size.width * 0.5)
        let y: CGFloat
        
        if contentOffset == 0 {
            y = bounds.maxY
        } else {
            y = titleVerticalPositionAdjusted(by: contentOffset)
        }
        
        currencyTitleButton.frame = CGRect(x: x, y: y, width: min(size.width, bounds.width), height: size.height)
    }
    
    private func layoutSubviews_11() {
        let size = currencyTitleButton.sizeThatFits(bounds.size)
        let x: CGFloat
        let y: CGFloat
        
        x = bounds.midX - size.width * 0.5
        
        if contentOffset == 0 {
            y = bounds.maxY
        } else {
            y = titleVerticalPositionAdjusted(by: contentOffset)
        }
        
        currencyTitleButton.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11.0, *) {
            layoutSubviews_11()
        } else {
            layoutSubviews_10()
        }
    }
    
    // MARK:
    
    /// Using the UIScrollViewDelegate it moves the inner UILabel to move up and down following the scroll offset.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll-view object in which the scrolling occurred.
    ///   - threshold: The minimum distance that must be scrolled before the title view will begin scrolling up into view
    func scrollViewDidScroll(_ scrollView: UIScrollView, threshold: CGFloat = 0) {
        guard scrollView.contentOffset.y > 0 else { return }
        contentOffset = scrollView.contentOffset.y - threshold
    }
    
    // MARK: Private
    
    private func titleVerticalPositionAdjusted(by yOffset: CGFloat) -> CGFloat {
        let midY = bounds.midY - currencyTitleButton.bounds.height * 0.5
        return max(bounds.maxY - yOffset, midY).rounded()
    }
}
