//
//  BRD_BarberAppointmentsBO.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 23/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_BarberAppointmentsBO: NSObject {
    public var _id : String?
    public var appointment_date : String?
    public var barber_id : BRD_BarberInfoBO?
    public var payment_method : String?
    public var shop_id : BRD_ShopDataBO?
    public var customer_name : String?
    public var shop_name : String?
    public var barber_name : String?
    public var customer_id : BRD_CustomerIDBO?
    public var __v : Int?
    public var modified_date : String?
    public var created_date : String?
    public var payment_status : String?
    public var appointment_status : String?
    public var services : [BRD_ServicesBO]?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [BRD_BarberAppointmentsBO]
    {
        var models:[BRD_BarberAppointmentsBO] = []
        for item in array
        {
            models.append(BRD_BarberAppointmentsBO(dictionary: item as! NSDictionary)!)
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
        appointment_date = dictionary["appointment_date"] as? String
        if (dictionary["barber_id"] != nil) { barber_id = BRD_BarberInfoBO(dictionary: dictionary["barber_id"] as! NSDictionary) }
        payment_method = dictionary["payment_method"] as? String
        if (dictionary["shop_id"] != nil) { shop_id = BRD_ShopDataBO(dictionary: dictionary["shop_id"] as! NSDictionary) }
        customer_name = dictionary["customer_name"] as? String
        shop_name = dictionary["shop_name"] as? String
        barber_name = dictionary["barber_name"] as? String
        if (dictionary["customer_id"] != nil) {
            customer_id = BRD_CustomerIDBO(dictionary: dictionary["customer_id"] as! NSDictionary)
        }
        __v = dictionary["__v"] as? Int
        modified_date = dictionary["modified_date"] as? String
        created_date = dictionary["created_date"] as? String
        payment_status = dictionary["payment_status"] as? String
        appointment_status = dictionary["appointment_status"] as? String
        if (dictionary["services"] != nil) { services = BRD_ServicesBO.modelsFromDictionaryArray(array: dictionary["services"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.barber_id?.dictionaryRepresentation(), forKey: "barber_id")
        dictionary.setValue(self.payment_method, forKey: "payment_method")
        dictionary.setValue(self.shop_id?.dictionaryRepresentation(), forKey: "shop_id")
        dictionary.setValue(self.customer_name, forKey: "customer_name")
        dictionary.setValue(self.shop_name, forKey: "shop_name")
        dictionary.setValue(self.barber_name, forKey: "barber_name")
        dictionary.setValue(self.customer_id?.dictionaryRepresentation(), forKey: "customer_id")
        dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.modified_date, forKey: "modified_date")
        dictionary.setValue(self.created_date, forKey: "created_date")
        dictionary.setValue(self.payment_status, forKey: "payment_status")
        dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        
        return dictionary
    }
    
}

class BRD_BarberAppointmentsBOBL: NSObject{

    class func initWithParameters(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlComponent: String, completionHandler: @escaping ([BRD_BarberAppointmentsBO]?, [BRD_BarberAppointmentsBO]?, NSError?) -> Void){
        
        
        let urlString: String = "\(KBaseURLString)\(urlComponent)"
        
        let comunicationManager = BRD_CommunicationManager()
        comunicationManager.getRequestUsingDictionaryParameters("GET", urlComponent: urlString, inputParameters: inputParameters, header: header, completion: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        let json = try JSONSerialization.jsonObject(with: result, options: .mutableContainers) as? [String:Any]
                        if let dataDictionary = json?["data"] as? [String: Any]{
                            var arrayPending = [BRD_BarberAppointmentsBO]()
                            var arrayBooked = [BRD_BarberAppointmentsBO]()

                            if let dataBooked = dataDictionary["booked"] as? [Any]{
                                print(dataBooked)
                                arrayBooked = BRD_BarberAppointmentsBO.modelsFromDictionaryArray(array: dataBooked as NSArray)
                            }
                            if let dataPending = dataDictionary["pending"] as? [Any]{
                                arrayPending = BRD_BarberAppointmentsBO.modelsFromDictionaryArray(array: dataPending as NSArray)
                            }
                            completionHandler(arrayPending,arrayBooked, nil)
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
                    completionHandler(nil,nil, BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
            
        }
        
    }
    
}
