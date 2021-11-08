//
//  UIViewController+Utilities.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit
import PKHUD

extension UIViewController {
    func showAlert(message: String = "Something went wrong!", action:((UIAlertAction) -> Void)? = nil) {
        if self.presentedViewController == nil {
            let alert = UIAlertController(title: "Warning",
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default,
                                          handler: action))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLoading() {
        HUD.show(.labeledProgress(title: "", subtitle: ""), onView: self.view)
    }

    func dismissLoading() {
        HUD.hide()
    }
}

