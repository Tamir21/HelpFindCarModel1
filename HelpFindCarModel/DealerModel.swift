//
//  DealerModel.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 02/01/2018.
//  Copyright © 2018 Tamir Hussain. All rights reserved.
//

import Foundation

// Works the same way as the Car Model
class DealershipList
{
    private static var listOfDealerships = [Dealership]()
    
    static var dealershipService:DealershipService?
    
    static func getDealershipsFromWebService(_ siteURL:String, _searchTerm:String)->[Dealership]
    {
        let apiKey = "0WsOmZnYMNGrF2sqEygeqX3cYXtnzIRwbCQGZm4Q"
        let searchURL = "\(siteURL)\(_searchTerm).json?auth\(apiKey)"
        
        print ("Web Service call = \(searchURL)")
    
        dealershipService = DealershipService(searchURL)
    
        let operationQ = OperationQueue()
        operationQ.maxConcurrentOperationCount = 1
        operationQ.addOperation(dealershipService!)
        operationQ.waitUntilAllOperationsAreFinished()
    
        listOfDealerships.removeAll()
    
        let returnedJSON = dealershipService!.jsonFromResponse
    
        let JSONObjects = returnedJSON as! [[String:Any]]
    
        for eachJSONObject in JSONObjects
        {
            print ("Creating dealership object")
            listOfDealerships.append(Dealership(eachJSONObject))
        }
        return listOfDealerships
        
    }
}

class Dealership
{
    private (set)var Name:String
    private (set)var Address:String
    private (set)var URL:String
    private (set)var latitude:Double
    private (set)var longitude:Double
    
    init?( _ n:String, _ a:String, _ u:String, _ lat:Double, _ long:Double)
    {
        if (n == "")
        {
            return nil
        }
        else
        {
            Name = n
            Address = a
            URL = u
            latitude = lat
            longitude = long
            
        }
    }
    convenience init(_ JSONObject:[String:Any])
    {
        let name = JSONObject["Name"] as! String
        let address = JSONObject["Address"] as! String
        let url = JSONObject["URL"] as! String
        let latititude = JSONObject["Latitude"]! as! Double
        let longitude = JSONObject["Longitude"]! as! Double
    
        self.init(name, address, url, Double(latititude), Double(longitude) )!
    }

}

class DealershipService:Operation
{
    var urlRecieved: URL?
    var jsonFromResponse:[Any]?
    
    init(_ incomingURLString:String)
    {
        urlRecieved = URL(string: incomingURLString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!)
    }
    
    override func main()
    {
        var responseData:Data?
        
        do
        {
            responseData = try Data(contentsOf: urlRecieved!)
            print("Service call to \(urlRecieved!) succesful! Returned: \(responseData!)")
        }
        catch
        {
            print("Service call to \(urlRecieved!) failed!!")
        }
        
        do
        {
            jsonFromResponse = try JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as? [Any]
            print("DealershipService: JSON Parser succesful! Returned: \(jsonFromResponse!)")
        }
        catch
        {
            print("DealershipService: JSON Parser failed!!")
        }
    }
}
