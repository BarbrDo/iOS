//
//  BusinessLayer.swift
//  BarbrDo
//
//  Created by Vishwajeet Kumar on 5/11/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit


class BRDAPI: NSObject {
    static func getAppointmentTimeSlot(headers: [String: String], urlString: String, _ handler: @escaping (_ response: [String: Any]?,_ timeSlots: BRDTimeSlot?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        //let urlString = KBaseURLString + KTimeSlotsURL
        
        ConnectionManager.shared.sendRequest(.GET, urlString, nil, false, headers) { (response, status, error, statusCode) in
            if let slots = response?["data"] as? [String: Any] {
                
                let timeSlots = BRDTimeSlot(dictionary: slots as NSDictionary)
                handler(response,timeSlots,.success,error)
            }
            else {
                handler(response,nil,status,error)
            }
        }
        
//        ConnectionManager.shared.sendRequest(.GET,headers, urlString, nil) { (response, status, error) in
//            if let slots = response?["data"] as? [String: Any] {
//                
//                let timeSlots = BRDTimeSlot(dictionary: slots as NSDictionary)
//                handler(response,timeSlots,.success,error)
//            }
//            else {
//                handler(response,nil,status,error)
//            }
//        }
    }
    
    static func getShopDetail(_ requestType: String, inputParameter: [String:Any]?, header: [String: String], urlString: String, completionHandler: @escaping (_ response: [String: Any]?,_ shops: BRD_ShopDataBO?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "Nil Response")
            if let shopDetails = response?["data"] as? [String: Any] {
                print(shopDetails)
                let shop = BRD_ShopDataBO(dictionary: shopDetails as NSDictionary)
                completionHandler(response,shop,.success,error)
            }
            else {
                completionHandler(response,nil, status, error)
            }
        }
    }
    static func sendMail(_ requestType: String, inputParameters: [String: Any]!, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                
                completionHandler(response,responseMessage,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    static func getManageChairListing( requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: [BRD_ChairInfo]?,_ status: ResponseStatus, _ error: Error? ) -> Void)
    {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            var arrayChairs = [BRD_ChairInfo]()
            var shopChairInfo = [ShopChairInfo]()
            var barberInfo = BRD_BarberInfoBO()
            if let responseDictionary  = response?["result"] as? NSArray
            {
                
                for i in 0 ..< responseDictionary.count
                {
                    
                    let service = ManageRequestInfo.modelsFromDictionaryArray(array: responseDictionary as NSArray)
                    
                    BRDSingleton.sharedInstane.objManageRequestInfo = service
                    let dic = (responseDictionary[i] as! NSDictionary).value(forKey: "shopChairInfo") as! NSDictionary
                   
                  if  let nameDic =  dic as? NSDictionary
                  {
                    let service = ShopChairInfo(dictionary: nameDic  )
                    shopChairInfo.append(service!)
                    BRDSingleton.sharedInstane.objShopChairInfo = shopChairInfo

                    print (BRDSingleton.sharedInstane.objShopChairInfo)
                    }
                    
//                        let service1 = ShopChairInfo.modelsFromDictionaryArray(array: nameDic!)
//                       BRDSingleton.sharedInstane.objShopChairInfo = service1
                    
                    
                    if   let  dic2 =   dic.value(forKey: "chairs") as?  NSDictionary
                    {
                        let service = BRD_ChairInfo(dictionary: (dic2 as? NSDictionary)! )
                        arrayChairs.append(service!)
                    }
                    
                    let barberDic = (responseDictionary[i] as! NSDictionary).value(forKey: "barberInfo") as! NSArray
                    
                    let barberDic1 = BRD_BarberInfoBO.modelsFromDictionaryArray(array: barberDic as NSArray)
                    print ("sdsada sadfasfd ----\(barberDic1)")
                 
                    BRDSingleton.sharedInstane.objBarberdetailInfo = barberDic1
                }
                completionHandler(response,arrayChairs as? [BRD_ChairInfo],.success,error)
            }
            else
            {
                completionHandler(response,nil,status,error)
            }
            
        }
    }
    static func updateAccount(_ requestType: String,
                              imageData: [String: Data]?,
                              imageType: ImageType,
                              dictionary: [String: Any],
                              header: [String: String],
                              url: String,
                              _ handler: @escaping (_ response: [String: Any]?,_ shops: BRD_UserInfoBO?,_ userProfile: BRD_UserProfileBO?,_ status: ResponseStatus, _ error: Error? ) -> Void) {
       
        
        ConnectionManager.shared.sendRequestWithMultipart(requestType, url, dictionary, imageData, imageType, false) { (response, status, error, statusCode) in
            print(response ?? "NO Response")
            
            if let shopDetails = response?["user"] as? [String: Any] {
                print(shopDetails)
                let objUser = BRD_UserInfoBO(dictionary: shopDetails as [String: Any])
                let userProfile = BRD_UserProfileBO.init(dictionary: shopDetails as [String: Any] as NSDictionary)
                handler(response,objUser,userProfile,.success,error)
            }
            else {
                handler(response,nil,nil,status,error)
            }
        }
    }
    
    
   
    static func getBarberDetail(_ dictionary: [String: Any]?, header: [String: String], url: String, _ handler: @escaping (_ response: [String: Any]?,_ userInfo: BRD_UserInfoBO?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, url, dictionary, false, header) { (response, status, error, statusCode) in

            print("API RESPONSE \n", response ?? "Else No Response")
            if let userInfo = response?["user"] as? [String: Any] {
                let objUser = BRD_UserInfoBO(dictionary: userInfo as [String: Any])
                handler(response,objUser,.success,error)
            }
            else {
                handler(response,nil,status,error)
            }
        }
    }
    
    static func getUserProfile(_ dictionary: [String: Any]?, header: [String: String], url: String, _ handler: @escaping (_ response: [String: Any]?,_ userInfo: BRD_UserInfoBO?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, url, dictionary, false, header) { (response, status, error, statusCode) in
            
            print("API RESPONSE \n", response ?? "Else No Response")
            if let userInfo = response?["data"] as? [String: Any] {
                let objUser = BRD_UserInfoBO(dictionary: userInfo as [String: Any])
                handler(response,objUser,.success,error)
            }
            else {
                handler(response,nil,status,error)
            }
            
        }
    }
    
    
    static func getAllListofBarberServices(_ requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: [BRD_ServicesBO]?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            
            if let barberServices = response?["data"] as? [Any] {
                print(barberServices)
                var arrayService = [BRD_ServicesBO]()
                for obj in barberServices{
                    let service = BRD_ServicesBO(dictionary: obj as! NSDictionary)
                    arrayService.append(service!)
                    
                }
                completionHandler(response,arrayService,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    static func deleteServices(_ requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ responseMessage: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.DELETE, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            
            if let responseMessage = response?["msg"] as? String {
                
                completionHandler(response,responseMessage,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    
    static func getListofShops(_ requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: [ShopChairsBO]?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let barberServices = response?["data"] as? [Any] {
                print(barberServices)
                var arrayService = [ShopChairsBO]()
                for obj in barberServices{
                    let service = ShopChairsBO(dictionary: obj as! NSDictionary)
                    arrayService.append(service!)
                }
                completionHandler(response,arrayService,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    static func getShopDataWithChair(_ requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: [ShopDataWithChairBO]?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let arrayShopData = response?["data"] as? [Any] {
                
                var arrayShopDataObj = [ShopDataWithChairBO]()
                for obj in arrayShopData{
                    let service = ShopDataWithChairBO(dictionary: obj as! NSDictionary)
                    arrayShopDataObj.append(service!)
                }
                
                
                print(arrayShopDataObj)
                completionHandler(response,arrayShopDataObj,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    static func confirmAppointmentDetail(_ requestType: String, inputParameters: [String: Any]!, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: BRD_AppointmentsInfoBO?, _ status: ResponseStatus, _ error: Error?) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let userInfo = response?["data"] as? [String: Any] {
                print(userInfo)
                let objUser = BRD_AppointmentsInfoBO(dictionary: userInfo as [String: Any])
                completionHandler(response,objUser,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
        }
        
    }

    
    
    static func addService(_ requestType: String, inputParameters: [String: Any]!, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error?) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                
                completionHandler(response,responseMessage,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    
    
  
    
    static func updateService(_ requestType: String, inputParameters: [String: Any]!, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                
                completionHandler(response,responseMessage,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
        }
    }
    
    
    static func confirmAppointment(_ requestType: String, inputParameters: [String: Any]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                
                completionHandler(response,responseMessage,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    static func completeAppointment(_ requestType: String, inputParameters: [String: Any], header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                
                completionHandler(response,responseMessage,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    static func forgotPassword(_ requestType: String, inputParameters: [String: Any], header: [String: String]?,urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,.success,error)
            }else{
                completionHandler(response,nil,status,error)
            }
        }
    }
    

    static func cancelAppointment(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?,urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,.success,error)
            }else{
                completionHandler(response,nil,status,error)
            }
        }
    }
    
    static func rescheduleAppointment(_ requestType: String, inputParameters: [String: Any], header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,.success,error)
            }else{
                completionHandler(response,nil,status,error)
            }
        }
    }
    
    static func deleteImage(_ requestType: String, inputParameters: [String: Any]?, header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseString: BRD_UserInfoBO?,_ status: ResponseStatus, _ error: Error?) -> Void){
        ConnectionManager.shared.sendRequest(.DELETE, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            
            if let userInfo = response?["user"] as? [String: Any] {
                print(userInfo)
                let objUser = BRD_UserInfoBO(dictionary: userInfo as [String: Any])
                completionHandler(response,objUser,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
        }
    }
    
    
    static func requestChair(_ requestType: String, inputParameters: [String: Any], header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ chairInfo: ChairRequestInfo?, _ status: Int, _ error: Error? ) -> Void) {
  
        ConnectionManager.shared.makeChairRequest(.POST, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            var theStatusCode: Int = 0
            if let theCode = statusCode{
                theStatusCode = theCode
            }
            if theStatusCode == 200{
                if let responseArray = response?["data"] as? [Any] {
                    
                    if responseArray.count > 0{
                        if let responseDictionary = responseArray[0] as? [String: Any]{
                            let chairDetails = ChairRequestInfo(dictionary: responseDictionary as NSDictionary)
                            completionHandler(response,chairDetails,theStatusCode,error)
                        }
                    }
                    
                }else if let responseDictionary = response?["data"] as? [String: Any]{
                    let chairDetails = ChairRequestInfo(dictionary: responseDictionary as NSDictionary)
                    completionHandler(response,chairDetails,theStatusCode,error)
                }
            }
            else{
                completionHandler(response,nil,theStatusCode,error)
            }
        }
    }
    
    
    
    static func getAllChairs(_ requestType: String, inputParameters: [String: Any]?, header: [String: String], urlString: String, completionHandler:@escaping(_ response: [String: Any]?, _ shops: [BRD_ChairInfo]?, _ status: ResponseStatus, _ error: Error? ) -> Void){
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
//            if let responseMessage = response?["msg"] as? String {
//                completionHandler(response,responseMessage,.success,error)
//            }else{
//                completionHandler(response,nil,status,error)
//            }
            
            
        }
        
    }
    
    static func logout(_ requestType: String, inputParameters: [String: Any]?, header: [String: String], urlString: String, completionHandler:@escaping(_ response: [String: Any]?, _ shops: [BRD_ChairInfo]?, _ status: ResponseStatus, _ error: Error? ) -> Void){
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            //            if let responseMessage = response?["msg"] as? String {
            //                completionHandler(response,responseMessage,.success,error)
            //            }else{
            //                completionHandler(response,nil,status,error)
            //            }
            
            
        }
        
    }

    
    
    
    static func postAnAppointment(_ requestType: String, inputParameter: [String: Any], header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: BRD_AppointmentsInfoBO?, _ status: ResponseStatus, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            print(response ?? "No Response")
            if let userInfo = response?["data"] as? [String: Any] {
                print(userInfo)
                let objUser = BRD_AppointmentsInfoBO(dictionary: userInfo as [String: Any])
                completionHandler(response,objUser,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    static func postShopBarberRequest(_ requestType: String, inputParameter: [String: Any], header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: ResponseStatus, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
       
                if(statusCode == 400)
                {

                    if let responseMessage = response?["msg"] as? String
                    {
                        
                        completionHandler(response,responseMessage,.success,nil)
                    }

                
                return
            }
            
        
             else   if(statusCode == 200)
                {
                    
            if let responseMessage = response?["msg"] as? String
            {
                
                    completionHandler(response,responseMessage,.success,nil)
                }
                    
            else
            {
                completionHandler(response,nil,status,error)
                    }

                }
                        }
                   }
        
    

    
    
    
    static func searchShops(_ requestType: String, inputParameter: [String: Any]?, header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ array: [BRD_ShopDataBO]?, _ status: ResponseStatus, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            
            if let barberServices = response?["data"] as? [Any] {
                print(barberServices)
                var arrayService = [BRD_ShopDataBO]()
                for obj in barberServices{
                    let service = BRD_ShopDataBO(dictionary: obj as! NSDictionary)
                    arrayService.append(service!)
                }
                completionHandler(response,arrayService,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
        }
    }
    
    
    
    // Get Shop List for shops
    
    static func getShopsListing(_ requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: [BRD_ChairInfo]?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            var arrayShop = [BRD_ShopDataBO]()
            var arrayChairs = NSMutableArray()
           if(response == nil)
           {
            completionHandler(response,nil,status,error)
            return
            }
            BRDSingleton.sharedInstane.objShop_id = response?["shop_id"] as? String

            if let responseDictionary  = response?["data"] as? AnyObject {
                
                
                    for obj in (responseDictionary as? NSArray)!
                    {
                        let obj = BRD_ShopDataBO.init(dictionary: obj as! NSDictionary)
                        arrayShop.append(obj!)
                        BRDSingleton.sharedInstane.objShopInfo = obj
                    }
                
                    for arrayObj in arrayShop{
                        let obj = arrayObj.chairs
                        
                        arrayChairs.addObjects(from: obj)
                    }
                
                completionHandler(response,arrayChairs as! [BRD_ChairInfo],.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    
    static func getBarberSale(_ requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: [BarberSale]?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            var barberSaleArray = [BarberSale]()
            if let responseDictionary  = response?["data"] as? NSDictionary
            {
                
                let obj = BarberSale.init(dictionary: responseDictionary )
                barberSaleArray.append(obj!)
            
//                for obj in responseDictionary
//                {
//                    print(obj)
////                    let obj = BarberSale.modelsFromDictionaryArray(array: responseDictionary as NSArray)
////                    barberSaleArray.append(obj!)
//                }

                
                completionHandler(response,barberSaleArray as! [BarberSale],.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }

    static func getShopSale(_ requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: [ShopSale]?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            var barberSaleArray = [ShopSale]()
            if let responseDictionary  = response?["data"] as? NSDictionary
            {
                
                let obj = ShopSale.init(dictionary: responseDictionary )
                barberSaleArray.append(obj!)
                
                //                for obj in responseDictionary
                //                {
                //                    print(obj)
                ////                    let obj = BarberSale.modelsFromDictionaryArray(array: responseDictionary as NSArray)
                ////                    barberSaleArray.append(obj!)
                //                }
                
                
                completionHandler(response,barberSaleArray as! [ShopSale],.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }

    static func updateWeeklyMonthlyChair(_ requestType: String, inputParameters: [String: Any]!, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                
                completionHandler(response,responseMessage,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    
    static func addChairShop(_ requestType: String, inputParameters: [String: Any]!, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                
                completionHandler(response,responseMessage,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    
    
    
    static func deleteChairShop(_ requestType: String, inputParameters: [String: Any], header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.DELETE, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,.success,error)
            }else{
                completionHandler(response,nil,status,error)
            }
        }
    }
    
    static func getUserProfile(_ requestType: String, inputParameter: [String:Any]?, header: [String: String]?, urlString: String, completionHandler: @escaping (_ response: [String: Any]?,_ profile: BRD_UserProfileBO?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "Nil Response")
            
            if let responseDictionary = response?["user"] as? [String: Any] {
                
                let profile = BRD_UserProfileBO(dictionary: responseDictionary as NSDictionary)
                completionHandler(response,profile,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
        }
    }
    
    static func getBarberList( requestType: String, inputParameter: [String:Any]?, header: [String: String], urlString: String, completionHandler: @escaping ( _ response: [String: Any]?, _ barbers: [BarberSearch]?,  _ status: ResponseStatus, _ error: Error? ) -> Void)
    {
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            var listing = [BarberSearch]()
            print(response ?? "No Response")
            
            if let barberServices = response?["data"] as? [Any]
            {
                print(barberServices)
                var arrayService = [BarberSearch]()
                for obj in barberServices
                {
                    let service = BarberSearch(dictionary: obj as! NSDictionary)
                    arrayService.append(service!)
                    listing.append(service!)
                }
                completionHandler(response,arrayService,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
        }
    }
    
    static func updateShopDetails(_ requestType: String, inputParameter: [String: Any], header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: ResponseStatus, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                if responseMessage == "Updated successfully"{
                    completionHandler(response,responseMessage,.success,nil)
                }else{
                    completionHandler(response,nil,.failed,error)
                }
                
            }else{
                print(error ?? "")
                completionHandler(response,nil,status,error)
            }
        }
        
    }
    
    
    
    static func rateBarber(_ requestType: String, inputParameter: [String: Any], header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: Int?, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if statusCode == 200{
                 completionHandler(response,"Success",statusCode,nil)
            }else{
                
                print(error ?? "")
                completionHandler(response,nil,statusCode,error)
            }
        }
        
    }
    
    
    
    static func contactShop(_ requestType: String, inputParameter: [String: Any], header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: ResponseStatus, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,.success,nil)
                
            }else{
                completionHandler(response,nil,status,error)
            }
        }
        
    }
    
    
    static func getAllEventsAndAppointment(_ requestType: String, inputParameter: [String: Any]?, header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: EventsAppointmentBO?, _ status: ResponseStatus, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if let eventsData = response?["data"] as? [String: Any] {
                
                //if let arrayAppointment = event
                let eventsModal = EventsAppointmentBO(dictionary: eventsData as NSDictionary)
                completionHandler(response,eventsModal,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }

        }
        
    }
    
    static func getAllShopsEvent(_ requestType: String, inputParameter: [String: Any]?, header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ arrayAppointments: [ShopsEventBO]?, _ arrayEvents: [EventsBO]?,  _ status: ResponseStatus, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            var arrayAppointment = [ShopsEventBO]()
            var arrayEvents = [EventsBO]()
            if let eventsData = response?["data"] as? [String: Any] {

                if let appointmentData = eventsData["appointment"] as? [Any]{
               
                    arrayAppointment = ShopsEventBO.modelsFromDictionaryArray(array: appointmentData as NSArray)
                }
                
                if let eventsData = eventsData["events"] as? [Any]{
                    
                    arrayEvents = EventsBO.modelsFromDictionaryArray(array: eventsData as NSArray)
                }
                
                completionHandler(response, arrayAppointment, arrayEvents, status, error)
               
            }
            else {
                
                completionHandler(response, nil, nil, status, error)
            }
            
        }
        
    }
    
    
    

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    static func deletAnEvent(_ requestType: String, inputParameter: [String: Any]?, header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: ResponseStatus, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.DELETE, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if let responseDict = response?["data"] as? [String: Any] {
                
                completionHandler(response, responseDict["msg"] as? String, status, error)
                
            }
            else {
                completionHandler(response, nil, status, error)
            }
            
        }
        
    }
    
    
    
    static func getAllBarber(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlString: String, completionHandler: @escaping ([BarberListBO]?, NSError?) -> Void){
        
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
                            var tempArray = [BarberListBO]()
                            
                            tempArray =  BarberListBO.modelsFromDictionaryArray(array: arrayValue as NSArray)
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
            completionHandler(nil, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    
    static func deleteFavoriteBarber(_ requestType: String, inputParameters: [String: Any]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: Int?, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.DELETE, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            
            if statusCode == 200{
                 completionHandler(response,"Success",statusCode,error)
            }else{
                completionHandler(response,"Fail",statusCode,error)
            }
            
        }
    }
    
    
    
    
    
    static func barberHOMEAPI(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlString: String, completionHandler: @escaping (AppointmentInfoBO?, [AssociatedShopsBO]?, [BRD_ServicesBO]?,RevenueBO?,Bool, NSError?) -> Void){
        
        let comunicationManager = BRD_CommunicationManager()
        comunicationManager.getRequestUsingDictionaryParameters("GET", urlComponent: urlString, inputParameters: inputParameters, header: header, completion: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    
                    print(statusCode)
                    
                    
                    if statusCode == 402{
                        
                        NotificationCenter.default.post(name: Notification.Name("SubcriptionExpire"), object: nil)
                        
                        
                    }
                    
                    
                    if statusCode == 200{
                        
                        let json = try JSONSerialization.jsonObject(with: result, options: .mutableContainers) as? [String:Any]
                        
                        var theDicAppointment : AppointmentInfoBO? = nil
                        var associatedShops = [AssociatedShopsBO]()
                        var services = [BRD_ServicesBO]()
                        var revenue : RevenueBO!
                        
                        if let dictAppointment = dict["appointment"] as? [String: Any]{
                            
                            if dictAppointment.keys.count > 0{
                                 theDicAppointment = AppointmentInfoBO.init(dictionary: dictAppointment as NSDictionary)
                            }
                           
                        }
                        
                        if let arrayShops = dict["associateShops"] as? [Any]{
                            
                         associatedShops = AssociatedShopsBO.modelsFromDictionaryArray(array: arrayShops as NSArray)
                        }
                        
                        if let arrayServices = dict["services"] as? [Any]{
                            services = BRD_ServicesBO.modelsFromDictionaryArray(array: arrayServices as NSArray)
                        }
                        if let dictRevenue = dict["revenue"] as? [String: Any]{
                            revenue = RevenueBO.init(dictionary: dictRevenue as NSDictionary)
                        }
                        
                        let isBarberOnline = dict["is_online"] as? Bool ?? false
                        completionHandler(theDicAppointment, associatedShops,services,revenue, isBarberOnline,nil)
                    }else{
                        let errorMessage = BRD_CommunicationManager.getError(result as AnyObject?)
                        completionHandler(nil,nil,nil,nil,false, errorMessage)
                    }
                }
                catch {
                    print("catch")
                    completionHandler(nil,nil, nil,nil,false, BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
            completionHandler(nil,nil, nil,nil, false, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    static func barberWentOnline(_ requestType: String, inputParameter: [String: Any], header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: Int, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,statusCode!,nil)
            }else{
                print(error ?? "")
                completionHandler(response,nil,statusCode!,error)
            }
        }
        
    }
    
    
    static func barberGoOffline(_ requestType: String, inputParameter: [String: Any]?, header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: Int, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,statusCode!,nil)
            }else{
                print(error ?? "")
                completionHandler(response,nil,statusCode!,error)
            }
        }
        
    }
    
    
    
    static func customerNewRequest(_ requestType: String, inputParameter: [String: Any], header: [String: String], urlString: String, completionHandler: @escaping(_ response: AppointmentInfoBO?, _ responseMessage: String?, _ status: Int?, _ error: Error?) -> Void){
        
        let comunicationManager = BRD_CommunicationManager()
        
        comunicationManager.postRequestUsingDictionaryParameters("POST", urlComponent: urlString, inputParameters: inputParameter, headers: header, completionHandler: { (result, httpResponse) in
        
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        let theDicAppointment = AppointmentInfoBO.init(dictionary: dict["data"] as! NSDictionary)
                        
                        completionHandler(theDicAppointment, "OK",statusCode,nil)
                    }else{
                        let errorMessage = BRD_CommunicationManager.getError(result as AnyObject?)
                        completionHandler(nil,nil,statusCode,errorMessage)
                    }
                }
                catch {
                    print("catch")
                    completionHandler(nil,nil,Int(httpResponse.statusCode), BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
            completionHandler(nil,nil,400, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    static func barberAcceptRequest(_ requestType: String, inputParameter: [String: Any]?, header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: Int?, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.PUT, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,statusCode,nil)
            }else{
                print(error ?? "")
                
                completionHandler(response, "Server Error",statusCode,error)
            }
        }
        
    }
    
    
    
    static func updateSubcribePlantoTheServer(_ requestType: String, inputParameter: [String: Any]?, header: [String: String], urlString: String, completionHandler: @escaping(_ response: [String: Any]?, _ responseMessage: String?, _ status: Int?, _ error: Error?) -> Void){
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameter, false, header) { (response, status, error, statusCode) in
            
            print(response ?? "No Response")
            if let responseMessage = response?["msg"] as? String {
                completionHandler(response,responseMessage,statusCode,nil)
            }else{
                print(error ?? "")
                
                completionHandler(response, "Server Error",statusCode,error)
            }
        }
        
    }
    
    static func getAllShops(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlString: String, completionHandler: @escaping ([BRD_UserProfileBO]?, NSError?) -> Void){
        
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
                            var tempArray = [BRD_UserProfileBO]()
                            
                            tempArray =  BRD_UserProfileBO.modelsFromDictionaryArray(array: arrayValue as NSArray)
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
            completionHandler(nil, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    
    static func searchAllShop(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlString: String, completionHandler: @escaping ([SearchShopsBO]?, NSError?) -> Void){
        
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
                            var tempArray = [SearchShopsBO]()
                            
                            tempArray =  SearchShopsBO.modelsFromDictionaryArray(array: arrayValue as NSArray)
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
            completionHandler(nil, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    
    static func getAppointmentDetail(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlString: String, completionHandler: @escaping ([AppointmentCompletedBO]?,BarberConfirmAppointmentBO?, NSError?) -> Void){
        
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
                            var tempArrayCompleted = [AppointmentCompletedBO]()
                            var tempArrayConfirm = [ConfirmAppointmentBO]()
                            var confirmAppointment: BarberConfirmAppointmentBO? = nil
                            if let arrayCompleted = dataDictionary["complete"] as? [Any]{
                                tempArrayCompleted =  AppointmentCompletedBO.modelsFromDictionaryArray(array: arrayCompleted as NSArray)
                               
                            }
                            
                            if let arrayConfirm = dataDictionary["confirm"] as? [Any]{
                                tempArrayConfirm =  ConfirmAppointmentBO.modelsFromDictionaryArray(array: arrayConfirm as NSArray)
                                
                                if tempArrayConfirm.count > 0 {
                                    
                                    let objConAppo = tempArrayConfirm[0]
                                    
                                    confirmAppointment = BarberConfirmAppointmentBO.init()
                                    
                                    confirmAppointment?.appointmentInfo?.barber_id = objConAppo.barber_id?._id
                                    confirmAppointment?.appointmentInfo?.customer_id = objConAppo.customer_id?._id
                                    
                                    confirmAppointment?.barberInfo?.first_name = objConAppo.barber_id?.first_name
                                    confirmAppointment?.barberInfo?.last_name = objConAppo.barber_id?.first_name
                                    confirmAppointment?.barberInfo?.picture = objConAppo.barber_id?.picture
                                    confirmAppointment?.barberInfo?.barber_services = objConAppo.barber_id?.barber_services
                                    confirmAppointment?.barberInfo?.barber_shops_latLong = objConAppo.barber_id?.barber_shops_latLong
                                    confirmAppointment?.barberInfo?.ratings = objConAppo.barber_id?.ratings
                                    confirmAppointment?.barberInfo?.rating_score = objConAppo.barber_id?.rating_score
                                    
                                    confirmAppointment?.customer_lat_long = objConAppo.customer_id?.latLong
                                    
                                    confirmAppointment?.appointmentInfo?._id = objConAppo._id
                                    confirmAppointment?.appointmentInfo?.__v = objConAppo.__v
                                    confirmAppointment?.appointmentInfo?.appointment_date = objConAppo.appointment_date
                                    confirmAppointment?.appointmentInfo?.totalPrice = objConAppo.totalPrice
                                    confirmAppointment?.appointmentInfo?.shop_id = objConAppo.shop_id
                                    confirmAppointment?.appointmentInfo?.services = objConAppo.services
                                    
                                    if let arrayLatLong = objConAppo.shop_id?.latLong{
                                        BRDSingleton.sharedInstane.barberShopLatLong = arrayLatLong
                                    }
                                    
                                    
//
                                    
                                    var address = ""
                                    if let shopName = objConAppo.shop_id?.name{
                                        address = shopName + "\n"
                                    }
                                    if let shopDetails = objConAppo.shop_id?.address {
                                        address = address + shopDetails + ", \n"
                                    }
                                    if let city = objConAppo.shop_id?.city {
                                        address = address + city + ", "
                                    }
                                    if let state = objConAppo.shop_id?.state {
                                        address = address + state + " "
                                    }
                                    if let zipCode = objConAppo.shop_id?.zip {
                                        address = address + zipCode
                                    }
                                    BRDSingleton.sharedInstane.fullShopAddress = address
                                    
                                    
                                    var countVal: Float = 0.0
                                    for temp in (confirmAppointment?.barberInfo?.ratings)!{
                                        let ratObj = temp as BRD_RatingsBO
                                        countVal = countVal + ratObj.score!
                                    }
                                    let meanVal: Float = countVal / Float((confirmAppointment?.barberInfo?.ratings?.count)!)
                                    confirmAppointment?.barberInfo?.rating_score = Double(meanVal)
                                        
//                                        String(format: "%.01f", meanVal)
                                    


                                }
                            }
                            
                             completionHandler(tempArrayCompleted,confirmAppointment,nil)
                            
                        }else{
                            
                            print("Invalid Response")
                            completionHandler(nil,nil, BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                        }
                    }else{
                        let errorMessage = BRD_CommunicationManager.getError(result as AnyObject?)
                        completionHandler(nil,nil, errorMessage)
                    }
                }
                catch {
                    print("catch")
                    completionHandler(nil,nil, BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
            completionHandler(nil,nil, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    static func makeChairAsDefault(_ requestType: String, inputParameters: [String: Any]!, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ status: Int?, _ error: Error? ) -> Void) {
        
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if  statusCode == 200{
                
                completionHandler(response,"Success",statusCode,error)
            }
            else {
                completionHandler(response,nil,statusCode,error)
            }
            
        }
        
    }
    
    
    
    static func deleteAssociatedShop(_ requestType: String, inputParameters: [String: Any]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ statusCode: Int?, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.DELETE, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if statusCode == 200 {
                completionHandler(response,"Success",statusCode,error)
            }else{
                completionHandler(response,nil,statusCode,error)
            }
        }
    }
    
    
    static func addANewShop(_ requestType: String, inputParameter: [String: Any], header: [String: String], urlString: String, completionHandler: @escaping(_ response: Any?, _ responseMessage: String?, _ status: Int?, _ error: Error?) -> Void){
        
        let comunicationManager = BRD_CommunicationManager()
        
        comunicationManager.postRequestUsingDictionaryParameters("POST", urlComponent: urlString, inputParameters: inputParameter, headers: header, completionHandler: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        
                        completionHandler(dict, "OK",statusCode,nil)
                    }else{
                        let errorMessage = BRD_CommunicationManager.getError(result as AnyObject?)
                        completionHandler(nil,nil,statusCode,errorMessage)
                    }
                }
                catch {
                    print("catch")
                    completionHandler(nil,nil,Int(httpResponse.statusCode), BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
            completionHandler(nil,nil,400, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    
    static func getAllState(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?, urlString: String, completionHandler: @escaping ([StatesBO]?, NSError?) -> Void){
        
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
                            
                            
                           let arrayState = StatesBO.modelsFromDictionaryArray(array: arrayValue as NSArray)
                            completionHandler(arrayState,nil)
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
            completionHandler(nil, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    static func customerSendMessageToBarber(_ requestType: String, inputParameters: [String: Any], header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ statusCode: Int?, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.POST, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            
            if statusCode == 200{
                completionHandler(response,"Success",statusCode,error)
            }else{
                completionHandler(response,nil,statusCode,error)
            }
        }
    }
    
    
    static func inviteToBarbrDo(_ requestType: String, inputParameters: [String: Any], header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ statusCode: Int?, _ error: Error? ) -> Void) {
    
        let comunicationManager = BRD_CommunicationManager()
        
        comunicationManager.postRequestUsingDictionaryParameters("POST", urlComponent: urlString, inputParameters: inputParameters, headers: header, completionHandler: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        completionHandler(dict, "OK",statusCode,nil)
                    }else{
                        let errorMessage = BRD_CommunicationManager.getError(result as AnyObject?)
                        completionHandler(nil,nil,statusCode,errorMessage)
                    }
                }
                catch {
                    print("catch")
                    completionHandler(nil,nil,Int(httpResponse.statusCode), BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
            completionHandler(nil,nil,400, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
    }
    
    
    
    
    static func fetchGoogleDirection(_ requestType: String, inputParameter: [String: Any]?, header: [String: String]?, urlString: String, completionHandler: @escaping(_ response: AppointmentInfoBO?, _ responseMessage: String?, _ status: Int?, _ error: Error?) -> Void){
        
        let comunicationManager = BRD_CommunicationManager()
        
        comunicationManager.postRequestUsingDictionaryParameters("POST", urlComponent: urlString, inputParameters: inputParameter!, headers: header!, completionHandler: { (result, httpResponse) in
            
            DispatchQueue.main.async(execute: {
                do {
                    let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
                    print(dict)
                    let statusCode: Int = httpResponse.statusCode
                    if statusCode == 200{
                        
                        let theDicAppointment = AppointmentInfoBO.init(dictionary: dict["data"] as! NSDictionary)
                        
                        completionHandler(theDicAppointment, "OK",statusCode,nil)
                    }else{
                        let errorMessage = BRD_CommunicationManager.getError(result as AnyObject?)
                        completionHandler(nil,nil,statusCode,errorMessage)
                    }
                }
                catch {
                    print("catch")
                    completionHandler(nil,nil,Int(httpResponse.statusCode), BRD_CommunicationManager.getError("Invalid Response" as AnyObject))
                }
            })
        }) { (error) in
            completionHandler(nil,nil,400, BRD_CommunicationManager.getError("Not Reachable" as AnyObject))
            
            print("Not Reachable")
        }
        
    }
    
    
    //MARK- Google Adddress fetching
   static func googleAddressFromAPI(googleAPIKey: String,inputText: String, completionHandler:@escaping (_ success:Bool, _ response: String) -> Void){
        let apiString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&key=\(googleAPIKey)&components=country:us&input=\(inputText)"
    
     let comunicationManager = BRD_CommunicationManager()
        comunicationManager.GET(api:apiString as NSString, queryString: "", sync: false) { (sucess, response) in
            completionHandler(sucess, response)
        }
    }
    //MARK- latLongfrom Goofle API
   static func latLongFromGooglAPI(googleAPIKey: String,placeId: String, completionHandler:@escaping (_ success:Bool, _ response: String) -> Void){
        let apiString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(googleAPIKey)"
    
        let comunicationManager = BRD_CommunicationManager()

        comunicationManager.GET(api:apiString as NSString, queryString: "", sync: false) { (sucess, response) in
            completionHandler(sucess, response)
        }
        
    }
   static func getResponseDictionary(_ responseData:Data) -> NSDictionary? {
        do {
            if let responseDictionary: NSDictionary = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary
            {
                return responseDictionary
            }
        } catch let error as NSError {
         
            
        }
        
        return nil
    }

    
    static func getStaticMaps(_ requestType: String, inputParameters: [String: Any]?, header: [String: String]?,urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ shops: String?, _ statusCode: Int?, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            
            if statusCode == 200{
                completionHandler(response,"Success",statusCode,error)
            }else{
                completionHandler(response,nil,statusCode,error)
            }
        }
    }
    
    
    
    
    static func getSubscriptionPlans(_ requestType: String, inputParameters: [String: String]?, header: [String: String],urlString: String, completionHandler: @escaping(_ response: [String: Any]?,_ plans: [ServerPlans]?, _ status: ResponseStatus, _ error: Error? ) -> Void) {
        
        ConnectionManager.shared.sendRequest(.GET, urlString, inputParameters, false, header) { (response, status, error, statusCode) in
            print(response ?? "No Response")
            if let barberServices = response?["data"] as? [Any] {
                print(barberServices)
                var arrayPlans = [ServerPlans]()
                for obj in barberServices{
                    let service = ServerPlans(dictionary: obj as! NSDictionary)
                    arrayPlans.append(service!)
                }
                completionHandler(response,arrayPlans,.success,error)
            }
            else {
                completionHandler(response,nil,status,error)
            }
            
        }
        
    }
    
    
}
