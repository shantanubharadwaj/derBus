//
//  HttpWorkerFactory.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Http{
    // Create instance of httpWorker, while passing a string value to differentiate between different callers
    static func create(_ creator: String) -> HttpWorker {
        return NetworkWorker(creator)
    }
}
