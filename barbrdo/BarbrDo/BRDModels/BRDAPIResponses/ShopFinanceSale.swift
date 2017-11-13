//
//  ShopFinanceSale.swift
//  BarbrDo
//
//  Created by Shami Kumar on 20/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class ShopFinanceSale: NSObject {
    var _id : String?
    var  appointments : Int? = 0
    var  shop_sale : Int? = 0
    var appointment_Date: String?
    var  total_sale : Int? = 0

    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ShopFinanceSale]
    {
        var models:[ShopFinanceSale] = []
        for item in array
        {
            models.append(ShopFinanceSale(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    override init() {
        
        self._id  = ""
        self.appointments  = 0
        self.shop_sale  = 0
        self.appointment_Date = ""
        self.total_sale = 0
    }
    
    required public init?(dictionary: NSDictionary) {
        
        
        _id = dictionary["_id"] as? String
        appointments = dictionary["appointments"] as? Int
        appointment_Date = dictionary["appointment_Date"] as? String
        shop_sale = dictionary["shop_sale"] as? Int
        total_sale = dictionary["total_sale"] as? Int

        
        
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
        dictionary.setValue(self.total_sale, forKey: "total_sale")
        dictionary.setValue(self.shop_sale, forKey: "shop_sale")

        
        
        
        return dictionary
    }

}
