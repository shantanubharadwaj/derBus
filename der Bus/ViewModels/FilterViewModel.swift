//
//  FilterViewModel.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

class FilterViewModel {
    
    var optionSelected: [FilterOptions]!
    init() {
    }

    var busDetails: [BusInfoDetails] = [BusInfoDetails]() {
        didSet {
            self.filteredList?()
        }
    }

    var filteredList: (()->())?

    func fetchFilteredData(for busList: [BusInfoDetails], with options:[FilterOptions]) {
        optionSelected = options
        busDetails = FilterEngine.filter(busList: busList, for: optionAttributesSelected())
    }
    
    fileprivate func optionAttributesSelected() -> FilterEngine.FilterAttributes {
        if optionSelected.count == FilterEngine.availableFilterOptions().count {
            return .ALL
        }else if optionSelected.count == 0 {
            return .NONE
        }else {
            if optionSelected.contains(.AC) && optionSelected.contains(.NONAC) && optionSelected.contains(.SEATER) && optionSelected.contains(.SLEEPER) {
                return [.AC, .NONAC, .SEATER, .SLEEPER]
            }else if optionSelected.contains(.AC) && optionSelected.contains(.NONAC) && optionSelected.contains(.SEATER){
                return [.AC, .NONAC, .SEATER]
            }else if optionSelected.contains(.AC) && optionSelected.contains(.NONAC) && optionSelected.contains(.SLEEPER){
                return [.AC, .NONAC, .SLEEPER]
            }else if optionSelected.contains(.SLEEPER) && optionSelected.contains(.NONAC) && optionSelected.contains(.SEATER){
                return [.NONAC, .SEATER, .SLEEPER]
            }else if optionSelected.contains(.AC) && optionSelected.contains(.NONAC) {
                return [.AC, .NONAC]
            }else if optionSelected.contains(.AC) && optionSelected.contains(.SEATER) {
                return [.AC, .SEATER]
            }else if optionSelected.contains(.AC) && optionSelected.contains(.SLEEPER) {
                return [.AC, .SLEEPER]
            }else if optionSelected.contains(.NONAC) && optionSelected.contains(.SEATER) {
                return [.NONAC, .SEATER]
            }else if optionSelected.contains(.NONAC) && optionSelected.contains(.SLEEPER) {
                return [.NONAC, .SLEEPER]
            }else if optionSelected.contains(.SEATER) && optionSelected.contains(.SLEEPER) {
                return [.SEATER, .SLEEPER]
            }else if optionSelected.contains(.AC){
                return .AC
            }else if optionSelected.contains(.NONAC){
                return .NONAC
            }else if optionSelected.contains(.SEATER) {
                return .SEATER
            }else if optionSelected.contains(.SLEEPER) {
                return .SLEEPER
            }else{
                return .NONE
            }
        }
    }
}
