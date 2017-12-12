//
//  SummaryViewController.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 11/26/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit
import MBProgressHUD
import SafariServices

class SummaryViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    var heading: String?
    var urlString:String?
    var image: UIImage?
    var delegate: SFSafariViewControllerDelegate?
    var persistance: PersistanceManager?
    var wikipediaAPIManager: WikipediaAPIManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryLabel.text = heading ?? ""
        
        let wikipediaAPIManager = WikipediaAPIManager()
        wikipediaAPIManager.delegate = self
        
        MBProgressHUD.showAdded(to: descriptionText, animated: true)
        wikipediaAPIManager.fetchDescription(topic: heading)
        
        persistance = PersistanceManager.sharedInstance
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        self.descriptionText.autocorrectionType = UITextAutocorrectionType.yes
        self.descriptionText.spellCheckingType = UITextSpellCheckingType.yes
        self.descriptionText.sizeToFit()
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        let description = self.descriptionText.text
        
        let textToShare = "Check out a small description of: \(String(describing: self.heading))! \n \(String(describing: description))"
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveFavorites(_ sender: UIBarButtonItem) {
        
        let message = persistance?.saveFavorites(description: self.descriptionText.text, favLabel: self.heading!, image: self.image!)
        
        let alertController = UIAlertController(title: "Success.", message: message, preferredStyle: .alert)
        let okAction: UIAlertAction?
        okAction = UIAlertAction(title: "OK",
                                 
                                 style: .default, handler: { (action) in
                                    
        })
        
        alertController.addAction(okAction!)
        self.present(alertController, animated: true,
                     completion: nil)
        
    }
    
    
    @IBAction func showSafariView(_ sender: UIButton) {
        let svc = SFSafariViewController(url: NSURL(string: self.urlString ?? "")! as URL, entersReaderIfAvailable: true)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
    
    private func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTweetsSegue" {
            let destinationViewController = segue.destination as? TwittersTimelineTableViewController
            destinationViewController?.searchQuery = self.heading!
        }
    }
}

extension SummaryViewController : WikiDescriptionDelegate {
    func descriptionFound(description: String, pageId: String?) {
        
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.descriptionText, animated: true)
            self.urlString = URL(string: "https://en.wikipedia.org/?curid=\(pageId ?? "")")?.absoluteString
            self.descriptionText.text = description.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        }
    }
    
    func descriptionNotFound(reason: WikipediaAPIManager.FailureReason) {
        
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.descriptionText, animated: true)
            
            switch reason {
            case .networkRequestFailed:
                self.descriptionText.text = "Network Request Failed."
            case .badJSONResponse:
                self.descriptionText.text = "Bad JSON Response."
            case .invalidData:
                self.descriptionText.text = "Invalid Data."
            case .invalidParsingJSON:
                self.descriptionText.text = "Problem while parsing the JSON."
            }
        }
        
    }
    
}


