//
//  DescriptionModel.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 12/4/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
class DescriptionModel: NSObject {
        
        let desc : String
        let descriptionKey = "description"
        let favoritelabel: String
        let favoriteLabelKey = "Favoritelabel"
        
    init(desc: String, favLabel: String) {
            self.desc = desc
            self.favoritelabel = favLabel
        }
        
        required init?(coder aDecoder: NSCoder) {
            desc = aDecoder.decodeObject(forKey: descriptionKey) as! String
            favoritelabel = aDecoder.decodeObject(forKey: favoriteLabelKey) as! String
        }
    }
    
    extension DescriptionModel: NSCoding {
        func encode(with aCoder: NSCoder) {
            aCoder.encode(desc, forKey: descriptionKey)
            aCoder.encode(favoritelabel, forKey: favoriteLabelKey)
        }
}
