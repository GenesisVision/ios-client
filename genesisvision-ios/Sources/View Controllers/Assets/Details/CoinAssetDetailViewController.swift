//
//  CoinAssetDetailViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 21.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

enum CoinAssetDetailType {
    case buyViewController
    case buyAndSellViewController
}

class CoinAssetDetailViewController : UIViewController {
    
    var viewModel : (CoinAssetDetailViewModelProtocol & CoinAssetDetailViewModelChartProtocol)?
    
    var type : CoinAssetDetailType = .buyViewController
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.backgroundColor = UIColor.BaseView.bg
        }
    }
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chartLabel: UILabel! {
        didSet {
            chartLabel.font = UIFont.getFont(.medium, size: 18)
            chartLabel.textColor = UIColor.Font.primary
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.backgroundColor = UIColor.BaseView.bg
        }
    }
    @IBOutlet weak var intervalCollectionView: UICollectionView! {
        didSet {
            intervalCollectionView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var CandleStickChartView: CandleStickChartView! {
        didSet {
            lineChartViewSetup()
        }
    }
    @IBOutlet weak var buyButtonLabel: UIButton! {
        didSet {
            buyButtonLabel.layer.cornerRadius = 20.0
            buyButtonLabel.backgroundColor = UIColor.Button.green
            buyButtonLabel.titleLabel?.textColor = UIColor.Font.white
            buyButtonLabel.titleLabel?.font = UIFont.getFont(.bold, size: 16)
        }
    }
    @IBOutlet weak var aboutTitleLabel: UILabel! {
        didSet {
            aboutTitleLabel.font = UIFont.getFont(.medium, size: 18)
            aboutTitleLabel.textColor = UIColor.Font.primary
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = UIFont.getFont(.regular, size: 15)
            descriptionLabel.textColor = UIColor.Font.light
        }
    }
    @IBOutlet weak var buttonsStackView: UIStackView! {
        didSet {
            buttonsStackView.alignment = .fill
            buttonsStackView.distribution = .fillEqually
            buttonsStackView.spacing = 8.0
            buttonsStackView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet var constraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var spacingConstraintBetweenButtonAndAboutLabel: NSLayoutConstraint!
    
    @IBOutlet weak var sellAndBuyCoinAssetView: SellAndBuyCoinAssetView!
    
    var isBuyViewController = true
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        CoinAssetRouter.showBuyViewController(portfolioAsset: viewModel?.coinAsset, navigationController: navigationController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuplabels()
        navigationBarSetup()
        setupStackView()
        setupActivityIndicator()
        CandleStickChartView.delegate = self
        intervalCollectionView.delegate = self
        intervalCollectionView.dataSource = self
        intervalCollectionView.register(CoinAssetDetailIntervalCollectionViewCell.self, forCellWithReuseIdentifier: CoinAssetDetailIntervalCollectionViewCell.self.identifier)
        intervalCollectionView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setuplabels()
//        navigationBarSetup()
//        setupStackView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async { [self] in
            var totalHeight: CGFloat = 0.0
            let descriptionLabelHeight = (descriptionLabel.text?.isEmpty ?? false) ? 40 : descriptionLabel.height
            let buttonsStackViewHeight = buttonsStackView.arrangedSubviews.isEmpty ? 20 : buttonsStackView.height
            switch type {
            case .buyViewController:
                totalHeight = chartLabel.height + intervalCollectionView.height + CandleStickChartView.height + buyButtonLabel.height + aboutTitleLabel.height + descriptionLabelHeight + buttonsStackViewHeight
            case .buyAndSellViewController:
                totalHeight = chartLabel.height + intervalCollectionView.height + CandleStickChartView.height + sellAndBuyCoinAssetView.height + aboutTitleLabel.height + descriptionLabelHeight + buttonsStackViewHeight
            }
            let constraintsConstats = constraints.map({$0.map({$0.constant})})
            let totalHeightOfConstraints = constraintsConstats?.reduce(0, +)
            print(descriptionLabel.height, buttonsStackView.height)
            scrollView.contentSize.height = totalHeight + (totalHeightOfConstraints ?? 90) + 20
            contentViewHeightConstraint.constant = totalHeight + (totalHeightOfConstraints ?? 90) + 20
        }
    }
    
    func setuplabels() {
        guard let asset = viewModel?.coinAsset else { return }
        DispatchQueue.main.async { [self] in
            self.descriptionLabel.text = asset.details?._description
            self.aboutTitleLabel.text = Constants.CoinAssetsConstants.about + " " + (asset.name ?? "")
            if let tickerSymbol = viewModel?.tickerSymbol {
                self.chartLabel.text = Constants.CoinAssetsConstants.chart + " " + tickerSymbol
            }
        }
    }
    
    func setupStackView() {
        guard let asset = viewModel?.coinAsset,
              let links = asset.details?.socialLinks else { return }
        DispatchQueue.main.async {
            for link in links {
                guard let imageLogoURL = link.logoUrl, let logoURL = URL(string: imageLogoURL), let url = link.url else { return }
                guard let data = try? Data(contentsOf: logoURL) else { return }
                let button = ButtonWithURL(url: url)
                let image = UIImage(data: data)
                button.setImage(image, for: .normal)
                button.addTarget(self, action: #selector(self.linkButtonTapped(_:)), for: .touchUpInside)
                button.isUserInteractionEnabled = true
                self.buttonsStackView.addArrangedSubview(button)
            }
        }
    }
    
    @objc func linkButtonTapped(_ sender : UIButton) {
        guard let url = (sender as? ButtonWithURL)?.url else { return }
        openSafariVC(with: url)
    }
    
    func navigationBarSetup() {
        guard let asset = viewModel?.coinAsset else { return }
        DispatchQueue.main.async {
            let logoAndTitle = UIView()
            let label : UILabel = {
                let label = UILabel()
                label.text = " " + (asset.name ?? "") + " | " + (asset.details?.symbol ?? "")
                label.textColor = UIColor.Font.white
                label.font = UIFont.getFont(.semibold, size: 20)
                label.sizeToFit()
                label.center = logoAndTitle.center
                label.textAlignment = NSTextAlignment.center
                return label
            }()
            let logo : UIImageView = {
                let logo = UIImageView()
                guard let stringURL = asset.logoUrl,
                      let url = URL(string: stringURL),
                      let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data) else { return logo }
                logo.image = image
                let imageAspect = image.size.width/image.size.height
                logo.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
                logo.contentMode = UIView.ContentMode.scaleAspectFit
                logo.layer.cornerRadius = logo.frame.height/2
                logo.clipsToBounds = true
                return logo
            }()
            logoAndTitle.addSubview(label)
            logoAndTitle.addSubview(logo)
            self.navigationItem.titleView = logoAndTitle
        }
    }
    
    func setupActivityIndicator() {
        DispatchQueue.main.async {
            if #available(iOS 13, *) {
                self.activityIndicator = UIActivityIndicatorView(style: .large)
            } else {
                self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            }
            self.contentView.addSubview(self.activityIndicator)
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.CandleStickChartView.centerXAnchor).isActive = true
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.CandleStickChartView.centerYAnchor).isActive = true
            self.activityIndicator.startAnimating()
        }
    }
    
    func setupBuyAndSellView(assetPortfolio: CoinsAsset) {
        type = .buyAndSellViewController
        sellAndBuyCoinAssetView.configure(assetPortfolio: assetPortfolio)
        buyButtonLabel.isHidden = true
        sellAndBuyCoinAssetView.isHidden = false
        spacingConstraintBetweenButtonAndAboutLabel.isActive = false
        aboutTitleLabel.topAnchor.constraint(equalTo: sellAndBuyCoinAssetView.bottomAnchor, constant: 10).isActive = true
//        scrollView.contentSize.height += sellAndBuyCoinAssetView.height - buyButtonLabel.height
        sellAndBuyCoinAssetView.buyButtonLabel.addTarget(self, action: #selector(buyCoinAsset), for: .touchUpInside)
        sellAndBuyCoinAssetView.sellButtonLabel.addTarget(self, action: #selector(sellCoinAsset), for: .touchUpInside)
    }
    
    func setupBuyButtonView() {
        type = .buyViewController
        buyButtonLabel.isHidden = false
        sellAndBuyCoinAssetView.isHidden = true
        spacingConstraintBetweenButtonAndAboutLabel.isActive = true
        aboutTitleLabel.topAnchor.constraint(equalTo: sellAndBuyCoinAssetView.bottomAnchor, constant: 10).isActive = false
    }
    
    @objc func buyCoinAsset() {
        CoinAssetRouter.showBuyViewController(portfolioAsset: viewModel?.portfolio, navigationController: navigationController)
    }
    
    @objc func sellCoinAsset() {
        CoinAssetRouter.showSellViewController(portfolioAsset: viewModel?.portfolio, navigationController: navigationController)
    }
}

extension CoinAssetDetailViewController : ChartViewDelegateProtocol, ChartViewDelegate {
    
    func lineChartViewSetup() {
        DispatchQueue.main.async { [self] in
            CandleStickChartView.backgroundColor = UIColor.BaseView.bg
            CandleStickChartView.leftAxis.enabled = false
            CandleStickChartView.xAxis.setLabelCount(5, force: false)
            CandleStickChartView.rightAxis.setLabelCount(8, force: false)
            CandleStickChartView.xAxis.labelPosition = .bottom
            CandleStickChartView.xAxis.labelTextColor = .white
            CandleStickChartView.rightAxis.labelTextColor = .white
            
            CandleStickChartView.animate(xAxisDuration: 0.8)
            CandleStickChartView.noDataText = ""
            CandleStickChartView.zoomIn()
            CandleStickChartView.dragEnabled = true
            CandleStickChartView.pinchZoomEnabled = true
            CandleStickChartView.legend.enabled = false
            CandleStickChartView.tintColor = .white
            //        CandleStickChartView.setScaleEnabled(true)
            //        CandleStickChartView.maxVisibleCount = 200
            //        CandleStickChartView.legend.horizontalAlignment = .right
            //        CandleStickChartView.legend.verticalAlignment = .top
            //        CandleStickChartView.legend.orientation = .vertical
            //        CandleStickChartView.legend.drawInside = false
            //        CandleStickChartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
            //        CandleStickChartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
            //        CandleStickChartView.leftAxis.spaceTop = 0.3
            //        CandleStickChartView.leftAxis.spaceBottom = 0.3
            //        CandleStickChartView.leftAxis.axisMinimum = 0
            //        CandleStickChartView.rightAxis.enabled = false
            //        CandleStickChartView.xAxis.labelPosition = .bottom
            //        CandleStickChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        }
    }
    
    func pushDataToChartView(dataSet : CandleChartDataSet, xAxisValueFormatter : MyXAxisFormatter) {
        DispatchQueue.main.async {
            dataSet.axisDependency = .left
            dataSet.drawIconsEnabled = false
            dataSet.shadowColorSameAsCandle = true
            dataSet.shadowWidth = 0.7
            dataSet.decreasingColor = .red
            dataSet.decreasingFilled = true
            dataSet.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
            dataSet.increasingFilled = true
            dataSet.neutralColor = .blue
            
            let data = CandleChartData(dataSet: dataSet)
            data.setDrawValues(false)
            self.CandleStickChartView.data = data
            self.CandleStickChartView.xAxis.valueFormatter = xAxisValueFormatter
            self.CandleStickChartView.reloadInputViews()
            self.activityIndicator.stopAnimating()
        }
    }
}

extension CoinAssetDetailViewController: AssetPortfolioDelegateProtocol {
    func pushPortfolioData(assetPortfolio: CoinsAsset?) {
        if let assetPortfolio = assetPortfolio {
            setupBuyAndSellView(assetPortfolio: assetPortfolio)
        } else {
            if buyButtonLabel.isHidden {
                setupBuyButtonView()
            }
        }
    }
}

extension CoinAssetDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.intervals.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = intervalCollectionView.dequeueReusableCell(withReuseIdentifier: CoinAssetDetailIntervalCollectionViewCell.self.identifier, for: indexPath) as! CoinAssetDetailIntervalCollectionViewCell
        guard let interval = viewModel?.intervals[indexPath.item] else { return UICollectionViewCell()}
        cell.configure(button: interval)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.activityIndicator.startAnimating()
        viewModel?.setupIntervalButtons(indexPath : indexPath)
        intervalCollectionView.reloadData()
        viewModel?.updateChartValues(indexPath: indexPath)
    }
}
