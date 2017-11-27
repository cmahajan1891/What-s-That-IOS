//
//  ViewController.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBAction func usePhotoAlbum(_ sender: UIButton) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        myVC.newMedia = false
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func useCamera(_ sender: UIButton) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        myVC.newMedia = true
        navigationController?.pushViewController(myVC, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

