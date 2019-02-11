//
//  SortEngine.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

enum SortOptions {
    case Rating_LowHigh
    case Rating_HighLow
    case DepartureTime_LowHigh
    case DepartureTime_HighLow
    case Fare_LowHigh
    case Fare_HighLow
}

struct SortEngine {
    static func sort(busList list: [BusInfoDetails], with options: SortOptions) -> [BusInfoDetails] {
        
        return sort(list: list, options: options)
    }
    
    fileprivate static func sort(list: [BusInfoDetails], options: SortOptions) -> [BusInfoDetails] {
        switch options {
            
        case .Rating_LowHigh:
            return list.sorted { $0.rating < $1.rating }
        case .Rating_HighLow:
            return list.sorted { $0.rating > $1.rating }
        case .DepartureTime_LowHigh:
            return list.sorted { $0.departureTime < $1.departureTime }
        case .DepartureTime_HighLow:
            return list.sorted { $0.departureTime > $1.departureTime }
        case .Fare_LowHigh:
            return list.sorted { $0.busFare < $1.busFare }
        case .Fare_HighLow:
            return list.sorted { $0.busFare > $1.busFare }
        }
    }
}
