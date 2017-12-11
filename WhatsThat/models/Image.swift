//
//  Image.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation

public class Image: Codable {
    public var content : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let image_list = Image.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Image Instances.
     */
        public class func modelsFromDictionaryArray(array:NSArray) -> [Image]
        {
            var models:[Image] = []
            for item in array
            {
                models.append(Image(dictionary: item as! NSDictionary)!)
            }
            return models
        }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let image = Image(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Image Instance.
     */
        required public init?(dictionary: NSDictionary) {
            content = dictionary["content"] as? String
        }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
        public func dictionaryRepresentation() -> NSDictionary {
    
            let dictionary = NSMutableDictionary()
    
            dictionary.setValue(self.content, forKey: "content")
    
            return dictionary
        }
    
}
