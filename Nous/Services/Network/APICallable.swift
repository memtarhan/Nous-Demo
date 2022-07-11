//
//  APICallable.swift
//  Nous
//
//  Created by Mehmet Tarhan on 11/07/2022.
//  Copyright © 2022 MEMTARHAN. All rights reserved.
//

import Foundation

protocol APICallable {
    var baseURL: String { get } // Base URL
    var decoder: JSONDecoder { get }
    var session: URLSession { get }
}

extension APICallable {
    var baseURL: String { apiBaseURL }
    var decoder: JSONDecoder {
        let decoder = JSONDecoder() 
        // Add custom implementations here such as date formatting

        return decoder
    }

    var session: URLSession {
        // TODO: Update Bearer once it's ready to use in backend
        let sessionConfig = URLSessionConfiguration.default
        // Add custom implementations here such as auth token
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)

        return session
    }
}

let apiBaseURL = "https://cloud.nousdigital.net/s/rNPWPNWKwK7kZcS/download"
