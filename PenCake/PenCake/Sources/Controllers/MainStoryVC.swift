//
//  MainStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit

class MainStoryVC: UIViewController {
    private var storyTableView = UITableView()
    private let titleHeader = StoryTitleHeader()
    
    private var originalTableViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConfigure()
    }
    
    private func setupTableView() {
        storyTableView.dataSource = self
        storyTableView.delegate = self
        
        storyTableView.backgroundColor = .secondarySystemBackground
        storyTableView.separatorStyle = .none
        
        let nib = UINib(nibName: StoryListTVC.identifier, bundle: nil)
        storyTableView.register(nib, forCellReuseIdentifier: StoryListTVC.identifier)
    }
    
    private func setupConfigure() {
        view.addSubview(titleHeader)
        view.addSubview(storyTableView)
        
        titleHeader.snp.makeConstraints { make in
            if UIDevice.current.hasNotch {
                make.top.equalToSuperview().inset(44)
            } else {
                make.top.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
        }
        
        storyTableView.snp.makeConstraints { make in
            make.top.equalTo(titleHeader.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        originalTableViewHeight = storyTableView.frame.size.height
    }
}

extension MainStoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryListTVC.identifier) as? StoryListTVC else {
            return UITableViewCell()
        }
        return cell
    }
}

extension MainStoryVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = storyTableView.contentOffset.y
        
        if offset > 0 {
            print(offset)
            titleHeader.updateHeaderLayout(offset: offset)
            
            if offset > 46 {
                storyTableView.transform = CGAffineTransform(translationX: 0, y: -110)
            } else {
                storyTableView.transform = CGAffineTransform(translationX: 0, y: -offset*2.5)
            }
        } else if offset == 0 {
            titleHeader.backToOriginalHeaderLayout()
            storyTableView.transform = .identity
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = storyTableView.contentOffset.y
        
        if offset < -100 {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "CreateContentVC") as? CreateContentVC else { return }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}
