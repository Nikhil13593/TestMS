//
//  UserDefaults.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 27/04/21.
//

import Foundation

struct StorageKey {
    static let keyLoggedIn = "Login"
}

class UserDefaultStorage {

    static let sharedInstance = UserDefaultStorage()
}
