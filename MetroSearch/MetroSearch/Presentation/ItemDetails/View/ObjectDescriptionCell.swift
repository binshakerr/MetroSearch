//
//  ObjectDescriptionCell.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 11/11/2021.
//

import UIKit

class ObjectDescriptionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistBioLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var objectDateLabel: UILabel!
    
    var object: MuseumItem? {
        didSet {
            guard let object = object else { return }
            titleLabel.text = object.title
            artistNameLabel.text = object.artistDisplayName
            artistBioLabel.text = object.artistDisplayBio
            mediumLabel.text = object.medium
            dimensionsLabel.text = object.dimensions
            objectDateLabel.text = object.objectDate
        }
    }

}
