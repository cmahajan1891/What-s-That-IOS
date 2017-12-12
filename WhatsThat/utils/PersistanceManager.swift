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
    let locKey = "Location"
    static let sharedInstance = PersistanceManager()
    let googleVisionManager = GoogleVisionAPIManager()
    
    
    func saveFavorites(description: String, favLabel: String, image: UIImage) -> String {
        let userDefaults = UserDefaults.standard
        let desc = DescriptionModel(desc: description, favLabel: favLabel)
        
        var descriptions: Set<DescriptionModel> = fetchFavorites()
        var message: String? = nil
        
        for item in descriptions {
            if item.desc == description {
                
                descriptions.remove(at: descriptions.index(of: item)!)
                message = "Item removed from the list of Favorites."
                //removeLocation(description: item.favoritelabel)
                
            }
        }
        
        if message == nil {
            message = "Item added in the list of Favorites."
            descriptions.insert(desc)
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent("\(favLabel).png")
                try? data.write(to: filename)
            }
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: descriptions)
        userDefaults.set(data, forKey: descKey)
        
        return message!
        
        
    }
    
    func saveLocation(locModel: LocationModel) {
        let userDefaults = UserDefaults.standard
        var locations: [LocationModel] = fetchLocations()
        
        for loc in locations {
            if loc.image == locModel.image {
                return
            }
        }
        
        locations.append(locModel)
        let data = NSKeyedArchiver.archivedData(withRootObject: locations)
        userDefaults.set(data, forKey: locKey)
        
    }
    
    func removeLocation(description: String) {
        
        let userDefaults = UserDefaults.standard
        var locations = fetchLocations()
        
        for loc in locations {
            for response in loc.responseModel {
                if description == response.descr.capitalized {
                    locations.remove(at: locations.index(of: loc)!)
                }
            }
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: locations)
        userDefaults.set(data, forKey: locKey)
    }
    
    func fetchLocations() -> [LocationModel] {
        let userDefaults = UserDefaults.standard
        let data = userDefaults.object(forKey: locKey) as? Data
        
        if let data = data {
            //data is not nil, so use it
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [LocationModel] ?? [LocationModel]()
        }
        else {
            //data is nil
            return [LocationModel]()
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
    
    func fetchImage(label: String) -> UIImage {
        
        let filename = getDocumentsDirectory().appendingPathComponent("\(label).png")
        return UIImage(contentsOfFile: filename.path)!
    }
    
}
