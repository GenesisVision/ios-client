//
//  AuthTwoFactorTutorialViewController.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class AuthTwoFactorTutorialViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: AuthTwoFactorTutorialViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Variables
    var didLoaded: Bool = false
    var stackViews = [UIStackView]()
    
    // MARK: - Actions
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.nextStep()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateLayout()
    }
    
    // MARK: - Private methods
    private func setup() {
        configureScrolView()
        configurePageControl()
    }
    
    private func configureScrolView() {
        let tutorialTopTitles = String.ViewTitles.TwoFactor.tutorialTopTitles
        let tutorialBottomTitles = String.ViewTitles.TwoFactor.tutorialBottomTitles
        
        for idx in 0..<viewModel.numberOfPages {
            let topLabel = UILabel(frame: .zero)
            topLabel.lineBreakMode = .byWordWrapping
            topLabel.numberOfLines = 3
            topLabel.textAlignment = .center
            topLabel.font = UIFont.getFont(.regular, size: 19.0)
            topLabel.textColor = UIColor.TwoFactor.title
            topLabel.text = tutorialTopTitles[idx]
            topLabel.sizeToFit()
            
            let image = UIImage(named: "img_2fa_tutorial_\(idx).png")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            let bottomLabel = UILabel(frame: .zero)
            bottomLabel.lineBreakMode = .byWordWrapping
            bottomLabel.numberOfLines = 3
            bottomLabel.textAlignment = .center
            bottomLabel.font = UIFont.getFont(.regular, size: 19.0)
            bottomLabel.textColor = UIColor.TwoFactor.title
            bottomLabel.text = tutorialBottomTitles[idx]
            bottomLabel.sizeToFit()
            
            let stackView = UIStackView(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = 8.0
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.addArrangedSubview(topLabel)
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(bottomLabel)
            stackViews.append(stackView)
            
            topLabel.translatesAutoresizingMaskIntoConstraints = false
            topLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            topLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16.0).isActive = true
            topLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16.0).isActive = true
            
            bottomLabel.translatesAutoresizingMaskIntoConstraints = false
            bottomLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            bottomLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16.0).isActive = true
            bottomLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16.0).isActive = true
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func updateLayout() {
        for idx in 0..<stackViews.count {
            var frame = CGRect.zero
            frame.origin.x = scrollView.frame.size.width * CGFloat(idx)
            frame.origin.y = 0.0
            frame.size = scrollView.frame.size
            
            let stackView = stackViews[idx]
            stackView.frame = frame
            scrollView.addSubview(stackView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(viewModel.numberOfPages), height: scrollView.frame.size.height)
    }
    
    private func configurePageControl() {
        pageControl.numberOfPages = viewModel.numberOfPages
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.TwoFactor.pageControllTint
        pageControl.pageIndicatorTintColor = UIColor.TwoFactor.pageControllPageIndicatorTint
        pageControl.currentPageIndicatorTintColor = UIColor.TwoFactor.pageControllCurrentPageIndicatorTint
        pageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
    }
    
    @objc private func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}

extension AuthTwoFactorTutorialViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
