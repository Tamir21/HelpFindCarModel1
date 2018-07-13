//
//  DealershipsViewController.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 08/01/2018.
//  Copyright © 2018 Tamir Hussain. All rights reserved.
//

import UIKit
import MapKit

class DealershipsViewController: UIViewController {
    
    // Variable to use the dealership from previous View
    var selectedDealership:Dealership?
    var Dealerships = [Dealership]()

    // Connected labels and MapView
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the location using the latitude and longitude from the webservice
        let location = CLLocationCoordinate2D(latitude: (selectedDealership?.latitude)!, longitude: (selectedDealership?.longitude)!)
        
        // set the span to view the map
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // Set the label of the pin of the name of the dealership
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = ("\(selectedDealership?.Name)")
        mapView.addAnnotation(annotation)
        
        // Set the lables
        lblName.text = selectedDealership?.Name
        lblAddress.text = selectedDealership?.Address
        lblAddress.numberOfLines = 0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Segue for the webview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! URLViewController
        let selecteddealership = self.selectedDealership
        destVC.selectedDealership = selecteddealership
        
    }

}
