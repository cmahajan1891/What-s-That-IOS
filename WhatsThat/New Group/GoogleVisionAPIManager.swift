//
//  GoogleVisionAPIManager.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/22/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol GoogleVisionAPIManagerDelegate {
    func labelsReceived(labels: [ResponseModel])
    func labelsNotReceived(reason: GoogleVisionAPIManager.FailureReason)
}

class GoogleVisionAPIManager {
    
    enum FailureReason: String {
        case networkRequestFailed = "Your Request Failed, Please Try again."
        case badJSONResponse = "Bad JSON Response."
    }
    
    var googleAPIKey = "AIzaSyCwT_7AmDe9BYsqsiYDau5nGWS0XgoD3Yk"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    var delegate: GoogleVisionAPIManagerDelegate?
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if(imagedata != nil) {
            if (imagedata!.count > 2097152) {
                let oldSize: CGSize = image.size
                let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
                imagedata = resizeImage(newSize, image: image)
            }
        }
        
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        let imageDictionary = ["content": imageBase64]
        
        let img = Image(dictionary: imageDictionary as NSDictionary)
        let featureDic = ["type": "LABEL_DETECTION", "maxResults": 10] as NSDictionary
        let featureDic2 = ["type": "FACE_DETECTION", "maxResults": 10] as NSDictionary
        
        let fet1 = Features(dictionary: featureDic as NSDictionary)
        let fet2 = Features(dictionary: featureDic2 as NSDictionary)
        
        let feats = [fet1!.dictionaryRepresentation(), fet2!.dictionaryRepresentation()]
        
        let reqDictionary = ["image": img!.dictionaryRepresentation(), "features": feats] as [String : Any]
        let req = Requests(dictionary: reqDictionary as NSDictionary)
        
        let reqs: NSArray? = [req!.dictionaryRepresentation()]
        
        let requestModelDictionary: NSDictionary = ["requests": reqs!]
        let jsonObject = GoogleVisionRequestModel(dictionary: requestModelDictionary)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(jsonObject)
        
        request.httpBody = jsonData
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        //create network request ("dataTask") and define callback behavior
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            //this code will execute upon completion of the network request
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 { //200 = success
                
                    let jsonDecoder = JSONDecoder()
                    if let responseModel = try? jsonDecoder.decode(GoogleVisionResponseModel.self, from: data!) {
                        
                        let labelAnnotations = responseModel.responses?[0].labelAnnotations
                        
                        var labels = [ResponseModel]()
                        
                        //convert json data to our model object
                        for annotation in labelAnnotations! {
                            
                            let mid = annotation.mid
                            let desc = annotation.description
                            let score = annotation.score

                            
                            labels.append(ResponseModel(middle: mid!, desc: desc!,sc: score!))
                        }
                    
                         self.delegate?.labelsReceived(labels: labels)
                    }
                    else {
                        self.delegate?.labelsNotReceived(reason: .badJSONResponse)
                    }
            }
            else {
                self.delegate?.labelsNotReceived(reason: .networkRequestFailed)
            }
        }
        
        task.resume()

    }
    
}

