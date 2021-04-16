//
//  ListTVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/16.
//

import UIKit

class ListTVC: UITableViewCell {
    static let identifier = "ListTVC"

    @IBOutlet weak var listImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UI
extension ListTVC {
    private func setUI() {
        setButton()
        setLabel()
    }
    
    private func setButton() {
        listImageButton.backgroundColor = .systemBlue
        listImageButton.layer.cornerRadius = 16
        listImageButton.setPreferredSymbolConfiguration(.init(pointSize: 12, weight: .bold, scale: .large), forImageIn: .normal)
    }
    
    private func setLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .light)
        
        countLabel.font = .systemFont(ofSize: 15)
        countLabel.textColor = .darkGray
    }
}

// MARK: - Data
extension ListTVC {
    func setLists(title: String) {
        titleLabel.text = title
        countLabel.text = "0"
    }
}
