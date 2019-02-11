//
//  URLConfigs.swift
//  der Bus
//
//  Created by Shantanu Dutta on 08/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Http {
    static func formRequest(with url: URL) -> Http.Request? {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let request = Http.Request(request: urlRequest)
        return request
    }
}

extension Http {
    struct URLConstants {
        static let httpTimeout: TimeInterval = 30.0
        static let baseUrl = URL(string: "https://api.myjson.com/bins/12l8sb")
    }
}
