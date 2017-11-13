






//
//  AppDelegate.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 01/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SideMenu
import FBSDKCoreKit
import IQKeyboardManagerSwift
import GoogleMaps
import UserNotifications
import Stripe
import Firebase
import UserNotificationsUI
import AVFoundation
import SwiftLoader

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var player: AVAudioPlayer?
    var isFirstTime: Bool? = true
    var badgeCount: Int = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // Override point for customization after application launch.
        UserDefaults.standard.removeObject (forKey: "ShopDashboard")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_fswpUdU8DBIKbLz1U637jNF7"
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = KStatusBarColor
        }
        
        
        BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
        BRD_LocationManager.sharedLocationManger.delegate = self
        UIApplication.shared.statusBarStyle = .lightContent
        GMSServices.provideAPIKey(KGoogleMaps)
        
        IQKeyboardManager.sharedManager().enable = true
        self.checkIfAlreadyLogin()
        
        if #available(iOS 10, *) {
            
            //Notifications get posted to the function (delegate):  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)"
            
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                
                guard error == nil else {
                    //Display Error.. Handle Error.. etc..
                    return
                }
                
                if granted {
                    //Do stuff here..
                    
                    //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
                    application.registerForRemoteNotifications()
                }
                else {
                    //Handle user denying permissions..
                    /*
 
                     Still we are at login screen so no need to handle else block
                     */
                }
            }
            
            //Register for remote notifications.. If permission above is NOT granted, all notifications are delivered silently to AppDelegate.
            application.registerForRemoteNotifications()
        }
        else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        //self.setBadgeIndicator(badgeCount: 0)
         FirebaseApp.configure()
       
        
//        var numberOfBadges = application.applicationIconBadgeNumber
//        numberOfBadges = 0
//        application.applicationIconBadgeNumber = numberOfBadges

        
        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
            
            print("Went to this method")
            
            let badgeCount: Int = UIApplication.shared.applicationIconBadgeNumber
            
            print(badgeCount)
        }
        return true
    }
    
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
    }
    
 
    
  
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
  {
       
        playSound()
        print("Notification Data--\(userInfo)")

        if let notificationName = userInfo["messageFrom"] as? AnyHashable{
         
            let notName = String(describing: notificationName)
            print(notName)
            if notName == KCustomerRequestToBarber{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KCustomerRequestToBarber), object: userInfo)
            }
            else if notName == KBarberConfirmAppointment{
              
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KBarberConfirmAppointment), object: userInfo)
            }
            else if notName == KBarberCancelAppointment{
               
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KBarberDeclineRequest), object: userInfo)
            }else if notName == KBarberCompletedAppointment{
               
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KBarberCompletedAppointment), object: userInfo)
            }else if notName == KCustomerCancelAppointmentNot{
                
                // This notification will go to barber
                // to hide the loader
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KCustomerCancelAppointmentNot), object: userInfo)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KReloadAgain), object: userInfo)
                
            }else if notName == KMessageToCustomer{
                // Show notification to customer
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KMessageToCustomer), object: userInfo)
            }
            else if notName == KMessageToBarber{
                // SHow Notification to Barber
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KMessageToBarber), object: userInfo)
            }
           
        }
//        if let aps = userInfo["aps"] as? NSDictionary {
//            if let alert = aps["alert"] as? NSDictionary {
//                if let message = alert["message"] as? NSString {
//                    
//                    let alert = UIAlertController(title: "Alert", message: userInfo.description, preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//                    //Do stuff
//                    
//                }
//            } else if let alert = aps["alert"] as? NSString {
//                //Do stuff
//            }
//        }
    
    UIApplication.shared.applicationIconBadgeNumber = 0

    
    
    }
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
    }
    func setBadgeIndicator(badgeCount:Int)
    {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
        }
        else{
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()
        //application.applicationIconBadgeNumber = badgeCount
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        BRDSingleton.sharedInstane.deviceUDID = deviceTokenString
        
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
        UserDefaults.standard.synchronize()
        
    }
    

    
    func setupLeftMenu(userType: Int) {
        if userType == 1{
            
            let storyboard = UIStoryboard(name: customerStoryboard, bundle: nil)
             let rootViewController = storyboard.instantiateViewController(withIdentifier: "CustomerDashboardVC") as! CustomerDashboardVC
            let navCon = UINavigationController(rootViewController: rootViewController)
            self.window?.rootViewController = navCon
        }
        if userType == 2{
            let storyboard = UIStoryboard(name: barberStoryboard, bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "BarberDashboardVC") as! BarberDashboardVC
            let navCon = UINavigationController(rootViewController: rootViewController)
            self.window?.rootViewController = navCon
        }
        if userType == 3{
            let storyboard = UIStoryboard(name: shopStoryboard, bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_DashboardVC_StoryboardID) as! BRD_Shop_DashboardVC
            let navCon = UINavigationController(rootViewController: rootViewController)
            self.window?.rootViewController = navCon
        }
        
       
        
    }
    
    func logout(){
        
        let data = NSKeyedArchiver.archivedData(withRootObject: "")
        UserDefaults.standard.set(data, forKey: BRDRawStaticStrings.kUserData)
        UserDefaults.standard.removeObject (forKey: "ShopDashboard")

        let storyboard = UIStoryboard(name: loginStoryboard, bundle: nil)
        let landingScreen = storyboard.instantiateViewController(withIdentifier: KBRD_LandingVC_StoryboardID) as! BRD_LandingVC
        let navCon = UINavigationController(rootViewController: landingScreen)
        self.window?.rootViewController = navCon
        
        let url = KBaseURLString + kLogOut
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{return}
        BRDAPI.logout("GET", inputParameters: nil, header: header!, urlString: url) { (response, arrayServices, status, error) in
            print(response)
        }

        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        var numberOfBadges = application.applicationIconBadgeNumber
//        numberOfBadges = 0
//        application.applicationIconBadgeNumber = numberOfBadges

        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
        BRD_LocationManager.sharedLocationManger.delegate = self
        
        BRDSingleton.sharedInstane.deviceUDID = UserDefaults.standard.string(forKey: "deviceToken")!
        
        print(BRDSingleton.sharedInstane.deviceUDID)
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

//        FBSDKAppEvents.activateApp()
        
//        if #available(iOS 10.0, *) {
//            let center = UNUserNotificationCenter.current()
//            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
//            center.removeAllDeliveredNotifications() // To remove all delivered notifications
//        } else {
//            UIApplication.shared.cancelAllLocalNotifications()
//        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        //let badgeCount: Int = UIApplication.shared.applicationIconBadgeNumber
        
        //print(badgeCount)


    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkIfAlreadyLogin() {
        
        if UserDefaults.standard.string(forKey: "deviceToken") != nil{
            BRDSingleton.sharedInstane.deviceUDID = UserDefaults.standard.string(forKey: "deviceToken")!
        }
        
        
        print(BRDSingleton.sharedInstane.deviceUDID)
        
        
        if let data = UserDefaults.standard.object(forKey: BRDRawStaticStrings.kUserData) as? NSData {
            
            if (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? BRD_UserInfoBO) != nil{
                
                var userType: Int = 1
                
                if let obj = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? BRD_UserInfoBO{
                    BRDSingleton.sharedInstane.objBRD_UserInfoBO = obj
                    BRDSingleton.sharedInstane.token = obj.token
                    BRDSingleton.sharedInstane.deviceUDID =   BRDSingleton.sharedInstane.deviceUDID
                    
                    
                    if obj.user_type == UserType.Customer.rawValue{
                        userType = 1
                    }
                    if obj.user_type == UserType.Barber.rawValue{
                        userType = 2
                    }
                    if obj.user_type == UserType.Shop.rawValue{
                        userType = 3
                    }
                }
                if let savedValue = UserDefaults.standard.string(forKey: "serverPath") {
                    BRDSingleton.sharedInstane.imagePath = savedValue
                    
                }
                self.setupLeftMenu(userType: userType)
            }
        }
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Accept", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension AppDelegate: BRD_LocationManagerProtocol{
    
    //MARK: ASLocation Manager Delegate Methods
    
    func didUpdateLocation(location:CLLocation) {
        
        SwiftLoader.hide()
        
    }
    
    func denyUpdateLocation(){
        
        SwiftLoader.hide()
        
        let alertController = UIAlertController(
            title: KAlertTitle,
            message: "BarbrDo want to access your location, please open this app's settings and set location access to 'Always'.",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url as URL)
            }
        }
        alertController.addAction(openAction)
        
        //self.present(alertController, animated: true, completion: nil)
        
    }
    
}
