//
//  BRD_LoginVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 01/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftLoader
import CoreLocation

let KBRD_LoginVC_StoryboardID = "BRD_LoginVC_StoryboardID"

private enum LoginScreenButtons: Int{
    
    case btnBack = 101
    case btnFacebook
    case btnLogin
    case btnForgotPassword
    case btnSignUp
}
class LoginCell:UITableViewCell
{
    
    @IBOutlet weak var fieldIconImage: UIImageView!
    @IBOutlet weak var cellTextField: UITextField!
    override func awakeFromNib() {
        
    }
}
class BRD_LoginVC: BRD_BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var tableViewLogin: UITableView!
    
    var objBRDLoginInfoData : BRD_UserInfoBO? = BRD_UserInfoBO()
    var userName        : String = ""
    var password        : String = ""
    var placeholderArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        // Do any additional setup after loading the view.
        
        self.initialize()
        self.tableViewLogin.tableFooterView = UIView()
        
//        SwiftLoader.show("Fetching User Location", animated: true)
//        BRD_LocationManager.sharedLocationManger.delegate = nil
//        
//        BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
//        BRD_LocationManager.sharedLocationManger.delegate = self
    }
    func initialize () {
        
        self.placeholderArray = ["Email Address","Password"]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func btnFacebookTapped() {
        
        FB.doFBLogin(completionHandler: { (success, fbUserObject) -> Void in
            //SwiftLoader.hide()
            if success {
                
                UserDefaults.standard.set(false, forKey: "isNormalLogin")
                
                if let data = (fbUserObject as? [String: AnyObject]){
                    let obj = BRD_FacebookDetailsBO.init()
                    obj.initWithDictionary(dictionary: data)
                    self.checkFBLogin(objFacebook: obj)
                }
            }
        })
    }
    
    func checkFBLogin(objFacebook: BRD_FacebookDetailsBO)  {
        
        
        let dictionary: [String: String] = ["facebook_id": objFacebook.id!]
        let headers = BRDSingleton.sharedInstane.getLatitudeLongitude()
        
        BRD_UserInfoBOBL.initWithFacebook("POST", urlComponent: "checkFaceBook", inputParameters: dictionary, headers: headers!, completionHandler: { (obj, error) in
            
            self.hideLoader()
            if let objUser = obj , error == nil {
                
                print(objUser)
                // Check Who's login
                
                var userType: Int = 1
                if obj?.user_type == UserType.Customer.rawValue{
                    userType = 1
                }else if obj?.user_type == UserType.Barber.rawValue{
                    userType = 2
                }else if obj?.user_type == UserType.Shop.rawValue{
                    userType = 3
                }
                
                // Login Successful
                // Save Data in User Defaults
                BRDSingleton.sharedInstane.objBRD_UserInfoBO = objUser
                BRDSingleton.sharedInstane.objBRD_UserInfoBO?.deviceID = BRDSingleton.sharedInstane.deviceUDID
                let data = NSKeyedArchiver.archivedData(withRootObject: objUser)
                UserDefaults.standard.set(data, forKey: BRDRawStaticStrings.kUserData)
                
                
                
                self.checkUserTypeAndNavigate(userType: userType)
                
                // Move to Dashboard Screen
//                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//                appDelegate.setupLeftMenu(userType: userType)
//                let storyboard = UIStoryboard(name:"Customer", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_DashboardVC_StoryboardID) as! BRD_Customer_DashboardVC
//                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                if let error = error {
                    
                    print(error.localizedDescription)
                    
                    if error.localizedDescription == "This user not found in database"{
                        
                        self.navigateToRegisterScreen(obj: objFacebook)
                    }else{
                        // Write Code for Error Handling
                        _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                    self.hideLoader()
                    return
                }
            }
        })
    }
    
    
    func checkUserTypeAndNavigate(userType: Int){
        if userType == 1{
            
            // Move to Dashboard Screen
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.setupLeftMenu(userType: userType)
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_DashboardVC_StoryboardID) as! BRD_Customer_DashboardVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if userType == 2{
            
            //ove to Dashboard Screen
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.setupLeftMenu(userType: userType)
            let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BarberDashboardVC") as! BarberDashboardVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        // For Shop......
        if userType == 3{
            
            //ove to Dashboard Screen
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.setupLeftMenu(userType: userType)
            let storyboard = UIStoryboard(name:shopStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_DashboardVC_StoryboardID) as! BRD_Shop_DashboardVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func loginScreenButtonActions(_ sender: UIButton) {
        
        switch BRD_LocationManager.sharedLocationManger.autorizationStatus {
            
        case .notDetermined, .restricted, .denied, .restricted:
            
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
            
            return
        default:
            break
        }
        
        
        
        switch sender.tag {
            
        case LoginScreenButtons.btnBack.rawValue:
            self.navigationController?.popViewController(animated: true)
            break
        case LoginScreenButtons.btnFacebook.rawValue:
            //SwiftLoader.show(KLoading, animated: true)
            self.btnFacebookTapped()
            break
        case LoginScreenButtons.btnLogin.rawValue:
            
            // UI Validation
            let str = self.validateAllFields()
            if str != "Please fill in:"{
                
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: str, onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }
            
            if BRDSingleton.sharedInstane.latitude == nil || BRDSingleton.sharedInstane.longitude == nil{
                self.checkLocationServices()
            }
            
            let inputParameters = ["email": userName,
                                   "password": password,
                                   "device_id": BRDSingleton.sharedInstane.deviceUDID]
            UserDefaults.standard.set(userName, forKey: KEmail)
            UserDefaults.standard.set(password, forKey: KPassword)
              UserDefaults.standard.synchronize()
            let headers = BRDSingleton.sharedInstane.getLatitudeLongitude()
            if headers == nil{
                self.hideLoader()
                
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
                    BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
                })

                return
            }
            
            self.showLoader(message: "Signing in...")

            BRD_UserInfoBOBL.initWithFacebook("POST", urlComponent: KLoginURL, inputParameters: inputParameters, headers: headers!, completionHandler: { (obj, error) in
                
                self.hideLoader()
                if let objUser = obj , error == nil {
                    
                    // Check Who's login
                    
                    var userType: Int = 0
                    
                    if objUser.user_type == UserType.Customer.rawValue{
                        userType = 1
                        // Move to Dashboard Screen
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        appDelegate.setupLeftMenu(userType: userType)
                        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "CustomerDashboardVC") as! CustomerDashboardVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    if objUser.user_type == UserType.Barber.rawValue{
                        userType = 2
                        
                        //ove to Dashboard Screen
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        appDelegate.setupLeftMenu(userType: userType)
                        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "BarberDashboardVC") as! BarberDashboardVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        /*
                        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "BarberSubscriptionVC") as! BarberSubscriptionVC
                        self.present(vc, animated: true, completion: nil)*/
                    }
                    // For Shop......
                    if objUser.user_type == UserType.Shop.rawValue{
                        userType = 3
                        
                        //ove to Dashboard Screen
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        appDelegate.setupLeftMenu(userType: userType)
                        let storyboard = UIStoryboard(name:shopStoryboard, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_DashboardVC_StoryboardID) as! BRD_Shop_DashboardVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                    // Login Successful
                    
                    // Save Data in User Defaults
                    BRDSingleton.sharedInstane.objBRD_UserInfoBO = objUser
                    BRDSingleton.sharedInstane.objBRD_UserInfoBO?.password = self.password
                    
                    let data = NSKeyedArchiver.archivedData(withRootObject: objUser)
                    UserDefaults.standard.set(data, forKey: BRDRawStaticStrings.kUserData)
                } else {
                    if let error = error {
                        // Write Code for Error Handling
                        _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                        self.hideLoader()
                        return
                    }
                }
            })
            break
        case LoginScreenButtons.btnForgotPassword.rawValue:
            
            var objVC: UIViewController? = nil
            if let viewControllers = navigationController?.viewControllers {
                for viewController in viewControllers {
                    // some process
                    if viewController .isKind(of: BRD_ForgotPasswordVC.self) {
                        objVC = viewController
                        break
                    }
                }
            }
            if objVC != nil{
                self.navigationController?.popToRootViewController(animated: (objVC != nil))
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: KBRD_ForgotPasswordVC_StoryboardID) as! BRD_ForgotPasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            break
        case LoginScreenButtons.btnSignUp.rawValue:
            
            self.navigateToRegisterScreen(obj: nil)
            break
        default:
            break
        }
    }
    
    
    func navigateToRegisterScreen(obj: BRD_FacebookDetailsBO?){
        
        var objVC: UIViewController? = nil
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                // some process
                if viewController .isKind(of: BRD_RegisterVC.self) {
                    objVC = viewController
                    break
                }
            }
        }
        if objVC != nil{
            self.navigationController?.popToViewController(objVC!, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: KBRD_RegisterVC_StoryboardID) as! BRD_RegisterVC
            
            if obj != nil{
                vc.objFacebook = obj
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: Textfield Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 0 :
            self.userName = textField.text!
            break
        case 1:
            self.password = textField.text!
        default:
            
            break
        }
    }
    
    
    //MARK:- UITableView DataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.placeholderArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "logincell", for: indexPath as IndexPath) as! LoginCell
        cell.backgroundColor  = UIColor.clear
        cell.cellTextField.tag = indexPath.row
        cell.cellTextField.tintColor = UIColor.lightGray
        cell.cellTextField.attributedPlaceholder = NSAttributedString(string: self.placeholderArray[indexPath.row] as! String,attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        
        cell.cellTextField.autocorrectionType = .no
        switch indexPath.row {
        case 0:
            cell.cellTextField.keyboardType = .emailAddress
            cell.fieldIconImage.image = UIImage(named:"ICON_USERNAME")
        case 1:
            cell.cellTextField.autocapitalizationType = .words
            cell.cellTextField.isSecureTextEntry = true
            cell.fieldIconImage.image = UIImage(named:"ICON_PASSWORD")
        default: break
            
        }
        return cell
    }
    
    
    func validateAllFields() -> String{
        var alertMessage = "Please fill in:"
        
        if userName == ""
        {
            alertMessage = alertMessage + BRDRawStaticStrings.KNextLine + "Username"
        }else{
            let obj = BRDRawStaticStrings.isValidEmail(testStr: userName)
            
            if obj == false{
                alertMessage = alertMessage + BRDRawStaticStrings.KNextLine + "valid email address"
            }
        }
        if password == ""
        {
            alertMessage = alertMessage + BRDRawStaticStrings.KNextLine + "Password"
        }
        return alertMessage
    }
}

extension BRD_LoginVC: BRD_LocationManagerProtocol{
    
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
        
        self.present(alertController, animated: true, completion: nil)
        
    }

}

