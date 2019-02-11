//
//  HomeScreenViewModel.swift
//  der Bus
//
//  Created by Shantanu Dutta on 10/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

class HomeScreenViewModel {
//    private let apiService: APIServiceProtocol
    
    var busDetailsList: BusDetailsList?{
        didSet {
            self.fetchedBusDetails?()
        }
    }
    
    var fromDestinationList: [String]? {
        guard let detailslist = busDetailsList?.busDetails else { return nil }
        var list = Set<String>(detailslist.map{ $0.source })
        list.insert(" ")
        return list.sorted()
    }
    
    var toDestinationList: [String]? {
        guard let detailslist = busDetailsList?.busDetails else { return nil }
        var list = Set<String>(detailslist.map{ $0.destination })
        list.insert(" ")
        return list.sorted()
    }
    
//    lazy var httpService: HttpService = {
//        return HttpService(apiService: apiService)
//    }()
    
//    var isLoading: Bool = false {
//        didSet {
//            self.updateLoadingStatus?()
//        }
//    }
//
//    var alertMessage: String? {
//        didSet {
//            self.showAlertClosure?()
//        }
//    }
    
//    var showAlertClosure: (()->())?
//    var updateLoadingStatus: (()->())?
    var fetchedBusDetails: (()->())?
    
//    init(_ apiService: APIServiceProtocol = APIService.create(.defaultService)) {
//        self.apiService = apiService
//        initService()
//
//        if let path = Bundle.main.path(forResource: "content", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            if let photos = try? decoder.decode(Photos.self, from: data){
//                complete(true, photos.photos, nil)
//            }
//
//        }
//    }
    
//    private func initService() {
//        httpService.updateLoadingStatus = { [weak self] in
//            self?.isLoading = self?.httpService.isLoading ?? false
//        }
//
//        httpService.fetchedBusDetailsClosure = { [weak self] in
//            if let response = self?.httpService.fetchedBusDetails, response.result == true, let details = response.busDetails {
//                self?.busDetails = details
//            }else{
//                self?.busDetails = nil
//                self?.alertMessage = "Failed to fetch response"
//            }
//        }
//    }
    
    func fetchBusDetails() {
//        guard let url = Http.URLConstants.baseUrl else { return }
//        httpService.fetchBusDetails(url)
        if let path = Bundle.main.path(forResource: "Data", ofType: "json"), let validdata = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            
            if let busInfo: BusInformationResponse = try? validdata.decode() {
                let details = BusDetailsList(source: busInfo)
                busDetailsList = details
            }else{
                busDetailsList = nil
            }
        }else{
            busDetailsList = nil
        }
    }
}
