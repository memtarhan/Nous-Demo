//
//  HomeViewController.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Nibbable {
    weak var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nous"
    }
}
