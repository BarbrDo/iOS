//
//  BRD_BaseViewController.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 03/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import MBProgressHUD
import SideMenu

class BRD_BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = kNavigationBarColor
        navigationBarAppearace.barTintColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        
        // Checking for UserType for changing side menu navigation items...
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        if (obj?.user_type == "customer"){
            let storyboard = UIStoryboard(name: "Customer", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_SideMenuVC_StoryboardID) as! BRD_Customer_SideMenuVC
            
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: vc)
            menuLeftNavigationController.leftSide = true
            SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
            SideMenuManager.menuEnableSwipeGestures = false
            //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        if (obj?.user_type == "barber") {
            let storyboard = UIStoryboard(name: "Barber", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_SideMenuVC_StoryboardID) as! BRD_Barber_SideMenuVC
            
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: vc)
            menuLeftNavigationController.leftSide = true
            SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
            SideMenuManager.menuEnableSwipeGestures = false
            //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        if (obj?.user_type == "shop") {
            let storyboard = UIStoryboard(name: "Shop", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_SideMenuVC_StoryboardID) as! BRD_Shop_SideMenuVC
            
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: vc)
            menuLeftNavigationController.leftSide = true
            SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
            SideMenuManager.menuEnableSwipeGestures = false
            //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionExpireNotification(_:)), name: Notification.Name("SubcriptionExpire"), object: nil)
        
        
        // Define identifier
        let notificationName = Notification.Name(KLocationServiceOFF)
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(showLocationAlert), name: notificationName, object: nil)
    }
    
    func showLocationAlert(){
        
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
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    func subscriptionExpireNotification(_ notification: Notification){
        //Take Action on Notification
        
        let storyboard = UIStoryboard(name: barberStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InAppPurchaseVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func addTopNavigationBar(title: String) {
        
        if title == ""{
            
            let header : NavigationBarWithoutTitle = Bundle.main.loadNibNamed(String(describing: NavigationBarWithoutTitle.self), owner: self, options: nil)![0] as! NavigationBarWithoutTitle
            header.btnSideMenu.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
            header.btnProfile.addTarget(self, action: #selector(profileMenu), for: .touchUpInside)
            header.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
           
            self.view.addSubview(header)
        }else{
            
            let header : BRD_NavigationBar = Bundle.main.loadNibNamed(String(describing: BRD_NavigationBar.self), owner: self, options: nil)![0] as! BRD_NavigationBar
            header.btnSideMenu.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
            header.btnProfile.addTarget(self, action: #selector(profileMenu), for: .touchUpInside)
            header.initWithTitle(title: title)
            header.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
            self.view.addSubview(header)
        }
    }

    
    func toggleMenu() {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func profileMenu(){
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        if (obj?.user_type == "customer"){
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as?BRD_Customer_ProfileViewController{
            
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if (obj?.user_type == "barber"){
            let storyboard = UIStoryboard(name:"Barber", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_Profile_StoryboardID) as! BRD_Barber_ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true) }
        if (obj?.user_type == "shop"){
            let storyboard = UIStoryboard(name:"Shop", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_ProfileVC_StoryboardID) as! BRD_Shop_ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    //-----------------------------------------------------//
    //------------ DISPLAY AND HIDE LOADER ----------------//
    //-----------------------------------------------------//
    
    func showLoader(message: String? = nil){
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.mode = MBProgressHUDMode.indeterminate
        
        spinnerActivity.label.text = message
    }
    func hideLoader(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // @vishwajeet
    func errorHandling(_ response: [String: Any]?, _ status: ResponseStatus, _ error: Error?) {
        self.hideLoader()
        switch status {
        case .failed :
            UIAlertController.show(self, KAlertTitle, response?[BRDKey.message] as? String)
        case .serverError :
            if let error = error?.localizedDescription {
                UIAlertController.show(self, KAlertTitle, error)
            }
            else {
                UIAlertController.show(self, KAlertTitle, KServerError)
            }
        case .internetNotAvailable:
            UIAlertController.show(self, KAlertTitle, KInternetConnection)
        case .tokenExpired:
            break
        default:
            break
        }
    }
    
    
    func checkLocationServices(){
        
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
        
        self.present(alertController, animated: true, completion: nil)
    }
}
