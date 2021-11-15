//
//  ObjectDetailsViewController.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ObjectDetailsViewController: UIViewController {
    
    private var viewModel: ObjectDetailsViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var objectID: Int!
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collection.dataSource = self
        collection.register(UINib(nibName: viewModel.imageCellIdentifier, bundle: nil), forCellWithReuseIdentifier: viewModel.imageCellIdentifier)
        collection.register(UINib(nibName: viewModel.descriptionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: viewModel.descriptionCellIdentifier)
        return collection
    }()
    
    
    convenience init(objectID: Int, viewModel: ObjectDetailsViewModelProtocol){
        self.init()
        self.objectID = objectID
        self.viewModel = viewModel
        self.viewModel.objectID.onNext(objectID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModelOutputs()
        bindInputs()
    }
    
    func setupUI(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.fillSuperviewSafeArea()
    }
    
    func createCompositionalLayout()-> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, environment) -> NSCollectionLayoutSection? in
            return self?.createSectionFor(index: index, environment: environment)
        }
        return layout
    }
    
    func createSectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch index {
        case 0:
            return createCompositionalSection(itemWidth: .fractionalWidth(1), itemHeight: .fractionalHeight(1), groupWidth: .fractionalWidth(1), groupHeight: .fractionalHeight(0.4))
        case 1:
            return createCompositionalSection(inset: 2.5, itemWidth: .fractionalWidth(0.4), itemHeight: .fractionalHeight(1), groupWidth: .fractionalWidth(1), groupHeight: .fractionalHeight(0.2), groupDirection: .horizontal, continuousScrolling: true, continuousScrollItemCount: 2)
        default:
            return createCompositionalSection(itemWidth: .fractionalWidth(1), itemHeight: .estimated(100), groupWidth: .fractionalWidth(1), groupHeight: .estimated(100))
        }
    }
    
    func bindViewModelOutputs(){
        
        viewModel.outputs.stateSubject
            .subscribe(onNext:  { [weak self] state in
                guard let self = self else { return }
                state == .loading ? self.startLoading() : self.stopLoading()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorSubject
            .subscribe(onNext:  { [weak self] message in
                guard let self = self, let message = message else { return }
                self.showSimpleAlert(title: "Error", message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.dataSubject
            .subscribe(onNext: { [weak self] object in
                guard let self = self, let object = object else { return }
                self.navigationItem.title = object.title
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func bindInputs(){
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.openPhotoAt(index)
        })
            .disposed(by: disposeBag)
    }
    
    func openPhotoAt(_ index: IndexPath) {
        guard let url = viewModel.outputs.getURLforImageAt(index) else {return}
        let controller = PhotoDetailsViewController(imageURL: url)
        present(controller, animated: true)
    }
    
}


extension ObjectDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return viewModel.dataSubject.value?.additionalImages?.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0, 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.imageCellIdentifier, for: indexPath) as? ObjectImageCell else {
                return UICollectionViewCell()
            }
            if indexPath.section == 0 {
                cell.imageURLString = viewModel.dataSubject.value?.primaryImage
            } else {
                cell.imageURLString = viewModel.dataSubject.value?.additionalImages?[indexPath.item]
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.descriptionCellIdentifier, for: indexPath) as? ObjectDescriptionCell else {
                return UICollectionViewCell()
            }
            
            cell.object = viewModel.dataSubject.value
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}
