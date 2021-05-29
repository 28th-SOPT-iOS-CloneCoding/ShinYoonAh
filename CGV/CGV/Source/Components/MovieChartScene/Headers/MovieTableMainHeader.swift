//
//  MovieTableMainHeader.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit
import SnapKit

class MovieTableMainHeader: UIView {
    let bookingRateButton = UIButton()
    let eggRateButton = UIButton()
    let nowPlayingButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        bookingRateButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(10)
        }
        
        eggRateButton.snp.makeConstraints { make in
            make.centerY.equalTo(bookingRateButton)
            make.leading.equalTo(bookingRateButton.snp.trailing).offset(10)
        }
        
        nowPlayingButton.snp.makeConstraints { make in
            make.centerY.equalTo(bookingRateButton.snp.centerY)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func setupConfigure() {
        backgroundColor = .systemGray6
        
        bookingRateButton.setHeaderButton(title: "예매율순")
        eggRateButton.setHeaderButton(title: "Egg지수순")
        nowPlayingButton.setHeaderButton(title: "현재상영작보기")
        
        changeHeaderButtonColor(selectedButton: bookingRateButton,
                                unselectedButton1: eggRateButton,
                                unselectedButton2: nowPlayingButton)
        setupButtonActions()
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(bookingRateButton)
        addSubview(eggRateButton)
        addSubview(nowPlayingButton)
    }
    
    // MARK: - MovieData 관련 ViewModel 생성
    private func setupButtonActions() {
        let bookingRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: self.bookingRateButton,
                                         unselectedButton1: self.eggRateButton,
                                         unselectedButton2: self.nowPlayingButton)
//            self.movieData = self.movieData.sorted(by: {$0.voteAverage > $1.voteAverage})
//            self.movieTableView.reloadData()
        }
        bookingRateButton.addAction(bookingRateAction, for: .touchUpInside)
        
        let eggRateAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: self.eggRateButton,
                                         unselectedButton1: self.bookingRateButton,
                                         unselectedButton2: self.nowPlayingButton)
            
//            self.movieData = self.movieData.sorted(by: {$0.popularity > $1.popularity})
//            self.movieTableView.reloadRows(
//                at: self.movieTableView.indexPathsForVisibleRows ?? [],
//                with: .none)
        }
        eggRateButton.addAction(eggRateAction, for: .touchUpInside)
        
        let nowPlayingAction = UIAction { _ in
            self.changeHeaderButtonColor(selectedButton: self.nowPlayingButton,
                                         unselectedButton1: self.bookingRateButton,
                                         unselectedButton2: self.eggRateButton)
//            self.page = 1
//            self.movieData.removeAll()
//            self.fetchNowPlaying(page: self.page)
        }
        nowPlayingButton.addAction(nowPlayingAction, for: .touchUpInside)
    }
}
