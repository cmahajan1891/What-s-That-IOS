//
//  GoogleVisionRequestModel.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
public class GoogleVisionRequestModel: Codable {
    public var requests : Array<Requests>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
        public class func modelsFromDictionaryArray(array:NSArray) -> [GoogleVisionRequestModel]
        {
            var models:[GoogleVisionRequestModel] = []
            for item in array
            {
                models.append(GoogleVisionRequestModel(dictionary: item as! NSDictionary)!)
            }
            return models
        }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
        required public init?(dictionary: NSDictionary) {
    
            if (dictionary["requests"] != nil) { requests = Requests.modelsFromDictionaryArray(array: dictionary["requests"] as! NSArray) }
        }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
        public func dictionaryRepresentation() -> NSDictionary {
    
            let dictionary = NSMutableDictionary()
    
            return dictionary
        }
    
}
