//
//  EditTopTVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/23.
//

import UIKit

class EditTopTVC: UITableViewCell {
    static let identifier = "EditTopTVC"

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isChecked = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCheckBox()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UI
extension EditTopTVC {
    private func setCheckBox() {
        checkButton.addTarget(self, action: #selector(touchUpCheck), for: .touchUpInside)
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
    }
    
    private func checkToggle() {
        if isChecked {
            isChecked = false
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkButton.tintColor = .lightGray
        } else {
            isChecked = true
            checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkButton.tintColor = .systemBlue
        }
    }
    
    func setConfigure(title: String) {
        titleLabel.text = title
        imageButton.setPreferredSymbolConfiguration(.init(pointSize: 35, weight: .regular, scale: .large), forImageIn: .normal)
        if title == "오늘" {
            imageButton.tintColor = .systemBlue
            imageButton.setImage(UIImage(systemName: "calendar.circle.fill"), for: .normal)
        } else if title == "예정" {
            imageButton.tintColor = .systemRed
            imageButton.setImage(UIImage(systemName: "calendar.circle.fill"), for: .normal)
        } else if title == "전체" {
            imageButton.tintColor = .darkGray
            imageButton.setImage(UIImage(systemName: "tray.circle.fill"), for: .normal)
        }
    }
}

// MARK: - Action
extension EditTopTVC {
    @objc
    func touchUpCheck() {
        checkToggle()
    }
}
