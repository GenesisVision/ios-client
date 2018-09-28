//
//  BottomSheet.swift
//  genesisvision-ios
//
//  Created by George on 05/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol BottomSheetControllerProtocol: class {
    func didHide()
    func didShowAll()
}

extension BottomSheetControllerProtocol {
    func didHide() {
        
    }
    func didShowAll() {
        
    }
}

public typealias BottomSheetController = BottomSheet.Controller
typealias BottomSheetTransitionAnimator = BottomSheet.TransitionAnimator

open class BottomSheet {
    open class Controller: UIViewController {
        public enum OverlayViewActionType {
            case swipe
            case tappedPresent
            case tappedDismiss
        }
        
        public enum ViewType {
            case bottomSheet
            case bottomView
        }
        
        fileprivate enum State {
            case hide
            case show
            case showAll
        }
        
        // MARK: - Open property
        weak var bottomSheetControllerProtocol: BottomSheetControllerProtocol?
        open var cornerRadius: CGFloat = 15.0
        open var initializeHeight: CGFloat = 300 {
            didSet {
                containerViewHeightConstraint?.constant = initializeHeight
            }
        }
        open var viewActionType: OverlayViewActionType = .tappedDismiss
        open var viewType: ViewType = .bottomSheet
        open var duration: (hide: TimeInterval, show: TimeInterval, showAll: TimeInterval) = (0.3, 0.3, 0.3)
        open var overlayBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6) {
            didSet {
                overlayView.backgroundColor = overlayBackgroundColor
            }
        }
        open var containerViewBackgroundColor: UIColor? {
            set { containerView.backgroundColor = newValue }
            get { return containerView.backgroundColor }
        }
        
        open var tintColor: UIColor? = UIColor.Cell.title
        open var titleTextColor: UIColor? = UIColor.Cell.title
        open var subtitleTextColor: UIColor? = UIColor.Cell.subtitle
        public let overlayView = UIView()
        public let containerView = UIView()
        open var isScrollEnabled: Bool = false
        // MARK: - Private property
        fileprivate let overlayViewPanGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        fileprivate let overlayViewTapGestureRecognizer: UITapGestureRecognizer = {
            let gestureRecognizer = UITapGestureRecognizer()
            return gestureRecognizer
        }()
        fileprivate let panGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        fileprivate let barGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        fileprivate var containerViewHeightConstraint: NSLayoutConstraint?
        fileprivate var state: State = .hide {
            didSet { newState(state) }
        }
        fileprivate var isNeedLayout = true
        fileprivate var lineView = UIView() {
            didSet {
                lineView.isUserInteractionEnabled = false
            }
        }
        fileprivate var bar: UIView?
        fileprivate var contentView: UIView?
        fileprivate var scrollView: UIScrollView?
        fileprivate var isScrollEnabledInSheet: Bool = true
        fileprivate var hasBar: Bool {
            if let _ = bar {
                return true
            }
            return false
        }
        fileprivate var hasView: Bool {
            if let _ = contentView {
                return true
            } else if let _ = scrollView {
                return true
            }
            return false
        }
        fileprivate var maxHeight: CGFloat {
            return view.frame.height
        }
        fileprivate var moveRange: (down: CGFloat, up: CGFloat) {
            return (initializeHeight / 3, initializeHeight / 3)
        }
        private var statusBarHeight: CGFloat {
            return UIApplication.shared.statusBarFrame.height
        }
        fileprivate lazy var navigationBarHeight: CGFloat = {
            return UINavigationBar().intrinsicContentSize.height
        }()
        // MARK: - Initialize
        public convenience init() {
            self.init(nibName: nil, bundle: nil)
            
            configure()
            configureConstraints()
        }
        
        // MARK: - Open method
        open func present() {
            let window = UIApplication.shared.windows[0] as UIWindow
            if let vc = window.rootViewController {
                DispatchQueue.main.async {
                    vc.present(self, animated: true, completion: nil)
                }
            }
        }

        // Adds UIToolbar
        open func addToolbar(_ configurationHandler: ((UIToolbar) -> Void)? = nil) {
            guard !hasBar else { fatalError("UIToolbar or UINavigationBar can only have one") }
            let toolbar = UIToolbar()
            toolbar.isTranslucent = false
            toolbar.backgroundColor = containerViewBackgroundColor
            toolbar.tintColor = tintColor
            toolbar.barTintColor = containerViewBackgroundColor
            containerView.addSubview(toolbar)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = NSLayoutConstraint(item: toolbar,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: lineView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
            let rightConstraint = NSLayoutConstraint(item: toolbar,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: containerView,
                                                     attribute: .right,
                                                     multiplier: 1,
                                                     constant: 0)
            let leftConstraint = NSLayoutConstraint(item: toolbar,
                                                    attribute: .left,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .left,
                                                    multiplier: 1,
                                                    constant: 0)
            let heightConstraint = NSLayoutConstraint(item: toolbar,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .height,
                                                      multiplier: 1,
                                                      constant: navigationBarHeight + statusBarHeight)
            
            containerView.addConstraints([topConstraint, rightConstraint, leftConstraint, heightConstraint])
            configurationHandler?(toolbar)
            self.bar = toolbar
        }
        
        // Adds UINavigationbar
        open func addNavigationBar(_ title: String? = nil,
                                   subtitle: String? = nil,
                                   buttonTitle: String? = nil,
                                   buttonSelectedTitle: String? = nil,
                                   normalImage: UIImage? = nil,
                                   selectedImage: UIImage? = nil,
                                   buttonAction: Selector? = nil,
                                   buttonTarget: Any? = nil,
                                   buttonSelected: Bool = false,
                                   _  configurationHandler: ((UINavigationBar) -> Void)? = nil) {
            
            guard !hasBar else { fatalError("UIToolbar or UINavigationBar can only have one") }
            let navigationBar = UINavigationBar()
            navigationBar.isTranslucent = false
            navigationBar.backgroundColor = containerViewBackgroundColor
            navigationBar.tintColor = tintColor
            navigationBar.barTintColor = containerViewBackgroundColor
            
            let item = UINavigationItem(title: "")
            
            if let title = title {
                let label = UILabel()
                label.textColor = titleTextColor
                label.text = title
                label.font = UIFont.getFont(.bold, size: 19)
                item.leftBarButtonItem = UIBarButtonItem(customView: label)
            }
            
            if let subtitle = subtitle {
                let label = UILabel()
                label.textColor = subtitleTextColor
                label.text = subtitle
                label.font = UIFont.getFont(.regular, size: 15)
                item.rightBarButtonItem = UIBarButtonItem(customView: label)
            }
            
            if let buttonTitle = buttonTitle {
                let btn = UIButton(type: .custom)
                
                if buttonSelected, let selectedImage = selectedImage {
                    btn.setImage(selectedImage.withRenderingMode(.alwaysTemplate), for: .normal)
                } else if let normalImage = normalImage {
                    btn.setImage(normalImage.withRenderingMode(.alwaysTemplate), for: .normal)
                }
                
                btn.contentHorizontalAlignment = .right
                
                btn.isSelected = buttonSelected
                
                let spacing = CGFloat(4)
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, spacing)
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, -spacing)
                
                btn.setTitle(buttonSelected ? buttonSelectedTitle : buttonTitle, for: .normal)
                btn.tintColor = tintColor
                btn.sizeToFit()
                
                if let buttonAction = buttonAction {
                    btn.addTarget(buttonTarget, action: buttonAction, for: .touchUpInside)
                }
                
                let rightButton = UIBarButtonItem(customView: btn)
                item.rightBarButtonItem = rightButton
            }
            
            navigationBar.items = [item]
            
            containerView.addSubview(navigationBar)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = NSLayoutConstraint(item: navigationBar,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: lineView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
            let rightConstraint = NSLayoutConstraint(item: navigationBar,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: containerView,
                                                     attribute: .right,
                                                     multiplier: 1,
                                                     constant: 0)
            let leftConstraint = NSLayoutConstraint(item: navigationBar,
                                                    attribute: .left,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .left,
                                                    multiplier: 1,
                                                    constant: 0)
            let heightConstraint = NSLayoutConstraint(item: navigationBar,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .height,
                                                      multiplier: 1,
                                                      constant: navigationBarHeight)
            containerView.addConstraints([topConstraint, rightConstraint, leftConstraint, heightConstraint])
            configurationHandler?(navigationBar)
            self.bar = navigationBar
        }
        
        // Adds ContentsView
        open func addContentsView(isScrollEnabledInSheet: Bool = true, _ contentView: UIView) {
            guard !hasView else { fatalError("ContainerView can only have one") }
            self.isScrollEnabledInSheet = isScrollEnabledInSheet
            containerView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = NSLayoutConstraint(item: contentView,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: hasBar ? bar : lineView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 8)
            let rightConstraint = NSLayoutConstraint(item: contentView,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: containerView,
                                                     attribute: .right,
                                                     multiplier: 1,
                                                     constant: 0)
            let leftConstraint = NSLayoutConstraint(item: contentView,
                                                    attribute: .left,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .left,
                                                    multiplier: 1,
                                                    constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: contentView,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: containerView,
                                                      attribute: .bottom,
                                                      multiplier: 1,
                                                      constant: 0)
            containerView.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
            self.contentView = contentView
        }
        
        // Adds UIScrollView
        open func addScrollView(isScrollEnabledInSheet: Bool = true, configurationHandler: ((UIScrollView) -> Void)) {
            guard !hasView else { fatalError("ContainerView can only have one \(containerView.subviews)") }
            self.isScrollEnabledInSheet = isScrollEnabledInSheet
            let scrollView = UIScrollView()
            scrollView.backgroundColor = containerViewBackgroundColor
            scrollView.tintColor = tintColor
            containerView.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            configurationHandler(scrollView)
            let topConstraint = NSLayoutConstraint(item: scrollView,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: hasBar ? bar : lineView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 8)
            let rightConstraint = NSLayoutConstraint(item: scrollView,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: containerView,
                                                     attribute: .right,
                                                     multiplier: 1,
                                                     constant: 0)
            let leftConstraint = NSLayoutConstraint(item: scrollView,
                                                    attribute: .left,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .left,
                                                    multiplier: 1,
                                                    constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: scrollView,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: containerView,
                                                      attribute: .bottom,
                                                      multiplier: 1,
                                                      constant: 0)
            containerView.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
            self.scrollView = scrollView
        }
        
        // Adds UICollectionView
        open func addCollectionView(isScrollEnabledInSheet: Bool = true, flowLayout: UICollectionViewFlowLayout? = nil, configurationHandler: ((UICollectionView) -> Void)) {
            guard !hasView else { fatalError("ContainerView can only have one \(containerView.subviews)") }
            self.isScrollEnabledInSheet = isScrollEnabledInSheet
            let collectionView: UICollectionView
            if let flowLayout = flowLayout {
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            } else {
                let flowLayout = UICollectionViewFlowLayout()
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            }
            collectionView.backgroundColor = containerViewBackgroundColor
            collectionView.tintColor = tintColor
            
            containerView.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            configurationHandler(collectionView)
            let topConstraint = NSLayoutConstraint(item: collectionView,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: hasBar ? bar : lineView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 8)
            let rightConstraint = NSLayoutConstraint(item: collectionView,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: containerView,
                                                     attribute: .right,
                                                     multiplier: 1,
                                                     constant: 0)
            let leftConstraint = NSLayoutConstraint(item: collectionView,
                                                    attribute: .left,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .left,
                                                    multiplier: 1,
                                                    constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: collectionView,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: containerView,
                                                      attribute: .bottom,
                                                      multiplier: 1,
                                                      constant: 0)
            containerView.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
            collectionView.reloadData()
            self.scrollView = collectionView
        }
        
        // Adds UITableView
        open func addTableView(isScrollEnabledInSheet: Bool = true, configurationHandler: ((UITableView) -> Void)) {
            guard !hasView else { fatalError("ContainerView can only have one \(containerView.subviews)") }
            self.isScrollEnabledInSheet = isScrollEnabledInSheet
            let tableView = UITableView(frame: .zero)
            tableView.backgroundColor = containerViewBackgroundColor
            tableView.tintColor = tintColor
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(tableView)
            configurationHandler(tableView)
            let topConstraint = NSLayoutConstraint(item: tableView,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: hasBar ? bar : lineView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 8)
            let rightConstraint = NSLayoutConstraint(item: tableView,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: containerView,
                                                     attribute: .right,
                                                     multiplier: 1,
                                                     constant: 0)
            let leftConstraint = NSLayoutConstraint(item: tableView,
                                                    attribute: .left,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .left,
                                                    multiplier: 1,
                                                    constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: tableView,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: containerView,
                                                      attribute: .bottom,
                                                      multiplier: 1,
                                                      constant: 0)
            containerView.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
            tableView.reloadData()
            self.scrollView = tableView
        }
        
        // Life cycle
        open override func viewDidLoad() {
            super.viewDidLoad()
            if #available(iOS 11.0, *) {
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
            overlayView.backgroundColor = overlayBackgroundColor
            containerView.backgroundColor = containerViewBackgroundColor
            state = .hide
        }
        open override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            adjustLayout()
        }
        
        // Action
        open func present(_ sender: AnyObject? = nil) {
            state = .showAll
            bottomSheetControllerProtocol?.didShowAll()
        }
        open func dismiss(_ sender: AnyObject? = nil) {
            state = .hide
            bottomSheetControllerProtocol?.didHide()
        }
        @objc dynamic func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            switch viewActionType {
            case .tappedPresent:
                present()
            case .tappedDismiss:
                dismiss()
            default:
                break
            }
        }
        @objc dynamic func handleGestureDragging(_ gestureRecognizer: UIPanGestureRecognizer) {
            let gestureView = gestureRecognizer.view
            let point = gestureRecognizer.translation(in: gestureView)
            let originY = maxHeight - initializeHeight
            switch state {
            case .show:
                switch gestureRecognizer.state {
                case .began:
                    scrollView?.isScrollEnabled = false
                case .changed:
                    
                    if ((containerViewHeightConstraint?.constant ?? 0) - initializeHeight > moveRange.up) && !isScrollEnabled {
                        return
                    }
                    
                    containerView.frame.origin.y = max(0, containerView.frame.origin.y + point.y)
                    containerViewHeightConstraint?.constant = max(initializeHeight, maxHeight - containerView.frame.origin.y)
                    gestureRecognizer.setTranslation(.zero, in: gestureView)
                case .ended, .cancelled:
                    scrollView?.isScrollEnabled = true
                    
                    if containerView.frame.origin.y - originY > moveRange.down {
                        dismiss()
                    } else if ((containerViewHeightConstraint?.constant ?? 0) - initializeHeight > moveRange.up) && isScrollEnabled {
                        present()
                    } else {
                        let animations = {
                            self.containerView.frame.origin.y = originY
                        }
                        UIView.perform(.delete, on: [], options: [], animations: animations, completion: { (value) in
                            DispatchQueue.main.async {
                                self.containerViewHeightConstraint?.constant = max(self.initializeHeight, self.maxHeight - self.containerView.frame.origin.y)
                            }
                        })
                    }
                default:
                    break
                }
                let rate = (containerView.frame.origin.y - (originY))  / (containerView.frame.height)
                overlayView.alpha = max(0, min(1, (1 - rate)))
            case .showAll:
                switch gestureRecognizer.state {
                case .began:
                    scrollView?.isScrollEnabled = false
                case .changed:
                    let currentTransformY = containerView.transform.ty
                    containerView.transform = CGAffineTransform(translationX: 0, y: currentTransformY + point.y)
                    gestureRecognizer.setTranslation(.zero, in: gestureView)
                case .ended, .cancelled:
                    scrollView?.isScrollEnabled = true
                    if containerView.transform.ty > moveRange.down {
                        dismiss()
                    } else {
                        let animations = {
                            self.containerView.transform = CGAffineTransform.identity
                        }
                        UIView.perform(.delete, on: [], options: [], animations: animations, completion: nil)
                    }
                default:
                    break
                }
            default:
                break
            }
        }
    }
}

// MARK: - private
private extension BottomSheetController {
    func configure() {
        containerView.backgroundColor = UIColor.Cell.bg
        
        view.frame.size = UIScreen.main.bounds.size
        transitioningDelegate = self
        modalPresentationStyle = .overCurrentContext
        modalPresentationCapturesStatusBarAppearance = true
        overlayView.backgroundColor = overlayBackgroundColor

        overlayView.frame = UIScreen.main.bounds
        view.addSubview(overlayView)
        
        let width: CGFloat = 44.0
        let height: CGFloat = 5.0
        lineView.backgroundColor = tintColor != nil ? tintColor!.withAlphaComponent(0.25) : UIColor.white.withAlphaComponent(0.25)
        lineView.clipsToBounds = true
        lineView.layer.cornerRadius = height / 2
        
        containerView.isUserInteractionEnabled = true
        containerView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: height).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: width).isActive = true
        lineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        
        containerView.transform = CGAffineTransform(translationX: 0, y: initializeHeight)
        view.addSubview(containerView)
    }
    func configureConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: containerView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .height,
                                                  multiplier: 1,
                                                  constant: initializeHeight)
        let rightConstraint = NSLayoutConstraint(item: containerView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: view,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        let leftConstraint = NSLayoutConstraint(item: containerView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let bottomLayoutConstraint = NSLayoutConstraint(item: containerView,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: view,
                                                        attribute: .bottom,
                                                        multiplier: 1,
                                                        constant: 0)
        view.addConstraints([heightConstraint, rightConstraint, leftConstraint, bottomLayoutConstraint])
        self.containerViewHeightConstraint = heightConstraint
    }
    func newState(_ state: State) {
        switch state {
        case .hide:
            removeGesture(state)
            addGesture(state)
        case .show:
            removeGesture(state)
            addGesture(state)
        case .showAll:
            removeGesture(state)
            addGesture(state)
        }
        transform(state)
    }
    func transform(_ state: State) {
        guard !isNeedLayout else { return }
        switch state {
        case .hide:
            guard let containerViewHeightConstraint = containerViewHeightConstraint else { return }
            let animations: (() -> Void) = {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: containerViewHeightConstraint.constant)
            }
            let completion: ((Bool) -> Void) = { [weak self] in
                guard $0 else { return }
                self?.dismiss(animated: true, completion: nil)
            }
            UIView.animate(withDuration: duration.hide, delay: 0, options: .curveEaseInOut, animations: animations, completion: completion)
        case .show:
            let animations: (() -> Void) = {
                self.containerView.transform = CGAffineTransform.identity
            }
            UIView.animate(withDuration: duration.show, delay: 0, options: .curveEaseInOut, animations: animations, completion: nil)
        case .showAll:
            containerViewHeightConstraint?.constant = maxHeight - statusBarHeight
            let animations: (() -> Void) = {
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: duration.showAll, delay: 0, options: .curveEaseInOut, animations: animations, completion: nil)
        }
    }
    func adjustLayout() {
        containerView.layoutIfNeeded()
        containerView.clipsToBounds = true
        containerView.roundCorners([.topLeft, .topRight], radius: cornerRadius)
        
        guard isNeedLayout else { return }
        isNeedLayout = false
        if let bar = bar {
            containerView.bringSubview(toFront: bar)
        }
        
        containerView.bringSubview(toFront: lineView)
        
        configureGesture()
        scrollView?.setContentOffset(CGPoint(x: 0, y: -(scrollView?.scrollIndicatorInsets.top ?? 0)), animated: false)
        state = .show
    }
    
    func configureGesture() {
        //
        overlayViewPanGestureRecognizer.addTarget(self, action: #selector(BottomSheetController.handleGestureDragging(_:)))
        overlayViewPanGestureRecognizer.delegate = self
        overlayViewTapGestureRecognizer.addTarget(self, action: #selector(BottomSheetController.handleTap(_:)))
        //
        panGestureRecognizer.addTarget(self, action: #selector(BottomSheetController.handleGestureDragging(_:)))
        panGestureRecognizer.delegate = self
        //
        barGestureRecognizer.addTarget(self, action: #selector(BottomSheetController.handleGestureDragging(_:)))
        barGestureRecognizer.delegate = self
        barGestureRecognizer.require(toFail: panGestureRecognizer)
    }
    func addGesture(_ state: State) {
        switch viewActionType {
        case .swipe:
            overlayView.addGestureRecognizer(overlayViewPanGestureRecognizer)
        case .tappedPresent, .tappedDismiss:
            overlayView.addGestureRecognizer(overlayViewTapGestureRecognizer)
        }
        switch state {
        case .hide:
            break
        case .show:
            bar?.addGestureRecognizer(barGestureRecognizer)
            guard scrollView == nil || !isScrollEnabledInSheet else { return }
            containerView.addGestureRecognizer(panGestureRecognizer)
        case .showAll:
            bar?.addGestureRecognizer(barGestureRecognizer)
            containerView.addGestureRecognizer(panGestureRecognizer)
        }
    }
    func removeGesture(_ state: State) {
        switch state {
        case .hide:
            overlayView.removeGestureRecognizer(overlayViewPanGestureRecognizer)
            overlayView.removeGestureRecognizer(overlayViewTapGestureRecognizer)
            containerView.removeGestureRecognizer(panGestureRecognizer)
            bar?.removeGestureRecognizer(barGestureRecognizer)
        case .show:
            bar?.removeGestureRecognizer(barGestureRecognizer)
            containerView.removeGestureRecognizer(panGestureRecognizer)
        case .showAll:
            overlayView.removeGestureRecognizer(overlayViewPanGestureRecognizer)
            overlayView.removeGestureRecognizer(overlayViewTapGestureRecognizer)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BottomSheetController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = scrollView, let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer , state == .showAll else {
            return true
        }
        let gestureView = gestureRecognizer.view
        let point = gestureRecognizer.translation(in: gestureView)
        let contentOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        return contentOffset == 0 && point.y > 0
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension BottomSheetController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetTransitionAnimator(present: true)
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetTransitionAnimator(present: false)
    }
}

// MARK: - TransitionAnimator
extension BottomSheet {
    class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        fileprivate var presentDuration: TimeInterval = 0.0
        fileprivate var dismissDuration: TimeInterval = 0.0
        fileprivate var present: Bool?
        convenience init(present: Bool, presentDuration: TimeInterval = 0.3, dismissDuration: TimeInterval = 0.3) {
            self.init()
            self.present = present
            self.presentDuration = presentDuration
            self.dismissDuration = dismissDuration
        }
        open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            if present == true {
                return presentDuration
            } else {
                return dismissDuration
            }
        }
        open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            if present == true {
                presentAnimation(transitionContext)
            } else {
                dismissAnimation(transitionContext)
            }
        }
        // private
        fileprivate func presentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
            guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? BottomSheetController else {
                transitionContext.completeTransition(false)
                return
            }
            let containerView = transitionContext.containerView
            containerView.backgroundColor = .clear
            containerView.addSubview(toVC.view)
            toVC.overlayView.alpha = 0
            let animations = {
                toVC.overlayView.alpha = 1
            }
            let completion: ((Bool) -> Void) = { finished in
                guard finished else { return }
                let cancelled = transitionContext.transitionWasCancelled
                if cancelled {
                    toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!cancelled)
            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: animations, completion: completion)
        }
        fileprivate func dismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
            guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? BottomSheetController else {
                transitionContext.completeTransition(false)
                return
            }
            let animations = {
                fromVC.overlayView.alpha = 0
            }
            let completion: ((Bool) -> Void) = { finished in
                guard finished else { return }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: animations, completion: completion)
        }
    }
}

