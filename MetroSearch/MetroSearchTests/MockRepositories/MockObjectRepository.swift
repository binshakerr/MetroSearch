//
//  MockObjectRepository.swift
//  MetroSearchTests
//
//  Created by Eslam Shaker on 15/11/2021.
//

import Foundation
import RxSwift
@testable import MetroSearch

class MockObjectRepository: ObjectRepositoryProtocol {

    var searchStubData: SearchResult?
    var objectStubData: MuseumItem?
    
    func searchObjects(keyword: String) -> Observable<SearchResult> {
        if let searchItem = searchStubData {
            return .just(searchItem)
        }
 
        return .error(MockError.noDataFound)
    }
 
    func getObjectDetails(id: Int) -> Observable<MuseumItem?> {
        if let museumItem = objectStubData {
            return .just(museumItem)
        }
 
        return .error(MockError.noDataFound)
    }
 
}
