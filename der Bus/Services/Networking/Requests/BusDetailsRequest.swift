//
//  BusDetailsRequest.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

struct BusDetailsRequest {
    fileprivate let httpWorker = Http.create("BusDetailsRequest")
    fileprivate let RequestQueue = DispatchQueue(label: "BusDetailsRequestQueue", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent)
    private let operationQueue = OperationQueue()
    private var request: Http.Request?
    
    init(url: URL) {
        self.request = Http.formRequest(with: url)
    }
    
    func cancelRequest() {
        guard let request = request else { return }
        httpWorker.cancel(request)
    }
    
    /// use this api to call the nextURL (if available) which was passed in the Link header during initial call.
    func fetchData(_ response: ((BusDetailsList?) -> ())?) {
        guard let request = self.request, let _ = request.urlRequest.url else {
            response?(nil)
            return
        }
        
        httpWorker.cancelAll()

        RequestQueue.async {
            self.httpWorker.send(request, success: { (request, httpResponse) in
                guard let validdata = httpResponse.data else{
                    print("<BusDetailsRequest> fetch data : Error in HTTP : [StatusCode : \(String(describing: httpResponse.urlResponse.statusCode))]")
                    response?(nil)
                    return
                }
                
                do{
                    let busInfo: BusInformationResponse = try validdata.decode()
                    let details = BusDetailsList(source: busInfo)
                    response?(details)
                }catch let error {
                    print("<BusDetailsRequest> fetch data : Error while parsing : [\(error.localizedDescription)]")
                    response?(nil)
                }
            }, error: { (request, error) in
                print("<BusDetailsRequest> fetch data : Error in HTTP : [<error  [\(String(describing: error))]>")
                response?(nil)
                return
            })
        }
    }
}
