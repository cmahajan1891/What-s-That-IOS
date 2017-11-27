//
//  WikipediaAPIManager.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/26/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import Foundation

protocol WikiDescriptionDelegate {
    func descriptionFound(description: String)
    func descriptionNotFound()
}

class WikipediaAPIManager {
    
    var delegate: WikiDescriptionDelegate?
    
    //this function parses the JSON manually
    func fetchDescription(topic: String?) {
        
        var urlComponents = URLComponents(string: "https://en.wikipedia.org/w/api.php")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "titles", value: topic!),
            URLQueryItem(name: "prop", value: "extracts"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "exchars", value: "500")
            
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                //check for valid response with 200 (success)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    self.delegate?.descriptionNotFound()
                    return
                }
                
                guard let data = data, let wikiJsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                    //TODO Need to change this.
                    as? [String:Any] ?? [String:Any]() else {
                        self.delegate?.descriptionNotFound()
                        
                        return
                }
                
                guard let query = wikiJsonObject["query"] as? [String:Any] else {
                    self.delegate?.descriptionNotFound()
                    
                    return
                }
                
                
                for (_, value) in query {
                    
                    let dict = value as! Dictionary<String, Any>
                    let pageid = dict.first?.key
                    
                    guard let pagesJsonObject = query["pages"] as? [String:Any], let uniqueId = pagesJsonObject[pageid!] as? [String:Any], let extract = uniqueId["extract"]  as? String else {
                        
                        self.delegate?.descriptionNotFound()
                        
                        return
                    }
                    
                    self.delegate?.descriptionFound(description: extract.description)
                }
                
            }
            task.resume()
        }
    }
    
}
