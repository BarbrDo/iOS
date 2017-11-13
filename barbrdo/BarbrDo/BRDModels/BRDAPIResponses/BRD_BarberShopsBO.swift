//
//  BRD_BarberShopsBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 31/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_BarberShopsBO: NSObject {
    public var _id : String?
    public var user_id : String?
    public var license_number : String?
    public var gallery : [BRD_GalleyBO]?
    public var chairs : [BRD_ShopChairs]?
    public var ratings : [BRD_RatingsBO]?
//    public var payment_methods : Array<String>?
    public var modified_date : String?
    public var created_date : String?
    public var __v : Int?
    public var latLong : [Double]?
    public var latitude: Double?
    public var longitude: Double?
    public var zip : String?
    public var city : String?
    public var state : String?
    public var address : String?
    public var name : String?
    public var dist : DistBO?
    
    public var barber_id : String?
    public var booking_date: String?
    public var chair_id: String?
    public var requested_by: String?
    public var shop_id: String?
    public var status: String?
    public var updatedAt: String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_BarberShopsBO]
    {
        var models:[BRD_BarberShopsBO] = []
        for item in array
        {
            models.append(BRD_BarberShopsBO(dictionary: item as! NSDictionary)!)
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
        user_id = dictionary["user_id"] as? String
        license_number = dictionary["license_number"] as? String
        if (dictionary["gallery"] != nil) { gallery = BRD_GalleyBO.modelsFromDictionaryArray(array: dictionary["gallery"] as! NSArray) }
        if (dictionary["chairs"] != nil) { chairs = BRD_ShopChairs.modelsFromDictionaryArray(array: dictionary["chairs"] as! NSArray) }
        if (dictionary["ratings"] != nil) { ratings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
//        if (dictionary["payment_methods"] != nil) { payment_methods = Payment_methods.modelsFromDictionaryArray(dictionary["payment_methods"] as! NSArray) }
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        __v = dictionary["__v"] as? Int
        
        if (dictionary["latLong"] != nil) {
            if let arrayLatlong = dictionary["latLong"] as? [Double]{
                latitude = arrayLatlong[1]
                longitude = arrayLatlong[0]
                latLong = arrayLatlong
            }
        }

        if dictionary["zip"] != nil{
            if let zipCode = dictionary["zip"] as? String{
                zip = zipCode
            }
        }
        
        city = dictionary["city"] as? String
        state = dictionary["state"] as? String
        address = dictionary["address"] as? String
        name = dictionary["name"] as? String
        if (dictionary["dist"] != nil) { dist = DistBO(dictionary: dictionary["dist"] as! NSDictionary) }
        
        
        if let strBarberID = dictionary["barber_id"] {
            barber_id =  strBarberID as? String
        }
        if let strBookingDate = dictionary["booking_date"] {
            booking_date =  strBookingDate as? String
        }
        if let strChairID = dictionary["chair_id"] {
            chair_id =  strChairID as? String
        }
        if let strRequestedBy = dictionary["requested_by"] {
            requested_by =  strRequestedBy as? String
        }
        if let strShop_id = dictionary["shop_id"] {
            shop_id =  strShop_id as? String
        }
        if let strStatus = dictionary["status"] {
            status =  strStatus as? String
        }
        if let strUpdatedAt = dictionary["updatedAt"] {
            updatedAt =  strUpdatedAt as? String
        }
    }

    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.license_number, forKey: "license_number")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.zip, forKey: "zip")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.dist?.dictionaryRepresentation(), forKey: "dist")
        
        return dictionary
    }
    
}
