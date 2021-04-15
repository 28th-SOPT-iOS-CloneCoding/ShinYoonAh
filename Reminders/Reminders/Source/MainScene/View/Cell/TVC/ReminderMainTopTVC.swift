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
    
    lazy var firstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    lazy var secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    lazy var thirdView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    
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
        setStackView()
    }
    
    private func setView() {
        backgroundColor = .clear
    }
    
    private func setStackView() {
        horizontalStackView.addArrangedSubview(firstView)
        horizontalStackView.addArrangedSubview(secondView)

        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(thirdView)
    }
}

// MARK: - Data
extension ReminderMainTopTVC {
    func setLists(lists: [String]) {
        self.lists = lists
    }
}
