//
//  ObjectImageCell.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 11/11/2021.
//

import UIKit

class ObjectImageCell: UICollectionViewCell {
    
    @IBOutlet weak var objectImageView: UIImageView!

    var imageURLString: String? {
        didSet {
            guard let url = URL(string: imageURLString ?? "") else { return }
            objectImageView.loadDownsampledImage(url: url)
        }
    }
}
