//
//  LocationModel.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 12/11/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
import UIKit

class LocationModel: NSObject {
    
    let responseModel: [GoogleVisionResultObject]
    let responseModelKey = "responseModel"
    let latitude: Double
    let latitudeKey = "latitude"
    let longitude: Double
    let longitudeKey = "longitude"
    let image: String
    let imageKey = "image"
    
    init(latitude: Double, longitude: Double, responseModel: [GoogleVisionResultObject], image: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.responseModel = responseModel
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        latitude = aDecoder.decodeDouble(forKey: latitudeKey)
        longitude = aDecoder.decodeDouble(forKey: longitudeKey) 
        responseModel = aDecoder.decodeObject(forKey: responseModelKey) as! [GoogleVisionResultObject]
        image = aDecoder.decodeObject(forKey: imageKey) as! String
    }
}

extension LocationModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: latitudeKey)
        aCoder.encode(longitude, forKey: longitudeKey)
        aCoder.encode(responseModel, forKey: responseModelKey)
        aCoder.encode(image, forKey: imageKey)
    }
}


