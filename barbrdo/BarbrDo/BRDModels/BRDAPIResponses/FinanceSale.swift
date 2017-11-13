//
//  FinanceSale.swift
//  BarbrDo
//
//  Created by Shami Kumar on 11/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class FinanceSale: NSObject {
    var _id : String?
    var  appointments : Int? = 0
    var  sale : Int? = 0
    var appointment_Date: String?
    var appointmentDate: Date?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [FinanceSale]
    {
        var models:[FinanceSale] = []
        for item in array
        {
            models.append(FinanceSale(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    override init() {
        
        self._id = ""
        self.appointments = 0
        self.appointment_Date = ""
        self.sale = 0
        self.appointmentDate = Date()
    }
    
    required public init?(dictionary: NSDictionary) {
        
        
        _id = dictionary["_id"] as? String
        appointments = dictionary["appointments"] as? Int
        appointment_Date = dictionary["appointment_Date"] as? String
        sale = dictionary["sale"] as? Int
        
        if dictionary["appointment_Date"] != nil{
            let dDate = Date.dateFromString(dictionary["appointment_Date"] as! String, Date.DateFormat.yyyy_MM_dd)
            appointmentDate = dDate
        }
        
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.appointments, forKey: "appointments")
        dictionary.setValue(self.appointment_Date, forKey: "appointment_Date")
        dictionary.setValue(self.sale, forKey: "sale")

        
        
        
        return dictionary
    }
    
}
