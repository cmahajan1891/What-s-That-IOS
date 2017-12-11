//
//  Persistance.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 12/5/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
import UIKit

class PersistanceManager {
    let descKey = "Description"
    static let sharedInstance = PersistanceManager()
    
    //    func removeFavorites(description: String, favLabel: String) {
    //        let userDefaults = UserDefaults.standard
    //
    //        var descriptions: Set<DescriptionModel> = fetchFavorites()
    //
    //        for item in descriptions {
    //            if item.desc == description {
    //                descriptions.remove(item)
    //            }
    //        }
    //
    //        let data = NSKeyedArchiver.archivedData(withRootObject: descriptions)
    //        userDefaults.set(data, forKey: descKey)
    //    }
    
    func saveFavorites(description: String, favLabel: String) -> String {
        let userDefaults = UserDefaults.standard
        let desc = DescriptionModel(desc: description, favLabel: favLabel)
        
        var descriptions: Set<DescriptionModel> = fetchFavorites()
        var message: String? = nil
        //let alertController = UIAlertController(title: "Favorites Selected.", message: reason.rawValue, preferredStyle: .alert)
        
        for item in descriptions {
            if item.desc == description {
                
                descriptions.remove(at: descriptions.index(of: item)!)
                
                message = "Item removed from the list of Favorites."
                
            }
        }
        
        if message == nil {
            message = "Item added in the list of Favorites."
            descriptions.insert(desc)
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: descriptions)
        userDefaults.set(data, forKey: descKey)
        
        return message!
        
        
    }
    
    func fetchFavorites() -> Set<DescriptionModel> {
        let userDefaults = UserDefaults.standard
        
        let data = userDefaults.object(forKey: descKey) as? Data
        
        if let data = data {
            //data is not nil, so use it
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Set<DescriptionModel> ?? Set<DescriptionModel>()
        }
        else {
            //data is nil
            return Set<DescriptionModel>()
        }
    }
    
}
