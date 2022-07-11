//
//  HomeViewController.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import Combine
import MessageUI
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setup() {
        title = "Nous"

        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        let cell = UINib(nibName: FeedTableViewCell.nibIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: FeedTableViewCell.reuseIdentifier)

        tableView.delegate = self
        tableView.dataSource = dataSource

        viewModel.snapshot
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let _ = self else { return }

                print(result)
                // TODO: Hide activity indicator or show error based on result

            } receiveValue: { [weak self] snapshot in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.dataSource.apply(snapshot, animatingDifferences: false)
                }
            }
            .store(in: &cancellables)

        viewModel.willSendEmail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mail in
                guard let self = self else { return }

                // MARK: - Requires real device with Apple Mail app installed
                if MFMailComposeViewController.canSendMail() {
                    let mailComposeViewController = MFMailComposeViewController()
                    mailComposeViewController.mailComposeDelegate = self
                    mailComposeViewController.setSubject(mail.subject)
                    mailComposeViewController.setMessageBody(mail.body, isHTML: false)

                    self.present(mailComposeViewController, animated: true)
                }
            }
            .store(in: &cancellables)

        viewModel.load.send(true)
    }

    private var generatedDataSource: FeedTableViewDiffableDataSource {
        FeedTableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as? FeedTableViewCell
            else { return UITableViewCell() }

            cell.tag = indexPath.row
            cell.configure(model)

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.willShowEmail.send(indexPath.row)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension HomeViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - UISearchControllerDelegate

extension HomeViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        viewModel.searchedKeyword.send("")
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange: \(searchText)")
        viewModel.searchedKeyword.send(searchText)
    }
}
