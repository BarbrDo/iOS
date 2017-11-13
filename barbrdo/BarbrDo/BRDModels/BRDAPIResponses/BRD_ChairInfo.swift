//
//  BRD_ChairInfo.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 05/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_ChairInfo: NSObject {
    public var isActive : Bool?
    public var created_date : String?
    public var modified_date : String?
    public var barber_percentage : Int?
    public var type : String?
    public var shop_percentage : Int?
    public var name : String?
    public var availability : String?
    public var _id : String?
    
    public var barber_name : String?
    public var amount : Float?
    public var barberArray  :  [BRD_BarberInfoBO]? = [BRD_BarberInfoBO]()

    public var barber_id: String?
    public var booking_end: String?
   // public var booking_date: String?
    public var booking_start: String?
    
    
    public var barberRequest : [BarberRequestBO]?
    public var barberInfo : [BRD_BarberInfoBO]?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_ChairInfo]
    {
        var models:[BRD_ChairInfo] = []
        for item in array
        {
            models.append(BRD_ChairInfo(dictionary: item as! NSDictionary)!)
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
        
        print(dictionary)
        
        
        isActive = dictionary["isActive"] as? Bool
        created_date = dictionary["created_date"] as? String
        modified_date = dictionary["modified_date"] as? String
        barber_percentage = dictionary["barber_percentage"] as? Int
        type = dictionary["type"] as? String
        shop_percentage = dictionary["shop_percentage"] as? Int
        name = dictionary["name"] as? String
        availability = dictionary["availability"] as? String
        _id = dictionary["_id"] as? String
        barber_name = dictionary["barber_name"] as? String
        amount = dictionary["amount"] as? Float

        booking_end = dictionary["booking_end"] as? String
      //  booking_date = dictionary["booking_date"] as? String
        barber_id = dictionary["barber_id"] as? String
        if let barbers = dictionary["barber"] as? [Any] {
            barberArray = BRD_BarberInfoBO.modelsFromDictionaryArray(array: barbers as NSArray)
        }
        booking_start = dictionary["booking_start"] as? String ?? ""
        
        
        if let barberReqArray = dictionary["barberRequest"] as? [Any] {
            barberRequest = BarberRequestBO.modelsFromDictionaryArray(array: barberReqArray as NSArray)
        }
        if let barberInfoArray = dictionary["barberInfo"] as? [Any] {
            barberInfo = BRD_BarberInfoBO.modelsFromDictionaryArray(array: barberInfoArray as NSArray)
        }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.barber_percentage, forKey: "barber_percentage")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.shop_percentage, forKey: "shop_percentage")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.availability, forKey: "availability")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.barber_name, forKey: "barber_name")
        dictionary.setValue(self.amount, forKey: "amount")
        dictionary.setValue(self.booking_start, forKey: "booking_start")
        dictionary.setValue(self.booking_end, forKey: "booking_end")
        //dictionary.setValue(self.booking_date, forKey: "booking_date")
        return dictionary
    }
    
}
