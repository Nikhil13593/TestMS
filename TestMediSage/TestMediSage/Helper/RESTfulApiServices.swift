//
//  RESTfulApiServices.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 27/04/21.
//

import Foundation
import UIKit

class RESTfulApiServices: NSObject , URLSessionDelegate {

    static let shared = RESTfulApiServices()
    
    static func makeRESTApiCall(endpointURL: String, requestMethod: String, customCompletionHandler: @escaping ((_ data: Data?, _ response: URLResponse?, _ error : Error?)->Void)) {
        
        let url = URL(string: endpointURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        var urlRequest = URLRequest (url: url!)
        urlRequest.httpMethod = requestMethod
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: shared, delegateQueue: OperationQueue.main)
        
        session.dataTask(with:urlRequest, completionHandler: customCompletionHandler).resume()
    }
}
