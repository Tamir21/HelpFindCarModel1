//
//  DealershipTableViewController.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 06/01/2018.
//  Copyright © 2018 Tamir Hussain. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DealershipTableViewController: UITableViewController {
    let CellreuseIdentifier = "DealershipTableViewCell"
    
    // Works the same way as the othr table view controller
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var search: UISearchBar!
    var Dealerships = [Dealership]()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text
        
        Dealerships = DealershipList.getDealershipsFromWebService("https://findadealership.firebaseio.com/", _searchTerm: searchTerm!)
        
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dealerships.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellreuseIdentifier, for: indexPath) as! DealershipTableViewCell
        
        cell.lblName.text = Dealerships[indexPath.row].Name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! DealershipsViewController
        
        let selectedDealershipIndex = self.tableView.indexPathForSelectedRow?.row
        destVC.selectedDealership = Dealerships[selectedDealershipIndex!]
        
    }
}
