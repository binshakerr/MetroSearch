//
//  PhotoDetailsViewController.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailsImageView: UIImageView!
    
    private var imageURL: URL!
        
    convenience init(imageURL: URL){
        self.init()
        self.imageURL = imageURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPhoto()
    }
    
    func setupUI() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }
    
    func loadPhoto(){
        detailsImageView.loadImage(url: imageURL)
    }
}


extension PhotoDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailsImageView
    }
}
