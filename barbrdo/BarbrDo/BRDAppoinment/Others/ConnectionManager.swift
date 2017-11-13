//
//  ConnectionManager.swift
//  SquadApp
//
//  Created by Vishwajeet Kumar on 1/16/17.
//  Copyright © 2017 Vishwajeet Kumar. All rights reserved.
//

import UIKit

public enum Method: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public enum ResponseStatus:Int {
    case tokenExpired = -3
    case internetNotAvailable
    case serverError
    case failed
    case success
}

public enum ImageType:Int {
    case png
    case jpeg
}



private let tokenExpirationCode   =   4015
private let succesCode            =   200
private let badCode               =   400

typealias responseHandler = (_ response: [String: Any]?, _ status: ResponseStatus, _ error: Error?, _ statusCode: Int?) -> Void

public class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    
    func sendRequest(_ method: Method = .POST, _ urlString: String, _ parameters: [String: Any]? = nil ,_ authentication: Bool = false, _ headers: [String: String]? = nil, _ onCompletion: @escaping responseHandler) {
        
        if isInternetReachable() {
            do {
                if let requestParameter = parameters {
                    let jsonData = try JSONSerialization.data(withJSONObject: requestParameter , options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    let jsonRequest = NSString(data: jsonData,
                                               encoding: String.Encoding.ascii.rawValue)
                    
                    print("json Request : \(String(describing: jsonRequest))")
                }
                print("URL : \(urlString)")
                
            } catch let error as NSError {
                print(error)
            }
            
            let session: URLSession
            if authentication == true {
                let sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
                session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
            }
            else {
                session = URLSession.shared
            }
            guard let url = URL(string: urlString) else {
                return
            }
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = method.rawValue
//            request.allHTTPHeaderFields = headers!
//            print(request.allHTTPHeaderFields)
            
            do {
                if let requestParameter = parameters {
                    let data = try JSONSerialization.data(withJSONObject: requestParameter, options: JSONSerialization.WritingOptions())
                    let postLength = NSString(format: "%ld", data.count)
                    request.httpBody = data
                    request.addValue(postLength as String, forHTTPHeaderField: "Content-Length")
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.addValue("Accept", forHTTPHeaderField: "application/json")
//                request.addValue("ios", forHTTPHeaderField: "device_type")
                
                if let customHeader = headers {
                    for (key, value) in customHeader {
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
                
                request.timeoutInterval = 60.0
            } catch {
                let encodingError = error as NSError
                print("Error could not parse JSON: \(encodingError)")
            }
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                DispatchQueue.main.async {
                    guard error == nil else {
                        onCompletion(nil, .serverError, error, nil)
                        return
                    }
                    do {
                        guard let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == succesCode || httpResponse.statusCode == badCode else {
                            if let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == tokenExpirationCode {
                                onCompletion(nil, .tokenExpired, error, statusCode)
                                return
                            }
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }
                        guard let responseData = data else {
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }
                        guard let responseDictionary = try JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as? NSDictionary else {
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }
                        guard let status = responseDictionary.value(forKey: "status") as? String, status == "success"  else {
                            if let response = responseDictionary as? [String : Any] {
                                onCompletion(response, .failed , nil, statusCode)
                            }
                            return
                        }
                        if let response = responseDictionary as? [String : Any] {
                            onCompletion(response, .success , nil, statusCode)
                        }
                        
                    } catch {
                        onCompletion(nil, .serverError, error, statusCode)
                    }
                }
            })
            task.resume()
        }
        else {
            onCompletion(nil, .internetNotAvailable, nil, nil)
        }
    }
    
    
    
    
    
    func makeChairRequest(_ method: Method = .POST, _ urlString: String, _ parameters: [String: Any]? = nil ,_ authentication: Bool = false, _ headers: [String: String]? = nil, _ onCompletion: @escaping responseHandler) {
        
        if isInternetReachable() {
            do {
                if let requestParameter = parameters {
                    let jsonData = try JSONSerialization.data(withJSONObject: requestParameter , options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    let jsonRequest = NSString(data: jsonData,
                                               encoding: String.Encoding.ascii.rawValue)
                    
                    print("json Request : \(String(describing: jsonRequest))")
                }
                print("URL : \(urlString)")
                
            } catch let error as NSError {
                print(error)
            }
            
            let session: URLSession
            if authentication == true {
                let sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
                session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
            }
            else {
                session = URLSession.shared
            }
            guard let url = URL(string: urlString) else {
                return
            }
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = method.rawValue
            
            do {
                if let requestParameter = parameters {
                    let data = try JSONSerialization.data(withJSONObject: requestParameter, options: JSONSerialization.WritingOptions())
                    let postLength = NSString(format: "%ld", data.count)
                    request.httpBody = data
                    request.addValue(postLength as String, forHTTPHeaderField: "Content-Length")
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                if let customHeader = headers {
                    for (key, value) in customHeader {
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
                
                request.timeoutInterval = 60.0
            } catch {
                let encodingError = error as NSError
                print("Error could not parse JSON: \(encodingError)")
            }
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                DispatchQueue.main.async {
                    guard error == nil else {
                        onCompletion(nil, .serverError, error, nil)
                        return
                    }
                    do {
                        /*guard let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == succesCode else {
                            if let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == tokenExpirationCode {
                                onCompletion(nil, .tokenExpired, error, statusCode)
                                return
                            }
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }*/
                        guard let responseData = data else {
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }
                        guard let responseDictionary = try JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as? NSDictionary else {
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }
                        guard let status = responseDictionary.value(forKey: "status") as? String, status == "success"  else {
                            if let response = responseDictionary as? [String : Any] {
                                onCompletion(response, .failed , nil, statusCode)
                            }
                            return
                        }
                        if let response = responseDictionary as? [String : Any] {
                            onCompletion(response, .success , nil, statusCode)
                        }
                        
                    } catch {
                        onCompletion(nil, .serverError, error, statusCode)
                    }
                }
            })
            task.resume()
        }
        else {
            onCompletion(nil, .internetNotAvailable, nil, nil)
        }
    }
    
    func sendRequestWithMultipart( _ method: String, _ urlString: String, _ parameters: [String: Any]? = nil,_ imagesData: [String: Data]?,_ imageType: ImageType = .jpeg,_ authentication: Bool = false, _ onCompletion: @escaping responseHandler) {
        
        if isInternetReachable() {
            do {
                if let requestParameter = parameters {
                    let jsonData = try JSONSerialization.data(withJSONObject: requestParameter , options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    let jsonRequest = NSString(data: jsonData,
                                               encoding: String.Encoding.ascii.rawValue)
                    
                    print("json Request : \(String(describing: jsonRequest))")
                }
                print("URL : \(urlString)")
                
            } catch let error as NSError {
                print(error)
            }
            
            let session: URLSession
            if authentication == true {
                let sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
                session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
            }
            else {
                session = URLSession.shared
            }
            guard let url = URL(string: urlString) else {
                return
            }
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = method
            
            let boundary = _generateBoundaryString()
            let postData =  _createBodyWithParameters(parameters, imagesData, imageType, boundary)
            request.httpBody = postData as Data
            let postLength = NSString(format: "%ld", (postData as Data).count)
            request.addValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue("ios", forHTTPHeaderField: "device_type")
            
            let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
            request.addValue((obj?._id)!, forHTTPHeaderField: "user_id")
            
           
            var lat: String = "40.834444"
            var lon: String = "-74.119792"
            if UserDefaults.standard.object(forKey: "CurrentLocation") != nil{
                
                if let arr = UserDefaults.standard.object(forKey: "CurrentLocation") as? [Any]{
                    
                    if arr.count == 2{
                        lat = String(describing: arr[0])
                        lon = String(describing: arr[1])
                    }
                }
            }
            let deviceID = UserDefaults.standard.string(forKey: "deviceToken")!
            request.addValue(deviceID, forHTTPHeaderField: KDeviceID)
            request.addValue(lat, forHTTPHeaderField: KLatitude)
            request.addValue(lon, forHTTPHeaderField: KLongitude)
            
            request.timeoutInterval = 60.0
        
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                DispatchQueue.main.async {
                    guard error == nil else {
                        onCompletion(nil, .serverError, error, nil)
                        return
                    }
                    do {
                        guard let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == succesCode else {
                            if let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == tokenExpirationCode {
                                onCompletion(nil, .tokenExpired, error, statusCode)
                                return
                            }
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }
                        guard let responseData = data else {
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }
                        guard let responseDictionary = try JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as? NSDictionary else {
                            onCompletion(nil, .serverError, error, statusCode)
                            return
                        }
                        guard let status = responseDictionary.value(forKey: "status") as? String, status == "success"  else {
                            if let response = responseDictionary as? [String : Any] {
                                onCompletion(response, .failed , nil, statusCode)
                            }
                            return
                        }
                        if let response = responseDictionary as? [String : Any] {
                            onCompletion(response, .success , nil, statusCode)
                        }
                        
                    } catch {
                        onCompletion(nil, .serverError, error, statusCode)
                    }
                }
            })
            task.resume()
        }
        else {
            onCompletion(nil, .internetNotAvailable, nil, nil)
        }
    }
    
    private func _createBodyWithParameters(_ parameters: [String: Any]?,_ imagesData: [String: Data]?,_ imageType: ImageType, _ boundary: String) -> NSData {
        
        let body = NSMutableData()
        if let requestParameter = parameters {
            for (key, value) in requestParameter {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        if let dataDictionay = imagesData {
            for (key, data) in dataDictionay {
                let type = (imageType == .jpeg) ? "jpeg" : "png"
                let filename = "\(key).\(type)"
                let mimetype = "image/\(type)"
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; image=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data)
            }
        }
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    private func _generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension ConnectionManager: URLSessionDelegate {
    
    //MARK:  NSURLSession delegate
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        if challenge.previousFailureCount > 0 {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
        else {
            let credential = URLCredential(user:"", password:"", persistence: .forSession)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
        }
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let err = error {
            print("Error: \(err.localizedDescription)")
        } else {
            print("Error. Giving up")
        }
    }
    
    
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            append(data)
        }
    }
}
