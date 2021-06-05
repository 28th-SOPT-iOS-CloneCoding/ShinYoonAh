//
//  Extension+UICollectionView.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/06/05.
//

import UIKit

extension UICollectionView {
    func setupCollectionViewNib(nib: String) {
        let customNib = UINib(nibName: nib, bundle: nil)
        self.register(customNib, forCellWithReuseIdentifier: nib)
    }
}
