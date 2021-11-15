//
//  ObjectRepository.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 15/11/2021.
//

import Foundation
import RxSwift

protocol ObjectRepositoryProtocol {
    func searchObjects(keyword: String) -> Observable<SearchResult>
    func getObjectDetails(id: Int) -> Observable<MuseumItem?>
}
 
class ObjectRepository: ObjectRepositoryProtocol {
 
    private let networkManager: NetworkManagerType
 
    init(networkManager: NetworkManagerType = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func searchObjects(keyword: String) -> Observable<SearchResult> {
        return Observable.create { [weak self] observer in
            let request = ObjectService.searchObjects(keyword: keyword)
            self?.networkManager.request(request, type: SearchResult.self) { (result, status) in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
 
    func getObjectDetails(id: Int) -> Observable<MuseumItem?> {
        return Observable.create { [weak self] observer in
            let request = ObjectService.objectDetails(id: id)
            self?.networkManager.request(request, type: MuseumItem.self) { (result, status) in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
 
}
