//
//  Extension+UITableView.swift
//  Reminders
//
//  Created by SHIN YOON AH on 2021/05/06.
//

import UIKit

extension UITableView {
    func removeExtraCellLines() {
        tableFooterView = UIView(frame: .zero)
    }
}
