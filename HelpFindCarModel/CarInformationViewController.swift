//
//  CarInformationViewController.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 14/12/2017.
//  Copyright © 2017 Tamir Hussain. All rights reserved.
//

import UIKit
import Social

class CarInformationViewController: UIViewController {

    
    @IBAction func button(_ sender: Any) {
        //Creating the alert for sharing on social media
        let selectServiceAlert = UIAlertController(title: "Select Service", message: "Select Service", preferredStyle: .actionSheet)
        
        //Creating the action button
        let facebookActionButton = UIAlertAction(title: "Facebook", style: .default) { (action) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                
                let facebookPostView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                //Setting the text and the image
                facebookPostView?.setInitialText("Found my dream Car! \((self.selectedCar?.Title)!)")
                let socialImage = UIImage(data: (self.selectedCar?.getImageDataFromURL())!)
                facebookPostView?.add(socialImage)
                
                self.present(facebookPostView!, animated: true, completion: nil)
            } else {
                self.error(serviceType: "Facebook")
            }
                
            
        }
        //Same as above but for twitter
        let twitterActionButton = UIAlertAction(title: "Twitter", style: .default) { (action) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                
                let twitterPostView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                twitterPostView?.setInitialText("Testing")
                
                self.present(twitterPostView!, animated: true, completion: nil)
            } else {
                self.error(serviceType: "Twitter")
            }
            
            
        }
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        selectServiceAlert.addAction(facebookActionButton)
        selectServiceAlert.addAction(twitterActionButton)
        selectServiceAlert.addAction(cancelActionButton)
        
        self.present(selectServiceAlert, animated: true, completion: nil)
        
    }
    func error(serviceType: String) {
        
        let errorAlert = UIAlertController(title: "Unavailable", message: "Not logged into \(serviceType)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        errorAlert.addAction(okAction)
        
        self.present(errorAlert, animated: true, completion: nil)
        
    }
    
    // Labels to display details of the car
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblbodytype: UILabel!
    @IBOutlet weak var lblcolour: UILabel!
    @IBOutlet weak var lbldoors: UILabel!
    @IBOutlet weak var lblenginesize: UILabel!
    @IBOutlet weak var lblfuelconsumption: UILabel!
    @IBOutlet weak var lblfueltype: UILabel!
    @IBOutlet weak var lblgearbox: UILabel!
    @IBOutlet weak var lblprice: UILabel!
    
    var selectedCar:Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the lables to use the information from the web service

        picture.image = UIImage(data: (selectedCar?.getImageDataFromURL())!)
        lblTitle.text = selectedCar?.Title
        lblbodytype.text = selectedCar?.BodyType
        lblcolour.text = selectedCar?.Colour
        lbldoors.text = String(describing: (selectedCar?.Doors)!)
        lblenginesize.text = selectedCar?.EngineSize
        lblfuelconsumption.text = selectedCar?.FuelConsumption
        lblfueltype.text = selectedCar?.FuelType
        lblgearbox.text = selectedCar?.Gearbox
        lblprice.text = selectedCar?.Price
    }
}
