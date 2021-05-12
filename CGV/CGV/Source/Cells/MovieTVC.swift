//
//  MovieTVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import UIKit
import Kingfisher

class MovieTVC: UITableViewCell {
    static let identifier = "MovieTVC"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eggRateLabel: UILabel!
    @IBOutlet weak var bookingTitleLabel: UILabel!
    @IBOutlet weak var bookingRateLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var nowBookingButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setConfigure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UI
extension MovieTVC {
    private func setConfigure() {
        setLabel()
        setButton()
    }
    
    private func setLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        eggRateLabel.font = .systemFont(ofSize: 12)
        eggRateLabel.textColor = .darkGray
        
        bookingTitleLabel.font = .systemFont(ofSize: 12)
        bookingTitleLabel.text = "예매율"
        bookingTitleLabel.textColor = .darkGray
        
        bookingRateLabel.font = .systemFont(ofSize: 12)
        bookingRateLabel.textColor = .systemRed
        
        releaseDateLabel.font = .systemFont(ofSize: 12)
        releaseDateLabel.textColor = .darkGray
    }
    
    private func setButton() {
        nowBookingButton.layer.cornerRadius = 3
    }
}

// MARK: - Data
extension MovieTVC {
    func setData(posterImage: String,
                 title: String,
                 eggRate: Double,
                 bookingRate: Double,
                 releaseData: String,
                 isAdult: Bool) {
        let string = "https://image.tmdb.org/t/p/w500/\(posterImage)"
        let url = URL(string: string)!
        posterImageView.kf.setImage(with: url)
        titleLabel.text = title
        eggRateLabel.text = "\(eggRate)"
        bookingRateLabel.text = "\(bookingRate)"
        releaseDateLabel.text = releaseData
    }
}
