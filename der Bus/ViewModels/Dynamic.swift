//
//  Dynamic.swift
//  der Bus
//
//  Created by Shantanu Dutta on 2/11/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}
