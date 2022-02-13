//
//  FileDownloader.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 4/5/20.
//

import Foundation
import Alamofire

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
    func request<T: Decodable>(_ request: URLRequestConvertible, type: T.Type, completion: @escaping(Result<T, Error>) -> Void)
}

class NetworkManager {
    
    private let session: Session
    static let shared = NetworkManager(session: customSessionManager)
    
    init(session: Session) {
        self.session = session
    }
}

extension NetworkManager: NetworkManagerType {
    
    func request<T: Decodable>(_ request: URLRequestConvertible, type: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
        
        // Check Internet Connection
        if NetworkReachability.shared.status == .notReachable {
            let userInfo: [String : Any] = [
                NSLocalizedDescriptionKey:  NSLocalizedString("Connection", value: "Please check your internet connectivity", comment: "") ,
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Connection", value: "No Internet Connection", comment: "")
            ]
            let error = NSError(domain: "", code: 0, userInfo: userInfo)
            completion(.failure(error))
        }
        
        // Make Request
        session
            .request(request)
            .validate()
            .responseJSON { result in
                let statusCode = result.response?.statusCode ?? 0
                
                switch result.result {
                case .success:
                    switch statusCode {
                    case 200...299:
                        do {
                            guard let data = result.data else { return }
                            let result = try JSONDecoder().decode(type.self, from: data)
                            completion(.success(result))
                        } catch let error {
                            completion(.failure(error))
                        }
                    default: // Custom error
                        do {
                            guard let data = result.data else { return }
                            let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            let userInfo: [String : Any] = [
                                NSLocalizedDescriptionKey:  NSLocalizedString("Error code: \(statusCode)", value: result.message, comment: "") ,
                            ]
                            let error = NSError(domain: "", code: 0, userInfo: userInfo)
                            completion(.failure(error))
                        } catch let error {
                            completion(.failure(error))
                        }
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
