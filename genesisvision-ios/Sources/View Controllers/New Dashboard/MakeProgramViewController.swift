//
//  MakeProgramViewController.swift
//  genesisvision-ios
//
//  Created by George on 03.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class MakeProgramViewController: BaseModalViewController {
    typealias ViewModel = MakeProgramViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: MakeProgramStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg

        stackView.configure()
        
        viewModel = MakeProgramViewModel(self)
    }

    // MARK: - Actions
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        showImagePicker()
    }
    @IBAction func makeProgramButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectPeriodButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.periodsViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.periodsViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.periodsDataSource
            tableView.dataSource = viewModel.periodsDataSource
            tableView.reloadData()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func selectTradesDelayButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.tradesDelayViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.tradesDelayViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.tradesDelayDataSource
            tableView.dataSource = viewModel.tradesDelayDataSource
            tableView.reloadData()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
}

extension MakeProgramViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return stackView.uploadLogoView.uploadLogoButton
    }
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImage = pickedImage, let pickedImageURL = pickedImageURL else { return }
        
        viewModel.pickedImage = pickedImage
        viewModel.pickedImageURL = pickedImageURL
        
        stackView.uploadLogoView.uploadLogoButton.isHidden = true
        stackView.uploadLogoView.logoStackView.isHidden = false
        stackView.uploadLogoView.imageView.image = pickedImage
        stackView.uploadLogoView.logoStackView.layoutSubviews()
        stackView.uploadLogoView.layoutSubviews()
        stackView.layoutSubviews()
    }
}

extension MakeProgramViewController: BaseCellProtocol {
    func didSelect(_ type: DidSelectType, index: Int) {
        switch type {
        case .periods:
            stackView.periodView.textLabel.text = viewModel.periodsViewModel.selected?.toString()
        case .tradesDelay:
            stackView.tradesDelayView.textLabel.text = viewModel.tradesDelayViewModel.selected
        default:
            break
        }
        
        bottomSheetController.dismiss()
    }
}

class MakeProgramViewModel {
    // MARK: - Variables
    var pickedImage: UIImage?
    var pickedImageURL: URL?
    var uploadedUuidString: String?
    
    var periodsViewModel: PeriodListViewModel!
    var periodsDataSource: TableViewDataSource<PeriodListViewModel>!
    
    var tradesDelayViewModel: TradesDelayListViewModel!
    var tradesDelayDataSource: TableViewDataSource<TradesDelayListViewModel>!
    
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
        
        periodsViewModel = PeriodListViewModel(delegate, items: [1,3,5,7], selected: 1)
        tradesDelayViewModel = TradesDelayListViewModel(delegate, items: ["1", "2", "3"], selected: "1")
        periodsDataSource = TableViewDataSource(periodsViewModel)
        tradesDelayDataSource = TableViewDataSource(tradesDelayViewModel)
    }
    
    // MARK: - Public methods
    func saveProfilePhoto(completion: @escaping CompletionBlock) {
        guard let pickedImageURL = pickedImageURL else {
            return completion(.failure(errorType: .apiError(message: nil)))
        }
        BaseDataProvider.uploadImage(imageURL: pickedImageURL, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult.id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedUuidString = uuidString
            completion(.success)
        }, errorCompletion: completion)
    }
}
class PeriodListViewModel: SelectableListViewModel<Int> {
    var title = "Choose period"
    
    override func updateSelectedIndex() {
        self.selectedIndex = items.firstIndex{ $0 == self.selected } ?? 0
    }
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item.toString(), selected: isSelected)

        return cell
    }
    
}
class TradesDelayListViewModel: SelectableListViewModel<String> {
    var title = "Choose trades delay"
    
    override func updateSelectedIndex() {
        self.selectedIndex = items.firstIndex{ $0 == self.selected } ?? 0
    }
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)

        delegate?.didSelect(.tradesDelay, index: indexPath.row)
    }
}
