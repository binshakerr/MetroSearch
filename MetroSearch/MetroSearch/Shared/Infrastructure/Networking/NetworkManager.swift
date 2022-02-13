//
//  FileDownloader.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 4/5/20.
//

import Foundation
import Alamofire

enum ResponseStatus {
    case success
    case error
}

var customSessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 30
    configuration.waitsForConnectivity = true

    
    let networkLogger = NetworkLogger()
    return Session(
        configuration: configuration,
        eventMonitors: [networkLogger])
}()

protocol NetworkManagerType {
    func request<T: Decodable>(_ request: URLRequestConvertible, type: T.Type, completion: @escaping(Result<T, Error>, ResponseStatus) -> Void)
}

class NetworkManager {
    
    private let manager: Session
    var requiresValidation: Bool?
    static let shared = NetworkManager(manager: customSessionManager, requiresValidation: true)
    
    init(manager: Session, requiresValidation: Bool) {
        self.manager = manager
        self.requiresValidation = requiresValidation
    }
}

extension NetworkManager: NetworkManagerType {
    
    func request<T: Decodable>(_ request: URLRequestConvertible, type: T.Type, completion: @escaping(Result<T, Error>, ResponseStatus) -> Void){
        
        var dataRequest: DataRequest!
        
        // 1- Check Internet Connection
        if NetworkReachability.shared.status == .notReachable {
            let userInfo: [String : Any] = [
                NSLocalizedDescriptionKey:  NSLocalizedString("Connection", value: "Please check your internet connectivity", comment: "") ,
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Connection", value: "No Internet Connection", comment: "")
            ]
            let error = NSError(domain: "", code: 0, userInfo: userInfo)
            completion(.failure(error), .error)
        }
        
        // 2- Validate Request
        dataRequest = (requiresValidation ?? false) ? customSessionManager.request(request).validate() : customSessionManager.request(request)
        
        // 3- Parse Request
        dataRequest.responseJSON { result in
            let statusCode = result.response?.statusCode ?? 0
            
            switch result.result {
            case .success(let response):
                switch statusCode {
                    
                case 200...299:
                    //see if it's error first
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let result = try JSONDecoder().decode(type.self, from: jsonData)
                        completion(.success(result), .success)
                    } catch let error {
                        print("error: ", error)
                        completion(.failure(error), .error)
                    }
                default: // Custom error
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let result = try JSONDecoder().decode(ErrorResponse.self, from: jsonData)
                        let userInfo: [String : Any] = [
                            NSLocalizedDescriptionKey:  NSLocalizedString("Error code: \(statusCode)", value: result.message, comment: "") ,
                        ]
                        let error = NSError(domain: "", code: 0, userInfo: userInfo)
                        completion(.failure(error), .error)
                    } catch let error {
                        print("error: ", error)
                        completion(.failure(error), .error)
                    }
                }
                
            case .failure(let error):
                print("error: ", error)
                completion(.failure(error), .error)
            }
        }
    }
}