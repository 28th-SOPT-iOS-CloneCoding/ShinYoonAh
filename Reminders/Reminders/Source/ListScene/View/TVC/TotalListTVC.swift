//
//  TotalListTVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/29.
//

import UIKit

class TotalListTVC: UITableViewCell {
    static let identifier = "TotalListTVC"

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var reminderTextField: UITextField!
    
    var isChecked = false
    var getText = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        setNotification()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension TotalListTVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text!.isEmpty) {
            getText = true
            infoButton.isHidden = true
        }
    }
}

// MARK: - UI
extension TotalListTVC {
    private func setUI() {
        setTextField()
        setCheckBox()
        setButton()
    }
    
    private func setTextField() {
        reminderTextField.delegate = self
    }
    
    private func setButton() {
        infoButton.isHidden = true
    }
    
    private func setCheckBox() {
        checkButton.addTarget(self, action: #selector(touchUpCheck), for: .touchUpInside)
        checkButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        checkButton.tintColor = .lightGray
    }
    
    private func checkToggle() {
        if isChecked {
            isChecked = false
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkButton.tintColor = .lightGray
        } else {
            isChecked = true
            checkButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            checkButton.tintColor = .systemBlue
        }
    }
}

// MARK: - Action
extension TotalListTVC {
    @objc
    func touchUpCheck() {
        if getText {
            checkToggle()
            infoButton.isHidden = true
        } else {
            reminderTextField.becomeFirstResponder()
            infoButton.isHidden = false
        }
    }
    
    @objc
    func touchUpList() {
        
    }
}

// MARK: - Notification
extension TotalListTVC {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(touchUpList), name: NSNotification.Name(rawValue: "selectList"), object: nil)
    }
}
