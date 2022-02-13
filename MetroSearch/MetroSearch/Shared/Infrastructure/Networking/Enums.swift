//
//  FileDownloader.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 4/5/20.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case userAgent = "User-Agent"
    case version = "Version"
}

enum ContentType: String {
    case json = "application/json"
    case string = "application/x-www-form-urlencoded"
}
