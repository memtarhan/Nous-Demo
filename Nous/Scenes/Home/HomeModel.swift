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
