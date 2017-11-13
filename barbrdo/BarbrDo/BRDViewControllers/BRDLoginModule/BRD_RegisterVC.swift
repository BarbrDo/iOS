

//
//  BRD_RegisterVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 01/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation


let KBRD_RegisterVC_StoryboardID = "BRD_RegisterVC_StoryboardID"

private enum RegisterScreenButtons: Int{
    
    case btnBack = 101
    case btnCustomer
    case btnBarber
    case btnBarberShop
    case btnSignUp
    case btnAlreadyHaveaAccount
    
}
class SignupCell:UITableViewCell
{
    
    @IBOutlet weak var viewPasswordConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtlicenseNumber: UITextField!
    
    @IBOutlet weak var iconLicenseNumber: UIImageView!
    @IBOutlet weak var lblLine: UILabel!
    
    @IBOutlet weak var iconPassword: UIImageView!
    @IBOutlet weak var iconConfirmPassword: UIImageView!
    
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    
    
    
//    @IBOutlet weak var fieldIconImage: UIImageView!
//    
//    @IBOutlet weak var cellTextField: UITextField!
    override func awakeFromNib() {
        
        
        self.txtFirstName.attributedPlaceholder = NSAttributedString(string: "First Name",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.txtLastName.attributedPlaceholder = NSAttributedString(string: "Last Name",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.txtMobileNumber.attributedPlaceholder = NSAttributedString(string: "Mobile Number",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.txtlicenseNumber.attributedPlaceholder = NSAttributedString(string: "License Number",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
    }
    
}

class BRD_RegisterVC: BRD_BaseViewController {
    
    

    @IBOutlet weak var btnCustomer: UIButton!
    @IBOutlet weak var btnBarber: UIButton!
    @IBOutlet weak var btnBarberShop: UIButton!
    var firstName       : String = BRDRawStaticStrings.KEmptyString
    var lastName        : String = BRDRawStaticStrings.KEmptyString
    var emailID         : String = BRDRawStaticStrings.KEmptyString
    var password        : String = BRDRawStaticStrings.KEmptyString
    var confirmPassword : String = BRDRawStaticStrings.KEmptyString
    var mobileNo        : String = BRDRawStaticStrings.KEmptyString
    var customerType    : String = BRDRawStaticStrings.KEmptyString
    var licenseNumber   : String = BRDRawStaticStrings.KEmptyString
    var placeholderArray = NSMutableArray()
    @IBOutlet weak var tableViewSignup: UITableView!
    
    var objFacebook: BRD_FacebookDetailsBO?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.RegisterScreenButtonAction(self.btnCustomer)

        self.initialize()
        self.tableViewSignup.tableFooterView = UIView()
        
        
        if objFacebook != nil{
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.tableViewSignup.cellForRow(at: indexPath) as? SignupCell

            
            if let fName = objFacebook?.fname {
                cell?.txtFirstName.text = fName
            }
            if let lName = objFacebook?.lname {
                cell?.txtLastName.text = lName
            }
            if let email = objFacebook?.email {
                cell?.txtEmail.text = email
            }
            if let phone = objFacebook?.mobileNumber {
                cell?.txtMobileNumber.text = phone
            }
        }
        
        
        self.tableViewSignup.reloadData()
        
        BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
       
    }
    func initialize () {
        
        self.placeholderArray = ["First Name","Last Name","Email Address","Password","Confirm Password","Mobile Number"]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.objFacebook = nil
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func RegisterScreenButtonAction(_ sender: UIButton) {
        
        switch sender.tag {
        case RegisterScreenButtons.btnBack.rawValue:
            self.navigationController?.popViewController(animated: true)
            break
        case RegisterScreenButtons.btnCustomer.rawValue:
            if self.btnCustomer.isSelected == true{return}
            
            sender.isSelected = !sender.isSelected
            self.btnBarber.isSelected = false
            self.btnBarberShop.isSelected = false
            // @paritosh
            self.btnCustomer.setTitleColor(.white, for: .normal)
            self.btnBarber.setTitleColor(.lightGray, for: .normal)
            self.btnBarberShop.setTitleColor(.lightGray, for: .normal)
            
            self.customerType = UserType.Customer.rawValue
            
            if self.placeholderArray.count == 7{
                self.placeholderArray.removeLastObject()
                self.tableViewSignup.reloadData()
            }
            break
        case RegisterScreenButtons.btnBarber.rawValue:
            
            if self.btnBarber.isSelected == true{return}
            
            sender.isSelected = !sender.isSelected
            self.btnCustomer.isSelected = false
            self.btnBarberShop.isSelected = false
            // @paritosh
            self.btnBarber.setTitleColor(.white, for: .normal)
            self.btnCustomer.setTitleColor(.lightGray, for: .normal)
            self.btnBarberShop.setTitleColor(.lightGray, for: .normal)
            self.customerType = UserType.Barber.rawValue
            if self.placeholderArray.count == 6{
                self.placeholderArray.add("Barber License Number")
                self.tableViewSignup.reloadData()
            }
            if self.placeholderArray.count == 7{
                self.placeholderArray.removeLastObject()
                self.placeholderArray.add("Barber License Number")
                self.tableViewSignup.reloadData()
            }
            break
        case RegisterScreenButtons.btnBarberShop.rawValue:
            
            if self.btnBarberShop.isSelected == true{return}
            
            sender.isSelected = !sender.isSelected
            self.btnCustomer.isSelected = false
            self.btnBarber.isSelected = false
            // @paritosh
            self.btnBarberShop.setTitleColor(.white, for: .normal)
            self.btnBarber.setTitleColor(.lightGray, for: .normal)
            self.btnCustomer.setTitleColor(.lightGray, for: .normal)
            self.customerType = UserType.Shop.rawValue
            if self.placeholderArray.count == 6{
                self.placeholderArray.add("Shop License Number")
                self.tableViewSignup.reloadData()
            }
            if self.placeholderArray.count == 7{
                self.placeholderArray.removeLastObject()
                self.placeholderArray.add("Shop License Number")
                self.tableViewSignup.reloadData()
            }
            break
            
        case RegisterScreenButtons.btnSignUp.rawValue:
            let isFormValid = self.validateRegisterForm()
            
            if isFormValid != "true"{
                // Show Alert
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: isFormValid, onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }
            
            let headers = BRDSingleton.sharedInstane.getLatitudeLongitude()
            if headers == nil{
                self.hideLoader()
                
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
                    BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
                })
                return
            }
            
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.tableViewSignup.cellForRow(at: indexPath) as? SignupCell
            var fabID: String = ""
            if self.objFacebook != nil{
                fabID = (self.objFacebook?.id)!
            }
            
            self.showLoader(message: "Signing Up...")
            let inputParameters: [String: Any] =
                ["first_name": (cell?.txtFirstName.text)!,
                 "last_name": (cell?.txtLastName.text)!,
                 "email": (cell?.txtEmail.text)!,
                 "password": (cell?.txtPassword.text)!,
                 "mobile_number": BRDSingleton.getMobileNumber((cell?.txtMobileNumber.text)!),
                 "user_type": self.customerType,
                 "facebook": fabID,
                 "license_number":(cell?.txtlicenseNumber.text)!]
            
            
            print(inputParameters)
            
            if fabID == ""{
                
                BRD_UserInfoBOBL.initWithParameters("POST", urlComponent: KSignUpURL, inputParameters: inputParameters, headers: headers!, completionHandler: { (obj, error) in
                    self.hideLoader()
                    if let _ = obj , error == nil {
                        
                        var userType: Int = 0
                        
                        // Login Successful
                        
                        // Save Data in User Defaults
                        
                        BRDSingleton.sharedInstane.objBRD_UserInfoBO = obj
                        BRDSingleton.sharedInstane.objBRD_UserInfoBO?.password = self.password
                        
                        BRDSingleton.sharedInstane.token = obj?.token!
                        let data = NSKeyedArchiver.archivedData(withRootObject: obj)
                        UserDefaults.standard.set(data, forKey: BRDRawStaticStrings.kUserData)
                        
                        
                        if obj?.user_type == UserType.Customer.rawValue{
                            userType = 1
                            // Move to Dashboard Screen
                            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                            appDelegate.setupLeftMenu(userType: userType)
                            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "CustomerDashboardVC") as! CustomerDashboardVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        if obj?.user_type == UserType.Barber.rawValue{
                            userType = 2
                            
                            //ove to Dashboard Screen
                            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                            appDelegate.setupLeftMenu(userType: userType)
                            let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "BarberDashboardVC") as! BarberDashboardVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        // For Shop......
                        if obj?.user_type == UserType.Shop.rawValue{
                            userType = 3
                            
                            //ove to Dashboard Screen
                            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                            appDelegate.setupLeftMenu(userType: userType)
                            let storyboard = UIStoryboard(name:shopStoryboard, bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_DashboardVC_StoryboardID) as! BRD_Shop_DashboardVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        if let error = error {
                            // Write Code for Error Handling
                            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: error.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                                
                            })
                            self.hideLoader()
                            return
                        }
                    }
                })
            }else{
                BRD_UserInfoBOBL.initWithFacebook("POST", urlComponent: KSignUpURL, inputParameters: inputParameters, headers: headers!, completionHandler: { (obj, error) in
                    
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
                            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_DashboardVC_StoryboardID) as! BRD_Customer_DashboardVC
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
                        print(self.password)
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
            }
            
            
            break
        case RegisterScreenButtons.btnAlreadyHaveaAccount.rawValue:
            
            var objVC: UIViewController? = nil
            if let viewControllers = navigationController?.viewControllers {
                for viewController in viewControllers {
                    // some process
                    if viewController .isKind(of: BRD_LandingVC.self) {
                        objVC = viewController
                        
                        break
                    }
                }
            }
            if objVC != nil{
                if let tempOBj = objVC as? BRD_LandingVC{
                    tempOBj.hasComeFromSignUp = true
                    self.navigationController?.popToViewController(tempOBj, animated: false)
                }
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: KBRD_LandingVC_StoryboardID) as! BRD_LandingVC
                vc.hasComeFromSignUp = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        default:
            break
        }
    }
    
    
    func clearAllTextfield(){
        self.firstName = ""
        self.lastName = ""
        self.emailID = ""
        self.password = ""
        self.tableViewSignup.reloadData()
    }

    
    func validateRegisterForm() -> String? {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewSignup.cellForRow(at: indexPath) as? SignupCell
        
        var alertString = "Please enter valid"
        
        if cell?.txtFirstName.text == ""{
            alertString = alertString + BRDRawStaticStrings.KNextLine + "First Name"
        }
        if cell?.txtLastName.text == ""{
            alertString = alertString + BRDRawStaticStrings.KNextLine + "Last Name"
        }
        if cell?.txtEmail.text == "" {
            alertString = alertString + BRDRawStaticStrings.KNextLine + "Email Address"
        }
        
        if cell?.txtEmail.text != ""{
            
            let obj = BRDRawStaticStrings.isValidEmail(testStr: (cell?.txtEmail.text)!)
            if obj == false{
                alertString = alertString + BRDRawStaticStrings.KNextLine + "Email Address"
            }
        }
        
        if objFacebook == nil{
            /* Password and Confirm Password should not be validated when
               facebook ID is coming
            */
            
            if cell?.txtPassword.text == ""{
                alertString = alertString + BRDRawStaticStrings.KNextLine + "Password"
            }
            if cell?.txtPassword.text != ""{
                if (cell?.txtPassword.text?.characters.count)! < 6 || (cell?.txtPassword.text?.characters.count)! > 10{
                    alertString = alertString + BRDRawStaticStrings.KNextLine + "Minimum password length is 6 and maximum length is 10"
                }
            }
            if cell?.txtConfirmPassword.text == ""{
                alertString = alertString + BRDRawStaticStrings.KNextLine + "Confirm Password"
            }
        }
        
        if cell?.txtMobileNumber.text == ""{
            alertString = alertString + BRDRawStaticStrings.KNextLine + "Mobile Number"
        }else{
          if (cell?.txtMobileNumber.text?.characters.count)! < 10 {
                alertString = alertString + BRDRawStaticStrings.KNextLine + "Valid mobile number"
            }
        }
//        if self.customerType == UserType.Barber.rawValue{
//            if cell?.txtlicenseNumber.text == ""{
//                alertString = alertString + BRDRawStaticStrings.KNextLine + "Barber License Number"
//            }
//        }
//        if self.customerType == UserType.Shop.rawValue{
//            if cell?.txtlicenseNumber.text == ""{
//                alertString = alertString + BRDRawStaticStrings.KNextLine + "Shop License Number"
//            }
//        }
        if cell?.txtPassword.text != cell?.txtConfirmPassword.text{
            alertString = alertString  + BRDRawStaticStrings.KNextLine + "Password and confirm password does not match"
        }
        if alertString == "Please enter valid"{
            return "true"
        }
        return alertString
    }
}
extension BRD_RegisterVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    //MARK:- UITableView DataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1 // self.placeholderArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 351
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "signupcell", for: indexPath as IndexPath) as! SignupCell
        
        if self.objFacebook != nil{
            cell.viewPasswordConstraint.constant = 0
            cell.txtPassword.isHidden = true
            cell.txtConfirmPassword.isHidden = true
            cell.iconPassword.isHidden = true
            cell.iconConfirmPassword.isHidden = true
            cell.lblPassword.isHidden = true
            cell.lblConfirmPassword.isHidden = true
        }else{
            
            cell.viewPasswordConstraint.constant = 100.0
            cell.txtPassword.isHidden = false
            cell.txtConfirmPassword.isHidden = false
            
            cell.iconPassword.isHidden = false
            cell.iconConfirmPassword.isHidden = false
            
            cell.lblPassword.isHidden = false
            cell.lblConfirmPassword.isHidden = false
        }
        
        if self.customerType == UserType.Barber.rawValue || self.customerType == UserType.Shop.rawValue{
            cell.iconLicenseNumber.isHidden = false
            cell.lblLine.isHidden = false
            cell.txtlicenseNumber.isHidden = false
        }else{
            cell.iconLicenseNumber.isHidden = true
            cell.lblLine.isHidden = true
            cell.txtlicenseNumber.isHidden = true
        }
        
        return cell
    }
    
    
    //MARK: Textfield Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 0 :
            self.firstName = textField.text!
            break
        case 1 :
            self.lastName = textField.text!
            break
        case 2 :
            self.emailID = textField.text!
            break
        case 3:
            self.password = textField.text!
            break
        case 4:
            self.confirmPassword = textField.text!
            break
        case 5:
            self.mobileNo  = BRDSingleton.getMobileNumber(textField.text!)
            
            if self.customerType == UserType.Barber.rawValue{
                self.tableViewSignup.reloadData()
            }
            break
        case 6:
            self.licenseNumber  = textField.text!
        default:
            break
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Should begin editing called")
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewSignup.cellForRow(at: indexPath) as? SignupCell
        
        if textField == cell?.txtFirstName || textField == cell?.txtLastName{
            if (textField.text!.characters.count > 30) {
                textField.deleteBackward()
            }
        }
        
        if textField == cell?.txtPassword || textField == cell?.txtConfirmPassword{
            if (textField.text!.characters.count > 15) {
                textField.deleteBackward()
            }
        }
        
        if textField == cell?.txtMobileNumber{
            let length = Int(BRDSingleton.getStringLength(textField.text!))
            if length == 10 {
                if range.length == 0 {
                    return false
                }
            }
            if length == 3 {
                let num: NSString = BRDSingleton.formatStringintoMobileNumber(textField.text!) as NSString
                textField.text = "(\(num)) "
                if range.length > 0 {
                    textField.text = num.substring(to: 3)
                }
            }
            else if length == 6 {
                let num: NSString = BRDSingleton.formatStringintoMobileNumber(textField.text!) as NSString
                textField.text = "(\(num.substring(to: 3)))" + " \(num.substring(from: 3))-"
                if range.length > 0 {
                    textField.text = (num.substring(to: 3)) + " \(num.substring(from: 3))"
                }
            }
        }
//        if textField == cell?.txtMobileNumber{
//            if (textField.text!.characters.count > 9) {
//                textField.deleteBackward()
//            }
//            
//        }
        return true
    }
}

extension BRD_RegisterVC: BRD_LocationManagerProtocol{
    
    
    func denyUpdateLocation() {
        
    }

    
    func didUpdateLocation(location: CLLocation) {
        
        print(location)
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        

    }
    func didDenyLocationAuthorization(){
        
    }
    func didFailToGetLocation(){
        
    }
}
