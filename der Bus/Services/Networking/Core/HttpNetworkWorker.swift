//
//  HttpNetworkWorker.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Http{
    fileprivate class RequestMetaData {
        var urlSession: URLSession
        var dataTask: URLSessionDataTask
        var httpRequest: Request
        var successHandler: Http.SuccessHandler
        var errorHandler: Http.ErrorHandler
        var data: Data?
        var httpURLResponse: HTTPURLResponse?
        
        init(_ request: Request, session: URLSession, task: URLSessionDataTask, success: @escaping Http.SuccessHandler, error: @escaping Http.ErrorHandler) {
            httpRequest = request
            urlSession = session
            dataTask = task
            successHandler = success
            errorHandler = error
        }
    }
    
    class NetworkWorker: NSObject, HttpWorker {
        fileprivate var creator: String = ""
        //Request Metadata Holder
        fileprivate var metaDataHolder = Dictionary<String, RequestMetaData>()
        
        init(_ creator: String){
            self.creator = creator
        }
        
        func send(_ request: Http.Request, success: @escaping Http.SuccessHandler, error: @escaping Http.ErrorHandler) {
            //cancel if the same request is already in progress.
            cancel(request)
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.timeoutIntervalForRequest = URLConstants.httpTimeout
            sessionConfiguration.timeoutIntervalForResource = URLConstants.httpTimeout
            
            let session = URLSession(configuration:sessionConfiguration, delegate: self, delegateQueue: nil)
            
            //            print("HTTPWorker[\(creator)]::sending http request:<\(request)>.")

            let dataTask = session.dataTask(with: request.urlRequest)
            dataTask.taskDescription = request.id.uuidString
            
            
            //create request meta data
            let requestMetaData = RequestMetaData(request, session: session, task: dataTask, success: success, error: error)
            self.setMetaData(requestMetaData, id: request.id.uuidString)
            //            print("HTTPWorker[\(self.creator)]::sessionConfiguration http headers:<\(String(describing: session.configuration.httpAdditionalHeaders))>.")
            //            print("HTTPWorker[\(self.creator)]::request http headers:<\(String(describing: request.urlRequest.allHTTPHeaderFields))>.")
            
            dataTask.resume()
        }
        
        @discardableResult
        func cancel(_ request: Http.Request) -> Bool {
            var result = false
            DispatchQueue.global().sync { [unowned self] in
                if let metaData = self.metaDataHolder[request.id.uuidString] {
                    metaData.dataTask.cancel()
                    metaData.urlSession.invalidateAndCancel()
                    result = true
                }
            }
            
            self.removeMetaData(request.id.uuidString)
            return result
        }
        
        @discardableResult
        func cancelAll() -> Bool {
            DispatchQueue.global().sync { [unowned self] in
                let values = Array(self.metaDataHolder.values)
                for metaData in values {
                    metaData.dataTask.cancel()
                    metaData.urlSession.invalidateAndCancel()
                }
            }
            
            removeAllMetaData()
            return true
        }
        
        //MARK:- Meta Data
        fileprivate func metaData(_ id: String) -> RequestMetaData? {
            var metaData: RequestMetaData?
            DispatchQueue.global().sync { [unowned self] in
                //                print("HTTPWorker[\(self.creator)]::returning metadata for: \(id)")
                metaData = self.metaDataHolder[id]
            }
            
            return metaData
        }
        
        fileprivate func setMetaData(_ metaData: RequestMetaData, id: String){
            DispatchQueue.global().sync { [unowned self] in
                //                print("HTTPWorker[\(self.creator)]::setting new meta data for: \(id)")
                self.metaDataHolder[id] = metaData
                //                print("HTTPWorker[\(self.creator)]::active requests after set: \(Array(self.metaDataHolder.keys))")
            }
        }
        
        fileprivate func initializeData(_ id: String) {
            DispatchQueue.global().sync { [unowned self] in
                if let metaData = self.metaDataHolder[id] {
                    metaData.data = Data()
                }
            }
        }
        
        fileprivate func appendDataForRequest(_ data: Data, id: String){
            DispatchQueue.global().sync { [unowned self] in
                if let metaData = self.metaDataHolder[id] {
                    metaData.data?.append(data)
                }
            }
        }
        
        fileprivate func removeMetaData(_ id: String) {
            DispatchQueue.global().sync { [unowned self] in
                let idd = id
//                print("HTTPWorker[\(self.creator)]::removing meta data for: \(id)")
                self.metaDataHolder.removeValue(forKey: idd)
            }
        }
        
        fileprivate func removeAllMetaData(){
            DispatchQueue.global().sync { [unowned self] in
//                print("HTTPWorker[\(self.creator)]::removing all meta data.")
                self.metaDataHolder.removeAll()
            }
        }
    }
}

extension Http.NetworkWorker: URLSessionDataDelegate{
    //MARK:- URLSessionDelegate
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?){
        //        print("HTTPWorker[\(self.creator)]::session became invalid with error:<\(String(describing: error))>")
    }
    
    //MARK:- URLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        
        if let metaData = self.metaData(task.taskDescription!) {
            let httpRequest = metaData.httpRequest
            if let validerror = error as NSError?{
                metaData.urlSession.finishTasksAndInvalidate()
                metaData.errorHandler(httpRequest, Http.Error(code: validerror.code, errorDescription: validerror.localizedDescription))
                self.removeMetaData(metaData.httpRequest.id.uuidString)
            }else{
                if let validResponse = metaData.httpURLResponse {
                    //                    print("HTTPWorker[\(String(describing: self.creator))]::valid response present, returning success. Data length: \(String(describing: metaData.data?.count)).)")
                    let httpResponse = Http.Response(httpResponse: validResponse, data: metaData.data
                        , finalURL: validResponse.url)
                    metaData.urlSession.finishTasksAndInvalidate()
                    metaData.successHandler(httpRequest, httpResponse)
                    self.removeMetaData(metaData.httpRequest.id.uuidString)
                }else{
                    //                    print("HTTPWorker[\(self.creator)]::invalid response present, returning success.")
                    metaData.urlSession.finishTasksAndInvalidate()
                    metaData.errorHandler(httpRequest, Http.Error(code: Http.ErrorCodes.invalidResponse.rawValue))
                    self.removeMetaData(metaData.httpRequest.id.uuidString)
                }
            }
        }else{
            //            print("HTTPWorker[\(self.creator)]::failed to get meta data of the request, error.")
        }
    }
    
    //MARK:- URLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        //        print("HTTPWorker[\(self.creator)]::did receive response:<\(response)>")
        
        if let metaData = self.metaData(dataTask.taskDescription!){
            guard let validResponse = response as? HTTPURLResponse else {
                //                print("HttpWorker[\(self.creator)]::failed to unwrap response, canceling HTTP.")
                metaData.urlSession.finishTasksAndInvalidate()
                metaData.errorHandler(metaData.httpRequest, Http.Error(code: Http.ErrorCodes.invalidResponse.rawValue))
                self.removeMetaData(dataTask.taskDescription!)
                
                completionHandler(.cancel)
                return
            }
            
            metaData.httpURLResponse = validResponse
            self.initializeData(metaData.httpRequest.id.uuidString)
            
            //            print("HttpWorker[\(self.creator)]::valid response, proceeding with the HTTP request.")
            completionHandler(.allow)
        }else{
            completionHandler(.cancel)
            //            print("HttpWorker[\(self.creator)]::URLSession(session,dataTask,didReceiveResponse,completionHandler):: failed to get meta data of the request, error.")
            return
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        appendDataForRequest(data, id: dataTask.taskDescription!)
    }
}
