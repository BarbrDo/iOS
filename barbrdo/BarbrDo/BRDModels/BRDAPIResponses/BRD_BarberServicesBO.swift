//
//  BRD_BarberServicesBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 19/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_BarberServicesBO: NSObject {
    public var _id : String?
    public var name : String?
    public var price : Int?
    public var barber_id : String?
    public var __v : Int?
    public var modified_date : String?
    public var created_date : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_BarberServicesBO]
    {
        var models:[BRD_BarberServicesBO] = []
        for item in array
        {
            models.append(BRD_BarberServicesBO(dictionary: item as! NSDictionary)!)
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
        name = dictionary["name"] as? String
        price = dictionary["price"] as? Int
        barber_id = dictionary["barber_id"] as? String
        __v = dictionary["__v"] as? Int
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.price, forKey: "price")
        dictionary.setValue(self.barber_id, forKey: "barber_id")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        
        return dictionary
    }
    
}


class BRD_BarberServicesBOBL: NSObject{
    
    
    class func initWithParameters(_ requestType: String, urlComponent: String, inputParameters: [String: Any], headers: [String: String], completionHandler: @escaping([BRD_BarberServicesBO]?, NSError?) -> Void){
        
        
        let urlString: String = "\(KBaseURLString)\(urlComponent)"
        
        let comunicationManager = BRD_CommunicationManager()
        print(headers)
        
        comunicationManager.getRequestUsingDictionaryParameters("GET", urlComponent: urlString, inputParameters: headers, header: headers, completion: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        let json = try JSONSerialization.jsonObject(with: result, options: .mutableContainers) as? [String:Any]
                        if let arrayValue = json?["data"] as? [Any]{
                            
                            let tempArray = BRD_BarberServicesBO.modelsFromDictionaryArray(array: arrayValue as NSArray)
                            
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
        }){ (error) in
            
            DispatchQueue.main.async(execute: {
                completionHandler(nil, error)
            })
        }
    }
}
