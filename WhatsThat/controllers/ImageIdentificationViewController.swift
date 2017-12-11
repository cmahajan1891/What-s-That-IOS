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
    
    var labels: [ResponseModel] = []
    var googleVisionAPIManager: GoogleVisionAPIManager?
    var newMedia: Bool?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagePicker = UIImagePickerController()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        //Initializing Black Box Classes
        googleVisionAPIManager = GoogleVisionAPIManager()
        
        //Assigning the delegates
        imagePicker.delegate = self
        googleVisionAPIManager?.delegate = self
        
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
            
            if imageView != nil {
                MBProgressHUD.showAdded(to: tableView, animated: true)
                imageView.image = image
                
                if googleVisionAPIManager != nil {
                    let imageBase64: String = googleVisionAPIManager!.base64EncodeImage(image)
                    googleVisionAPIManager!.createRequest(with: imageBase64)
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
        cell.identificationLabel.text = label.description?.capitalized
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDescriptionSegue" {
            let destinationViewController = segue.destination as? SummaryViewController
            destinationViewController?.heading = labels[(self.tableView.indexPathForSelectedRow?.row)!].description?.capitalized
        }
    }
}

extension ImageIdentificationViewController: GoogleVisionAPIManagerDelegate{
    func labelsReceived(labels: [ResponseModel]) {
        self.labels = labels
        
        //update tableview data on the main (UI) thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.tableView, animated: true)
            self.tableView.reloadData()
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

