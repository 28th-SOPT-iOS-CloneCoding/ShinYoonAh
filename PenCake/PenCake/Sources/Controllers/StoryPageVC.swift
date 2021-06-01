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
    
    lazy var viewsList: [UIViewController] = {
        let storyboard = UIStoryboard(name: "StoryPage", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainStoryNavi")
        let createVC = storyboard.instantiateViewController(withIdentifier: "CreateStoryVC") as! CreateStoryVC
        createVC.pageController = self
        
        return [mainVC, createVC]
    }()
    private var plusButton = PlusButton()
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pageInit()
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
        
        if let firstVC = viewsList.first {
            self.setViewControllers([firstVC],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
        }
        
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupButton() {
        view.addSubview(plusButton)
    }
    
    func setViewControllersFromIndex(index: Int) {
        if index < 0 && index >= viewsList.count { return }
        self.setViewControllers([viewsList[index]], direction: .forward, animated: true, completion: nil)
        completeHandler?(currentIndex)
    }
    
    func makeNewViewController(title: String, subTitle: String) {
        let storyboard = UIStoryboard(name: "StoryPage", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "MainStoryNavi")
        
        guard let embedVC = newVC.children.first as? MainStoryVC else { return }
        embedVC.titleHeader = StoryTitleHeader(title: title, subTitle: subTitle)
        viewsList.insert(newVC, at: 0)
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
