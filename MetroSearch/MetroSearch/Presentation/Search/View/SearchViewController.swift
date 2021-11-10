//
//  SearchViewController.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
    }
    
}
