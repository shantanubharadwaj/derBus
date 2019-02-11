//
//  BusListCellViewModel.swift
//  der Bus
//
//  Created by Shantanu Dutta on 10/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

class BusListCellViewModel {
    private let apiService: APIServiceProtocol
    private let busDetails: BusInfoDetails
    
    init(_ apiService: APIServiceProtocol = APIService.create(.defaultService), busDetails: BusInfoDetails) {
        self.apiService = apiService
        self.busDetails = busDetails
    }
    
    var imageData: Data? {
        didSet {
            self.logoImageDownloadClosure?()
        }
    }
    
    var travelerName: String = "" {
        didSet {
            self.travelerNameClosure?()
        }
    }
    
    var departureTime: String = "" {
        didSet {
            self.departureTimeClosure?()
        }
    }
    
    var arrivalTime: String = "" {
        didSet {
            self.arrivalTimeClosure?()
        }
    }
    
    var ratingLabel: String = "" {
        didSet {
            self.ratingLabelClosure?()
        }
    }
    
    var ratingCountLabel: String = "" {
        didSet {
            self.ratingCountLabelClosure?()
        }
    }
    
    var featuresLabel: String = "" {
        didSet {
            self.featuresLabelClosure?()
        }
    }
    
    var fareLabel: String = "" {
        didSet {
            self.fareLabelClosure?()
        }
    }
    
    var logoImageDownloadClosure: (()->())?
    var travelerNameClosure: (()->())?
    var departureTimeClosure: (()->())?
    var arrivalTimeClosure: (()->())?
    var ratingLabelClosure: (()->())?
    var ratingCountLabelClosure: (()->())?
    var featuresLabelClosure: (()->())?
    var fareLabelClosure: (()->())?
    
    init(_ busDetails: BusInfoDetails) {
        travelerName = busDetails.travelerName
        departureTime = DateFormatter.iso8601_24HTime.string(from: busDetails.departureTime)
        
        if let arrivetime = busDetails.arrivalTime {
            arrivalTime = DateFormatter.iso8601_24HTime.string(from: arrivetime)
        }
        
        
    }
    
    private func initService() {
        
    }
    
    private func fetchLogo() {
        
    }
    
    private func cancelLogRequest() {
        
    }
}
