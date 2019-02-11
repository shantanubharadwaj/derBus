//
//  Reachable.swift
//  der Bus
//
//  Created by Shantanu Dutta on 08/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Reachability {
    static var isReachable: Bool {
        guard let reachability = Reachability() else {
            return true
        }
        let status = reachability.connection
        return (status == .wifi || status == .cellular) ? true : false
    }
}
