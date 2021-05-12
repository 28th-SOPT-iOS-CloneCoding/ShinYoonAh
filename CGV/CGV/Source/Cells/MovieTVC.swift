//
//  MovieTVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/12.
//

import UIKit
import Kingfisher

enum MovieFormat: String, CaseIterable {
    case iMax = "imax"
    case arthouse = "arthouse"
    case fourDX = "4dx"
    case none
}

class MovieTVC: UITableViewCell {
    static let identifier = "MovieTVC"
    
    private let randomFormat = MovieFormat.allCases.randomElement()!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var movieFormatImageView: UIImageView!
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
        setFormat()
    }
    
    private func setLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
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
    
    private func setFormat() {
        movieFormatImageView.image = UIImage(named: randomFormat.rawValue)
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
        
        let eRate: Int = Int(round(eggRate / 100))
        eggRateLabel.text = "\(eRate)%"
        
        let bRate = bookingRate * 10
        bookingRateLabel.text = "\(bRate)%"
        
        let date = releaseData.replacingOccurrences(of: "-", with: ".")
        releaseDateLabel.text = "\(date) 개봉"
        
        if eRate >= 50 {
            eggImageView.image = UIImage(named: "goldEgg")
        } else {
            eggImageView.image = UIImage(named: "egg")
        }
        
        if isAdult {
            ageImageView.image = UIImage(named: "adult")
        } else {
            ageImageView.image = UIImage(named: "12")
        }
    }
}

