//
//  APIServices.swift
//  der Bus
//
//  Created by Shantanu Dutta on 10/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

typealias ImageFetchResponseHandler = ( _ success: Bool, _ photoBytes: Data?) -> ()
typealias BusDetailsFetchResponseHandler = ( _ success: Bool, _ photoBytes: BusDetailsList?) -> ()

struct APIService {
    enum Factory {
        case defaultService
    }
    
    static func create(_ factory: Factory) -> APIServiceProtocol {
        switch factory {
            
        case .defaultService:
            return APIServices()
        }
    }
}

protocol APIServiceProtocol {
    func fetchImage(url: URL, complete: @escaping ImageFetchResponseHandler)
    func cancelImageRequest()
    func fetchBusDetails(url: URL, complete: @escaping BusDetailsFetchResponseHandler)
    func cancelBusDetailsRequest()
}

class APIServices: APIServiceProtocol {
    
    var imageService: ImageRequest?
    var busDataService: BusDetailsRequest?
    
    func fetchImage(url: URL, complete: @escaping ImageFetchResponseHandler) {
        imageService = ImageRequest(url: url)
        imageService?.fetch({ (data) in
            if let data = data {
                complete(true, data)
            }else{
                complete(false, nil)
            }
        })
        
    }
    
    func fetchBusDetails(url: URL, complete: @escaping BusDetailsFetchResponseHandler) {
        busDataService = BusDetailsRequest(url: url)
        busDataService?.fetchData({ (busDetails) in
            if let busDetails = busDetails {
                complete(true, busDetails)
            }else{
                complete(false, nil)
            }
        })
    }
    
    func cancelImageRequest() {
        imageService?.cancelRequest()
    }
    
    func cancelBusDetailsRequest() {
        busDataService?.cancelRequest()
    }
}
