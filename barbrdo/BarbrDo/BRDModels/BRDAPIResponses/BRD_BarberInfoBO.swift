//
//  BRD_BarberInfoBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 05/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_BarberInfoBO: NSObject {
    
    public var _id : String?
    public var first_name : String?
    public var last_name : String?
    public var picture : String?
    public var ratings : [BRD_RatingsBO]?
    
    // Addition From Different API
    
    public var user_id : String?
    public var license_number : String?
    public var gallery : [BRD_GalleyBO]?
    public var payment_methods : Array<String>?
    public var subscription : Array<String>?
    public var modified_date : String?
    public var created_date : String?
    public var __v : Int?
    
    // Addition From Different API
    public var distance : Float?
    public var units : String?
    public var location : String?
    public var shop_id : String?
    public var ratingValue : CGFloat = 0.0
    
    
    public var isActive: Bool? = false
    public var isDeleted: Bool? = false
    public var is_Verified: Bool? = false
    public var latLong = [String]()
    public var mobileNumber : String?
    public var userType: String?
    public var appointment_date : String?
    public var chair_id : String?
    public var chair_name : String?
    public var chair_type : String?
    public var chair_amount : Int?
    public var chair_shop_percentage : Int?
    public var chair_barber_percentage : Int?

    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let barber_id_list = Barber_id.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Barber_id Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_BarberInfoBO]
    {
        var models:[BRD_BarberInfoBO] = []
        for item in array
        {
            models.append(BRD_BarberInfoBO(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    override init() {
        
        self._id = ""
        self.first_name = ""
        self.last_name = ""
        self.picture = ""
        self.ratings = nil
        
        // Addition From Different API
        self.user_id = ""
        self.license_number = ""
        self.gallery = nil
        self.payment_methods = nil
        self.subscription = nil
        self.modified_date = ""
        self.created_date = ""
        self.__v = 0
        self.appointment_date = ""
        self.distance = 0
        self.units = ""
        self.location = ""
        self.shop_id = ""
        self.ratingValue = 0.0
        
        
        self.isActive = false
        self.isDeleted = false
        self.is_Verified = false
        self.mobileNumber = nil
        self.userType = nil
        self.chair_id = nil
        self.chair_name = nil
        self.chair_type = nil
        self.chair_amount = 0
        self.chair_shop_percentage = 0
        self.chair_barber_percentage = 0

    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let barber_id = Barber_id(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Barber_id Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
    print(dictionary)
        
        _id = dictionary["_id"] as? String
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        picture = dictionary["picture"] as? String
        
        appointment_date = dictionary["appointment_date"] as? String
        if (dictionary["ratings"] != nil) { ratings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
        
        
        user_id = dictionary["user_id"] as? String
        license_number = dictionary["license_number"] as? String
        if (dictionary["gallery"] != nil) { gallery = BRD_GalleyBO.modelsFromDictionaryArray(array: dictionary["gallery"] as! NSArray) }
        //        if (dictionary["payment_methods"] != nil) { payment_methods = Payment_methods.modelsFromDictionaryArray(dictionary["payment_methods"] as! NSArray) }
        //        if (dictionary["subscription"] != nil) { subscription = Subscription.modelsFromDictionaryArray(dictionary["subscription"] as! NSArray) }
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        __v = dictionary["__v"] as? Int
        
        
        distance = dictionary["distance"] as? Float
        units = dictionary["units"] as? String
//        if let ratingArray = dictionary["ratings"] as? [Any] {
//            if let ratingModelArray = BRD_RatingsBO.modelsFromDictionaryArray(array: ratingArray as NSArray) as? [BRD_RatingsBO] {
//                rating = ratingModelArray
//                var avg: Float = 0.0
//                if let ratings = rating {
//                    if ratings.count > 0 {
//                        for obj in ratings {
//                            if let value: Float = obj.score {
//                                avg = avg + value
//                            }
//                        }
//                        let fMean: Float = Float((rating?.count)!)
//                        ratingValue = CGFloat(avg/fMean)
//                    }
//                }
//            }
//        }
        
        location = dictionary["location"] as? String
        shop_id = dictionary["shop_id"] as? String
        
        self.userType = dictionary["user_type"] as? String ?? ""
        self.mobileNumber = dictionary["mobile_number"] as? String ?? ""
        
        chair_id = dictionary["chair_id"] as? String
        chair_name = dictionary["chair_name"] as? String
        chair_type = dictionary["chair_type"] as? String
        chair_amount = dictionary["chair_amount"] as? Int
        chair_shop_percentage = dictionary["chair_shop_percentage"] as? Int
        chair_barber_percentage = dictionary["chair_barber_percentage"] as? Int

    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.picture, forKey: "picture")
        
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.license_number, forKey: "license_number")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.gallery, forKey: "gallery")
        
        dictionary.setValue(self.distance, forKey: "distance")
        dictionary.setValue(self.units, forKey: "units")
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.shop_id, forKey: "shop_id")
        dictionary.setValue(self.chair_barber_percentage, forKey: "chair_barber_percentage")
        dictionary.setValue(self.chair_shop_percentage, forKey: "chair_shop_percentage")
        dictionary.setValue(self.chair_type, forKey: "chair_type")
        dictionary.setValue(self.chair_amount, forKey: "chair_amount")
        dictionary.setValue(self.chair_name, forKey: "chair_name")
        dictionary.setValue(self.chair_id, forKey: "chair_id")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")

        
        return dictionary
    }
    
}
