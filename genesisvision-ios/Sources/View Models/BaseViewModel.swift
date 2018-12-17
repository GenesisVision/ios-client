//
//  BaseViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//
protocol BaseViewModelProtocol {
    var title: String { get }
}

class BaseViewModel: BaseViewModelProtocol {
    var title: String = ""
    
    var router: Router!
}
