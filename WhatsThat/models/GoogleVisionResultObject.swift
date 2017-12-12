//
//  ResponseModel.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation


class GoogleVisionResultObject: NSObject {
    
    let mid : String
    let midKey = "mid"
    let descr : String
    let descriptionKey = "descr"
    let score : Double
    let scoreKey = "score"
    
    init(mid: String, description: String, score: Double) {
        self.mid = mid
        self.descr = description
        self.score = score
    }
    
    required init?(coder aDecoder: NSCoder) {
        mid = aDecoder.decodeObject(forKey: midKey) as! String
        descr = aDecoder.decodeObject(forKey: descriptionKey) as! String
        score = aDecoder.decodeDouble(forKey: scoreKey) 
    }
}

extension GoogleVisionResultObject: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mid, forKey: midKey)
        aCoder.encode(descr, forKey: descriptionKey)
        aCoder.encode(score, forKey: scoreKey)
    }
    
}

extension GoogleVisionResultObject {
    static func == (lhs: GoogleVisionResultObject, rhs: GoogleVisionResultObject) -> Bool {
        return lhs.descr == rhs.descr && lhs.mid == rhs.mid && lhs.score == rhs.score
    }
}
