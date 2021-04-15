//
//  ReminderMainTopTVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/15.
//

import UIKit

class ReminderMainTopTVC: UITableViewCell {
    static let identifier = "ReminderMainTopTVC"
    
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var firstCountLabel: UILabel!
    @IBOutlet weak var secondCountLabel: UILabel!
    @IBOutlet weak var thirdCountLabel: UILabel!
    
    var lists: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UI
extension ReminderMainTopTVC {
    private func setUI() {
        setView()
        setButton()
        setLabel()
    }
    
    private func setView() {
        backgroundColor = .clear
        
        firstView.layer.cornerRadius = 18
        secondView.layer.cornerRadius = 18
        thirdView.layer.cornerRadius = 18
    }
    
    private func setButton() {
        firstButton.layer.cornerRadius = 16
        
        secondButton.layer.cornerRadius = 16
        
        thirdButton.layer.cornerRadius = 16
    }
    
    private func setLabel() {
        firstLabel.textColor = .darkGray
        firstLabel.font = .boldSystemFont(ofSize: 16)
        
        secondLabel.textColor = .darkGray
        secondLabel.font = .boldSystemFont(ofSize: 16)
        
        thirdLabel.textColor = .darkGray
        thirdLabel.font = .boldSystemFont(ofSize: 16)
        
        firstCountLabel.font = .systemFont(ofSize: 25, weight: .bold)
        secondCountLabel.font = .systemFont(ofSize: 25, weight: .bold)
        thirdCountLabel.font = .systemFont(ofSize: 25, weight: .bold)
    }
    
    private func configureView(list: String, button: UIButton, label: UILabel) {
        label.text = list
        button.setPreferredSymbolConfiguration(.init(pointSize: 35, weight: .regular, scale: .large), forImageIn: .normal)
        if list == "오늘" {
            button.tintColor = .systemBlue
            button.setImage(UIImage(systemName: "calendar.circle.fill"), for: .normal)
        } else if list == "예정" {
            button.tintColor = .systemRed
            button.setImage(UIImage(systemName: "calendar.circle.fill"), for: .normal)
        } else if list == "전체" {
            button.tintColor = .darkGray
            button.setImage(UIImage(systemName: "tray.circle.fill"), for: .normal)
        }
    }
}

// MARK: - Data
extension ReminderMainTopTVC {
    func setLists(lists: [String]) {
        self.lists = lists
        
        firstCountLabel.text = "0"
        secondCountLabel.text = "0"
        thirdCountLabel.text = "0"
        
        if lists.count == 3 {
            configureView(list: lists[0], button: firstButton, label: firstLabel)
            configureView(list: lists[1], button: secondButton, label: secondLabel)
            configureView(list: lists[2], button: thirdButton, label: thirdLabel)
        }
    }
}
