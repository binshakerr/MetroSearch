//
//  NetworkLogger.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 07/03/2021.
//

import Alamofire

class NetworkLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "com.MetroSearch.networklogger")
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print(json)
        }
    }
}
