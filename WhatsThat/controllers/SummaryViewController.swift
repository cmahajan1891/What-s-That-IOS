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
    var heading: String?
    var urlString:String?
    var delegate: SFSafariViewControllerDelegate?
    
    @IBOutlet weak var descriptionText: UITextView!
    
    //var desc: WikipediaResultModel?
    var wikipediaAPIManager: WikipediaAPIManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryLabel.text = heading!
        let wikipediaAPIManager = WikipediaAPIManager()
        wikipediaAPIManager.delegate = self
        MBProgressHUD.showAdded(to: descriptionText, animated: true)
        wikipediaAPIManager.fetchDescription(topic: heading)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textViewDidChange(_ textView: UITextView) {
        self.descriptionText.autocorrectionType = UITextAutocorrectionType.yes
        self.descriptionText.spellCheckingType = UITextSpellCheckingType.yes
        self.descriptionText.sizeToFit()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func showSafariView(_ sender: UIButton) {
        let svc = SFSafariViewController(url: NSURL(string: self.urlString ?? "")! as URL, entersReaderIfAvailable: true)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
    
    private func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadTwitterFeed(_ sender: UIButton) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TwittersTimelineTableViewController") as! TwittersTimelineTableViewController
        myVC.searchQuery = self.heading!
        navigationController?.pushViewController(myVC, animated: true)
    }
}

extension SummaryViewController : WikiDescriptionDelegate {
    func descriptionFound(description: String, pageId: String?) {
        //print("desc found called.")
        // Enable auto-correction and Spellcheck
    
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.descriptionText, animated: true)
            
            self.urlString = URL(string: "https://en.wikipedia.org/?curid=\(pageId ?? "")")?.absoluteString
            self.descriptionText.text = description.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        }
        
        
    }
    
    func descriptionNotFound(reason: WikipediaAPIManager.FailureReason) {
        //print("Description Not found.")
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



