//
//  StoryListTVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit

class StoryListTVC: UITableViewCell {
    static let identifier = "StoryListTVC"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfigure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupConfigure() {
        backgroundColor = .clear
        
        titleLabel.font = .myRegularSystemFont(ofSize: 15)
        dateLabel.font = .myRegularSystemFont(ofSize: 10)
        dateLabel.textColor = .systemGray
    }
}
