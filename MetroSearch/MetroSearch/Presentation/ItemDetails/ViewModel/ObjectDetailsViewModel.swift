//
//  ObjectDetailsViewModel.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol ObjectDetailsViewModelInputs: AnyObject {
    var objectID: PublishSubject<Int> { get }
}

protocol ObjectDetailsViewModelOutputs: AnyObject {
    var dataSubject: BehaviorRelay<MuseumItem?> { get }
    var stateSubject: BehaviorRelay<DataState?> { get }
    var errorSubject: BehaviorRelay<String?> { get }
    var imageCellIdentifier: String { get }
    var descriptionCellIdentifier: String { get }
    func getURLforImageAt(_ index: IndexPath) -> URL?
}

protocol ObjectDetailsViewModelProtocol: ObjectDetailsViewModelInputs, ObjectDetailsViewModelOutputs {
    var inputs: ObjectDetailsViewModelInputs { get }
    var outputs: ObjectDetailsViewModelOutputs { get }
}


class ObjectDetailsViewModel: ObjectDetailsViewModelProtocol {
    
    var inputs: ObjectDetailsViewModelInputs { self }
    var outputs: ObjectDetailsViewModelOutputs { self }
    
    //MARK: - Inputs
    let objectID = PublishSubject<Int>()
    
    //MARK: - Outputs
    let dataSubject = BehaviorRelay<MuseumItem?>(value: nil)
    let stateSubject = BehaviorRelay<DataState?>(value: nil)
    let errorSubject = BehaviorRelay<String?>(value: nil)
    let imageCellIdentifier = "ObjectImageCell"
    let descriptionCellIdentifier = "ObjectDescriptionCell"
    
    //MARK: -     
    private let objectRepository: ObjectRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(objectRepository: ObjectRepositoryProtocol){
        self.objectRepository = objectRepository
        bindInputs()
    }
    
    func bindInputs(){
        inputs
            .objectID
            .subscribe(onNext: { [weak self] id in
                self?.getObjectDetails(id: id)
            })
            .disposed(by: disposeBag)
    }
    
    func getObjectDetails(id: Int) {
        stateSubject.accept(.loading)
        
        objectRepository
            .getObjectDetails(id: id)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.stateSubject.accept(.populated)
                self.dataSubject.accept(item)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func getURLforImageAt(_ index: IndexPath) -> URL? {
        if index.section == 0 {
            return URL(string: dataSubject.value?.primaryImage ?? "")
        } else {
            return URL(string: dataSubject.value?.additionalImages?[index.item] ?? "")
        }
    }
    
}
