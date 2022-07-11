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

    private var feedModels: [FeedDisplayModel] = []

    init() {
        snapshot.value.appendSections([.feed])

        load.sink { [weak self] _ in
            guard let self = self else { return }
            Task {
                do {
                    let models = try await self.model.fetchFeeds()
                    let displayModels = models.map { model in
                        FeedDisplayModel(id: model.id,
                                         title: model.title,
                                         description: model.description,
                                         image: URL(string: model.imageUrl))
                    }
                    self.feedModels = displayModels
                    self.snapshot.value.appendItems(displayModels, toSection: .feed)
                    self.snapshot.send(self.snapshot.value)

                } catch {
                    // TODO: Display error
                }
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
}
