//
//  BusDetails.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

struct BusInformationResponse: Decodable {
    let infolist: [BusInfoList]
    let logoBaseUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case infolist = "RIN"
        case logoBaseUrl = "blu"
    }
}

struct BusInfoList: Decodable {
    let invList: [BusDetails]
    
    enum CodingKeys: String, CodingKey {
        case invList = "InvList"
    }
}

struct BusDetails: Decodable {
    let busType: BusType
    let source: String
    let destination: String
    let rating: Rating
    var orating: ORating?
    let departureTime: Date
    var arrivalTime: Date?
    let imageEndPoint: String
    let currency: String
    let travelerName: String
    let busFare: Double
    
    enum CodingKeys: String, CodingKey {
        case busType = "Bc"
        case source = "src"
        case destination = "dst"
        case rating = "rt"
        case orating = "oprt"
        case departureTime = "dt"
        case arrivalTime = "at"
        case imageEndPoint = "lp"
        case currency = "cur"
        case travelerName = "Tvs"
        case busFare = "minfr"
    }
}

struct BusType: Decodable {
    let IsAc: Bool
    let IsNonAc: Bool
    let IsSeater: Bool
    let IsSleeper: Bool
}

struct Rating: Decodable {
    struct RatingCount: Decodable {
        let count: String
        enum CodingKeys: String, CodingKey {
            case count = "Ct"
        }
    }
    
    let totalRating: Double
    let count: RatingCount
    
    enum CodingKeys: String, CodingKey {
        case totalRating = "totRt"
        case count = "Rt"
    }
}

struct ORating: Decodable {
    let totalRating: String
    let count: String
    
    enum CodingKeys: String, CodingKey {
        case totalRating = "totRt"
        case count = "Ct"
    }
}


