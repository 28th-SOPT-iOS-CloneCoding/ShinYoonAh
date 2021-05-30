//
//  MainStoryVC.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/30.
//

import UIKit

class MainStoryVC: UIViewController {
    @IBOutlet weak var storyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
    }
    
    private func setupConfigure() {
        storyTableView.dataSource = self
        
        storyTableView.backgroundColor = .secondarySystemBackground
        storyTableView.separatorStyle = .none
        
        let nib = UINib(nibName: StoryListTVC.identifier, bundle: nil)
        storyTableView.register(nib, forCellReuseIdentifier: StoryListTVC.identifier)
    }
}

extension MainStoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryListTVC.identifier) as? StoryListTVC else {
            return UITableViewCell()
        }
        return cell
    }
}
