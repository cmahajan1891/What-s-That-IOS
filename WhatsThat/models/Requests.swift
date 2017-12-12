//
//  Requests1.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation


public class Requests: Codable {
    public var image : Image?
    public var features : Array<Features>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let requests_list = Requests.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Requests Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Requests]
    {
        var models:[Requests] = []
        for item in array
        {
            models.append(Requests(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let requests = Requests(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Requests Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["image"] != nil) { image = Image(dictionary: dictionary["image"] as! NSDictionary) }
        if (dictionary["features"] != nil) { features = Features.modelsFromDictionaryArray(array: dictionary["features"] as! NSArray)}
        
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.image?.dictionaryRepresentation(), forKey: "image")
        var feats = [NSDictionary]()
        for feature in features! {
            feats.append(feature.dictionaryRepresentation())
        }
        
        dictionary.setValue(feats, forKey: "features")
        
        return dictionary
    }
    
}
