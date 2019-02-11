//
//  BusInfoDetails.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

struct BusDetailsList {
    let busDetails: [BusInfoDetails]
    
    init?(source: BusInformationResponse) {
        guard let details = source.infolist.first?.invList, !details.isEmpty else {
            return nil
        }
        let logoBusUrl = source.logoBaseUrl
        busDetails = details.map{ BusInfoDetails(details: $0, baseURL: logoBusUrl) }
    }
}

struct BusInfoDetails {
    let busType: BusType
    let source: String
    let destination: String
    let rating: Double
    let totalRatingCount: UInt
    let departureTime: Date
    var arrivalTime: Date?
    let currency: String
    let travelerName: String
    let busFare: Double
    let imageEndPoint: String
    let logoBaseURL: URL
    
    init(details: BusDetails, baseURL: URL) {
        self.busType = details.busType
        self.source = details.source
        self.destination = details.destination
        let ratings = BusInfoDetails.calculateRatingWithCount(details: details)
        self.rating = ratings.rating
        self.totalRatingCount = ratings.count
        self.departureTime = details.departureTime
        self.arrivalTime = details.arrivalTime
        self.currency = details.currency
        self.travelerName = details.travelerName
        self.busFare = details.busFare
        self.imageEndPoint = details.imageEndPoint
        self.logoBaseURL = baseURL
    }
    
    fileprivate static func calculateRatingWithCount(details: BusDetails) -> (rating: Double, count: UInt) {
        if let orating = details.orating {
            let rating = Double(orating.totalRating) ?? 0
            let ratingCount = UInt(orating.count) ?? 0
            return ((rating > 0 ? rating : 0), ratingCount)
        }else{
            let busrating = details.rating
            let rating = busrating.totalRating
            let ratingCount = UInt(busrating.count.count) ?? 0
            return ((rating > 0 ? rating : 0), ratingCount)
        }
    }
}


