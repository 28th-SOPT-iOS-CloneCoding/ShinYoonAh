//
//  SelectTheaterTVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/18.
//

import UIKit
import SnapKit

class SelectTheaterTVC: UITableViewCell {
    static let identifier = "SelectTheaterTVC"

    @IBOutlet weak var areaCollectionView: UICollectionView!
    @IBOutlet weak var positionCollectionView: UICollectionView!
    
    private var downButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .white
        button.setPreferredSymbolConfiguration(.init(pointSize: 15,
                                                     weight: .regular,
                                                     scale: .small),
                                                forImageIn: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: -2, height: 2)
        button.layer.shadowRadius = 3
        return button
    }()
    
    private let flowLayout = UICollectionViewFlowLayout()
    private let customFlowLayout = LeftAlignedCollectionViewFlowLayout()
    private var isFirst = true
    private var isClicked = false
    
    private let areas: [String] = ["추천 CGV", "서울", "경기", "인천", "강원", "대전/충청", "대구", "부산/울산", "경상", "광주/전라/제주"]
    private var positions: [String] = ["강변", "건대입구", "용산아이파크몰", "왕십리", "송파", "스타필드시티위례", "성남모란", "야탑"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SelectTheaterTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == areaCollectionView {
            return areas.count
        }
        return positions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == areaCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheaterCVC.identifier, for: indexPath) as? TheaterCVC else {
                return UICollectionViewCell()
            }
            if indexPath.item == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            } else  {
                cell.isSelected = false
            }
            cell.areaConfigure(area: areas[indexPath.row])
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheaterDetailCVC.identifier, for: indexPath) as? TheaterDetailCVC else {
            return UICollectionViewCell()
        }
        if indexPath.row == 0 && isFirst {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            isFirst = false
        } else  {
            cell.isSelected = false
        }
        cell.labelConfigure(position: positions[indexPath.row])
        return cell
    }
    
    
}

extension SelectTheaterTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if collectionView == areaCollectionView {
            label.text = areas[indexPath.row]
            label.sizeToFit()
            
            width = label.frame.width
            height = 30
        } else if collectionView == positionCollectionView {
            label.text = positions[indexPath.row]
            label.sizeToFit()
            
            if label.text?.count ?? 0 < 3 {
                width = label.frame.width + 50
            } else if label.text?.count ?? 0 <= 4 {
                width = label.frame.width + 40
            } else if label.text?.count ?? 0 <= 5 {
                width = label.frame.width + 30
            } else {
                width = label.frame.width + 20
            }
            height = 50
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == areaCollectionView {
            return 10
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == areaCollectionView {
            return UIEdgeInsets(top: 13, left: 15, bottom: 5, right: 15)
        }
        return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
    }
}

extension SelectTheaterTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == areaCollectionView {
            areaCollectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            setPositionData(index: indexPath.row)
            NotificationCenter.default.post(name: NSNotification.Name("buttonInActive"), object: nil)
            
            if isClicked {
                NotificationCenter.default.post(name: NSNotification.Name("increaseCell"), object: positions.count)
            }
        } else if collectionView == positionCollectionView {
            positionCollectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("buttonActive"), object: positions[indexPath.item])
        }
    }
}

// MARK: - UI
extension SelectTheaterTVC {
    private func setUI() {
        setCollectionView()
        setButton()
    }
    
    private func setCollectionView() {
        let theaterNib = UINib(nibName: TheaterCVC.identifier, bundle: nil)
        let detailNib = UINib(nibName: TheaterDetailCVC.identifier, bundle: nil)
        
        areaCollectionView.delegate =  self
        areaCollectionView.dataSource = self
        areaCollectionView.register(theaterNib, forCellWithReuseIdentifier: TheaterCVC.identifier)
        
        positionCollectionView.delegate = self
        positionCollectionView.dataSource = self
        positionCollectionView.register(detailNib, forCellWithReuseIdentifier: TheaterDetailCVC.identifier)
        
        flowLayout.scrollDirection = .horizontal
        positionCollectionView.collectionViewLayout = flowLayout
    }
    
    private func setButton() {
        self.addSubview(downButton)
        downButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(positionCollectionView.snp.top).offset(20)
            make.width.height.equalTo(30)
        }
        downButton.addTarget(self,
                         action: #selector(touchUpDown),
                         for: .touchUpInside)
    }
}

// MARK: - Action
extension SelectTheaterTVC {
    @objc
    func touchUpDown() {
        print("눌렀다")
        if !isClicked {
            downButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            isClicked = true
            positionCollectionView.collectionViewLayout = customFlowLayout
            positionCollectionView.isScrollEnabled = false
            NotificationCenter.default.post(name: NSNotification.Name("increaseCell"), object: positions.count)
        } else {
            downButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            isClicked = false
            flowLayout.scrollDirection = .horizontal
            positionCollectionView.collectionViewLayout = flowLayout
            positionCollectionView.isScrollEnabled = true
            NotificationCenter.default.post(name: NSNotification.Name("decreaseCell"), object: nil)
        }
    }
}

// MARK: - Data
extension SelectTheaterTVC {
    private func setPositionData(index: Int) {
        var array: [String] = []
        
        positions.removeAll()
        
        switch index {
        case 0: array = ["강변", "건대입구", "용산아이파크몰", "왕십리", "송파" ,"스타필드시티위례", "성남모란", "야탑"]
        case 1: array = ["강남", "강변", "건대입구", "구로", "대학로", "동대문", "등촌" ,"명동", "명동역 씨네라이브러리", "목동", "미아", "불광", "상봉", "성신여대입구", "송파", "수유", "신촌아트레온", "씨네드쉐프 압구정", "씨네드쉐프 용산", "압구정", "여의도", "영등포", "왕십리", "용산아이파크몰", "중계", "천호", "청담씨네시티", "피카디리1958", "하계", "홍대"]
        case 2: array = ["경기광주", "고양행신", "광교", "광교상현", "구리", "김포", "김포운양", "김포풍무", "김포한강", "동백", "동수원", "동탄", "동탄역", "동탄호수공원", "배곧", "범계", "부천", "부천역", "부천옥길", "북수원", "산본", "서현", "성남모란", "소풍" ,"수원" ,"스타필드시티위례", "시흥", "안산", "안성", "야탑", "양주옥정", "역곡", "오리", "오산", "오산중앙", "용인", "의정부", "의정부태흥", "이천", "일산", "정왕", "죽전", "파주문산", "파주야당", "판교", "평촌", "평택", "평택소사" ,"포천", "하남미사", "화성봉담", "화정"]
        case 3: array = ["계양", "남주안", "부평", "송도타임스페이스", "연수역", "인천" ,"인천공항", "인천논현", "인천연수", "인천학익", "주안역", "청라"]
        case 4: array = ["강릉", "원주", "인제", "춘천"]
        case 5: array = ["대전", "대전가수원", "대전가오", "대전탄방", "대전터미널", "유성노은", "논산", "당진", "보령", "서산", "세종", "천안", "천안터미널", "천안펜타포트", "청주(서문)", "청주성안길", "청주율량", "청주지웰시티", "청주터미널", "충북혁신" ,"충주교현", "홍성"]
        case 6: array = ["대구", "대구수성", "대구스타디움", "대구아카데미", "대구월성", "대구이시아", "대구칠곡", "대구한일", "대구현대"]
        case 7: array = ["남포", "대연", "동래" ,"서면", "서면삼정타워", "센텀시티", "씨네드쉐프 센텀시티", "아시아드", "정관", "하단아트몰링", "해운대", "화명", "울산삼산", "울산신천", "울산진장"]
        case 8: array = ["거제", "경산", "고성", "구미" ,"김천율곡", "김해", "김해율하", "김해장유", "마산", "북포항", "안동", "양산물금", "양산삼호", "진주혁신", "창원", "창원더시티" , "창원상남", "통영", "포항"]
        case 9: array = ["광주금남로", "광주상무", "광주용봉", "광주첨단", "광주충장로", "광주터미널", "광주하남" ,"광양", "광양 엘에프스퀘어", "군산", "나주", "목포", "목포평화광장", "서전주", "순천", "순천신대", "여수웅천", "익산", "제주", "제주노형"]
        default: array = []
        }
        
        positions = array
        positionCollectionView.reloadData()
        positionCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
}
