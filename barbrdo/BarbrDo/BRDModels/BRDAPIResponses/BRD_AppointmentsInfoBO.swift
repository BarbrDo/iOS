//
//  BRD_AppointmentsInfoBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_AppointmentsInfoBO: NSObject {
    public var _id : String?
    public var shop_id : BRD_ShopDataBO?
    public var barber_id : BRD_BarberInfoBO?
    public var payment_method : String?
    public var appointment_date : String?
    public var customer_name : String?
    public var shop_name : String?
    public var barber_name : String?
    public var customer_id : String?
    public var __v : Int?
    public var modified_date : String?
    public var created_date : String?
    public var payment_status : String?
    public var appointment_status : String?
    public var services : Array<BRD_ServicesBO>? = []
    public var is_rating_given: Bool?
    public var rating_score: Float?
    public var chair_id : String?
    public var chair_name : String?
    public var chair_type : String?
    public var chair_amount : Int?
    public var chair_shop_percentage : Int?
    public var chair_barber_percentage : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_AppointmentsInfoBO]
    {
        var models:[BRD_AppointmentsInfoBO] = []
        for item in array
        {
            models.append(BRD_AppointmentsInfoBO(dictionary: item as! [String: Any])!)
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
    required public init?(dictionary: [String: Any]) {
        
        print(dictionary)
        
        _id = dictionary["_id"] as? String
        if (dictionary["shop_id"] != nil) { shop_id = BRD_ShopDataBO(dictionary: dictionary["shop_id"] as! NSDictionary) }

        if (dictionary["barber_id"] != nil && !(dictionary["barber_id"] is NSNull)) { barber_id = BRD_BarberInfoBO(dictionary: dictionary["barber_id"] as! NSDictionary) }
        payment_method = dictionary["payment_method"] as? String
        appointment_date = dictionary["appointment_date"] as? String
        customer_name = dictionary["customer_name"] as? String
        shop_name = dictionary["shop_name"] as? String
        barber_name = dictionary["barber_name"] as? String
        customer_id = dictionary["customer_id"] as? String
        __v = dictionary["__v"] as? Int
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        payment_status = dictionary["payment_status"] as? String
        appointment_status = dictionary["appointment_status"] as? String
        
        chair_id = dictionary["chair_id"] as? String
        chair_name = dictionary["chair_name"] as? String
        chair_type = dictionary["chair_type"] as? String
        chair_amount = dictionary["chair_amount"] as? Int
        chair_shop_percentage = dictionary["chair_shop_percentage"] as? Int
        chair_barber_percentage = dictionary["chair_barber_percentage"] as? Int

        
        
        if (dictionary["services"] != nil) { services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["services"] as! NSArray) }
        
        is_rating_given = dictionary["is_rating_given"] as? Bool
        rating_score = dictionary["rating_score"] as? Float ?? 0
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.shop_id?.dictionaryRepresentation(), forKey: "shop_id")
        dictionary.setValue(self.barber_id?.dictionaryRepresentation(), forKey: "barber_id")
        dictionary.setValue(self.payment_method, forKey: "payment_method")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.customer_name, forKey: "customer_name")
        dictionary.setValue(self.shop_name, forKey: "shop_name")
        dictionary.setValue(self.barber_name, forKey: "barber_name")
        dictionary.setValue(self.customer_id, forKey: "customer_id")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.payment_status, forKey: "payment_status")
        dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        dictionary.setValue(self.rating_score, forKey: "rating_score")
        dictionary.setValue(self.chair_barber_percentage, forKey: "chair_barber_percentage")
        dictionary.setValue(self.chair_shop_percentage, forKey: "chair_shop_percentage")
        dictionary.setValue(self.chair_type, forKey: "chair_type")
        dictionary.setValue(self.chair_amount, forKey: "chair_amount")
        dictionary.setValue(self.chair_name, forKey: "chair_name")
        dictionary.setValue(self.chair_id, forKey: "chair_id")


        return dictionary
    }
    
}

class BRD_AppointmentsInfoBOBL: NSObject {
    
    class func initWithParameters(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlComponent: String, completionHandler: @escaping ([BRD_AppointmentsInfoBO]?,[BRD_AppointmentsInfoBO]?, NSError?) -> Void){
        
        let urlString: String = "\(KBaseURLString)\(KGetAllAppointmentURL)"
        
        let comunicationManager = BRD_CommunicationManager()
        comunicationManager.getRequestUsingDictionaryParameters("GET", urlComponent: urlString, inputParameters: inputParameters, header: header, completion: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        let json = try JSONSerialization.jsonObject(with: result, options: .mutableContainers) as? [String:Any]
                        if let jsonData = json?["data"] as? [String: Any]{
                            var arrayUpcoming = [BRD_AppointmentsInfoBO]()
                            var arrayCompleted = [BRD_AppointmentsInfoBO]()
                            if let dataArray = jsonData["upcoming"] as? [Any]{
                              arrayUpcoming = BRD_AppointmentsInfoBO.modelsFromDictionaryArray(array: dataArray as NSArray)
                            }
                            if let dataArray = jsonData["complete"] as? [Any]{
                                arrayCompleted = BRD_AppointmentsInfoBO.modelsFromDictionaryArray(array: dataArray as NSArray)
                            }
                            
                            completionHandler(arrayUpcoming, arrayCompleted, nil)
                        }else{
                            print("Invalid Response")
                            completionHandler(nil, nil, BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                        }
                    }else{
                        let errorMessage = BRD_CommunicationManager.getError(result as AnyObject?)
                        completionHandler(nil, nil, errorMessage)
                    }
                }
                catch {
                    print("catch")
                    completionHandler(nil, nil, BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
           print("Could not reach to server")
            completionHandler(nil, nil, error)
        }
        
    }
    
    
    class func initWithPOSTRequest(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlComponent: String, completionHandler: @escaping (String?, NSError?) -> Void){
        
        
        let urlString: String = "\(KBaseURLString)\(KGetAllAppointmentURL)"
        
        let comunicationManager = BRD_CommunicationManager()
        
        
        comunicationManager.getRequestUsingDictionaryParameters("POST", urlComponent: urlString, inputParameters: inputParameters, header: header, completion: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                         completionHandler("SUCCESS", nil)
                       
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
            print("Could not reach to server")
            completionHandler(nil, error)
        }
        
    }
}
