//
//  GoogleVisionResponseModelq.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
struct GoogleVisionResponseModel : Codable {
    let responses : [Responses]?
    
    enum CodingKeys: String, CodingKey {
        
        case responses = "responses"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        responses = try values.decodeIfPresent([Responses].self, forKey: .responses)
    }
    
}
