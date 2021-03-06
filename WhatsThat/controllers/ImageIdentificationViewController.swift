//
//  TableViewController.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/23/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit
import MobileCoreServices
import MBProgressHUD


class ImageIdentificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    
    var labels: [GoogleVisionResultObject] = []
    var googleVisionAPIManager: GoogleVisionAPIManager?
    var newMedia: Bool?
    var locationFinder: LocationFinder?
    var persistance: PersistanceManager?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagePicker = UIImagePickerController()
        
        //Initializing Black Box Classes
        googleVisionAPIManager = GoogleVisionAPIManager()
        
        
        //Assigning the delegates
        imagePicker.delegate = self
        googleVisionAPIManager?.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        persistance = PersistanceManager.sharedInstance
        
        //setting the source as photo gallery or camera
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum) && newMedia == false {
            
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            
        }
            
        else if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) && newMedia == true {
            
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            
        }
        
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true,
                     completion: nil)
        
    }
    
    func findLocation() {
        self.locationFinder?.findLocation()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // First dismiss the image picker controller and then pop out to the root view controller;
        self.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            if let imageView = imageView {
                imageView.image = image
                //Show progress bar
                MBProgressHUD.showAdded(to: self.tableView, animated: true)
                if self.googleVisionAPIManager != nil {
                    let image = imageView.image
                    //send request to retreive labels.
                    let imageBase64: String = (self.googleVisionAPIManager?.base64EncodeImage(image!))!
                    self.googleVisionAPIManager?.createRequest(with: imageBase64)
                }
            }
            
            if (newMedia == true) {
                
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(ImageIdentificationViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
                
            }
            
        }
        
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
            
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identificationCell", for: indexPath) as! IdentificationLabelViewCell
        
        // Configure the cell...
        let label = labels[indexPath.row]
        cell.identificationLabel.text = label.descr.capitalized
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDescriptionSegue" {
            let destinationViewController = segue.destination as? SummaryViewController
            destinationViewController?.heading = labels[(self.tableView.indexPathForSelectedRow?.row)!].descr.capitalized
            destinationViewController?.image = self.imageView.image!
        }
    }
}


extension ImageIdentificationViewController: GoogleVisionAPIManagerDelegate{
    func labelsReceived(labels: [GoogleVisionResultObject]) {
        self.labels = labels
        
        //update tableview data on the main (UI) thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.tableView, animated: true)
            self.tableView.reloadData()
            self.locationFinder = LocationFinder()
            self.locationFinder?.delegate = self
            self.locationFinder?.findLocation()
        }
        
    }
    
    func labelsNotReceived(reason: GoogleVisionAPIManager.FailureReason) {
        
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.tableView, animated: true)
            
            let alertController = UIAlertController(title: "Problem fetching labels.", message: reason.rawValue, preferredStyle: .alert)
            
            self.tableView.reloadData()
            switch reason {
            case .badJSONResponse:
                
                let okAction = UIAlertAction(title: "OK",
                                             
                                             style: .default, handler: nil)
                alertController.addAction(okAction)
                
            case .networkRequestFailed:
                
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    
                    if self.googleVisionAPIManager != nil {
                        let imageBase64: String = self.googleVisionAPIManager!.base64EncodeImage((self.imageView?.image)!)
                        self.googleVisionAPIManager!.createRequest(with: imageBase64)
                    }
                    
                })
                
                let cancelAction = UIAlertAction(title: "OK",
                                                 
                                                 style: .cancel, handler: nil)
                
                alertController.addAction(retryAction)
                alertController.addAction(cancelAction)
                
                
            }
            
            self.present(alertController, animated: true,
                         completion: nil)
        }
        
    }
}


//adhere to the LocationFinderDelegate protocol
extension ImageIdentificationViewController: LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double) {
        let imageBase64: String = (self.googleVisionAPIManager?.base64EncodeImage((self.imageView?.image)!))!
        if imageView?.image != nil {
            
            let labels = self.labels
            
            let locModel = LocationModel(latitude: latitude, longitude: longitude, responseModel: labels, image: imageBase64)
            
            self.persistance?.saveLocation(locModel: locModel)
            
        }
        
    }
    
    func locationNotFound(reason: LocationFinder.FailureReason) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            //TODO pop up an alert controller with message
            //print(reason.rawValue)
            
            let alertController = UIAlertController(title: "Problem fetching location.", message: reason.rawValue, preferredStyle: .alert)
            
            switch reason {
                
            case .error:
                
                let okAction = UIAlertAction(title: "OK",
                                             
                                             style: .default, handler: nil)
                alertController.addAction(okAction)
                
            case .noPermission:
                
                let retryAction = UIAlertAction(title: "Location Permissions are required for the application to run properly", style: .default, handler: { (action) in
                    
                    self.locationFinder?.findLocation()
                    
                })
                
                let cancelAction = UIAlertAction(title: "OK",
                                                 
                                                 style: .cancel, handler: nil)
                
                alertController.addAction(retryAction)
                alertController.addAction(cancelAction)
                
            case .timeout:
                
                let retryAction = UIAlertAction(title: "Location Permissions are required for the application to run properly", style: .default, handler: { (action) in
                    
                    self.locationFinder?.findLocation()
                    
                })
                
                let cancelAction = UIAlertAction(title: "OK",
                                                 
                                                 style: .cancel, handler: nil)
                
                alertController.addAction(retryAction)
                alertController.addAction(cancelAction)
                
            }
            
            self.present(alertController, animated: true,
                         completion: nil)
            
        }
    }
}



