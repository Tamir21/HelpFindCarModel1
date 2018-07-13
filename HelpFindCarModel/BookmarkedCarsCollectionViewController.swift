//
//  BookmarkedCarsCollectionViewController.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 29/12/2017.
//  Copyright © 2017 Tamir Hussain. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CarCollectionViewCell"

class BookmarkedCarsCollectionViewController: UICollectionViewController {
    
    var bookMarkedCars = CarList.getBookMarkedCars()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To remove item from the database
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector (longPressForUnBookMark(_:)))

        collectionView?.addGestureRecognizer(longPressRecognizer)
    }
    
    var timeOfLastPress = Date()
    
    func longPressForUnBookMark(_ sender: UILongPressGestureRecognizer)
    {
        if Date().timeIntervalSince(timeOfLastPress) > 3
        {
            timeOfLastPress = Date()
            let touchPoint = sender.location(in: self.view)
            if let indexPath = collectionView?.indexPathForItem(at: touchPoint)
            {
                print("Selected item: \(bookMarkedCars[indexPath.item].displayCar())")
                bookMarkedCars[indexPath.row].BookMark(false)
                bookMarkedCars = CarList.getBookMarkedCars()
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        bookMarkedCars = CarList.getBookMarkedCars()
        print("bookmarked cars = \(bookMarkedCars)")
        self.collectionView?.reloadData()
    }

    // For the cells in the collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return bookMarkedCars.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CarCollectionViewCell
        cell.lblTitle.text = bookMarkedCars[indexPath.row].Title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destVC = segue.destination as! CarInformationViewController
        let selectedCarIndex = self.collectionView?.indexPathsForSelectedItems?[0].row
        destVC.selectedCar = bookMarkedCars[selectedCarIndex!]
    }
}
