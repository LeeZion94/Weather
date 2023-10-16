//
//  AlertControllerShowable.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/16.
//

import UIKit

protocol AlertControllerShowable where Self: UIViewController {
    func showAlert(title: String?,
                   message: String?,
                   style: UIAlertController.Style,
                   actionList: [UIAlertAction]?)
}

extension AlertControllerShowable {
    func showAlert(title: String? = "",
                   message: String? = "",
                   style: UIAlertController.Style,
                   actionList: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actionList?.forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
}
