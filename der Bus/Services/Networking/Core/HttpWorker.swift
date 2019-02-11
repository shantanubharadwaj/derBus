//
//  HttpWorker.swift
//  der Bus
//
//  Created by Shantanu Dutta on 08/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

struct Http {
    typealias SuccessHandler = (Request, Response) -> ()
    typealias ErrorHandler = (Request, Error) -> ()
}

protocol HttpWorker {
    func send(_ request: Http.Request, success: @escaping Http.SuccessHandler, error: @escaping Http.ErrorHandler)
    
    @discardableResult
    func cancel(_ request: Http.Request) -> Bool

    @discardableResult
    func cancelAll() -> Bool
}
