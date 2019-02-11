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
        
        imageData = Dynamic(nil)
        travelerName = Dynamic(busDetails.travelerName)
        departureTime = Dynamic(DateFormatter.iso8601_24HTime.string(from: busDetails.departureTime))
        arrivalTime = Dynamic("")
        if let arrivetime = busDetails.arrivalTime {
            arrivalTime.value = DateFormatter.iso8601_24HTime.string(from: arrivetime)
        }

        ratingLabel = Dynamic("")
        ratingCountLabel = Dynamic("")
        if busDetails.rating > 0 , busDetails.totalRatingCount > 0 {
            ratingLabel.value = "★ \(String(busDetails.rating))"
            ratingCountLabel.value = "\(String(busDetails.totalRatingCount)) ratings"
        }
        featuresLabel = Dynamic(busDetails.busType.description)
        fareLabel = Dynamic("\(busDetails.currency) \(String(busDetails.busFare))")
        initService()
        fetchLogo()
    }
    
    let imageData: Dynamic<Data?>
    let travelerName: Dynamic<String>
    let departureTime: Dynamic<String>
    let arrivalTime: Dynamic<String>
    let ratingLabel: Dynamic<String>
    let ratingCountLabel: Dynamic<String>
    let featuresLabel: Dynamic<String>
    let fareLabel: Dynamic<String>

    var travelerNameClosure: (()->())?
    var departureTimeClosure: (()->())?
    var arrivalTimeClosure: (()->())?
    var ratingLabelClosure: (()->())?
    var ratingCountLabelClosure: (()->())?
    var featuresLabelClosure: (()->())?
    var fareLabelClosure: (()->())?
    var logoImageDownloadClosure: (()->())?
    var imageLoadUpdateLoadingStatus: (()->())?
    
    lazy var httpService: HttpService = {
        return HttpService(apiService: apiService)
    }()
    
    var isLoading: Bool = false {
        didSet {
            self.imageLoadUpdateLoadingStatus?()
        }
    }
    
    func initService() {
        httpService.updateLoadingStatus = { [weak self] in
            self?.isLoading = self?.httpService.isLoading ?? false
        }
        
        httpService.downloadedImageClosure = { [weak self] in
            if let imageData = self?.httpService.downloadedImage {
                self?.processImageData(imageData)
            }
        }
    }
    
    private func fetchLogo() {
        let completeURL = busDetails.logoBaseURL.absoluteString + busDetails.imageEndPoint
        guard let url = URL(string: completeURL) else { return }
        httpService.fetchImage(url)
    }
    
    func processImageData(_ imageData: Data ) {
        self.imageData.value = imageData
    }
    
    private func cancelLogRequest() {
        
    }
}
