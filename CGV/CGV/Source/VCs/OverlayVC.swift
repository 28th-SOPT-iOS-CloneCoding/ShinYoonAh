//
//  OverlayVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/16.
//

import UIKit

class OverlayVC: UIViewController {
    @IBOutlet weak var swipeButton: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bookingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension OverlayVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension OverlayVC: UITableViewDelegate {
    
}

extension OverlayVC {
    private func setUI() {
        setView()
    }
    
    private func setView() {
        backView.layer.cornerRadius = 20
        swipeButton.layer.cornerRadius = 3
    }
}
