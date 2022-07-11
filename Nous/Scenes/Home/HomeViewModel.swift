//
//  HomeViewModel.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import Combine
import UIKit

class HomeViewModel {
    weak var view: HomeViewController!
    weak var model: HomeModel!

    typealias snapshotType = NSDiffableDataSourceSnapshot<FeedSection, FeedDisplayModel>

    @Published var snapshot = CurrentValueSubject<snapshotType, Never>(snapshotType())

    @Published var searchedKeyword = PassthroughSubject<String, Never>()
    @Published var load = PassthroughSubject<Bool, Never>()
    @Published var willShowEmail = PassthroughSubject<Int, Never>() // Has index of selected feed as parameter
    @Published var willSendEmail = PassthroughSubject<MailModel, Never>()

    private var cancellables: Set<AnyCancellable> = []

    private(set) var feedModels: [FeedDisplayModel] = []

    init() {
        snapshot.value.appendSections([.feed])

        searchedKeyword
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] keyword in
                guard let self = self else { return }

                guard keyword != "" else {
                    self.update(self.feedModels)
                    return
                }

                let models = self.feedModels.filter { $0.title.contains(keyword) || $0.description.contains(keyword) }
                self.update(models)
            }
            .store(in: &cancellables)

        load.sink { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.loadInitialData()
            }
        }
        .store(in: &cancellables)

        willShowEmail.sink { [weak self] index in
            guard let self = self else { return }

            let feed = self.snapshot.value.itemIdentifiers[index]
            let mail = MailModel(subject: feed.title, body: feed.description)
            self.willSendEmail.send(mail)
        }
        .store(in: &cancellables)
    }

    func loadInitialData() async {
        do {
            let models = try await model.fetchFeeds()
            let displayModels = models.map { model in
                FeedDisplayModel(id: model.id,
                                 title: model.title,
                                 description: model.description,
                                 image: URL(string: model.imageUrl))
            }

            feedModels = displayModels
            update(displayModels)

        } catch {
            // TODO: Display error
        }
    }

    private func update(_ displayModels: [FeedDisplayModel]) {
        snapshot.value.deleteAllItems()
        snapshot.value.appendSections([.feed])
        snapshot.value.appendItems(displayModels, toSection: .feed)
        snapshot.send(snapshot.value)
    }
}
