//
//  NewStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class NewStoryVC: UIViewController {
    lazy private var header = NewStoryHeader(root: self, with: self)
    private var storyTitleView = StoryTitleView(content: "새 이야기를 추가합니다.\n이야기의 제목을 입력해주세요.", placeholder: "예) 일기, 일상을 끄적이다")
    private var storySubTitleView = StoryTitleView(content: "이야기의 소제목을 입력해주세요.\n다짐말을 써도 좋아요.", placeholder: "예) 오늘도 수고했어!")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfigure()
    }
    
    override func viewWillLayoutSubviews() {
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        storyTitleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(header.snp.bottom).offset(130)
            make.width.equalTo(UIScreen.main.bounds.size.width - 100)
            make.height.equalTo(90)
        }
        
        storySubTitleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.width.equalTo(UIScreen.main.bounds.size.width - 100)
            make.height.equalTo(90)
        }
    }
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(header)
        view.addSubview(storyTitleView)
        view.addSubview(storySubTitleView)
        
        storySubTitleView.isHidden = true
    }
    
    func moveStoryView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.storyTitleView.transform = CGAffineTransform(translationX: 0, y: -500)
            self.storySubTitleView.transform = CGAffineTransform(translationX: 0, y: -500)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.storyTitleView.backgroundColor = .none?.withAlphaComponent(0.5)
                self.storyTitleView.isHidden = true
                self.storySubTitleView.isHidden = false
            }
        })
    }
}
