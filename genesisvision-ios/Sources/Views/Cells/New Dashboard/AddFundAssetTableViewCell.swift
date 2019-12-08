//
//  AddFundAssetTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 06.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct AssetModel: Hashable {
    var logo: String?
    var name: String?
    var symbol: String?
    var value: Int?
}

struct AddFundAssetTableViewCellViewModel {
    let assetModel: AssetModel?
    weak var delegate: AddFundAssetTableViewCellProtocol?
}

extension AddFundAssetTableViewCellViewModel: CellViewModel {
    func setup(on cell: AddFundAssetTableViewCell) {
        cell.configure(assetModel, delegate: delegate)
    }
}

protocol AddFundAssetTableViewCellProtocol: class {
    func confirmAsset(_ asset: AssetModel?)
}

class AddFundAssetTableViewCell: UITableViewCell {
    // MARK: - Variables
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.roundCorners()
        }
    }
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var subtitleLabel: SubtitleLabel!
    @IBOutlet weak var textField: DesignableUITextField! {
        didSet {
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var percentLabel: TitleLabel!
    @IBOutlet weak var decrementButton: UIButton! {
        didSet {
            decrementButton.tintColor = UIColor.BaseView.bg
            decrementButton.backgroundColor = UIColor.white
            decrementButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            decrementButton.layer.cornerRadius = Constants.SystemSizes.cornerSize / 2
        }
    }
    @IBOutlet weak var incrementButton: UIButton! {
        didSet {
            incrementButton.tintColor = UIColor.BaseView.bg
            incrementButton.backgroundColor = UIColor.white
            incrementButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            incrementButton.layer.cornerRadius = Constants.SystemSizes.cornerSize / 2
        }
    }
    
    weak var delegate: AddFundAssetTableViewCellProtocol?
    var percentValue: Int = 0
    var assetModel: AssetModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
        contentView.backgroundColor = UIColor.Cell.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.Cell.bg
        
        selectionStyle = .none
    }
    
    func configure(_ assetModel: AssetModel?, delegate: AddFundAssetTableViewCellProtocol?) {
        self.delegate = delegate
        self.assetModel = assetModel
        
        logoImageView.image = #imageLiteral(resourceName: "img_wallet_usdt_icon")
        
        if let logo = assetModel?.logo, let fileUrl = getFileURL(fileName: logo) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl)
        }
        if let name = assetModel?.name {
            titleLabel.text = name
        }
        if let symbol = assetModel?.symbol {
            subtitleLabel.text = symbol
        }
        if let value = assetModel?.value {
            percentValue = value
            textField.text = percentValue.toString()
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        percentValue = Int(textField.text?.doubleValue ?? 0.0)
        assetModel?.value = percentValue
        delegate?.confirmAsset(assetModel)
    }
    
    // MARK: - Actions
    @IBAction func incrementButtonAction(_ sender: UIStepper) {
        if assetModel?.symbol == "GVT" && percentValue > 97 || percentValue > 98 { return }
        
        percentValue += 1
        assetModel?.value = percentValue
        textField.text = percentValue.toString()
        delegate?.confirmAsset(assetModel)
    }
    @IBAction func decrementButtonAction(_ sender: UIStepper) {
        if assetModel?.symbol == "GVT" && percentValue < 2 || percentValue < 1 { return }
        
        percentValue -= 1
        assetModel?.value = percentValue
        textField.text = percentValue.toString()
        delegate?.confirmAsset(assetModel)
    }
}

extension AddFundAssetTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, string != "" else { return true }
        let intValue = text.intValue ?? 0
        
        return intValue >= 0 && intValue < 100
    }
}
