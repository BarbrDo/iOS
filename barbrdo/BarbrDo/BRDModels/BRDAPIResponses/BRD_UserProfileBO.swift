//
//  BRD_UserProfileBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 18/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_UserProfileBO: NSObject {
    public var _id : String?
    public var first_name : String?
    public var last_name : String?
    public var email : String?
    public var mobile_number : String?
    public var user_type : String?
    public var latLong : Array<Double>?
    public var randomString : String?
    public var __v : Int?
    public var picture : String?
    public var isActive : String?
    public var is_verified : String?
    public var isDeleted : String?
    public var modified_date : String?
    public var created_date : String?
    public var gallery : [BRD_GalleyBO]?
    public var ratings : [BRD_RatingsBO]?
    public var shops : [BRD_ShopDataBO]?
    public var barbers : [BRD_BarberDataBO]?
    public var password : String?
    public var confirmPassword: String?
    public var licenseNumber: String?
    
    public var image: UIImage!
    
    public var bio: String?
    public var licensed_since: String?
    public var radius_search: String?
    public var subscription_device_type: String?
    public var subscription_end_date: String?
    public var subscription_pay_id: String?
    public var subscription_plan_name: String?
    public var subscription_price: Int?
    public var subscription_start_date: String?
    public var subscription_transaction_response = [Any]()
    
    
    
    override init() {
        self._id = ""
        self.first_name = ""
        self.last_name = ""
        self.email = ""
        self.mobile_number = ""
        self.user_type = ""
        self.latLong = []
        self.randomString = ""
        self.__v = 0
        self.picture = ""
        self.isActive = ""
        self.is_verified = ""
        self.isDeleted = ""
        self.modified_date = ""
        self.created_date = ""
        self.gallery = []
        self.ratings = []
        self.shops = []
        self.barbers = []
        self.password = ""
        self.confirmPassword = ""
        self.licenseNumber = ""
        
        self.image = nil
        self.bio = ""
        
        self.radius_search = "50"
        self.licensed_since = ""
        
        self.subscription_device_type = ""
        self.subscription_end_date = ""
        self.subscription_pay_id = ""
        self.subscription_plan_name = ""
        self.subscription_price = 0
        self.subscription_start_date = ""
    }
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_UserProfileBO]
    {
        var models:[BRD_UserProfileBO] = []
        for item in array
        {
            models.append(BRD_UserProfileBO(dictionary: item as! NSDictionary)!)
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
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        mobile_number = dictionary["mobile_number"] as? String
        user_type = dictionary["user_type"] as? String
//        if (dictionary["latLong"] != nil) { latLong = latLong.modelsFromDictionaryArray(dictionary["latLong"] as! NSArray) }
        randomString = dictionary["randomString"] as? String
        __v = dictionary["__v"] as? Int
        picture = dictionary["picture"] as? String
        isActive = dictionary["isActive"] as? String
        is_verified = dictionary["is_verified"] as? String
        isDeleted = dictionary["isDeleted"] as? String
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        if (dictionary["gallery"] != nil) { gallery = BRD_GalleyBO.modelsFromDictionaryArray(array: dictionary["gallery"] as! NSArray) }
        if (dictionary["ratings"] != nil) { ratings = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
        
        if (dictionary["barber"] != nil) { barbers = BRD_BarberDataBO.modelsFromDictionaryArray(array: dictionary["barber"] as! NSArray) }
        
        if (dictionary["associateShops"] != nil) { shops = BRD_ShopDataBO.modelsFromDictionaryArray(array: dictionary["associateShops"] as! NSArray) }
        
        password = dictionary["password"] as? String
        licenseNumber = dictionary["license_number"] as? String
        
        if (dictionary["bio"] != nil) {
            bio = dictionary["bio"] as! String
        }
        
        if let radius = dictionary["radius_search"] as? String{
            radius_search = radius
        }else if let radiusInt = dictionary["radius_search"] as? Int {
            radius_search = String(describing: radiusInt)
        }else{
            radius_search = "50"
        }

        licensed_since = dictionary["licensed_since"] as? String
        
        subscription_device_type = dictionary["subscription_device_type"] as? String
        subscription_end_date = dictionary["subscription_end_date"] as? String
        subscription_pay_id = dictionary["subscription_pay_id"] as? String
        subscription_plan_name = dictionary["subscription_plan_name"] as? String
        subscription_price = dictionary["subscription_price"] as? Int
        subscription_start_date = dictionary["subscription_start_date"] as? String
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
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        dictionary.setValue(self.user_type, forKey: "user_type")
        dictionary.setValue(self.randomString, forKey: "randomString")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.picture, forKey: "picture")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.is_verified, forKey: "is_verified")
        dictionary.setValue(self.isDeleted, forKey: "isDeleted")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.barbers, forKey: "barber")
        dictionary.setValue(self.password, forKey: "password")
        
        dictionary.setValue(self.subscription_device_type, forKey: "subscription_device_type")
        dictionary.setValue(self.subscription_end_date, forKey: "subscription_end_date")
        dictionary.setValue(self.subscription_pay_id, forKey: "subscription_pay_id")
        dictionary.setValue(self.subscription_plan_name, forKey: "subscription_plan_name")
        dictionary.setValue(self.subscription_price, forKey: "subscription_price")
        dictionary.setValue(self.subscription_start_date, forKeyPath: "subscription_start_date")
        dictionary.setValue(self.licensed_since, forKey: "licensed_since")
        return dictionary
    }
    
}

class BRD_UserProfileBOBL: NSObject{
    
    class func initWithParameters(_ requestType: String, urlComponent: String, inputParameters: [String: Any], headers: [String: String], completionHandler: @escaping(BRD_UserInfoBO?, NSError?) -> Void){
        
        
        let urlString: String = "\(KBaseURLString)\(urlComponent)"
        
        let comunicationManager = BRD_CommunicationManager()
        comunicationManager.postRequestUsingDictionaryParameters(requestType, urlComponent: urlString, inputParameters: inputParameters, headers: headers, completionHandler: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        if let userData = dict["user"] as? [String: Any]{
                            let obj = BRD_UserInfoBO.init(dictionary: userData)
                            completionHandler(obj, nil)
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
            
            DispatchQueue.main.async(execute: {
                completionHandler(nil, error)
            })
        }
    }
}
