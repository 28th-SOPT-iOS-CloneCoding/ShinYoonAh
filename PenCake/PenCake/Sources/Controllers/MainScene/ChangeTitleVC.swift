//
//  ChangeTitleVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/06/03.
//

import UIKit
import SnapKit
import Then

class ChangeTitleVC: UIViewController {
    var changeTitle: ((String, String) -> Void)?
    
    lazy private var header = StorySubViewHeader(root: self)
    private var titleTextField = UITextField().then {
        $0.placeholder = "제목"
        $0.font = .myBoldSystemFont(ofSize: 19)
        $0.borderStyle = .none
        $0.textAlignment = .center
        $0.removeAuto()
    }
    
    private var subTitleTextField = UITextField().then {
        $0.placeholder = "소제목"
        $0.font = .myRegularSystemFont(ofSize: 15)
        $0.borderStyle = .none
        $0.textAlignment = .center
        $0.removeAuto()
    }
    
    var titleData: String?
    var subTitleData: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        subTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(header)
        view.addSubview(titleTextField)
        view.addSubview(subTitleTextField)
        
        titleTextField.becomeFirstResponder()
        
        titleTextField.text = titleData
        subTitleTextField.text = subTitleData
    }
    
    func saveTitle() {
        if let titleEmpty = titleTextField.text?.isEmpty,
           let subEmpty = subTitleTextField.text?.isEmpty {
            if titleEmpty {
                makeAlert(message: "제목을 입력해주세요")
                return
            } else if subEmpty {
                makeAlert(message: "소제목을 입력해주세요")
                return
            }
            
            changeTitle?(titleTextField.text!, subTitleTextField.text!)
            dismiss(animated: true, completion: nil)
        }
    }
}
