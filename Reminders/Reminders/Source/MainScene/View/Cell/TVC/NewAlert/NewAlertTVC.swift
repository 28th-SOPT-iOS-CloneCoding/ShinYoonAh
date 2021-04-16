//
//  NewAlertTVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/16.
//

import UIKit

class NewAlertTVC: UITableViewCell {
    static let identifier = "NewAlertTVC"

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var memoTextView: UITextView!
    
    var isFirst = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension NewAlertTVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            setNotification()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if isFirst {
            if textField.text?.count != 0 {
                setNotification()
                isFirst = false
            }
        }
    }
}

extension NewAlertTVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "메모"
            textView.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        }
    }
}


// MARK: - UI
extension NewAlertTVC {
    private func setUI() {
        setTextField()
        setView()
        setTextView()
    }
    
    private func setTextField() {
        titleTextField.delegate = self
        titleTextField.placeholder = "제목"
        titleTextField.font = .systemFont(ofSize: 17)
        titleTextField.perform(#selector(becomeFirstResponder))
    }
    
    private func setView() {
        separatorView.backgroundColor = .reminderGray
    }
    
    private func setTextView() {
        memoTextView.delegate = self
        memoTextView.text = "메모"
        memoTextView.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        memoTextView.font = .systemFont(ofSize: 17)
    }
}

// MARK: - Notification
extension NewAlertTVC {
    private func setNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("Save"), object: nil)
    }
}
