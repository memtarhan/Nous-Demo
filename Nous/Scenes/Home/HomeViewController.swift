//
//  HomeViewController.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import Combine
import UIKit

class HomeViewController: UIViewController, Nibbable {
    weak var viewModel: HomeViewModel!

    @IBOutlet var tableView: UITableView!

    private lazy var dataSource = generatedDataSource

    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = "Nous"

        let cell = UINib(nibName: FeedTableViewCell.nibIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: FeedTableViewCell.reuseIdentifier)

        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.rowHeight = 128

        viewModel.snapshot
            .receive(on: DispatchQueue.main)
            .sink { result in
                print(result)
                // TODO: Hide activity indicator or show error based on result

            } receiveValue: { [weak self] snapshot in
                guard let self = self else { return }

                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
        
        viewModel.load.send(true)
    }

    private var generatedDataSource: FeedTableViewDiffableDataSource {
        FeedTableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as? FeedTableViewCell
            else { return UITableViewCell() }

            cell.configure(model)

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
}
