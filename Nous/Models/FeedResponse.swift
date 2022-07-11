//
//  FeedResponse.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import Foundation

struct FeedsResponse: Codable {
    let feeds: [FeedResponse]

    enum CodingKeys: String, CodingKey {
        case feeds = "items"
    }
}

// MARK: - FeedResponse

struct FeedResponse: Codable {
    let id: Int
    let title, description, imageUrl: String
}
