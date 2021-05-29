//
//  ScrollToTopButton.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit

class ScrollToTopButton: UIButton {
    private var movieTableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(tableView: UITableView) {
        super.init(frame: .zero)
        movieTableView = tableView
        setupConfigure()
    }
    
    private func setupConfigure() {
        backgroundColor = .white.withAlphaComponent(0.8)
        layer.cornerRadius = 27
        layer.shadowColor  = UIColor.gray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3
        setImage(UIImage(systemName: "arrow.up"), for: .normal)
        setPreferredSymbolConfiguration(.init(pointSize: 20,
                                                      weight: .light,
                                                      scale: .large),
                                                 forImageIn: .normal)
        tintColor = .gray
        setupButtonAction()
    }
    
    private func setupButtonAction() {
        let scrollToTopAction = UIAction { _ in
            self.movieTableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
//            self.isScrolled = false
        }
        self.addAction(scrollToTopAction, for: .touchUpInside)
    }
}
