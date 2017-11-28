//
//  Responses1.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
struct Responses : Codable {
    let labelAnnotations : [LabelAnnotations]?
    
    enum CodingKeys: String, CodingKey {
        case labelAnnotations = "labelAnnotations"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        labelAnnotations = try values.decodeIfPresent([LabelAnnotations].self, forKey: .labelAnnotations)
    }
    
}
