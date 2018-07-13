//
//  CarModel.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 12/12/2017.
//  Copyright © 2017 Tamir Hussain. All rights reserved.
//

import Foundation
import CoreData

// Create a class to allow objects created to be used by views
class CarList
{
    // List of the Car objects, and CarService for delegation
    private static var listOfCars = [Car]()
    static var carService:CarService?
    
    // Method for the use of Web Service
    static func getCarsFromWebService(_ siteURL:String, _ searchTerm:String)->[Car]
    {
        // API Key to be used when constructing searchURL
        let apiKey = "lg9aQ0XYySjyEDmB2RLNG8CNkvtJPXDwCB3DMsox"
        
        // Construct the search url used for web service
        let searchURL =  "\(siteURL)\(searchTerm).json?auth\(apiKey)"
        
        // Prints the search URL to test if works
        print ("Web Service call = \(searchURL)")
        
        // Create a web service object
        carService = CarService(searchURL)
        
        // Create an operation queue
        let operationQ = OperationQueue()
        operationQ.maxConcurrentOperationCount = 1
        operationQ.addOperation(carService!)
        operationQ.waitUntilAllOperationsAreFinished()
        
        // Clear current list of movies
        listOfCars.removeAll()
        
        let returnedJSON = carService!.jsonFromResponce
        
        if let JSONObjects = returnedJSON as? [[String:Any]]
        {
            for eachJSONObject in JSONObjects
            {
                print("Creating Car object from JSON: \(eachJSONObject)")
                listOfCars.append(Car(eachJSONObject))
            }
         
        }
       return listOfCars
    }
    // Method used to retrieve the Bookmarked Cars
    static func getBookMarkedCars()->[Car]
    {
        // Variables used to return bookmarked cars object and hold them
        var bookMarkedCars:[Car] = [Car]()
        var retrievedCars:[BookMarkedCar]
        
        let managedContext = DataBaseHelper.persistentContainer.viewContext
        
        // Retreive Entities
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookMarkedCar")
        
        do
        {
            retrievedCars = try managedContext.fetch(fetchRequest) as! [BookMarkedCar]
            print ("\(retrievedCars.count) bookmarked Cars")
            
            // Pass data
            for eachRetrieved in retrievedCars
            {
                let t = eachRetrieved.title
                let a = eachRetrieved.age
                let b = eachRetrieved.bodytype
                let c = eachRetrieved.colour
                let d = eachRetrieved.doors
                let e = eachRetrieved.enginesize
                let fc = eachRetrieved.fuelconsumption
                let ft = eachRetrieved.fueltype
                let g = eachRetrieved.gearbox
                let p = eachRetrieved.price
                let i = eachRetrieved.imageurl
                
                //Create new object and add to array
                bookMarkedCars.append(Car(t!,Int(a),b!,c!,Int(d),e!,fc!,ft!,g!,p!,i!)!)
            }
        }
        catch
        {
            print ("Failed: \(error)")
        }
        return bookMarkedCars
    }
}

// Core data code automatically generated
class DataBaseHelper
{
    static var persistentContainer:NSPersistentContainer =
        {
            let container = NSPersistentContainer(name: "Model")
            
            container.loadPersistentStores(completionHandler:{ (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
    }()
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//Domain class of te model
class Car
{
    // Class attributes
    private (set)var Title:String
    private (set)var Age:Int
    private (set)var BodyType: String
    private (set)var Colour: String
    private (set)var Doors: Int
    private (set)var EngineSize: String
    private (set)var FuelConsumption: String
    private (set)var FuelType: String
    private (set)var Gearbox: String
    private (set)var Price: String
    private (set)var ImageURL:String
    private (set)var isBookmarked: Bool
    
    // Initiale to ccheck if the attributes have values
    init?(_ t:String, _ a:Int, _ b:String, _ c:String, _ d:Int, _ e:String, _ fc:String, _ ft:String, _ g:String, _ p:String, _ i:String)
    {
        if ((b == "") || (c == "") || (fc == "") || (ft == "") || (g == "" ))
        {
            return nil
        }
        else
        {
            Title = t
            Age = a
            BodyType = b
            Colour = c
            Doors = d
            EngineSize = e
            FuelConsumption = fc
            FuelType = ft
            Gearbox = g
            Price = p
            isBookmarked = false
        }
        
        if i != "N/A"
        {
            ImageURL = i
        }
        else
        {
            ImageURL = "Unknown.jpg"
        }
        
    }
    // Initialiser to parse JSON
    convenience init (_ JSONObject:[String:Any])
    {
        // Extract attributes
        let title = JSONObject["Title"] as! String
        let age = JSONObject["Age"]! as! Int
        let bodytype = JSONObject["BodyType"] as! String
        let colour = JSONObject["Colour"] as! String
        let doors = JSONObject["Doors"]! as! Int
        let enginesize = JSONObject["EngineSize"] as! String
        let fuelconsumption = JSONObject["FuelConsumption"] as! String
        let fueltype = JSONObject["FuelType"] as! String
        let gearbox = JSONObject["Gearbox"] as! String
        let price = JSONObject["Price"] as! String
        let image = JSONObject["Image"] as! String
        
        // Set up Object from the values
        self.init(title,age,bodytype,colour,doors,enginesize,fuelconsumption,fueltype,gearbox,price,image)!
    }
    
    // Object from the URL string for image
    func getImageDataFromURL()->Data
    {
        var imageData: Data
        
        // Check if image is a valid URL
        if ImageURL.contains("https://")
        {
            imageData = try! Data(contentsOf: (URL(string: ImageURL))!)
        }
        else
        {
            let bundle = Bundle.main
            let path = bundle.path(forResource: ImageURL, ofType: nil)
            imageData = try! NSData(contentsOfFile: path!) as Data
        }
        //Returns the data
        return imageData
    }
    
    // Method to save and delete bookmarks
    func BookMark(_ save:Bool)
    {
        let managedContext = DataBaseHelper.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "BookMarkedCar", in: managedContext)!
        let bookMarkedCar = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // Put object members into the attributes within the entitiy
        bookMarkedCar.setValue(self.Title, forKeyPath: "title")
        bookMarkedCar.setValue(self.Age, forKeyPath: "age")
        bookMarkedCar.setValue(self.BodyType, forKeyPath: "bodytype")
        bookMarkedCar.setValue(self.Colour, forKeyPath: "colour")
        bookMarkedCar.setValue(self.Doors, forKeyPath: "doors")
        bookMarkedCar.setValue(self.EngineSize, forKeyPath: "enginesize")
        bookMarkedCar.setValue(self.FuelConsumption, forKeyPath: "fuelconsumption")
        bookMarkedCar.setValue(self.FuelType, forKeyPath: "fueltype")
        bookMarkedCar.setValue(self.Gearbox, forKeyPath: "gearbox")
        bookMarkedCar.setValue(self.Price, forKeyPath: "price")
        bookMarkedCar.setValue(self.ImageURL, forKeyPath: "imageurl")
        
        
        // To save
        if (save)
        {
            do
            {
                try managedContext.save()
                isBookmarked = true
                print ("The Car \(Title) has been added to bookmarks")
            }
            catch let error as NSError
            {
                print("Could not save\(Title)")
            }
        }
        else // To delete
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookMarkedCar")
            fetchRequest.predicate = NSPredicate(format: "title == %@", Title)
            
            do
            {
                let resultData = try managedContext.fetch(fetchRequest) as! [BookMarkedCar]
                print("Found")
                
                for object in resultData
                {
                    managedContext.delete(object)
                    print("Deleted")
                }
                
                try! managedContext.save()
                isBookmarked = false
            }
            catch
            {
                print("not found")
            }
        }
    }
    func displayCar() ->String
    {
        let strCar = "The Car model is \(Title)"
        return strCar
    }

}

protocol CarServiceDelegate
{
    func serviceFinished(_ service:CarService, _error:Bool)
}

// Create class for web service as queable operation
class CarService:Operation
{
    var urlReceived: URL?
    // Creates a JSON object
    var jsonFromResponce: [Any]?
    
    init(_ incomingURLString:String)
    {
        urlReceived = URL(string: incomingURLString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!)
    }
    
    // Override to do the work of the service
    override func main()
    {
        var responseData:Data?
        
        // Call Web Service
        do
        {
            // Get the data back
            responseData = try Data(contentsOf: urlReceived!)
            print("Service call (request) succesful! Returned: \(responseData!)")
        }
        catch
        {
            print("Service call (request) failed!!")
        }
        do
            // Parse the JSON
        {
            jsonFromResponce = try JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as? [Any]
            
            print("JSON Parser succesful! Returned: \(jsonFromResponce!)")
            // Print to show JSON has been parsed
        }
        catch
        {
            print("JSON Parser failed!!")
        }
    }
}





