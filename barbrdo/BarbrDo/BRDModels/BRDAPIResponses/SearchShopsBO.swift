//
//  SearchShopsBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 01/09/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class SearchShopsBO: NSObject {
    public var __v : Int?
    public var _id : String?
    public var address : String?
    public var chairs : Array<String>?
    public var city : String?
    public var created_date : String?
    public var latLong : [Double]?
    public var license_number : String?
    public var modified_date : String?
    public var name : String?
    public var payment_methods : [Any]?
    public var ratings : [BRD_RatingsBO]?
    public var state : String?
    public var user_id : String?
    public var zip : String?
    public var street_address: String?
    
    
   
    public class func modelsFromDictionaryArray(array:NSArray) -> [SearchShopsBO]
    {
        var models:[SearchShopsBO] = []
        for item in array
        {
            models.append(SearchShopsBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    override init() {
        
        __v = 1
        _id = ""
        address = ""
        
        city = ""
        created_date = ""
        latLong = []
        license_number = ""
        modified_date = ""
        name = ""
        
        ratings = []
        state = ""
        user_id = ""
        zip = ""
        street_address = ""
        
    }
    
     required public init?(dictionary: NSDictionary) {
        
        __v = dictionary["__v"] as? Int
        _id = dictionary["_id"] as? String
        address = dictionary["address"] as? String
//        if (dictionary["chairs"] != nil) { chairs = Chairs.modelsFromDictionaryArray(dictionary["chairs"] as! NSArray) }
        city = dictionary["city"] as? String
        created_date = dictionary["created_date"] as? String
        if (dictionary["latLong"] != nil) {
            latLong = dictionary["latLong"] as! [Double]
        }
        license_number = dictionary["license_number"] as? String
        modified_date = dictionary["modified_date"] as? String
        name = dictionary["name"] as? String
//        if (dictionary["payment_methods"] != nil) { payment_methods = Payment_methods.modelsFromDictionaryArray(dictionary["payment_methods"] as! NSArray) }
        if (dictionary["ratings"] != nil) { ratings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
        state = dictionary["state"] as? String
        user_id = dictionary["user_id"] as? String
        zip = dictionary["zip"] as? String
        street_address = dictionary["street_address"] as? String
    }
    
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.license_number, forKey: "license_number")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.zip, forKey: "zip")
        dictionary.setValue(self.street_address, forKey: "street_address")
        return dictionary
    }
    
}
