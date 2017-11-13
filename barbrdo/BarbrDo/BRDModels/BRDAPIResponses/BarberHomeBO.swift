//
//  BarberHomeBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberHomeBO: NSObject {
    public var msg : String?
    public var associateShops : [AssociatedShopsBO]?
    public var revenue : RevenueBO?
    public var services : [BRD_ServicesBO]?
    //public var appointment : Array<String>?
    
   
    public class func modelsFromDictionaryArray(array:NSArray) -> [BarberHomeBO]
    {
        var models:[BarberHomeBO] = []
        for item in array
        {
            models.append(BarberHomeBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        msg = dictionary["msg"] as? String
        if (dictionary["associateShops"] != nil) { associateShops = AssociatedShopsBO.modelsFromDictionaryArray(array: dictionary["associateShops"] as! NSArray) }
        if (dictionary["revenue"] != nil) { revenue = RevenueBO(dictionary: dictionary["revenue"] as! NSDictionary) }
        if (dictionary["services"] != nil) { services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["services"] as! NSArray) }
       // if (dictionary["appointment"] != nil) { appointment = Appointment.modelsFromDictionaryArray(dictionary["appointment"] as! NSArray) }
    }
    
   
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.msg, forKey: "msg")
        dictionary.setValue(self.revenue?.dictionaryRepresentation(), forKey: "revenue")
        
        return dictionary
    }
    
}
