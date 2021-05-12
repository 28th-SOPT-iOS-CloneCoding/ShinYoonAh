//
//  MovieChartVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/11.
//

import UIKit

class MovieChartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
    }
}

// MARK: - UI
extension MovieChartVC {
    private func setConfigure() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .darkGray
        
        let rightButton: UIBarButtonItem = {
            let button = UIBarButtonItem(
                image: UIImage(named: "line.horizontal.3"),
                style: .plain,
                target: self,
                action: #selector(showupMenu))
            button.tintColor = .darkGray
            return button
        }()
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - Action
extension MovieChartVC {
    @objc func showupMenu(){
        self.navigationController?.popViewController(animated: true)
    }
}
