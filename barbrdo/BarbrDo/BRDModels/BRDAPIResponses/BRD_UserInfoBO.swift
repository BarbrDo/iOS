//
//  BRD_UserInfoBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_UserInfoBO:NSObject, NSCoding {
    
    public var password: String?
    public var confirmPassword: String?
    
    public var image: UIImage?
    
    public var token : String?
    public var notification : [NotificationDisplay]?
    public var _id : String?
    public var first_name : String?
    public var last_name : String?
    public var email : String?
    public var mobile_number : String?
    public var user_type : String?

    public var latitude: Double?
    public var longitude: Double?
    
    public var randomString : String?
    public var __v : Int?
    public var picture: String?
    public var isActive : Bool?
    public var is_verified : Bool?
    public var is_Online: Bool?
    public var isDeleted : Bool?
    public var modified_date: String?
    public var created_date: String?
    public var licensed_since: String?
    public var gallery: [BRD_GalleyBO]?
    public var rating: [BRD_RatingsBO]?
    public var barberProfile : BRD_BarberInfoBO?
    public var radius_search: String?
    
    public var imagesPath : String?
    public var facebook: String?
    
    public var bio : String?
    public var deviceID: String?
    public var shopInfo : SearchShopsBO?
    
    override init() {
        
        self.password = BRDRawStaticStrings.KEmptyString
        self.confirmPassword = BRDRawStaticStrings.KEmptyString
        
        self.image = nil
        
        self.token = BRDRawStaticStrings.KEmptyString
        
        self._id = BRDRawStaticStrings.KEmptyString
        self.first_name = BRDRawStaticStrings.KEmptyString
        self.last_name = BRDRawStaticStrings.KEmptyString
        self.email = BRDRawStaticStrings.KEmptyString
        self.mobile_number = BRDRawStaticStrings.KEmptyString
        self.user_type = BRDRawStaticStrings.KEmptyString
        
        self.latitude = 0.0
        self.longitude = 0.0
        
        self.randomString = BRDRawStaticStrings.KEmptyString
        self.__v = 0
        self.picture = BRDRawStaticStrings.KEmptyString
        self.isActive = false
        self.is_verified = false
        self.isDeleted = false
        self.is_Online = false
        self.modified_date = BRDRawStaticStrings.KEmptyString
        self.created_date = BRDRawStaticStrings.KEmptyString
        self.gallery =  [BRD_GalleyBO]()
        self.rating = [BRD_RatingsBO]()
        self.barberProfile = nil
        self.imagesPath = BRDRawStaticStrings.KEmptyString
        self.radius_search = BRDRawStaticStrings.KEmptyString
        self.facebook = BRDRawStaticStrings.KEmptyString
        self.bio = ""
        
        self.deviceID = ""
        self.licensed_since = ""
        self.shopInfo = nil
    }
    
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_UserInfoBO]
    {
        var models:[BRD_UserInfoBO] = []
        for item in array
        {
            models.append(BRD_UserInfoBO.init(dictionary: item as! [String: Any])!)
        }
        return models
    }
    
    required public init?(dictionary: [String: Any]) {
        print(dictionary)
        
        _id = dictionary["_id"] as? String ?? BRDRawStaticStrings.KEmptyString

        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        mobile_number = dictionary["mobile_number"] as? String
        user_type = dictionary["user_type"] as? String

        if dictionary["latLong"] != nil{
            if let thelatLong = dictionary["latLong"] as? [Double]{
                if thelatLong.count > 2{
                    latitude = thelatLong[1]
                    longitude = thelatLong[0]
                }
            }
        }
        randomString = dictionary["randomString"] as? String
        __v = dictionary["__v"] as? Int ?? 0
        picture = dictionary["picture"] as? String
        isActive = dictionary["isActive"] as? Bool
        is_verified = dictionary["is_verified"] as? Bool
        isDeleted = dictionary["isDeleted"] as? Bool
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        licensed_since = dictionary["licensed_since"] as? String
       // radius_search = dictionary["radius_search"] as? String
        
        if let radius = dictionary["radius_search"] as? String{
            radius_search = radius
        }else if let radiusInt = dictionary["radius_search"] as? Int {
            radius_search = String(describing: radiusInt)
        }else{
            radius_search = "0"
        }
        
        if (dictionary["gallery"] != nil) { gallery = BRD_GalleyBO.modelsFromDictionaryArray(array: dictionary["gallery"] as! NSArray) }
        if (dictionary["notification"] != nil) { notification = NotificationDisplay.modelsFromDictionaryArray(array: dictionary["notification"] as! NSArray) }

        if (dictionary["ratings"] != nil) { rating = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
        
        print(dictionary["barber"] ?? "No Barbers")
        if (dictionary["barber"] != nil) {
            if let arrayBarber = dictionary["barber"] as? [Any]{
                if let barberObj = arrayBarber[0] as? NSDictionary{
                    if let data = BRD_BarberInfoBO.init(dictionary: barberObj){
                        barberProfile = data
                    }
                }
                
            }
        }
        
        self.facebook = dictionary["facebook"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.is_Online = dictionary["is_online"] as? Bool
        
        if (dictionary["shop_info"] != nil) { shopInfo =
            SearchShopsBO.init(dictionary: dictionary["shop_info"] as! NSDictionary)
        }
        
    }
    
    
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.token, forKey: "token")
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        dictionary.setValue(self.user_type, forKey: "user_type")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        
        dictionary.setValue(self.randomString, forKey: "randomString")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.picture, forKey: "picture")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.isDeleted, forKey: "isDeleted")
        dictionary.setValue(self.is_verified, forKey: "is_verified")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")

        dictionary.setValue(self.gallery, forKey: "gallery")
        dictionary.setValue(self.notification, forKey: "notification")

        dictionary.setValue(self.rating, forKey: "ratings")
        dictionary.setValue(self.barberProfile, forKey: "barber")
        dictionary.setValue(self.radius_search, forKey: "radius_search")
        return dictionary
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.password = aDecoder.decodeObject(forKey: "password") as? String ?? ""
        self.token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        self._id = aDecoder.decodeObject(forKey: "_id") as? String ?? ""
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String ?? ""
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.mobile_number = aDecoder.decodeObject(forKey: "mobile_number") as? String ?? ""
        self.user_type = aDecoder.decodeObject(forKey: "user_type") as? String ?? ""
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? Double ?? 0.0
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? Double ?? 0.0
        self.randomString = aDecoder.decodeObject(forKey: "randomString") as? String ?? ""
        self.__v = aDecoder.decodeObject(forKey: "__v") as? Int ?? 0
        
        self.picture = aDecoder.decodeObject(forKey: "picture") as? String ?? ""
        if let value = aDecoder.decodeObject(forKey: "isActive") as? Bool {
            self.isActive = value
        }
        if let value = aDecoder.decodeObject(forKey: "isDeleted") as? Bool {
            self.isDeleted = value
        }
        if let value = aDecoder.decodeObject(forKey: "is_verified") as? Bool {
            self.is_verified = value
        }
        
        self.modified_date = aDecoder.decodeObject(forKey: "modified_date") as? String ?? ""
        self.created_date = aDecoder.decodeObject(forKey: "created_date") as? String ?? ""
        self.gallery = aDecoder.decodeObject(forKey: "gallery")  as? [BRD_GalleyBO] ?? []
        self.notification = aDecoder.decodeObject(forKey: "notification")  as? [NotificationDisplay] ?? []

        self.rating = aDecoder.decodeObject(forKey: "ratings") as? [BRD_RatingsBO] ?? []
        
        self.imagesPath = aDecoder.decodeObject(forKey: "imagesPath") as? String ?? ""
        
        self.radius_search = aDecoder.decodeObject(forKey: "radius_search") as? String ?? ""
        
        self.deviceID = aDecoder.decodeObject(forKey: "deviceID") as? String ?? ""

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.password, forKey: "password")
        
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self._id, forKey: "_id")
        aCoder.encode(self.first_name, forKey: "first_name")
        aCoder.encode(self.last_name, forKey: "last_name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.mobile_number, forKey: "mobile_number")
        aCoder.encode(self.user_type, forKey: "user_type")
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey: "longitude")
        aCoder.encode(self.randomString, forKey: "randomString")
        aCoder.encode(self.__v, forKey: "__v")
        aCoder.encode(self.picture, forKey: "picture")

        aCoder.encode(self.isActive as Any, forKey: "isActive")
        aCoder.encode(self.isDeleted as Any, forKey: "isDeleted")
        aCoder.encode(self.is_verified as Any, forKey: "is_Verified")

        aCoder.encode(self.modified_date, forKey: "modified_date")
        aCoder.encode(self.created_date, forKey: "created_date")
        aCoder.encode(self.gallery, forKey: "gallery")
        
        aCoder.encode(self.rating, forKey: "ratings")
        aCoder.encode(self.imagesPath, forKey: "imagesPath")
        aCoder.encode(self.radius_search, forKey: "radius_search")
        
        aCoder.encode(self.deviceID, forKey: "deviceID")
    }
}


class  BRD_UserInfoBOBL: NSObject {
    
    class func initWithParameters(_ requestType: String, urlComponent: String, inputParameters: [String: Any], headers: [String: String], completionHandler: @escaping(BRD_UserInfoBO?, NSError?) -> Void){
        
        
        let urlString: String = "\(KBaseURLString)\(urlComponent)"
        
        let comunicationManager = BRD_CommunicationManager()
        comunicationManager.postRequestUsingDictionaryParameters(requestType, urlComponent: urlString, inputParameters: inputParameters, headers: headers, completionHandler: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    
                    print(result)
                    
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        //completionHandler(dict, nil)
                        
//                        if let responseMessage = dict["msg"] as? String{
//                            
//                            completionHandler(responseMessage, nil)
                        
                        if let userData = dict["user"] as? [String: Any]{
                            let obj = BRD_UserInfoBO.init(dictionary: userData)
                            
                            if dict["imagesPath"] != nil{
                                if let serverPath = dict["imagesPath"] as? String{
                                    obj?.imagesPath = serverPath
                                }
                            }
                            if dict["token"] != nil{
                                if let token = dict["token"] as? String{
                                    obj?.token = token
                                }
                            }
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
    
    
    class func initWithFacebook(_ requestType: String, urlComponent: String, inputParameters: [String: Any], headers: [String: String], completionHandler: @escaping(BRD_UserInfoBO?, NSError?) -> Void){
        
        
        let urlString: String = "\(KBaseURLString)\(urlComponent)"
        
        let comunicationManager = BRD_CommunicationManager()
        comunicationManager.postRequestUsingDictionaryParameters(requestType, urlComponent: urlString, inputParameters: inputParameters, headers: headers, completionHandler: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    print(result)
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                   
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        BRDSingleton.sharedInstane.token = dict["token"] as? String
                        
                        if let userData = dict["user"] as? [String: Any]{
                            let obj = BRD_UserInfoBO.init(dictionary: userData)
                         BRDSingleton.sharedInstane.objBRD_UserInfoBO = obj
                            if dict["imagesPath"] != nil{
                                if let serverPath = dict["imagesPath"] as? String{
                                    obj?.imagesPath = serverPath
                                }
                            }
                            if dict["token"] != nil{
                                if let token = dict["token"] as? String{
                                    obj?.token = token
                                    BRDSingleton.sharedInstane.token = token
                                }
                            }
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
