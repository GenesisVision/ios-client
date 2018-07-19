//
//  CreateProgramTabmanRouter.swift
//  genesisvision-ios
//
//  Created by George on 10/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum CreateProgramTabmanRouteType {
    case successCreate(String)
}

class CreateProgramTabmanRouter: TabmanRouter {
    
    // MARK: - Variables
    var createProgramFirstViewController: CreateProgramFirstViewController?
    var createProgramSecondViewController: CreateProgramSecondViewController?
    var createProgramThirdViewController: CreateProgramThirdViewController?
    
    var createProgramFirstViewModel: CreateProgramFirstViewModel?
    var createProgramSecondViewModel: CreateProgramSecondViewModel?
    var createProgramThirdViewModel: CreateProgramThirdViewModel?
    
    var temparyNewInvestmentRequest: TemparyNewInvestmentRequest? {
        didSet {
            createProgramFirstViewModel?.temparyNewInvestmentRequest = temparyNewInvestmentRequest
            createProgramSecondViewModel?.temparyNewInvestmentRequest = temparyNewInvestmentRequest
            createProgramThirdViewModel?.temparyNewInvestmentRequest = temparyNewInvestmentRequest
        }
    }
    
    var pickedImageURL: URL? {
        didSet {
            createProgramFirstViewModel?.pickedImageURL = pickedImageURL
            createProgramThirdViewModel?.pickedImageURL = pickedImageURL
        }
    }
    
    // MARK: - Public methods
    func show(routeType: CreateProgramTabmanRouteType) {
        switch routeType {
        case .successCreate(let programId):
            showSuccessCreateVC(programId)
        }
    }
    
    func getCreateProgramFirstVC(with tabmanViewModel: CreateProgramTabmanViewModel) -> CreateProgramFirstViewController? {
        guard let viewController = CreateProgramFirstViewController.storyboardInstance(name: .programs) else { return  nil }
        createProgramFirstViewModel = CreateProgramFirstViewModel(withRouter: self, tabmanViewModel: tabmanViewModel, textFieldDelegate: viewController)
        viewController.viewModel = createProgramFirstViewModel
        createProgramFirstViewController = viewController

        return viewController
    }

    func getCreateProgramSecondVC(with tabmanViewModel: CreateProgramTabmanViewModel, brokersViewModel: BrokersViewModel? = nil) -> CreateProgramSecondViewController? {
        guard let viewController = CreateProgramSecondViewController.storyboardInstance(name: .programs) else { return  nil }
        createProgramSecondViewModel = CreateProgramSecondViewModel(withRouter: self, tabmanViewModel: tabmanViewModel, textFieldDelegate: viewController, brokersViewModel: brokersViewModel)
        viewController.viewModel = createProgramSecondViewModel
        createProgramSecondViewController = viewController
        
        return viewController
    }

    func getCreateProgramThirdVC(with tabmanViewModel: CreateProgramTabmanViewModel) -> CreateProgramThirdViewController? {
        guard let viewController = CreateProgramThirdViewController.storyboardInstance(name: .programs) else { return  nil }
        createProgramThirdViewModel = CreateProgramThirdViewModel(withRouter: self, tabmanViewModel: tabmanViewModel, textFieldDelegate: viewController)
        viewController.viewModel = createProgramThirdViewModel
        createProgramThirdViewController = viewController
        
        return viewController
    }
    
    // MARK: - Private methods
    private func getSuccessCreateVC(with programId: String) -> InfoViewController? {
        guard let viewController = InfoViewController.storyboardInstance(name: .auth) else { return nil }
        viewController.viewModel = CreateProgramSuccessViewModel(withRouter: self)
        
        return viewController
    }
    
    private func showSuccessCreateVC(_ programId: String) {
        guard let viewController = getSuccessCreateVC(with: programId) else { return }
        present(viewController: viewController)
    }
    
    func next(with temparyNewInvestmentRequest: TemparyNewInvestmentRequest?, pickedImageURL: URL? = nil) {
        self.temparyNewInvestmentRequest = temparyNewInvestmentRequest
        
        if let pickedImageURL = pickedImageURL {
            self.pickedImageURL = pickedImageURL
        }
        
        tabmanViewController?.scrollToPage(.next, animated: true)
    }
}

