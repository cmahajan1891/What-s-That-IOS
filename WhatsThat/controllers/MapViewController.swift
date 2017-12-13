//
//  MapViewController.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 12/11/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var persistanceManager: PersistanceManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        persistanceManager = PersistanceManager.sharedInstance
        let locations = persistanceManager?.fetchLocations()
        let favorites = persistanceManager?.fetchFavorites()
        
        putMarkers(locations: locations!,favorites:favorites!)
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        
        nextViewController.heading = (view.annotation?.title)!
        
        let dataDecoded : Data = Data(base64Encoded: ((view.annotation?.subtitle)!)!, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        
        nextViewController.image = decodedimage
        navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        let locations = persistanceManager?.fetchLocations()
        let favorites = persistanceManager?.fetchFavorites()
        putMarkers(locations:locations!, favorites:favorites!)
        self.mapView.reloadInputViews()
    }
    
    
    func putMarkers(locations: [LocationModel], favorites: Set<DescriptionModel>) {
        for fav in favorites {
            
            let label = fav.favoritelabel
            
            for loc in locations {
                
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
                        annotation.title = label
                        annotation.subtitle = loc.image
                        mapView.addAnnotation(annotation)
                    }
                }
                
            }
            
        }
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
