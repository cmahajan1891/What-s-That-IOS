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
    }
    
}
