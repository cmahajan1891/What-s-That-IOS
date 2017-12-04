//
//  TwittersTimelineTableViewController.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 12/4/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit
import TwitterKit

class TwittersTimelineTableViewController: TWTRTimelineViewController {

    var searchQuery: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: "\(searchQuery ?? "") filter:media", apiClient: TWTRAPIClient())
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
