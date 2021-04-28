//
//  SingletonClass.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 27/04/21.
//

import Foundation

class Singleton {
    
    static let sharedInstance = Singleton()
    private init() { }
    
    var postListData = [PostModel]()
    var titleSingleton : [String] = []
    var bodySingleton : [String] = []
    var index: [Int] = []
}
