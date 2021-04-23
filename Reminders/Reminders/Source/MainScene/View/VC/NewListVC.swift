//
//  NewListVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/16.
//

import UIKit

class NewListVC: UIViewController {
    var saveList: ((String) -> ())?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listImage: UIButton!
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet weak var listTextField: UITextField!
    
    var canSaved = false
    
    let colors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .systemGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension NewListVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            canSaved = true
            addButton.isEnabled = true
        } else {
            canSaved = false
            addButton.isEnabled = false
        }
    }
}

extension NewListVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if canSaved {
            let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let dismiss = UIAlertAction(title: "변경 사항 폐기", style: .destructive) { (_) in
                self.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(dismiss)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UI
extension NewListVC {
    private func setUI() {
        setDelegate()
        setButton()
        setLabel()
        setTextField()
    }
    
    private func setDelegate() {
        presentationController?.delegate = self
        isModalInPresentation = true
    }
    
    private func setButton() {
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.addTarget(self, action: #selector(touchUpCancel), for: .touchUpInside)
        
        addButton.setTitle("완료", for: .normal)
        addButton.isEnabled = false
        addButton.addTarget(self, action: #selector(touchUpSave), for: .touchUpInside)
        
        listImage.backgroundColor = .systemBlue
        listImage.layer.cornerRadius = 45
        listImage.tintColor = .white
        listImage.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listImage.setPreferredSymbolConfiguration(.init(pointSize: 35, weight: .bold, scale: .large), forImageIn: .normal)
        listImage.layer.shadowColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
        listImage.layer.shadowRadius = 8
        listImage.layer.shadowOpacity = 1
        listImage.layer.shadowOffset = CGSize(width: 0, height: 0)
        listImage.isUserInteractionEnabled = false
        
        var index = 0
        for btn in colorButtons {
            btn.setTitle("", for: .normal)
            btn.layer.cornerRadius = 20
            btn.backgroundColor = colors[index]
        
            let action = UIAction { _ in
                self.listImage.backgroundColor = btn.backgroundColor
                self.listTextField.textColor = btn.backgroundColor
            }
            btn.addAction(action, for: .touchUpInside)
            index += 1
        }
    }
    
    private func setLabel() {
        titleLabel.text = "새로운 목록"
        titleLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    private func setTextField() {
        listTextField.delegate = self
        listTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        listTextField.textAlignment = .center
        listTextField.textColor = .systemBlue
        listTextField.font = .boldSystemFont(ofSize: 20)
        listTextField.clearButtonMode = .whileEditing
        listTextField.becomeFirstResponder()
    }
}

// MARK: - Action
extension NewListVC {
    @objc
    func touchUpCancel() {
        if canSaved {
            let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let dismiss = UIAlertAction(title: "변경 사항 폐기", style: .destructive) { (_) in
                self.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(dismiss)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func touchUpSave() {
        dismiss(animated: true) {
            self.saveList?(self.listTextField.text!)
        }
    }
}
