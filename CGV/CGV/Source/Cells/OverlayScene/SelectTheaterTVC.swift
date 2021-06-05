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
    
    lazy private var viewModel = TheaterViewModel(collectionView: positionCollectionView)
    private let downButton = DownButton()
    private let basicFlowLayout = UICollectionViewFlowLayout()
    private let customFlowLayout = LeftAlignedCollectionViewFlowLayout()
    
    private var isFirst = true
    private var isClicked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
        collectionViewSetting()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupButton() {
        self.addSubview(downButton)
        
        downButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(positionCollectionView.snp.top).offset(20)
            make.width.height.equalTo(30)
        }
        
        let downAction = UIAction { _ in
            if !self.isClicked {
                self.downButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                self.isClicked = true
                self.positionCollectionView.collectionViewLayout = self.customFlowLayout
                self.positionCollectionView.isScrollEnabled = true
                NotificationCenter.default.post(name: NSNotification.Name("increaseCell"), object: self.viewModel.positions.count)
            } else {
                self.downButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                self.isClicked = false
                self.basicFlowLayout.scrollDirection = .horizontal
                self.positionCollectionView.collectionViewLayout = self.basicFlowLayout
                self.positionCollectionView.isScrollEnabled = true
                NotificationCenter.default.post(name: NSNotification.Name("decreaseCell"), object: nil)
            }
        }
        downButton.addAction(downAction, for: .touchUpInside)
    }
    
    private func collectionViewSetting() {
        areaCollectionView.delegate =  self
        areaCollectionView.dataSource = self
        
        positionCollectionView.delegate = self
        positionCollectionView.dataSource = self
        
        areaCollectionView.setupCollectionViewNib(nib: TheaterCVC.identifier)
        positionCollectionView.setupCollectionViewNib(nib: TheaterDetailCVC.identifier)
        
        basicFlowLayout.scrollDirection = .horizontal
        positionCollectionView.collectionViewLayout = basicFlowLayout
    }
    
    private func calculateCellSize(collectionView: UICollectionView, index: Int) -> CGSize {
        let label = UILabel()
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch collectionView {
        case areaCollectionView:
            label.text = viewModel.areas[index]
            label.sizeToFit()
            
            width = label.frame.width
            height = 30
            return CGSize(width: width, height: height)
        case positionCollectionView:
            label.text = viewModel.positions[index]
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
            
            return CGSize(width: width, height: height)
        default:
            return CGSize.zero
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SelectTheaterTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case areaCollectionView:
            return viewModel.areas.count
        case positionCollectionView:
            return viewModel.positions.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case areaCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheaterCVC.identifier, for: indexPath) as? TheaterCVC else {
                return UICollectionViewCell()
            }
            
            if indexPath.item == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            } else  {
                cell.isSelected = false
            }

            cell.areaConfigure(area: viewModel.areas[indexPath.row])
            
            return cell
        case positionCollectionView:
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
            
            cell.labelConfigure(position: viewModel.positions[indexPath.row])
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SelectTheaterTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize(collectionView: collectionView, index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case areaCollectionView:
            return 10
        case positionCollectionView:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case areaCollectionView:
            return UIEdgeInsets(top: 13, left: 15, bottom: 5, right: 15)
        case positionCollectionView:
            return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
        default:
            return UIEdgeInsets.zero
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SelectTheaterTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case areaCollectionView:
            areaCollectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            viewModel.setPositionData(index: indexPath.row)
            NotificationCenter.default.post(name: NSNotification.Name("buttonInActive"), object: nil)
            
            if isClicked {
                NotificationCenter.default.post(name: NSNotification.Name("increaseCell"), object: viewModel.positions.count)
            }
        case positionCollectionView:
            positionCollectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("buttonActive"), object: viewModel.positions[indexPath.item])
        default: break
        }
    }
}
