//
//  HomeModel.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import Foundation

class HomeModel {
    func fetchFeeds() async throws -> [FeedResponse] {
        return try await FeedsService.shared.fetchFeeds().feeds
    }
}

class FeedDisplayModel {
    let id: Int
    let title: String
    let description: String
    let image: URL?

    init(id: Int, title: String, description: String, image: URL?) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
    }
}

/// - to confirm UITableViewDiffableDataSource
extension FeedDisplayModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FeedDisplayModel, rhs: FeedDisplayModel) -> Bool {
        return (lhs.id == rhs.id) && (lhs.title == rhs.title)
    }
}

struct MailModel {
    let subject: String
    let body: String
}
