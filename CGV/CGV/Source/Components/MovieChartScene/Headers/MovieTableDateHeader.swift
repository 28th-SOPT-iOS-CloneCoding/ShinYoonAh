//
//  MovieTableDateHeader.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/29.
//

import UIKit

class MovieTableDateHeader: UIView {
    let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: MovieChartViewModel, section: Int) {
        super.init(frame: .zero)
        setupConfigure()
        headerLabel.text = model.releaseDate[section - 1].replacingOccurrences(of: "-", with: ".")
    }
    
    override func layoutSubviews() {
        headerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).inset(5)
            make.leading.equalTo(self.snp.leading).inset(10)
        }
    }
    
    private func setupConfigure() {
        backgroundColor = .white
        
        headerLabel.font = .systemFont(ofSize: 15)
        
        addSubview(headerLabel)
    }
}
