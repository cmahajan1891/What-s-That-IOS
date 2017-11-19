//
//  ImageViewController.swift
//  What's That
//
//  Created by Chetan Mahajan on 11/19/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit
import MobileCoreServices





class ImageViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    var newMedia: Bool?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: false,
                             completion: nil)
                newMedia = false
            
        }
        // Do any additional setup after loading the view.
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
                    imageView.image = image
                } 
                
                
    
                if (newMedia == true) {
    
                    UIImageWriteToSavedPhotosAlbum(image, self,
                        #selector(ImageViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
