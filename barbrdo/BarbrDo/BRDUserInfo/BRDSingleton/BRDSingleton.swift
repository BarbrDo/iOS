//
//  BRDSingleton.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 08/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class BRDSingleton: NSObject {
    
    
    var isUpComing: Bool? = true
    
    static let sharedInstane = BRDSingleton()
    var objBarberdetailInfo: [BRD_BarberInfoBO]? = nil

    var latitude: String? = nil //"40.749485"
    var longitude: String? = nil //"-73.991769"
    
//    var latitude: String? = "40.749485"
//    var longitude: String? = "-73.991769"
    
    var objBRD_UserInfoBO: BRD_UserInfoBO? = nil
    var objManageRequestInfo : [ManageRequestInfo]? = nil
    var objShopChairInfo : [ShopChairInfo]? = nil
    var objBarberInfo: BRD_UserInfoBO? = nil
    var objShop_id : String? = ""
    var objShopInfo : BRD_ShopDataBO? = nil
    var objAppointmentDetail : BRD_AppointmentsInfoBO? = nil
    var totalCuts : Int? = 0
    
    var location: [CLLocation]? = nil
    var imagePath: String? = nil
    var deviceUDID: String = ""
    
    var indexPathForEvent: IndexPath? = nil
    var calendarDate: String? = nil
    
    var token: String? = nil
    
    var shopName: String? = nil
    
    var barberShopLatLong = [Double]()
    
    var isFirstTime: Bool? = true
    
    var shopNameAndDistance: String? = nil
    var fullShopAddress: String? = nil
    
    var barberImage: UIImage? = nil
    var barberImageString: String? = nil
    var customerImage: UIImage? = nil
    var customerImageString: String? = nil
    
    open func getLatitudeLongitude() -> [String: String]?{
        
//        if latitude != nil &&
//            latitude != "0.0"{
//            self.latitude = String(describing: (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.latitude)!)
//        }else{
//            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
//        }
        
        print("*****    Latitude: \(self.latitude)")
        print("*****    Longitude \(self.longitude)")
        
        
        if UserDefaults.standard.object(forKey: "CurrentLocation") != nil{
            
            if let arr = UserDefaults.standard.object(forKey: "CurrentLocation") as? [Any]{
                
                if arr.count == 2{
                    self.latitude = String(describing: arr[0])
                    self.longitude = String(describing: arr[1])
                }
            }
            
        }
        
        
//            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
//        }

//        if self.latitude == nil || self.longitude == nil{
//            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
//        }
        // US Lat long
        var headerDict: [String: String]? = nil
        
//         headerDict = [KLatitude: "40.749485",
//                       KLongitude: "-73.991769",
//                       KDeviceType: KiOS,
//                       KDeviceID: self.deviceUDID]
//        return headerDict
        
        
        if latitude != nil && longitude != nil{
            var accessToken: String = KBearer
            if BRDSingleton.sharedInstane.token != nil{
                accessToken = KBearer + BRDSingleton.sharedInstane.token!
            }
            
            headerDict = [KLatitude: latitude!,
                          KLongitude: longitude!,
                          KDeviceType: KiOS,
                          KDeviceID: self.deviceUDID,
                          KAuthorization: accessToken ]
        }else{
            // IN case of Simulator
           // headerDict = ["device_latitude": "40.658801", "device_longitude": "-74.1063776"]
            
            // IN case of delivery
            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
            headerDict = nil
        }
        
        print(headerDict)
        return headerDict
    }
    
    open func getHeaders() -> [String: String]?{
        
        
        
        print("*****    Latitude: \(self.latitude)")
        print("*****    Longitude \(self.longitude)")
        
        if BRDSingleton.sharedInstane.objBRD_UserInfoBO == nil{
            return nil
        }
//        {
//            if BRDSingleton.sharedInstane.objBRD_UserInfoBO?.latitude != nil &&
//                BRDSingleton.sharedInstane.objBRD_UserInfoBO?.latitude != 0.0{
//                self.latitude = String(describing: (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.latitude)!)
//            }else{
//                BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
//            }
//
//            if BRDSingleton.sharedInstane.objBRD_UserInfoBO?.longitude != nil && BRDSingleton.sharedInstane.objBRD_UserInfoBO?.latitude != 0.0{
//                self.longitude = String(describing: (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.longitude)!)    
//            }else{
//                BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
//            }
//            
//        }
        
        
        if UserDefaults.standard.object(forKey: "CurrentLocation") != nil{
            
            if let arr = UserDefaults.standard.object(forKey: "CurrentLocation") as? [Any]{
            
                if arr.count == 2{
                    self.latitude = String(describing: arr[0])
                    self.longitude = String(describing: arr[1])
                }
            }
            
        }
//        if self.latitude == nil || self.longitude == nil{
//            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
//        }
        
        
       // US Lat Long
//        let headerDict: [String: String] = ["device_latitude": "40.749485", "device_longitude": "-73.991769"]
//        return headerDict
        
       print(self.deviceUDID)
        var headerDict: [String: String]? = nil
        let objUser : BRD_UserInfoBO =  BRDSingleton.sharedInstane.objBRD_UserInfoBO!
        
        //if objUser == nil { return }
        if latitude != nil && longitude != nil{
            
        headerDict = [KLatitude: latitude!,
                      KLongitude: longitude!,
                      KUserID: (objUser._id)!,
                      KDeviceType: KiOS,
                        KUserType: (objUser.user_type)!,
                      KDeviceID: self.deviceUDID,
                      KAuthorization: KBearer + BRDSingleton.sharedInstane.token!]
            
        }else{
            // IN case of Simulator
            //headerDict = ["device_latitude": "30.538994", "device_longitude": "30.538994"]
            
            // IN case of delivery
            headerDict = nil
        }
        
        
//        headerDict = [KLatitude: "40.749485",
//                      KLongitude: "-73.991769",
//                      KUserID: objUser._id!,
//                      KDeviceType: KiOS,
//                      KUserType: objUser.user_type!,
//                      KDeviceID: self.deviceUDID,                      
//                      KAuthorization: KBearer + BRDSingleton.sharedInstane.token!]
        
        
        print(headerDict)
        return headerDict
 
 
    }

    
    func displayLoader(viewController: UIViewController, message: String? = nil){
        
        let spinnerActivity = MBProgressHUD.showAdded(to: viewController.view, animated: true)
        spinnerActivity.mode = MBProgressHUDMode.indeterminate
        spinnerActivity.label.text = message
    }
    func dismissLoader(viewController: UIViewController){
        MBProgressHUD.hide(for: viewController.view, animated: true)
        
        
    }
    
    class func removeEmptyMessage(_ view:AnyObject)
    {
        if let control = view.viewWithTag(1000000) {
            control.removeFromSuperview()
        }
    }
    class func showEmptyMessage(_ message:String,view:AnyObject)->UILabel
    {
        if let control = view.viewWithTag(1000000) {
            control.removeFromSuperview()
        }
        
//        let label = UILabel(frame: CGRect(x: view.bounds.size.width/2-125, y: view.bounds.size.height/2-21, width: 250, height: 21))
        let label = UILabel(frame: CGRect(x: view.bounds.size.width/2-125, y: 100, width: 250, height: 21))

        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 20.0) // AppFont.Regular
        label.tag = 1000000
        label.textColor = UIColor.gray // APPCOLOR.Gray.Dark
        label.text = message
        return label
    }
    
    class func getMobileNumber(_ mobileNumber: String) -> String {
        var mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        return mobileNumber
    }
    
    class func getStringLength(_ mobileNumber: String) -> Int {
        var mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        let length = Int(mobileNumber.characters.count )
        return length
    }
    
    class func formatStringintoMobileNumber(_ mobileNumber: String) -> String {
        var  mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        print("\(mobileNumber)")
        
        let strMobileNumber : NSString = (mobileNumber as? NSString)!
        let length = Int(mobileNumber.characters.count )
        if length > 10 {
            mobileNumber = (strMobileNumber.substring(from: length - 10))
            print("\(mobileNumber)")
        }
        return mobileNumber
    }
    
    class func resizingCapturedImage(CapturedImage image : UIImage) -> UIImage {
        
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = 736.0
        let maxWidth: Float = 414.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.50
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData: Data = UIImageJPEGRepresentation(img, CGFloat(compressionQuality))!
        UIGraphicsEndImageContext()
        return UIImage.init(data: imageData)!
        
    }

}
