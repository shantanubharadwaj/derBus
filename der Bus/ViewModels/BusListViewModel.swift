//
//  BusListViewModel.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

class BusListViewModel {
    private let apiService: APIServiceProtocol
    private var _fromDestination: String!
    private var _toDestination: String!
    
    var busDetailsList: BusDetailsList?{
        didSet {
            self.fetchedBusDetails?()
        }
    }
    
    var busCountInfo: String = ""
    var titleBarInfo: String = ""
    
    var busDetails: [BusInfoDetails] = [BusInfoDetails]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    lazy var httpService: HttpService = {
        return HttpService(apiService: apiService)
    }()

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfSections: Int {
        if busDetails.count > 0 {
            return 1
        }else{
            return 0
        }
    }
    
    var numberOfCells: Int {
        return busDetails.count
    }
    
    func busDetailsInfo(for indexPath: IndexPath ) -> BusInfoDetails {
        return busDetails[indexPath.row]
    }
    
    func viewModelForCell(for indexPath: IndexPath ) -> BusListCellViewModel {
        return BusListCellViewModel(busDetails: busDetails[0])
    }

    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var fetchedBusDetails: (()->())?
    var reloadTableViewClosure: (()->())?
    
    init(_ apiService: APIServiceProtocol = APIService.create(.defaultService), fromDestination: String, toDestination: String) {
        self.apiService = apiService
        _fromDestination = fromDestination
        _toDestination = toDestination
        titleBarInfo = "\(fromDestination) to \(toDestination)"
        initService()
    }

    private func initService() {
        httpService.updateLoadingStatus = { [weak self] in
            self?.isLoading = self?.httpService.isLoading ?? false
        }
        
        httpService.fetchedBusDetailsClosure = { [weak self] in
            if let response = self?.httpService.fetchedBusDetails, response.result == true, let details = response.busDetails {
                self?.processFetchedBusDetails(details)
            }else{
                self?.busDetailsList = nil
                self?.alertMessage = "Failed to fetch response"
            }
        }
    }
    
    func fetchBusDetails() {
        guard let url = Http.URLConstants.baseUrl else { return }
        httpService.fetchBusDetails(url)
    }
    
    func processFetchedBusDetails(_ details: BusDetailsList ) {
        self.busDetailsList = details
        self.busDetails = details.busDetails
        busCountInfo = "\(details.busDetails.count) buses found from \(_fromDestination!) to \(_toDestination!)"
    }
    
    var isAppOnline: Bool {
        return HttpService.isReachable
    }
}
