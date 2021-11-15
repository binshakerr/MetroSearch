//
//  MockError.swift
//  MetroSearchTests
//
//  Created by Eslam Shaker on 15/11/2021.
//

import Foundation

enum MockError: Error, LocalizedError {
    case noDataFound
 
    var errorDescription: String? {
        switch self {
        case .noDataFound:
            return "No data found"
        }
    }
}
