//
//  ImageRequest.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

class ImageRequest {
    fileprivate let httpWorker = Http.create("ImageService")
    fileprivate let RequestQueue = DispatchQueue(label: "ImageServiceRequestQueue", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent)
    private let operationQueue = OperationQueue()
    private var request: Http.Request?
    init(url: URL) {
        self.request = Http.formRequest(with: url)
    }
    
    func cancelRequest() {
        guard let request = request else { return }
        httpWorker.cancel(request)
    }
    
    func fetch(_ response: ((Data?) -> ())?){
        guard let request = self.request, let _ = request.urlRequest.url else {
            response?(nil)
            return
        }
        
        httpWorker.cancelAll()
        
        RequestQueue.async {
            self.httpWorker.send(request, success: { (request, httpResponse) in
                guard let validdata = httpResponse.data else{
                    print("<ImageRequest> fetch data : Error in HTTP : [StatusCode : \(String(describing: httpResponse.urlResponse.statusCode))]")
                    response?(nil)
                    return
                }
                
                response?(validdata)
            }, error: { (request, error) in
                print("<ImageRequest> fetch data : Error in HTTP : [<error  [\(String(describing: error))]>")
                response?(nil)
                return
            })
        }
    }
}
