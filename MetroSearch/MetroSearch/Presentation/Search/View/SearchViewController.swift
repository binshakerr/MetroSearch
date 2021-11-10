//
//  SearchViewController.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel = SearchViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    
    lazy var searchTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.cellIdentifier)
        return table
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.text = viewModel.noResultsText
        return label
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindOutputs()
        bindInputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //clear cell selection when returning back to the screen
        if let selectedIndexPath = searchTable.indexPathForSelectedRow {
            searchTable.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    //MARK: -
    func setupUI(){
        navigationItem.title = viewModel.screenTitle
        view.backgroundColor = .systemBackground
        view.addSubview(searchTable)
        searchTable.fillSuperviewSafeArea()
        setupSearchController()
    }
    
    func setupSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = viewModel.searchControllerPlaceHolder
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func bindOutputs(){
       
        viewModel.outputs.stateSubject
            .subscribe(onNext:  { [weak self] state in
            guard let self = self else { return }
            state == .loading ? self.startLoading() : self.stopLoading()
                if state == .empty {
                    self.searchTable.backgroundView = self.emptyLabel
                    self.searchTable.separatorStyle = .none
                } else {
                    self.searchTable.backgroundView = nil
                    self.searchTable.separatorStyle = .singleLine
                }
        })
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorSubject
            .subscribe(onNext:  { [weak self] message in
            guard let self = self, let message = message else { return }
            self.showSimpleAlert(title: "Error", message: message)
        })
            .disposed(by: disposeBag)
        
        viewModel.outputs.dataSubject
            .bind(to: searchTable
                    .rx
                    .items(cellIdentifier: viewModel.cellIdentifier, cellType: UITableViewCell.self)) { (items, object, cell) in
                cell.textLabel?.text = "\(object)"
            }
                    .disposed(by: disposeBag)
    }
    
    func bindInputs() {
        searchController.searchBar.rx.searchButtonClicked
            .compactMap {self.searchController.searchBar.text}
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        
        searchTable.rx.itemSelected.subscribe(onNext: { [weak self] item in
            self?.openPhotoDetails(item.row)
        })
            .disposed(by: disposeBag)
    }
    
    func openPhotoDetails(_ index: Int) {
        let id = viewModel.getIDForObjectAt(index)
        let controller = ObjectDetailsViewController(objectID: id)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
