//
//  BRD_ShopDataBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_ShopDataBO: NSObject {
    public var _id : String?
    public var address : String?
    public var barbers : Int?
    public var city : String?
    public var distance : Float?
    public var gallery : [BRD_GalleyBO]?
    public var latLong : [Double]?
    public var name : String?
    public var state : String?
    public var units : String?
    public var barberArray  =  [BRD_BarberInfoBO]()
    public var latitude: Double?
    public var longitude: Double?
    public var isActive : Int?
    public var shop = [BRD_ShopChairs]()
    public var chairs = [BRD_ChairInfo]()
    public var createdDate: String?
    
    public var is_Default: Bool?
    public var zip: String?
    public var is_available: Bool?
    public var is_favourite: Bool?
    public var is_online: Bool?
    
    
    override init() {
        self._id = ""
        self.address = ""
        self.barbers = 0
        self.city = ""
        self.distance = 0
        self.gallery = [BRD_GalleyBO]()
        self.latLong = []
        self.name = ""
        self.state = ""
        self.units = ""
        self.barberArray  =  [BRD_BarberInfoBO]()
        self.latitude = 0
        self.longitude = 0
        self.isActive = 0
        self.shop = [BRD_ShopChairs]()
        self.chairs = [BRD_ChairInfo]()
        self.createdDate = ""
        
        self.is_Default = false
        self.zip = ""

        self.is_available = false
        self.is_favourite = false
        self.is_online = false
    }
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_ShopDataBO]
    {
        var models:[BRD_ShopDataBO] = []
        for item in array
        {
            models.append(BRD_ShopDataBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        address = dictionary["address"] as? String
        barbers = dictionary["barbers"] as? Int
        city = dictionary["city"] as? String
        distance = dictionary["distance"] as? Float
        isActive = dictionary["_id"] as? Int
        //         shop =  (dictionary.value(forKey: "shop") as? [BRD_ShopChairs])!
        
        if (dictionary["gallery"] != nil) {
            gallery =  BRD_GalleyBO.modelsFromDictionaryArray(array: dictionary["gallery"] as! NSArray)
        }
        
        if(dictionary["chairs"] != nil)
        {
            chairs = BRD_ChairInfo.modelsFromDictionaryArray(array: dictionary["chairs"] as! NSArray)
            
        }
        
        if (dictionary["latLong"] != nil) {
            if let arrayLatlong = dictionary["latLong"] as? [Double]{
                latitude = arrayLatlong[1]
                longitude = arrayLatlong[0]
                latLong = arrayLatlong
            }
        }
        name = dictionary["name"] as? String
        state = dictionary["state"] as? String
        units = dictionary["units"] as? String
        
        if let barbers = dictionary["barber"] as? [Any] {
            barberArray = BRD_BarberInfoBO.modelsFromDictionaryArray(array: barbers as NSArray)
        }
        self.createdDate = dictionary["created_date"] as? String
        zip = dictionary["zip"] as? String
        is_Default = dictionary["is_default"] as? Bool
        
        is_online = dictionary["is_online"] as? Bool
        is_favourite = dictionary["is_favourite"] as? Bool
        is_available = dictionary["is_available"] as? Bool
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.barbers, forKey: "barbers")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.distance, forKey: "distance")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.units, forKey: "units")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.isActive, forKey: "isActive")
        
        
        return dictionary
    }
    
    
}

class BRD_ShopDataBOBL: NSObject{
    
    class func initWithParameters(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlComponent: String, completionHandler: @escaping ([BRD_ShopDataBO]?, NSError?) -> Void){
        
        let urlString: String = "\(KBaseURLString)\(urlComponent)"
        
        let comunicationManager = BRD_CommunicationManager()
        comunicationManager.getRequestUsingDictionaryParameters("GET", urlComponent: urlString, inputParameters: inputParameters, header: header, completion: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        let json = try JSONSerialization.jsonObject(with: result, options: .mutableContainers) as? [String:Any]
                        if let arrayValue = json?["data"] as? [Any]{
                            
                            let tempArray = BRD_ShopDataBO.modelsFromDictionaryArray(array: arrayValue as NSArray)
                            
                            completionHandler(tempArray,nil)
                        }else{
                            print("Invalid Response")
                            completionHandler(nil, BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                        }
                    }else{
                        let errorMessage = BRD_CommunicationManager.getError(result as AnyObject?)
                        completionHandler(nil, errorMessage)
                    }
                }
                catch {
                    print("catch")
                    completionHandler(nil, BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
            
        }
    }
}
