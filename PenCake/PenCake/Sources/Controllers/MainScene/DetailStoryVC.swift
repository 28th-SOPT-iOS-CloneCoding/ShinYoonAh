//
//  DetailStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit
import SnapKit
import Then
import CoreData

class DetailStoryVC: UIViewController {
    lazy private var backButton = UIButton().then {
        let action = UIAction { _ in
            self.navigationController?.popViewController(animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.setPreferredSymbolConfiguration(.init(pointSize: 18,
                                                    weight: .light,
                                                    scale: .large),
                                               forImageIn: .normal)
        $0.tintColor = .lightGray
    }
    private var lineView = DetailSliderLineView()
    private var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()
    
    var textCount: Int = 0
    var currentIndex: CGFloat = 0
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
            make.width.equalTo(UIScreen.main.bounds.size.width/CGFloat(textCount))
            make.height.equalTo(1)
        }
        
        detailCollectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupConfigure() {
        view.backgroundColor = .secondarySystemBackground
        
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 8
        
        view.addSubview(backButton)
        view.addSubview(lineView)
        view.addSubview(detailCollectionView)
        
        print(currentIndex)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
            self.detailCollectionView.scrollToItem(at: IndexPath(item: Int(self.currentIndex), section: 0), at: .centeredHorizontally, animated: false)
        })
        movePositiveDirection()
    }
    
    private func collectionViewSetting() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        flowLayout.scrollDirection = .horizontal
        detailCollectionView.collectionViewLayout = flowLayout
        detailCollectionView.isPagingEnabled = true
        
        let nib = UINib(nibName: "StoryDetailCVC", bundle: nil)
        detailCollectionView.register(nib, forCellWithReuseIdentifier: StoryDetailCVC.identifier)
        
        if textCount == 1 {
            detailCollectionView.isScrollEnabled = false
        }
    }
    
    // read the data
    func fetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contents")
        
        // sort
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest)
        return result
    }
}

extension DetailStoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(textCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryDetailCVC.identifier, for: indexPath) as? StoryDetailCVC else {
            return UICollectionViewCell()
        }
        let row = indexPath.row
        let record = self.list[row]
        let title = record.value(forKey: "title") as? String
        let content = record.value(forKey: "content") as? String
        
        cell.titleButton.setTitle(title, for: .normal)
        cell.contentButton.setTitle(content, for: .normal)
        cell.delegate = self
        return cell
    }
}

extension DetailStoryVC: UICollectionViewDelegateFlowLayout {
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

extension DetailStoryVC: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing = UIScreen.main.bounds.size.width
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
            moveNegativeDirection()
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
            movePositiveDirection()
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func movePositiveDirection() {
        UIView.animate(withDuration: 0.3, animations: {
            self.lineView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.size.width/CGFloat(self.textCount) * self.currentIndex, y: 0)
        })
    }
    
    func moveNegativeDirection() {
        UIView.animate(withDuration: 0.3, animations: {
            self.lineView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width/CGFloat(self.textCount) * (CGFloat(self.textCount) - self.currentIndex), y: 0)
        })
    }
}

extension DetailStoryVC: ModalFromCellDelegate {
    func presentViewController(with vc: CreateContentVC) {
        vc.isEditMode = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
