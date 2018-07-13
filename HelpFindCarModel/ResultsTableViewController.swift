//
//  ResultsTableViewController.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 12/12/2017.
//  Copyright © 2017 Tamir Hussain. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController, UISearchBarDelegate{
    
    // Connect the label
    @IBOutlet weak var lblTitle: UILabel!
    let reuseIdentifier = "ResultsTableViewCell"
    
    var Cars = CarList.getCarsFromWebService("https://findacar-9212e.firebaseio.com/", "BMW")

    @IBOutlet weak var search: UISearchBar!
    
    // Function for the searchbar to respond to the search term
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text
        
        // Use the class from the model to get the Cars
        if ((searchTerm == "Audi") || (searchTerm == "BMW") || (searchTerm == "Mercedes"))
        {
            Cars = CarList.getCarsFromWebService("https://findacar-9212e.firebaseio.com/", searchTerm!)
        
                //Reload to refresh the table
                self.tableView.reloadData()
                searchBar.resignFirstResponder()
        }
    }
    
    var timeofLastPress = Date()
    func longPressForBookMark(_ sender: UILongPressGestureRecognizer)
    {
        if Date().timeIntervalSince(timeofLastPress) > 3
        {
            timeofLastPress = Date()
            let touchPoint = sender.location(in: self.view)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint)
            {
                if !(Cars[indexPath.row].isBookmarked)
                {
                    print("Selected item: \(Cars[indexPath.row].displayCar())")
                    self.tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.yellow
                    Cars[indexPath.row].BookMark(true)
                }
            }
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ResultsTableViewController.longPressForBookMark(_:)))
        tableView.addGestureRecognizer(longPressRecognizer)
        self.clearsSelectionOnViewWillAppear = false
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        for carCount in 0...Cars.count-1
        {
            if (Cars[carCount].isBookmarked)
        {
            self.tableView.cellForRow(at:IndexPath(row: carCount, section: 0))?.backgroundColor = UIColor.yellow
        }
        else
        {
            self.tableView.cellForRow(at:IndexPath(row: carCount, section: 0))?.backgroundColor = UIColor.white
        }
        }
    }
        
        

    // Data in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return Cars.count
    }
    
    
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ResultsTableViewCell
        
    cell.lblTitle.text = Cars[indexPath.row].Title
  
       return cell
    }

    // Segue for the information to carry to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destVC = segue.destination as! CarInformationViewController
        
        let selectedCarIndex = self.tableView.indexPathForSelectedRow?.row
        destVC.selectedCar = Cars[selectedCarIndex!]
        
    }
 }
 
