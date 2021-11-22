//
//  FundAssetManageViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 19.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

protocol ChangeFundAssetPartViewProtocol: AnyObject {
    func close()
    func update(targetInFund: Int, freeInFund: Int, fundSymbol: String)
}

class ChangeFundAssetPartView: UIView {
    
    //First Layer
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Cell.bg
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Cell.bg
        return view
    }()
    
    //Second Layer
    private var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "img_textfield_clear"), for: .normal)
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let symbolLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getFont(.regular, size: 15)
        return label
    }()
    
    private let coinFullNameLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getFont(.semibold, size: 15.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let freeSpaceInTheFundLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.text = "Free space in the fund"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getFont(.regular, size: 14)
        return label
    }()
    
    private let percentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Common.darkBackground
        view.roundCorners(with: 20)
        return view
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "minusButton"), for: .normal)
        button.addTarget(self, action: #selector(minusPercent), for: .touchUpInside)
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "plusButton"), for: .normal)
        button.addTarget(self, action: #selector(plusPercent), for: .touchUpInside)
        return button
    }()
    
    private let percentValue: DesignableUITextField = {
        let textField = DesignableUITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.textColor = UIColor.Cell.title
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(percentTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let percentLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.text = "%"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getFont(.regular, size: 14)
        return label
    }()
    
    private let updateButton: ActionButton = {
        let button = ActionButton()
        button.configure(with: .custom(options: ActionButtonOptions(borderWidth: 0, borderColor: nil, fontSize: nil, bgColor: UIColor.BaseView.bg, textColor: nil, image: nil, rightPosition: nil)))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.addTarget(self, action: #selector(updateButtonAction), for: .touchDown)
        return button
    }()
    
    private let GVT = "GVT"
    private var mainViewHeight: CGFloat = 200
    private var mainViewWidth: CGFloat = 200
    private var freeSpaceInFund: Int = 0
    private var targetValueInFund: Int = 0
    private var maximumFreeSpaceWithThisAsset: Int = 0
    private var assetInfo = FundAssetInfo()
    
    var delegate: ChangeFundAssetPartViewProtocol?
    
    
    init(frame: CGRect, mainViewHeight: CGFloat = 200, mainViewWidth: CGFloat = 200) {
        super.init(frame: frame)
        self.mainViewHeight = mainViewHeight
        self.mainViewWidth = mainViewWidth
        
        overlayFirstLayer()
        overlaySecondLayer()
        overlayThirdLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(assetInfo: FundAssetInfo, freeSpaceInFund: Int) {
        guard let imageUrl = assetInfo.logoUrl, let symbol = assetInfo.symbol, let assetName = assetInfo.asset, let target = assetInfo.target else { return }
        
        let targetValueInFund = Int(target)
        DispatchQueue.main.async {
            if let fileUrl = getFileURL(fileName: imageUrl) {
                self.logoImageView.isHidden = false
                self.logoImageView.kf.indicatorType = .activity
                self.logoImageView.kf.setImage(with: fileUrl)
            } else {
                self.logoImageView.isHidden = true
            }
            self.assetInfo = assetInfo
            self.symbolLabel.text = symbol
            self.coinFullNameLabel.text = assetName
            self.percentValue.text = targetValueInFund.toString()
            self.maximumFreeSpaceWithThisAsset = freeSpaceInFund + targetValueInFund
            self.updateValuesAndLabel(freeSpaceInFund: freeSpaceInFund, targetValue: targetValueInFund)
        }
    }
    
    private func overlayFirstLayer() {
        addSubview(topView)
        addSubview(bottomView)
        
        topView.anchor(top: topAnchor,
                       leading: leadingAnchor,
                       bottom: nil,
                       trailing: trailingAnchor,
                       padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        bottomView.anchor(top: topView.bottomAnchor,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    private func overlaySecondLayer() {
        topView.addSubview(logoImageView)
        topView.addSubview(symbolLabel)
        topView.addSubview(coinFullNameLabel)
        topView.addSubview(freeSpaceInTheFundLabel)
        topView.addSubview(closeButton)
        
        logoImageView.anchorCenter(centerY: nil, centerX: topView.centerXAnchor)
        logoImageView.anchor(top: topView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        logoImageView.anchorSize(size: CGSize(width: 50, height: 50))
        
        coinFullNameLabel.anchor(top: logoImageView.bottomAnchor, leading: nil, bottom: nil, trailing: symbolLabel.leadingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        coinFullNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        coinFullNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        coinFullNameLabel.anchorCenter(centerY: nil, centerX: logoImageView.leadingAnchor)
        
        symbolLabel.anchor(top: logoImageView.bottomAnchor, leading: coinFullNameLabel.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        symbolLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        symbolLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true

        
        freeSpaceInTheFundLabel.anchor(top: symbolLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        freeSpaceInTheFundLabel.anchorCenter(centerY: nil, centerX: topView.centerXAnchor)
        
        closeButton.anchor(top: topView.topAnchor, leading: nil, bottom: nil, trailing: topView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10), size: CGSize(width: 30, height: 30))
    }
    
    
    private func overlayThirdLayer() {
        bottomView.addSubview(percentView)
        bottomView.addSubview(updateButton)
        
        percentView.anchor(top: bottomView.topAnchor, leading: bottomView.leadingAnchor, bottom: nil, trailing: bottomView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
        
        
        percentView.addSubview(minusButton)
        percentView.addSubview(percentValue)
        percentView.addSubview(percentLabel)
        percentView.addSubview(plusButton)
        
        minusButton.anchor(top: percentView.topAnchor, leading: percentView.leadingAnchor, bottom: percentView.bottomAnchor, trailing: nil, size: CGSize(width: 40, height: 0))
        
        percentValue.anchor(top: percentView.topAnchor, leading: nil, bottom: percentView.bottomAnchor, trailing: nil, size: CGSize(width: 40, height: 0))
        percentValue.anchorCenter(centerY: nil, centerX: percentView.centerXAnchor)
        
        percentLabel.anchor(top: percentView.topAnchor, leading: percentValue.trailingAnchor, bottom: percentView.bottomAnchor, trailing: nil, size: CGSize(width: 40, height: 0))
        
        plusButton.anchor(top: percentView.topAnchor, leading: nil, bottom: percentView.bottomAnchor, trailing: percentView.trailingAnchor, size: CGSize(width: 40, height: 0))
        
        updateButton.anchor(top: nil, leading: bottomView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: bottomView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10), size: CGSize(width: 0, height: 50))
        
    }
    
    private func updateValuesAndLabel(freeSpaceInFund: Int, targetValue: Int) {
        self.freeSpaceInFund = freeSpaceInFund
        self.targetValueInFund = targetValue
        let combination = NSMutableAttributedString()
        let boldAndWhiteFontAttribute = [NSAttributedString.Key.font: UIFont.getFont(.medium, size: 13), NSAttributedString.Key.foregroundColor: UIColor.Common.white]
        let attrText = NSMutableAttributedString(string: " \(freeSpaceInFund)%", attributes: boldAndWhiteFontAttribute)
        
        combination.append(NSAttributedString(string: "Free space in the fund"))
        combination.append(attrText)
        
        DispatchQueue.main.async {
            self.freeSpaceInTheFundLabel.attributedText = combination
            self.percentValue.text = targetValue.toString()
        }
    }
    
    @objc private func minusPercent() {
        guard freeSpaceInFund <= 100, targetValueInFund - 1 >= 0 else { return }
        
        if let symbol = assetInfo.symbol, symbol == GVT, targetValueInFund == 1 { return }
        
        let freeSpace = freeSpaceInFund + 1
        let targetValue = targetValueInFund - 1
        
        updateValuesAndLabel(freeSpaceInFund: freeSpace, targetValue: targetValue)
    }
    
    @objc private func plusPercent() {
        guard targetValueInFund + 1 <= 100, freeSpaceInFund >= 1 else { return }
        
        let freeSpace = freeSpaceInFund - 1
        let targetValue = targetValueInFund + 1
        updateValuesAndLabel(freeSpaceInFund: freeSpace, targetValue: targetValue)
    }
    
    @objc private func updateButtonAction() {
        guard let symbol = assetInfo.symbol, targetValueInFund > 0 else { return }
        delegate?.update(targetInFund: targetValueInFund, freeInFund: freeSpaceInFund, fundSymbol: symbol)
    }
    
    @objc private func closeButtonAction() {
        freeSpaceInFund = 0
        targetValueInFund = 0
        delegate?.close()
    }
    
    @objc private func percentTextFieldDidChange() {
        guard let text = percentValue.text, text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            percentValue.text = targetValueInFund.toString()
            return
        }
        
        var freeSpace = freeSpaceInFund
        var targetValue = targetValueInFund
        
        guard !text.isEmpty else {
            if freeSpace + targetValue >= maximumFreeSpaceWithThisAsset {
                freeSpace = maximumFreeSpaceWithThisAsset
                updateValuesAndLabel(freeSpaceInFund: freeSpace, targetValue: 0)
            } else {
                freeSpace += targetValue
                targetValue -= targetValue
                updateValuesAndLabel(freeSpaceInFund: freeSpace, targetValue: targetValue)
            }
            return
        }
        
        if let number = Int(text), number >= maximumFreeSpaceWithThisAsset {
            targetValue = maximumFreeSpaceWithThisAsset
            freeSpace = 0
            updateValuesAndLabel(freeSpaceInFund: freeSpace, targetValue: targetValue)
            return
        }
        
        if let number = Int(text) {
            freeSpace = maximumFreeSpaceWithThisAsset
            targetValue = number
            freeSpace -= targetValue
            updateValuesAndLabel(freeSpaceInFund: freeSpace, targetValue: targetValue)
            return
        }
    }
}
