//
//  FeedsService.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import Foundation

class FeedsService: APICallable {
    static let shared = FeedsService()

    private init() {}

    func fetchFeeds() async throws -> FeedsResponse {
        let endpoint = "\(baseURL)" // BaseURL could be manipulated here
        guard let url = URL(string: endpoint) else { throw HTTPError.invalidEndpoint }

        let (data, _) = try await session.data(from: url)
        return try decoder.decode(FeedsResponse.self, from: data)
    }
}
