//
//  HomeVC.swift
//  CGV
//
//  Created by SHIN YOON AH on 2021/05/11.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpMore(_ sender: Any) {
        guard let dvc = UIStoryboard(name: "MovieChart", bundle: nil).instantiateViewController(identifier: "MovieChartVC") as? MovieChartVC else {
            return
        }
        navigationController?.pushViewController(dvc, animated: true)
    }
}
