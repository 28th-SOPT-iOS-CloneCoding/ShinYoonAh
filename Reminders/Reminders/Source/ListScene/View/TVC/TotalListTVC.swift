//
//  TotalListTVC.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/04/29.
//

import UIKit

class TotalListTVC: UITableViewCell {
    static let identifier = "TotalListTVC"
    
    var pushCheck: (() -> Void)?

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var underLabel: UILabel!
    
    var listTableView: UITableView?
    var indexPath: IndexPath?
    var totalListVC: TotalListVC?
    var expectedListVC: ExpectedListVC?
    
    var isExpected = false
    var isChecked = false
    var isCreated = false
    var getText = false
    var count = 0
    
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
            isCreated = true
            infoButton.isHidden = true
            if isExpected {
                createExpectCell()
            } else {
                createCell()
            }
        } else {
            getText = false
            isCreated = false
            infoButton.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reminderTextField.resignFirstResponder()
        infoButton.isHidden = true
        if isExpected {
            createExpectCell()
        } else {
            createCell()
        }
        return true
    }
}

// MARK: - UI
extension TotalListTVC {
    private func setUI() {
        setTextField()
        setCheckBox()
        setButton()
        setToolbar()
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
    
    func checkToggle() {
        if isChecked {
            isChecked = false
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkButton.tintColor = .lightGray
            reminderTextField.textColor = .black
        } else {
            isChecked = true
            checkButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            checkButton.tintColor = .systemBlue
            reminderTextField.textColor = .lightGray
            pushCheck?()
        }
    }
    
    private func setToolbar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 50))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar.badge.clock"), style: .plain, target: self, action: #selector(tappedCalendar))
        calendarButton.tintColor = .black
        let positionButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(tappedCalendar))
        positionButton.tintColor = .black
        let flagButton = UIBarButtonItem(image: UIImage(systemName: "flag"), style: .plain, target: self, action: #selector(tappedCalendar))
        flagButton.isEnabled = false
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(tappedCalendar))
        cameraButton.isEnabled = false
        
        toolBar.items = [flexibleSpace, calendarButton, flexibleSpace, flexibleSpace, positionButton, flexibleSpace,flexibleSpace, flagButton, flexibleSpace, flexibleSpace, cameraButton, flexibleSpace]
        toolBar.sizeToFit()
        reminderTextField.inputAccessoryView = toolBar
    }
}

// MARK: - Data
extension TotalListTVC {
    func createCell() {
        if getText && count == 0 {
            if let text = reminderTextField.text,
               let section = indexPath?.section {
                print(text)
                totalListVC?.cells[section].append(text)
                
                isChecked.toggle()
                checkToggle()
                
                listTableView?.beginUpdates()
                listTableView?.insertRows(at: [IndexPath(row: totalListVC?.cells[section].count ?? 0, section: section)], with: .automatic)
                listTableView?.endUpdates()
            }
            count += 1
        }
    }
    
    func createExpectCell() {
        if getText && count == 0 {
            if let text = reminderTextField.text,
               let count = expectedListVC?.cells.count {
                print(text)
                expectedListVC?.cells.append(text)
                
                isChecked.toggle()
                checkToggle()
                
                
                listTableView?.insertRows(at: [IndexPath(row: count, section: 0)], with: .fade)
            }
            count += 1
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
            // MARK: - 이 안에 넣어줘야 함
            if isExpected {
                createExpectCell()
            } else {
                createCell()
            }
        }
    }
    
    @objc
    func touchUpList() {
        
    }
    
    @objc
    private func tappedCalendar() {
        print("캘린더")
    }
}

// MARK: - Notification
extension TotalListTVC {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(touchUpList), name: NSNotification.Name(rawValue: "selectList"), object: nil)
    }
}
