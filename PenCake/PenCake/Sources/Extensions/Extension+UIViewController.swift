//
//  Extension+UIViewController.swift
//  PenCake
//
//  Created by SHIN YOON AH on 2021/05/31.
//

import UIKit

extension UIViewController {
    func makeContentActionSheet(title : String? = nil,
                         message : String,
                         okAction : ((UIAlertAction) -> Void)? = nil,
                         completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .actionSheet)
        
        let noAction = UIAlertAction(title: "버리기", style: .destructive,
            handler: { _ in
                self.dismiss(animated: true, completion: nil)
            })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertViewController.addAction(noAction)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func makeTableActionSheet(title : String? = nil,
                         message : String,
                         okAction : ((UIAlertAction) -> Void)? = nil,
                         completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .actionSheet)
        
        let noAction = UIAlertAction(title: "글 삭제", style: .destructive, handler: okAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertViewController.addAction(noAction)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func makeAlert(title : String? = nil,
                   message : String,
                   okAction : ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func makeRemoveAlert(title : String?,
                   message : String,
                   okAction : ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let removeAction = UIAlertAction(title: "제거", style: .destructive, handler: okAction)
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(removeAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
}
