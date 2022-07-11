//
//  HomeAssembly.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import UIKit

class HomeAssembly {
    static let shared = HomeAssembly()

    private let model: HomeModel
    private(set) var view: HomeViewController
    private let viewModel: HomeViewModel

    private init() {
        let model = HomeModel()
        let view = HomeViewController.instantiate()
        let viewModel = HomeViewModel()

        view.viewModel = viewModel
        viewModel.view = view
        viewModel.model = model

        self.model = model
        self.view = view
        self.viewModel = viewModel
    }
}
