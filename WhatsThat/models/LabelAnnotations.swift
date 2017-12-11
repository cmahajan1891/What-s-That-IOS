//
//  LabelAnnotationsq.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation

struct LabelAnnotations : Codable {
    
    let mid : String?
    let description : String?
    let score : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case mid = "mid"
        case description = "description"
        case score = "score"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mid = try values.decodeIfPresent(String.self, forKey: .mid)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        score = try values.decodeIfPresent(Double.self, forKey: .score)
    }
    
}
