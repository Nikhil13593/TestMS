//
//  WebApiConstants.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 27/04/21.
//

import Foundation

class WebApiConstants{
    
    static var baseServer: String = "https://jsonplaceholder.typicode.com/posts"
    
    class func APIList() -> String {
           return "\(baseServer)"
       }
}
