//
//  DateCVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/18.
//

import UIKit

class DateCVC: UICollectionViewCell {
    static let identifier = "DateCVC"

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.dateLabel.textColor = isSelected ? UIColor.systemRed : UIColor.darkGray
            self.dateLabel.font = isSelected ? .boldSystemFont(ofSize: 15) : .systemFont(ofSize: 15, weight: .semibold)
            self.dayLabel.textColor = isSelected ? UIColor.systemRed : UIColor.lightGray
            self.backView.layer.borderColor = isSelected ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
            self.layer.shadowColor = isSelected ? UIColor.black.withAlphaComponent(0.3).cgColor : UIColor.white.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfigure()
    }

    func labelConfigure(date: String, day: String) {
        dateLabel.text = date
        dayLabel.text = day
    }
    
    private func setupConfigure() {
        self.setViewShadow(backView: backView)
        
        dayLabel.font = .systemFont(ofSize: 13)
    }
}
