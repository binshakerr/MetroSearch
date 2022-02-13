//
//  SearchService.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import Foundation
import Alamofire

enum ObjectService {
    case searchObjects(keyword: String)
    case objectDetails(id: Int)
}

extension ObjectService: EndPoint {
    
    var method: HTTPMethod {
        switch self {
        case .searchObjects:
            return .get
        case .objectDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchObjects:
            return "/search"
        case .objectDetails(let id):
            return "/objects/\(id)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        
        case let .searchObjects(keyword):
            let parameters: [String: Any] =
            ["q": keyword,
             "hasImages": true]
            return parameters
            
        case .objectDetails:
            return nil
        }
        
    }
    
    var headers: [String: String] {
        return makeDefaultHeaders()
    }
    
}


extension ObjectService: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        return try makeURLRequest()
    }
}
