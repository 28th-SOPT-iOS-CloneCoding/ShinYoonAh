//
//  StoryPageVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit
import SnapKit

class StoryPageVC: UIPageViewController {
    var completeHandler: ((Int) -> ())?
    
    var viewsList: [UIViewController] = []
    var plusButton = PlusButton()
    
    private var canReload = true
    private var currentPage = 0
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pageInit()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setViewControllersFromIndex(index: currentPage)
    }
    
    override func viewWillLayoutSubviews() {
        plusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(55)
        }
    }
    
    private func pageInit() {
        self.dataSource = self
        self.delegate = self
        
        view.backgroundColor = .secondarySystemBackground
        
        let storyboard = UIStoryboard(name: "StoryPage", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainStoryNavi")
        let createVC = storyboard.instantiateViewController(withIdentifier: "CreateStoryVC") as! CreateStoryVC
        if let vc = mainVC.children.first as? MainStoryVC {
            vc.pageVC = self
        }
        createVC.pageController = self
        
        viewsList = [mainVC, createVC]
    }
    
    private func setupButton() {
        view.addSubview(plusButton)
        
        let plusAction = UIAction { _ in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC else { return }
            if self.currentIndex == self.viewsList.count - 1 {
                vc.isCreateView = true
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            vc.pageController = self
            self.present(vc, animated: true, completion: nil)
        }
        plusButton.addAction(plusAction, for: .touchUpInside)
    }
    
    func setViewControllersFromIndex(index: Int) {
        if canReload {
            print("Reload")
            if index < 0 && index >= viewsList.count { return }
            self.setViewControllers([viewsList[index]], direction: .forward, animated: true, completion: nil)
            completeHandler?(currentIndex)
            print(viewsList)
            
            canReload = false
        } else {
            print("didnt Reload")
        }
    }
    
    func makeNewViewController(title: String, subTitle: String) {
        let storyboard = UIStoryboard(name: "StoryPage", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "MainStoryNavi")
        
        guard let embedVC = newVC.children.first as? MainStoryVC else { return }
        embedVC.titleHeader = StoryTitleHeader(title: title, subTitle: subTitle, root: embedVC)
        embedVC.pageVC = self
        viewsList.insert(newVC, at: 0)
        
        canReload = true
        currentPage = 0
    }
    
    // MARK: - FIX: 2?????? ????????? remove ????????? ??????
    func removeViewController() {
        print(currentIndex)
        viewsList.remove(at: currentIndex)
        
        canReload = true
        currentPage = 0
    }
    
    func makeNewContent() {
        canReload = true
        currentPage = 0
    }
}

extension StoryPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return viewsList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == viewsList.count { return nil }
        return viewsList[nextIndex]
    }
}

extension StoryPageVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            completeHandler?(currentIndex)
        }
    }
}
