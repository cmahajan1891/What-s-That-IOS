//
//  ViewController.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    //Setting the property newMedia to true if camera is selected.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectPhotoSegue" {
            let destinationViewController = segue.destination as? ImageIdentificationViewController
            destinationViewController?.newMedia = false
        }
        
        if segue.identifier == "useCameraSegue" {
            let destinationViewController = segue.destination as? ImageIdentificationViewController
            destinationViewController?.newMedia = true
        }
    }
}

