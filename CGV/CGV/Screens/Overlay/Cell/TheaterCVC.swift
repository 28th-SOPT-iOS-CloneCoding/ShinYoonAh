//
//  TheaterCVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/18.
//

import UIKit

class TheaterCVC: UICollectionViewCell {
    static let identifier = "TheaterCVC"

    @IBOutlet weak var areaLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.areaLabel.textColor = isSelected ? UIColor.systemRed : UIColor.gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }
    
    func areaConfigure(area: String) {
        areaLabel.text = area
    }
    
    private func setupLabel() {
        areaLabel.font = .systemFont(ofSize: 15)
    }
}
