//
//  SearchViewModel.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

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
    var searchSubject = PublishSubject<String>()


    //MARK: - Outputs
    let cellIdentifier = "SearchCell"
    let screenTitle = "The Metropolitan Museum of Art"
    let searchControllerPlaceHolder = "Search Objects"
    var dataSubject = BehaviorRelay<[Int]>(value: [])
    var stateSubject = BehaviorRelay<DataState?>(value: nil)
    var errorSubject = BehaviorRelay<String?>(value: nil)
    let noResultsText = "No results found for this query!"
    
    //MARK: -
    private var networkManager: NetworkManagerType
    private let disposeBag = DisposeBag()
    private var lastSearchedKeyword = ""
    
    init(networkManager: NetworkManagerType = NetworkManager.shared){
        self.networkManager = networkManager
        bindInputs()
    }
    
    func bindInputs(){
        inputs.searchSubject.subscribe(onNext: { [weak self] searchTerm in
            self?.searchPhotos(keyword: searchTerm)
        }).disposed(by: disposeBag)
    }
    
    func searchPhotos(keyword: String) {
        let text = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 0 else {return}
        if keyword != self.lastSearchedKeyword {
            resetSearch()
        }
        lastSearchedKeyword = keyword
        stateSubject.accept(.loading)
        
        let request = ObjectService.searchObjects(keyword: keyword)
        networkManager.request(request, type: SearchResult.self) { [weak self] (result, status) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.stateSubject.accept(response.total > 0 ? .populated : .empty)
                self.dataSubject.accept(response.objectIDs ?? [])
            case .failure(let error):
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            }
        }
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

