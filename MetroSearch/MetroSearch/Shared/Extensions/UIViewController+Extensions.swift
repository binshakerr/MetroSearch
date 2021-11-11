//
//  UIViewController+Extensions.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func showSimpleAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func startLoading(){
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.tag = 6006
        view.addSubview(backgroundView)
        
        let loaderSize: CGFloat = 50
        let activity = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width/2) - (loaderSize/2), y: (view.frame.height/2) - (loaderSize/2), width: loaderSize, height: loaderSize), type: .lineScale)
        activity.tag = 7007
        activity.startAnimating()
        backgroundView.addSubview(activity)
    }
    
    func stopLoading() {
        if let activity = view.viewWithTag(7007) as? NVActivityIndicatorView {
            activity.stopAnimating()
            activity.removeFromSuperview()
        }
        
        if let background = view.viewWithTag(6006) {
            background.removeFromSuperview()
        }
    }
    
}


//MARK: - Compositional Layout

enum groupDirection {
    case horizontal
    case vertical
}

extension UIViewController {
    
    func createCompositionalSection(
        inset: CGFloat = 0.0,
        itemWidth: NSCollectionLayoutDimension,
        itemHeight: NSCollectionLayoutDimension,
        groupWidth: NSCollectionLayoutDimension,
        groupHeight: NSCollectionLayoutDimension,
        groupDirection: groupDirection = .horizontal,
        continuousScrolling: Bool = false,
        continuousScrollItemCount: Int = 1) -> NSCollectionLayoutSection {
            
            //item
            let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            //group
            var group: NSCollectionLayoutGroup!
            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
            if groupDirection == .horizontal {
                if continuousScrolling {
                  group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: continuousScrollItemCount)
                } else {
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                }
            } else {
                if continuousScrolling {
                    group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: continuousScrollItemCount)
                } else {
                    group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                }
            }
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            if continuousScrolling {
                section.orthogonalScrollingBehavior = .continuous
            }
            return section
        }
}
