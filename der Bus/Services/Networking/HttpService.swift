//
//  HttpService.swift
//  der Bus
//
//  Created by Shantanu Dutta on 10/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

class HttpService {
    let apiService: APIServiceProtocol
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var downloadedImage: Data? {
        didSet{
            self.downloadedImageClosure?()
        }
    }
    
    var fetchedBusDetails: (result: Bool, busDetails: BusDetailsList?) = (false, nil) {
        didSet{
            self.fetchedBusDetailsClosure?()
        }
    }
    
    // MARK: - Bind closures
    var updateLoadingStatus: (()->())?
    var downloadedImageClosure: (() -> ())?
    var fetchedBusDetailsClosure: (() -> ())?
    
    init( apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchImage(_ url: URL) {
        isLoading = true
        apiService.fetchImage(url: url) { [weak self] (result, imageData) in
            self?.isLoading = false
            self?.downloadedImage = imageData
        }
    }
    
    func cancelImageRequest() {
        apiService.cancelImageRequest()
        isLoading = false
        downloadedImage = nil
    }
    
    func fetchBusDetails(_ url: URL) {
        isLoading = true
        apiService.fetchBusDetails(url: url) { [weak self] (result, busDetails) in
            self?.isLoading = false
            self?.fetchedBusDetails = (result, busDetails)
        }
    }
    
    func cancelBusDetailsRequest() {
        apiService.cancelBusDetailsRequest()
        isLoading = false
        fetchedBusDetails = (false, nil)
    }
}

extension HttpService {
    static var isReachable: Bool {
        guard let reachability = Reachability() else {
            return true
        }
        let status = reachability.connection
        return (status == .wifi || status == .cellular) ? true : false
    }
}
