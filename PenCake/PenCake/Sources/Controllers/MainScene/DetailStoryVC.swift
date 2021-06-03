//
//  DetailStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit

class DetailStoryVC: UIViewController {
    lazy private var backButton: UIButton = {
        let button = UIButton()
        let action = UIAction { _ in
            self.navigationController?.popViewController(animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18,
                                                    weight: .light,
                                                    scale: .large),
                                               forImageIn: .normal)
        button.tintColor = .lightGray
        return button
    }()
    private var lineView = DetailSliderLineView()
    private var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var textCount: CGFloat = 10
    private let flowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfigure()
        collectionViewSetting()
    }
    
    override func viewWillLayoutSubviews() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width/textCount)
            make.height.equalTo(1)
        }
        
        detailCollectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupConfigure() {
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 8
        
        view.addSubview(backButton)
        view.addSubview(lineView)
        view.addSubview(detailCollectionView)
    }
    
    private func collectionViewSetting() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        flowLayout.scrollDirection = .horizontal
        detailCollectionView.collectionViewLayout = flowLayout
        detailCollectionView.isPagingEnabled = true
        
        let nib = UINib(nibName: "StoryDetailCVC", bundle: nil)
        detailCollectionView.register(nib, forCellWithReuseIdentifier: StoryDetailCVC.identifier)
    }
}

extension DetailStoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryDetailCVC.identifier, for: indexPath) as? StoryDetailCVC else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension DetailStoryVC:  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
