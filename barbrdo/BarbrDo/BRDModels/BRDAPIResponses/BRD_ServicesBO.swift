//
//  BRD_ServicesBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_ServicesBO: NSObject {
    public var price : Double!
    public var name : String?
    public var id : String?
    public var created_date: String?
    public var is_active: Bool?
    public var modified_date: String?
    public var service_id: String?
    
    
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let services_list = Services.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Services Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_ServicesBO]
    {
        var models:[BRD_ServicesBO] = []
        for item in array
        {
            models.append(BRD_ServicesBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let services = Services(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Services Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        print(dictionary)
        price = dictionary["price"] as? Double
        name = dictionary["name"] as? String
        id = dictionary["id"] as? String
        
        created_date = dictionary["modified_date"] as? String
        is_active = dictionary["is_active"] as? Bool
        modified_date = dictionary["modified_date"] as? String
        service_id = dictionary["_id"] as? String
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.price, forKey: "price")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.id, forKey: "id")
        
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.is_active, forKey: "is_active")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.service_id, forKey: "_id")
        return dictionary
    }
    
}
