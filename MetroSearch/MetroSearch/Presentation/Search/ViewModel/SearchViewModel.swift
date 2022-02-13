//
//  SearchViewModel.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchViewModelInputs: AnyObject {
    var searchSubject: PublishSubject<String> { get }
}

protocol SearchViewModelOutputs: AnyObject {
    var dataSubject: BehaviorRelay<[Int]> { get }
    var stateSubject: BehaviorRelay<DataState?> { get }
    var errorSubject: BehaviorRelay<String?> { get }
    var screenTitle: String { get }
    var cellIdentifier: String { get }
    var searchControllerPlaceHolder: String { get }
    var noResultsText: String { get }
    func getIDForObjectAt(_ index: Int) -> Int
}


protocol SearchViewModelProtocol: SearchViewModelInputs, SearchViewModelOutputs {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

class SearchViewModel: SearchViewModelProtocol {
    
    var inputs: SearchViewModelInputs { self }
    var outputs: SearchViewModelOutputs { self }
    
    //MARK: - Inputs
    let searchSubject = PublishSubject<String>()


    //MARK: - Outputs
    let cellIdentifier = "SearchCell"
    let screenTitle = "The Metropolitan Museum of Art"
    let searchControllerPlaceHolder = "Search Objects"
    let dataSubject = BehaviorRelay<[Int]>(value: [])
    let stateSubject = BehaviorRelay<DataState?>(value: nil)
    let errorSubject = BehaviorRelay<String?>(value: nil)
    let noResultsText = "No results found for this query!"
    
    //MARK: -
    private let objectRepository: ObjectRepositoryProtocol
    private let disposeBag = DisposeBag()
    private var lastSearchedKeyword = ""
    
    init(objectRepository: ObjectRepositoryProtocol) {
        self.objectRepository = objectRepository
        bindInputs()
    }
    
    func bindInputs(){
        inputs
            .searchSubject
            .subscribe(onNext: { [weak self] searchTerm in
                self?.searchObjects(keyword: searchTerm)
            })
            .disposed(by: disposeBag)
    }
    
    func searchObjects(keyword: String) {
        let text = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 0 else {return}
        if keyword != self.lastSearchedKeyword {
            resetSearch()
        }
        lastSearchedKeyword = keyword
        stateSubject.accept(.loading)
        
        objectRepository
            .searchObjects(keyword: keyword)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.stateSubject.accept(response.total > 0 ? .populated : .empty)
                self.dataSubject.accept(response.objectIDs ?? [])
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func resetSearch(){
        dataSubject.accept([])
        stateSubject.accept(.empty)
        errorSubject.accept(nil)
        lastSearchedKeyword = ""
    }
    
    func getIDForObjectAt(_ index: Int) -> Int {
        return dataSubject.value[index]
    }
    
}

