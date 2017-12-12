//
//  MapViewController.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 12/11/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var persistanceManager: PersistanceManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistanceManager = PersistanceManager.sharedInstance
        let locations = persistanceManager?.fetchLocations()
        let favorites = persistanceManager?.fetchFavorites()
        
        for fav in favorites! {
            
            let label = fav.favoritelabel
            
            for loc in locations ?? [LocationModel]() {
                
                let responses = loc.responseModel
                for response in responses {
                    if response.descr.capitalized == label {
                        let lat = loc.latitude
                        let lon = loc.longitude
                        
                        let span = MKCoordinateSpanMake(0.1, 0.1)
                        let location = CLLocationCoordinate2DMake(lat, lon)
                        let region = MKCoordinateRegion(center: location, span: span)
                        mapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        //annotation.title = "Chetan Mahajan"
                        mapView.addAnnotation(annotation)
                    }
                }
                
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //TODO display the description if the user selects the annotations.
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
