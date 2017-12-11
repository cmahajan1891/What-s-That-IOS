//
//  ResponseModel.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
struct ResponseModel : Codable {
    
    let mid : String?
    let description : String?
    let score : Double?
    
    
    enum CodingKeys: String, CodingKey {
        
        case mid = "mid"
        case description = "description"
        case score = "score"
        
    }
    
    init(middle: String, desc: String, sc: Double)  {
        
        mid = middle
        description = desc
        score = sc
        
        
    }
    
}
