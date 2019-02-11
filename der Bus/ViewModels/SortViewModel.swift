//
//  SortViewModel.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

class SortViewModel {
    
    init() {
    }
    
    var busDetails: [BusInfoDetails] = [BusInfoDetails]() {
        didSet {
            self.sortedList?()
        }
    }
    
    var sortedList: (()->())?
    
    func fetchSortedData(for busList: [BusInfoDetails], with option: SortOptions) {
        busDetails = SortEngine.sort(busList: busList, with: option)
    }
}
