//
//  BRD_CommunicationManager.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 14/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_CommunicationManager: NSObject {
    
    
    func postRequestUsingDictionaryParameters(_ requestType: String, urlComponent: String, inputParameters: [String: Any], headers: [String: String], completionHandler: @escaping(_ result: Data, _ httpResponse: HTTPURLResponse) -> Void, failure: @escaping(_ error: NSError) -> ()) {
        
        //--------------------------------------------------------------
        // IF NO INTERNET CONNECTION THEN RETURN
        //--------------------------------------------------------------
        
        if (BRD_CheckReachability.isAvailable() == false) {
            let error = NSError.init(domain: "Wifi or mobile data not available", code: 999, userInfo: nil)
            failure (error)
            return
        }
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: inputParameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            let data = jsonString.data(using: String.Encoding.ascii, allowLossyConversion: false)
            
            
            let request = NSMutableURLRequest(url: URL(string: urlComponent)!)
            request.httpMethod = requestType
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/Json", forHTTPHeaderField: "Accept")
            request.allHTTPHeaderFields = headers
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                guard error == nil && data != nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    failure(error!  as NSError)
                    return
                }
                if error != nil {
                    failure (error! as NSError)
                } else {
                    
                    completionHandler(data!, (response as? HTTPURLResponse)!)
                }
            })
            task.resume()
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    func getRequestUsingDictionaryParameters(_ requestType : String, urlComponent : String, inputParameters : [String: Any]?, header: [String: String]?, completion: @escaping (_ result : Data, _ httpResponse : HTTPURLResponse) -> Void, failure:@escaping (_ error: NSError) ->()){
        
        //--------------------------------------------------------------
        // IF NO INTERNET CONNECTION THEN RETURN
        //--------------------------------------------------------------
        
        if (BRD_CheckReachability.isAvailable() == false) {
            let error = NSError.init(domain: "Wifi or mobile data not available", code: 999, userInfo: nil)
            failure (error)
            return
        }
        
        do {
            let urlNew: URL = URL(string: urlComponent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            
            let request = NSMutableURLRequest(url: urlNew)
            request.httpMethod = requestType
            request.httpBody = nil
            request.allHTTPHeaderFields = header
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                guard error == nil && data != nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    failure(error! as NSError)
                    return
                }
                if error != nil {
                    failure (error! as NSError)
                } else {
                    
                    completion(data!, (response as? HTTPURLResponse)!)
                }
            })
            
            task.resume()
        }
        catch let error as NSError {
            print(error)
            failure (error)
        }
    }

    
    
    class func getError(_ response: AnyObject?) -> NSError? {
        
        let errorMessageDummy = "Please try again later"
        
        if response == nil {
            return NSError.init(domain: errorMessageDummy, code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessageDummy])
        }
        if let errorMessage = response as? String{
             return NSError.init(domain: errorMessage, code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessage])
        }
        
        if let responseData = response as? Data{
            
            do {
                let dict = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [String:AnyObject]
                
                print(dict)
                
                if let errorMessage = dict["msg"] as? String {
                    return NSError.init(domain: errorMessage, code: 10, userInfo: [NSLocalizedDescriptionKey : errorMessage])
                }
                
                
            }catch let error as NSError{
                print(error.description)
            }
            
            return NSError.init(domain: errorMessageDummy, code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessageDummy])
        }
        return NSError.init(domain: errorMessageDummy, code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessageDummy])
    }
    
    
    //Mark
    func GET(api:NSString,queryString:NSString,sync:Bool, completionHandler:@escaping (_ success:Bool,_ response:String) -> Void) {
        
        var api = api
        
        api = (api as String) + (queryString.addingPercentEscapes(using: String.Encoding.utf8.rawValue))!  as NSString
        
        let url: URL? = URL(string: api as String)
        
        if((url) != nil) {
            
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 120
            
            let session: URLSession
            let sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
            session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                DispatchQueue.main.async {
                    
                    if let data = data {
                        if let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                            completionHandler(true,responseString as String)
                        }
                        else {
                           // Helper.printLog("Error: CommMgr:GET=\(error)" as AnyObject?)
                            completionHandler(false,"")
                        }
                    }
                    else {
                       // Helper.printLog("Error in GET \(error)" as AnyObject?)
                    }
                }
            })
            task.resume()
            
            
        }
        else{
            completionHandler(false,"")
        }
    }
    
}
