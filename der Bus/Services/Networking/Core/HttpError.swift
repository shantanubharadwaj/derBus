//
//  HttpError.swift
//  der Bus
//
//  Created by Shantanu Dutta on 08/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Http{
    enum ErrorCodes: Int {
        case invalidResponse
        case retryNotAvalaible
        case cancelled
    }
    
    /// Error object received while performing http
    struct Error: CustomStringConvertible {
        let errorCode: Int
        let errorReason: String?
        init(code: Int, errorDescription: String? = nil) {
            errorCode = code
            errorReason = errorDescription
        }
        
        var description: String{
            return "HttpError :> [code: \(errorCode), reason: \(errorReason ?? "")]"
        }
    }
}
