//
//  UIImageView+Extension.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 11/11/2021.
//

import Kingfisher

extension UIImageView {
    func loadImage(url: URL){
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }
}
