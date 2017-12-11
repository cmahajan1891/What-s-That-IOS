//
//  UINavigationControllerExtension.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 12/10/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    ///Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController?{
        
        let length = self.viewControllers.count
        
        let previousViewController = length >= 2 ? self.viewControllers[length-2] : nil
        
        return previousViewController
    }
    
}


extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
