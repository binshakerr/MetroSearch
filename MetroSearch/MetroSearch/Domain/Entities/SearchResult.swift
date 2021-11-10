//
//  SearchResult.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import Foundation

struct SearchResult: Codable {
    var total: Int
    var objectIDs: [Int]?
}
