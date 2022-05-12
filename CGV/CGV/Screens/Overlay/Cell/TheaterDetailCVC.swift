//
//  TheaterDetailCVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/18.
//

import UIKit

class TheaterDetailCVC: UICollectionViewCell {
    static let identifier = "TheaterDetailCVC"

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var areaLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.areaLabel.textColor = isSelected ? UIColor.systemRed : UIColor.darkGray
            self.areaLabel.font = isSelected ? .boldSystemFont(ofSize: 15) : .systemFont(ofSize: 15)
            self.backView.layer.borderColor = isSelected ? UIColor.systemRed.cgColor : UIColor.systemGray4.cgColor
            self.backView.backgroundColor = isSelected ? .white : .systemGray6
            self.layer.shadowColor = isSelected ? UIColor.black.withAlphaComponent(0.3).cgColor : UIColor.white.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        self.setViewShadow(backView: backView)
    }
    
    func labelConfigure(position: String) {
        areaLabel.text = position
    }
}
