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

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    
    var labels: [ResponseModel] = []
    var googleVisionAPIManager: GoogleVisionAPIManager?
    var newMedia: Bool?
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
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
        
        googleVisionAPIManager = GoogleVisionAPIManager()
        googleVisionAPIManager?.delegate = self
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(TableViewController.tapFunction))
//        identificationLabel.isUserInteractionEnabled = true
//        identificationLabel.addGestureRecognizer(tap)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                    googleVisionAPIManager?.createRequest(with: imageBase64)
                }
                
            }
            
            if (newMedia == true) {
                
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(TableViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
                
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                
                // Code to support video here
                
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identificationCell", for: indexPath) as! IdentificationLabelViewCell

        // Configure the cell...
        let label = labels[indexPath.row]
        
        cell.identificationLabel.text = label.description?.capitalized

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let label = labels[indexPath.row]
        //print("selected Label:", label)
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        myVC.heading = label.description?.capitalized
        
        navigationController?.pushViewController(myVC, animated: true)
    }

}

extension TableViewController: GoogleVisionAPIManagerDelegate{
    func labelsReceived(labels: [ResponseModel]) {
        self.labels = labels
        
        //update tableview data on the main (UI) thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.tableView, animated: true)
            self.tableView.reloadData()
        }
    }
    
    func labelsNotReceived() {
        //print("No Results Found.")
    }
}
