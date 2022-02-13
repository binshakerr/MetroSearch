//
//  MusuemItem.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import Foundation

struct MuseumItem: Decodable {
    var objectID: Int
    var primaryImage: String?
    var primaryImageSmall: String?
    var additionalImages: [String]?
    var title: String?
    var artistDisplayName: String?
    var artistDisplayBio: String?
    var medium: String?
    var dimensions: String?
    var objectDate: String?
}
