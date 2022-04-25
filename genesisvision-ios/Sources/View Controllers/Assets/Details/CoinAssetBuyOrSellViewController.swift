//
//  CoinAssetBuyViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 28.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class CoinAssetBuyOrSellViewController : BaseViewController {
    
    @IBOutlet weak var currencyLogoImage: UIImageView!
    
    @IBOutlet weak var currencyTitle: LargeTitleLabel!
    
    @IBOutlet weak var currencyValueLabel: TitleLabel!
    
    @IBOutlet weak var fromLabel: SubtitleLabel!
    
    @IBOutlet weak var walletLogoImage: UIImageView!
    
    @IBOutlet weak var walletLabel: TitleLabel!
    
    @IBOutlet weak var walletButtonLabel: UIButton!
    
    @IBOutlet weak var availableInWalletTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var availableInWalletValueLabel: TitleLabel!
    
    @IBOutlet weak var amountTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var amountValueLabel: TitleLabel!
    
    @IBOutlet weak var amountCurrencyLabel: SubtitleLabel!
    
    @IBOutlet weak var currencyRateLabel: SubtitleLabel!
    
    @IBOutlet weak var feeLabel: SubtitleLabel!
    
    @IBOutlet weak var feeValueLabel: TitleLabel!
    
    @IBOutlet weak var withdrawingLabel: SubtitleLabel!
    
    @IBOutlet weak var withdrawingValueLabel: TitleLabel!
    
    @IBOutlet weak var disclaimer: SubtitleLabel! {
        didSet {
            disclaimer.text = Constants.CoinAssetsConstants.disclaimer
        }
    }
    
    @IBOutlet weak var confirmButtonLabel: ActionButton!
    
    
    @IBOutlet weak var firstView: UIView! {
        didSet {
            firstView.backgroundColor = UIColor.BaseView.bg
        }
    }
    
    
    @IBOutlet weak var secondView: UIView! {
        didSet {
            secondView.backgroundColor = UIColor.Common.darkCell
            secondView.isOpaque = true
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var numpadBackView: GradientView! {
        didSet {
            numpadBackView.isHidden = true
            numpadBackView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideNumpadView))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.delegate = self
            numpadBackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.isUserInteractionEnabled = true
            numpadView.delegate = self
            numpadView.type = .currency
        }
    }
    
    @IBOutlet weak var numpadHeightConstraint: NSLayoutConstraint! {
        didSet {
            numpadHeightConstraint.constant = 0.0
        }
    }
    
    @IBAction func maxButtonTapped(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        if viewModel.isBuyVC {
            amountValueLabel.text = availableInWalletValue.toString()
            amountValue = availableInWalletValue
        } else {
            guard let assetAvailable = viewModel.coinAsset?.amount else { return }
            amountValueLabel.text = assetAvailable.toString()
            amountValue = assetAvailable
        }
        updateUI()
    }
    
    var amountValue: Double {
        get {
            viewModel?.amount ?? 0.0
        }
        set {
            viewModel?.amount = newValue
        }
    }
    
    var availableInWalletValue: Double = 0.0 {
        didSet {
            if let currency = viewModel?.wallet?.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                self.availableInWalletValueLabel.text = availableInWalletValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
            }
        }
    }
    
    var viewModel : CoinAssetBuyAndSellViewModelProtocol?
    
    var labelPlaceholder: String = "0"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMainCoinlabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupWallet(currency: viewModel?.currency)
        setupTriange()
    }
    
    private func setup() {
        confirmButtonLabel.setEnabled(false)
        if viewModel != nil {
            viewModel?.alertControllerDelegate = self
        }
        guard let isBuyVC = viewModel?.isBuyVC else {
            return}
        switch isBuyVC {
        case true:
            navigationItem.title = "Buy"
        case false:
            navigationItem.title = "Sell"
        }
    }
    
    func setupMainCoinlabels() {
        guard let viewModel = viewModel, let asset = viewModel.coinAsset else { return }
        DispatchQueue.main.async { [self] in
            if let stringURL = asset.logoUrl, let url = URL(string: stringURL), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.currencyLogoImage.image = image
            }
            currencyTitle.text = asset.name
            
            switch viewModel.isBuyVC {
            case true:
                fromLabel.text = Constants.CoinAssetsConstants.from
            case false:
                fromLabel.text = Constants.CoinAssetsConstants.to
            }
        }
    }
    
    func setupWallet(currency: Currency?) {
        viewModel?.getWalletSummary(currency: currency, completion: { wallet in
            self.updateUI()
        }, completionError: { result in
            print(result)
        })
    }
    //MARK: - TODO Постоянно облновлять только некоторые лейблы, неизменные вынести в одиночный метод
    func updateUI() {
        guard let viewModel = self.viewModel, let wallet = viewModel.wallet else { return }
        self.availableInWalletTitleLabel.text = WalletBalanceType.available.rawValue
        if let available = wallet.available, let currency = wallet.currency?.rawValue {
            self.availableInWalletValueLabel.text = available.toString() + " " + (currency)
            self.availableInWalletValue = available
//            self.amountCurrencyLabel.text = currency
        }
        
        if viewModel.isBuyVC {
            let currency = wallet.currency?.rawValue
            self.amountCurrencyLabel.text = currency
            let confirmButtonEnabled = amountValue > 0.0 && amountValue <= availableInWalletValue
            confirmButtonLabel?.setEnabled(confirmButtonEnabled)
        } else {
            let assetCurrency = viewModel.coinAsset?.asset
            self.amountCurrencyLabel.text = assetCurrency
            guard let assetAvailable = viewModel.coinAsset?.amount else { return }
            let confirmButtonEnabled = amountValue > 0.0 && amountValue <= assetAvailable
            confirmButtonLabel?.setEnabled(confirmButtonEnabled)
        }
        
        let commission = viewModel.commission
        if let currency = viewModel.isBuyVC ? viewModel.coinAsset?.asset : wallet.currency?.rawValue {
            if viewModel.whatUserGetValue > commission {
                var value = viewModel.whatUserGetValue
                value = value > 0.0 ? value : 0.0
                self.withdrawingValueLabel.text = "≈" + value.toString() + " " + currency
                feeValueLabel.text = "≈" + commission.toString() + " " + currency
            } else {
                self.withdrawingValueLabel.text = "0 " + currency
                feeValueLabel.text = commission.toString() + " " + currency
            }
        }
        
        amountTitleLabel.text = Constants.CoinAssetsConstants.enterAmount
//        amountValueLabel.text = amountValue.toString()
        
        if let rate = viewModel.rate, let currency = wallet.currency?.rawValue, let assetCurrency = viewModel.coinAsset?.asset {
            if viewModel.isBuyVC {
                currencyRateLabel.text = "1 " + currency + " = " + rate.toString() + " " + assetCurrency
            } else {
                currencyRateLabel.text = "1 " + assetCurrency + " = " + rate.toString() + " " + currency
            }
        }
        
        if let logo = wallet.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            self.walletLogoImage.kf.setImage(with: fileUrl)
        }
        self.walletLabel.text = wallet.title
        if let walletDepositCurrencyDelegateManager = viewModel.walletDepositCurrencyDelegate {
            walletDepositCurrencyDelegateManager.currencyDelegate = self
        }
        
        if let assetAvailable = viewModel.coinAsset?.amount, let currency = viewModel.coinAsset?.asset {
            currencyValueLabel.text = assetAvailable.toString() + " " + currency
        }
//        let confirmButtonEnabled = amountValue > 0.0 && amountValue <= availableInWalletValue
//        confirmButtonLabel?.setEnabled(confirmButtonEnabled)
    }
    
    func setupTriange() {
        guard let viewModel = viewModel else { return }
        let triangle = UIView()
        triangle.translatesAutoresizingMaskIntoConstraints = false
        
        let heightWidth = 30
        let path = CGMutablePath()
        
        if viewModel.isBuyVC {
            path.move(to: CGPoint(x: 0, y: heightWidth))
            path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
            path.addLine(to: CGPoint(x:heightWidth, y:heightWidth))
            path.addLine(to: CGPoint(x:0, y:heightWidth))
            firstView.addSubview(triangle)
            triangle.bottomAnchor.constraint(equalTo: firstView.bottomAnchor).isActive = true
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
            path.addLine(to: CGPoint(x:heightWidth, y:0))
            path.addLine(to: CGPoint(x:0, y:0))
            secondView.addSubview(triangle)
            triangle.topAnchor.constraint(equalTo: secondView.topAnchor).isActive = true
        }
        triangle.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        triangle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        triangle.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = viewModel.isBuyVC ? UIColor.Common.darkCell.cgColor : UIColor.BaseView.bg.cgColor
        
        triangle.layer.insertSublayer(shape, at: 0)
    }
    
    @IBAction func selectWalletButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        viewModel?.walletDepositCurrencyDelegate?.updateSelectedIndex()
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(Constants.CoinAssetsConstants.selectAWallet)

        bottomSheetController.addTableView { [weak self] tableView in
            self?.viewModel?.walletDepositCurrencyDelegate?.tableView = tableView
            tableView.separatorStyle = .none

            guard let walletCurrencyDelegateManager = self?.viewModel?.walletDepositCurrencyDelegate else { return }
            tableView.registerNibs(for: walletCurrencyDelegateManager.cellModelsForRegistration)
            tableView.delegate = walletCurrencyDelegateManager
            tableView.dataSource = walletCurrencyDelegateManager
        }

        bottomSheetController.present()
    }
    
    @IBAction func showNumPadButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        numpadHeightConstraint.constant = 212.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.currencyRateLabel.frame.maxY), animated: true)
            self.numpadBackView.layoutIfNeeded()
        })
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        viewModel?.transfer(navigationController: navigationController)
    }
    
    
    @objc private func hideNumpadView() {
        numpadHeightConstraint.constant = 0.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.frame.minY), animated: true)
            self.numpadBackView.layoutIfNeeded()
        })
    }
}

extension CoinAssetBuyOrSellViewController : WalletDelegateManagerProtocol {
    func didSelectWallet(at indexPath: IndexPath, walletId: Int) {
        self.viewModel?.updateSelectedWallet(index: indexPath.row)
        amountValueLabel.text = amountValue.toString()
        updateUI()
        bottomSheetController.dismiss()
    }
}

extension CoinAssetBuyOrSellViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        guard let viewModel = viewModel else { return availableInWalletValue }
        if viewModel.isBuyVC {
            return availableInWalletValue
        } else {
            return viewModel.coinAsset?.amount
        }
    }
    
    var textPlaceholder: String? {
        return labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return -1
    }
    
    var currency: CurrencyType? {
        if let currency = viewModel?.wallet?.currency {
            return CurrencyType(rawValue: currency.rawValue)
        }
        
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountValueLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let viewModel = viewModel, let value = value else { return }
        if viewModel.isBuyVC {
            guard value <= availableInWalletValue else { return }
        } else {
            guard let amount = viewModel.coinAsset?.amount, value <= amount else { return }
        }
        numpadView.isEnable = true
        amountValue = value
        updateUI()
    }
}
extension CoinAssetBuyOrSellViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

extension CoinAssetBuyOrSellViewController : AlertControllerDelegateProtocol {
    func showAlert(title: String?, massage: String?) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        self.present(viewController: alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
           alert.dismiss(animated: true, completion: nil)
         })
    }
}
