//
//  HttpRequest.swift
//  der Bus
//
//  Created by Shantanu Dutta on 08/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Http{
    struct Request: Hashable, CustomStringConvertible {
        let id = UUID()
        var urlRequest: URLRequest
        var timeout: TimeInterval = URLConstants.httpTimeout
        
        var description: String {
            get {
                if let validURL = self.urlRequest.url {
                    var description = "URL: \(validURL.absoluteString)\n"
                    description += "HTTPHeaders: \(String(describing: self.urlRequest.allHTTPHeaderFields))\n"
                    description += "timeout: \(self.timeout)\n"
                    return description
                }else{
                    return ""
                }
            }
        }
        
        init(request: URLRequest) {
            urlRequest = request
        }
        
        init(url: URL) {
            urlRequest = URLRequest(url: url)
        }
        
        //hashable
        func isEqual(_ object: Any?) -> Bool {
            guard let validObject = object as? Request else {
                return false
            }
            
            return (self.id == validObject.id)
        }
        
        static func == (lhs: Request, rhs: Request) -> Bool {
            return lhs.id == rhs.id
        }
        
        var hashValue: Int {
            return id.uuidString.hashValue
        }
    }
}
