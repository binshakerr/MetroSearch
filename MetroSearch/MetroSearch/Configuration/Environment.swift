//
//  Environment.swift
//  UGU
//
//  Created by Eslam Shaker on 30/03/2021.
//  Copyright © 2021 Human Soft Solution. All rights reserved.
//

import Foundation

public enum Environment {
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let value = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return value
    }()
    
    // MARK: - Plist values
    static let baseURL: String = {
        guard let value = Environment.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return value
    }()
    
    
   //MARK: - other values
    static let apiURL: String = {
        return baseURL + "/public/collection/v1"
    }()
}
