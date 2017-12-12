//
//  FavoriteTableViewController.swift
//  WhatsThat
//
//  Created by Chetan Mahajan on 12/5/17.
//  Copyright © 2017 Chetan Mahajan. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    var favorites = Set<DescriptionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorites = PersistanceManager.sharedInstance.fetchFavorites()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteLabel", for: indexPath) as! FavoritesLabelTableViewCell
        
        // Configure the cell...
        let favs = Array(favorites)
        let label = favs[indexPath.row]
        cell.favoriteLabel.text = label.favoritelabel.capitalized
        cell.imageLabel.image =  PersistanceManager.sharedInstance.fetchImage(label: cell.favoriteLabel.text!)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = PersistanceManager.sharedInstance.fetchFavorites()
        self.tableView.reloadData()
    }
    
    override func didChange(_ changeKind: NSKeyValueChange, valuesAt indexes: IndexSet, forKey key: String) {
        self.tableView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "fromFavoritesSegue" {
            let destinationViewController = segue.destination as? SummaryViewController
            let favs = Array(favorites)
            destinationViewController?.heading = favs[(self.tableView.indexPathForSelectedRow?.row)!].favoritelabel.capitalized
            destinationViewController?.image = PersistanceManager.sharedInstance.fetchImage(label: favs[(self.tableView.indexPathForSelectedRow?.row)!].favoritelabel.capitalized)
        }
    }
    
}
