//
//  EditBottomTVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/23.
//

import UIKit

class EditBottomTVC: UITableViewCell {
    static let identifier = "EditBottomTVC"

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// MARK: - UI
extension EditBottomTVC {
    private func setUI() {
        setButton()
        setLabel()
    }
    
    private func setButton() {
        imageButton.backgroundColor = .systemBlue
        imageButton.layer.cornerRadius = 16
        imageButton.setPreferredSymbolConfiguration(.init(pointSize: 12, weight: .bold, scale: .large), forImageIn: .normal)
    }
    
    private func setLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .light)
    }
}

// MARK: - Data
extension EditBottomTVC {
    func setLists(title: String) {
        titleLabel.text = title
    }
}
