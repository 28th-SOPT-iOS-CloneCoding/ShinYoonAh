//
//  NewListVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/16.
//

import UIKit

class NewListVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listImage: UIButton!
    @IBOutlet weak var listTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension NewListVC {
    private func setUI() {
        setButton()
        setLabel()
        setTextField()
        setColorWell()
    }
    
    private func setButton() {
        cancelButton.setTitle("취소", for: .normal)
        
        addButton.setTitle("완료", for: .normal)
        addButton.isEnabled = false
        
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
    }
    
    private func setLabel() {
        titleLabel.text = "새로운 목록"
        titleLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    private func setTextField() {
        listTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        listTextField.textAlignment = .center
        listTextField.textColor = .systemBlue
        listTextField.font = .boldSystemFont(ofSize: 20)
        listTextField.clearButtonMode = .whileEditing
        listTextField.becomeFirstResponder()
    }
    
    private func setColorWell() {

    }
}

