//
//  BRD_BarberDataBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_BarberDataBO: NSObject {
    public var _id : String?
    public var first_name : String?
    public var gallery: [BRD_GalleyBO]?
    public var last_name : String?
    public var picture: String?
    
    public var distance : Int?
    public var units : String?
    public var created_date : String?
    public var rating : [BRD_RatingsBO]?
    public var location : String?
    public var shop_id : String?
    public var ratingValue : CGFloat = 0.0
    
    public var licenseNumber: String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_BarberDataBO]
    {
        var models:[BRD_BarberDataBO] = []
        for item in array
        {
            models.append(BRD_BarberDataBO(dictionary: item as! NSDictionary)!)
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
        picture = dictionary["picture"] as? String
        last_name = dictionary["last_name"] as? String
        distance = dictionary["distance"] as? Int
        units = dictionary["units"] as? String
        created_date = dictionary["created_date"] as? String
        
        if (dictionary["ratings"] != nil) { rating = BRD_RatingsBO.modelsFromDictionaryArray(array: dictionary["ratings"] as! NSArray) }
        /* if let ratingArray = dictionary["ratings"] as? [Any] {
         if let ratingModelArray = BRD_RatingsBO.modelsFromDictionaryArray(array: ratingArray as NSArray) as? [BRD_RatingsBO] {
         rating = ratingModelArray
         var avg: Float = 0.0
         if let ratings = rating {
         if ratings.count > 0 {
         for obj in ratings {
         if let value: Float = obj.score {
         avg = avg + value
         }
         }
         let fMean: Float = Float((rating?.count)!)
         ratingValue = CGFloat(avg/fMean)
         }
         }
         }
         }*/
        
        location = dictionary["location"] as? String
        shop_id = dictionary["shop_id"] as? String
        licenseNumber = dictionary["license_number"] as? String
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
        dictionary.setValue(self.distance, forKey: "distance")
        dictionary.setValue(self.units, forKey: "units")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.shop_id, forKey: "shop_id")
        
        return dictionary
    }
    
}

class BRD_BarberDataBOBL: NSObject{
    
    
    class func initWithParameters(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlComponent: String, completionHandler: @escaping ([BRD_BarberInfoBO]?, NSError?) -> Void){
        
        
        let urlString: String = "\(KBaseURLString)\(urlComponent)"
        print(urlString)
        let comunicationManager = BRD_CommunicationManager()
        comunicationManager.getRequestUsingDictionaryParameters("GET", urlComponent: urlString, inputParameters: inputParameters, header: header, completion: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        let json = try JSONSerialization.jsonObject(with: result, options: .mutableContainers) as? [String:Any]
                        if let arrayValue = json?["data"] as? [Any]{
                            var tempArray = [BRD_BarberInfoBO]()
                            
                            for obj in arrayValue{
                                let temp = BRD_BarberInfoBO.modelsFromDictionaryArray(array: arrayValue as NSArray)
                                tempArray.append(temp[0])
                            }
                            
                            completionHandler(tempArray,nil)
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
            
        }
        
    }
}
