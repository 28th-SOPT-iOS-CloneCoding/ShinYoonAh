//
//  MovieTableSubHeader.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit
import SnapKit

class MovieTableSubHeader: UIView {
    let comeoutButton = UIButton()
    let bookingRateButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        comeoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(10)
        }
        
        bookingRateButton.snp.makeConstraints { make in
            make.centerY.equalTo(comeoutButton)
            make.leading.equalTo(comeoutButton.snp.trailing).offset(10)
        }
    }
    
    private func setupConfigure() {
        backgroundColor = .systemGray6

        comeoutButton.setHeaderButton(title: "개봉순")
        bookingRateButton.setHeaderButton(title: "예매율순")

        changeHeaderButtonColor(selectedButton: comeoutButton,
                                unselectedButton1: bookingRateButton,
                                unselectedButton2: UIButton())
        setupButtonAction()
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(comeoutButton)
        addSubview(bookingRateButton)
    }
    
    // MARK: - MovieData 관련 ViewModel 생성
    private func setupButtonAction() {
        let comeoutAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: self.comeoutButton,
                                         unselectedButton1: self.bookingRateButton,
                                    unselectedButton2: UIButton())
//            self.movieData = self.movieData.sorted(by: {$0.releaseDate > $1.releaseDate})
//            self.movieTableView.reloadData()
        }
        comeoutButton.addAction(comeoutAction, for: .touchUpInside)
        
        let bookingRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: self.bookingRateButton,
                                         unselectedButton1: self.comeoutButton,
                                    unselectedButton2: UIButton())
            print("도대체 이걸 어찌 구현..")
        }
        bookingRateButton.addAction(bookingRateAction, for: .touchUpInside)
    }
}
