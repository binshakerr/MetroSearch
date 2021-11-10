//
//  ObjectDetailsViewModel.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

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

}


protocol ObjectDetailsViewModelProtocol: ObjectDetailsViewModelInputs, ObjectDetailsViewModelOutputs {
    var inputs: ObjectDetailsViewModelInputs { get }
    var outputs: ObjectDetailsViewModelOutputs { get }
}

class ObjectDetailsViewModel: ObjectDetailsViewModelProtocol {
    
    var inputs: ObjectDetailsViewModelInputs { self }
    var outputs: ObjectDetailsViewModelOutputs { self }
    
    //MARK: - Inputs
    var objectID = PublishSubject<Int>()
    
    func bindInputs(){
        inputs.objectID.subscribe(onNext: { [weak self] id in
            self?.getObjectDetails(id: id)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    var dataSubject = BehaviorRelay<MuseumItem?>(value: nil)
    var stateSubject = BehaviorRelay<DataState?>(value: nil)
    var errorSubject = BehaviorRelay<String?>(value: nil)
    var imageCellIdentifier = "ObjectImageCell"
    var descriptionCellIdentifier = "ObjectDescriptionCell"
    
    //MARK: -     
    private var networkManager: NetworkManagerType
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerType = NetworkManager.shared){
        self.networkManager = networkManager
        bindInputs()
    }
    
    func getObjectDetails(id: Int) {
        stateSubject.accept(.loading)
        
        let request = ObjectService.objectDetails(id: id)
        networkManager.request(request, type: MuseumItem.self) { [weak self] (result, status) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.stateSubject.accept(.populated)
                self.dataSubject.accept(response)
            case .failure(let error):
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            }
        }
    }
    
}
