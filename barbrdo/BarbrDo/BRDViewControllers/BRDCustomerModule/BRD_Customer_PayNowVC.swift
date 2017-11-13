//
//  BRD_Customer_PayNowVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 19/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import Stripe
import SwiftLoader

let KBRD_Customer_PayNowVC_StoryboardID = "BRD_Customer_PayNowVC_storyboardID"

class BRD_Customer_PayNowVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var txtFullName: BRD_TextField!
    @IBOutlet weak var txtCardNumber: BRD_TextField!
    @IBOutlet weak var txtMonthYear: BRD_TextField!
    @IBOutlet weak var txtCVV: BRD_TextField!
    
    @IBOutlet weak var btnAgreeWithTermsAndCondition: UIButton!
    var fullInfo : BRD_AppointmentsInfoBO? 
    var appointmentFlag : Bool? = false
    var serviceArray : NSMutableArray = NSMutableArray()
    var totalAmount: String? = nil
    var shopDetail: BRD_ShopDataBO? = nil
    var barberDetails: BRD_BarberInfoBO? = nil
    var payLaterFlag : Bool? = false
    var appointmentId : String? = ""
    var appointmentDate : String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let header = Bundle.main.loadNibNamed(String(describing: BRD_TopBar.self), owner: self, options: nil)![0] as? BRD_TopBar
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.btnProfile.addTarget(self, action: #selector(btnProfileAction), for: .touchUpInside)
        self.viewNavigationBar.addSubview(header!)
        
        if self.totalAmount != nil{
            self.lblAmount.text = self.totalAmount!
        }
        
        print(self.shopDetail)
        print(self.barberDetails)
        
        
        self.txtFullName.addImage(name: "ICON_USERNAME_GREY")
        self.txtCardNumber.addImage(name: "ICON_CARDNUMBER_GREY")
        self.txtMonthYear.addImage(name: "ICON_MONTHYEAR_GREY")
        self.txtCVV.addImage(name: "ICON_CVV_GREY")
    }

    
    func btnProfileAction() {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAgreeWithTermsAndConditionAction(sender: UIButton){
    
        sender.isSelected = !sender.isSelected
    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.characters.count == 0 {
            return true
        }
      
        switch textField {
        case self.txtFullName:
            if self.txtFullName.text?.characters.count == 25{
                textField.deleteBackward()
                return false
            }
            break
        case self.txtCardNumber:
//            if self.txtCardNumber.text?.characters.count == 16{
//                textField.deleteBackward()
//                return false
//            }
            
            if range.location == 19 {
                return false
            }
            // Backspace
            if string.characters.count == 0 {
                return true
            }
            if (range.location == 4) || (range.location == 9) || (range.location == 14) {
                let str: String = "\(String(describing: textField.text!))-"
                textField.text = str
            }
            return true
            break
        case self.txtCVV:
            if (self.txtCVV.text?.characters.count)! > 2{
                textField.deleteBackward()
                }
            break
        case self.txtMonthYear:
            if(textField == self.txtMonthYear)
            {
                //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
                if range.length > 0
                {
                    return true
                }
                
                //Dont allow empty strings
                if string == " "
                {
                    return false
                }
                
                //Check for max length including the spacers we added
                if range.location >= 5
                {
                    return false
                }
                
                var originalText = textField.text
                let replacementText = string.replacingOccurrences(of: " ", with: "")
                
                //Verify entered text is a numeric value
                let digits = NSCharacterSet.decimalDigits
                for char in replacementText.unicodeScalars
                {
                    if !digits.contains(char)
                    {
                        return false
                    }
                }
                
                //Put / space after 2 digit
                if range.location == 2
                {
                    originalText?.append("/")
                    textField.text = originalText
                }
                return true
            }
            
            // SPECIAL CHARACTER VALIDATION
            if string.rangeOfCharacter(from: KCharacterset.inverted) != nil
            {
                return false
            }
            break
            
        default:
            break
        }
        
        return true
    }
    
    func checkMaxLength(_ textField: UITextField!, maxLength: Int) {
        if (textField.text!.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    @IBAction func btnPayNowAction(sender: UIButton!){
        


        let isFormValid = self.validateCreditCard()
        
        if isFormValid != "true"{
            // Show Alert
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: isFormValid, onViewController: self, returnBlock: { (clickedIN) in
                
            })
            return
        }else
        {
            
            if btnAgreeWithTermsAndCondition.isSelected == false{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please agree to the terms and condition", onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                
                return
            }
            SwiftLoader.show(KLoading, animated: true)

            var stripCard = STPCard()
            
            // Split the expiration date to extract Month & Year
            if self.txtMonthYear.text!.isEmpty == false {
                
                let expirationDate = self.txtMonthYear.text!.components(separatedBy: ("/"))
                let expMonth = UInt(expirationDate[0])
                let expYear = UInt(expirationDate[1])
                
                // Send the card info to Strip to get the token
                
                let creditcardNumber = self.txtCardNumber.text?.replacingOccurrences(of: "-", with: "")
                stripCard.number = creditcardNumber
                stripCard.cvc = self.txtCVV.text
                stripCard.expMonth = expMonth!
                stripCard.expYear = expYear!
                stripCard.name = self.txtFullName.text
            }
            
            //        let underlyingError: NSError?
            //        if underlyingError != nil {
            //            self.spinner.stopAnimating()
            //            self.handleError(underlyingError!)
            //            return
            //        }
            
            
            STPAPIClient.shared().createToken(withCard: stripCard, completion: { (token, error) -> Void in
                
                if error != nil {
                    self.handleError(error! as NSError)
                    return
                }
                print("tokkkkk -- \(token!)")
                
                let stripeToken = "\(token!)"
                
                self.payNow(stripeToken)
                
                
                //            self.postStripeToken(token!)
            })

//            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Payment Done", onViewController: self, returnBlock: { (clickedIN) in
//                
//            })
        }
    }
    
    
    func payNow(_ token : String)
    
    {
        
        
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        
        if(self.appointmentFlag == true)
        {
            
            if let obj = self.barberDetails
            {
                

                
                let amount = self.totalAmount?.replacingOccurrences(of: "$ ", with: "")
                
              let appointmentDate = self.appointmentDate

                let userId = (BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id)!
                
                let  chair_id = obj.chair_id
                let chair_name = obj.chair_name
                
                let chair_type = obj.chair_type
                let chair_amount = obj.chair_amount
                let chair_shop_percentage = obj.chair_shop_percentage == nil ? 0 : obj.chair_shop_percentage!
                let chair_barber_percentage = obj.chair_barber_percentage == nil ? 0 : obj.chair_barber_percentage!
                
                
                let shop_id = obj.shop_id == nil ? BRDSingleton.sharedInstane.objShop_id : obj.shop_id
                
                
                let inputParameters = ["shop_id": shop_id!,
                                       "barber_id": obj._id!,
                                       "amount": amount! , "payment_method" : "card" , "services":  self.serviceArray ,"appointment_date" : appointmentDate , "token" : token as AnyObject , "user_id" : userId , "totalPrice" : amount! , "chair_id" : chair_id! , "chair_name" : chair_name! , "chair_type" : chair_type! , "chair_amount" : chair_amount == nil ? "" : chair_amount! , "chair_shop_percentage" : chair_shop_percentage  , "chair_barber_percentage" : chair_barber_percentage   ] as [String: Any]
                print(inputParameters)
                let urlString = KBaseURLString + KPostCustomerCharges
                
                print(urlString)
                BRDAPI.confirmAppointmentDetail("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                    SwiftLoader.hide()
                    
                    if let serverMessage = responseMessage {
                        
                        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_AppointmentDetail_StoryboardID) as! BRD_Customer_AppointmentDetail
                        vc.objAppointment = serverMessage as? BRD_AppointmentsInfoBO
                        self.navigationController?.pushViewController(vc, animated: true)                        // SUCCESS CASE

                        
                    }
                    else{
                         SwiftLoader.hide()
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                    
                    
                    if error != nil{
                         SwiftLoader.hide()
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                            
                        })
                        return
                    }
                }
            }

        }
            
        
        
        else if (self.payLaterFlag == true)
        {
            
               //
                let amount = self.totalAmount?.replacingOccurrences(of: "$ ", with: "")
                let appointmentDate1 =  Date.convert(self.appointmentDate!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
            
                let appointment_id = self.appointmentId
                
                let inputParameters = ["appointmentId" : appointment_id == nil ? "" : appointment_id!,
                                       
                                       "amount": amount! , "date" : appointmentDate1 == "" ? self.appointmentDate! : appointmentDate1, "token" : token as AnyObject ,"payment_method" : "cash"  ] as [String: Any]
                print(inputParameters)
                let urlString = KBaseURLString + KPayAfterAppointment
                
                print(urlString)
                BRDAPI.confirmAppointmentDetail("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                    SwiftLoader.hide()
                    
                    if let serverMessage = responseMessage {
//                        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_AppointmentDetail_StoryboardID) as! BRD_Customer_AppointmentDetail
//                          vc.objAppointment = serverMessage as? BRD_AppointmentsInfoBO
                   _   = self.navigationController?.popToRootViewController(animated: true)
                        
                        // SUCCESS CASE
                        //                            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: serverMessage , onViewController: self, returnBlock: { (clickedIN) in
                        //                            })
                        
                    }
                    else{
                         SwiftLoader.hide()
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                    
                    
                    if error != nil{
                         SwiftLoader.hide()
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                            
                        })
                        return
                    }
                }
            }

        
            
        else
        {
        if let obj = self.fullInfo
        {
        
            if(obj.services != nil)
            {
           
                
        for obj1 in obj.services!
        {
            let dic = NSMutableDictionary()
            dic.setValue(obj1.id, forKey: "id")
            dic.setValue(obj1.name, forKey: "name")
            dic.setValue(obj1.price, forKey: "price")
            self.serviceArray.add(dic)
        }


                
            }
            
            let amount = self.totalAmount?.replacingOccurrences(of: "$ ", with: "")
            
            let appointmentDate =  Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.yyyy_MM_dd_HH_mm_ss)
            let userId = (BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id)!
            
           let  chair_id = obj.chair_id
           let chair_name = obj.chair_name

             let chair_type = obj.chair_type
           let chair_amount = obj.chair_amount
           let chair_shop_percentage = obj.chair_shop_percentage
           let chair_barber_percentage = obj.chair_barber_percentage
            
                
                let inputParameters = ["shop_id": obj.shop_id!._id!,
                                       "barber_id": obj.barber_id!._id!,
                                       "amount": amount! , "payment_method" : "card" , "services":  self.serviceArray ,"appointment_date" : appointmentDate , "token" : token as AnyObject , "user_id" : userId , "totalPrice" : amount! , "chair_id" : chair_id! , "chair_name" : chair_name! , "chair_type" : chair_type! , "chair_amount" : chair_amount == nil ? "" : chair_amount! , "chair_shop_percentage" : chair_shop_percentage == nil ? "" : chair_shop_percentage! , "chair_barber_percentage" : chair_barber_percentage == nil ? "" : chair_barber_percentage!   ] as [String: Any]
                print(inputParameters)
                let urlString = KBaseURLString + KPostCustomerCharges
                
                print(urlString)
                BRDAPI.confirmAppointmentDetail("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                    SwiftLoader.hide()
                    
                    if let serverMessage = responseMessage {
                        
                         SwiftLoader.hide()
                        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_AppointmentDetail_StoryboardID) as! BRD_Customer_AppointmentDetail
                        vc.objAppointment = serverMessage as? BRD_AppointmentsInfoBO
                        self.navigationController?.pushViewController(vc, animated: true)                            // SUCCESS CASE
//                            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: serverMessage , onViewController: self, returnBlock: { (clickedIN) in
//                            })
                        
                    }
                    else{
                         SwiftLoader.hide()
                        if let serverMessage = reponse?["msg"]  {
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: serverMessage as! String, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                        }
                    }
                    
                    
                    if error != nil{
                         SwiftLoader.hide()
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                            
                        })
                        return
                    }
                }
            }
            }
        

       
        
    }
    
    
    
    func handleError(_ error: NSError) {
        
                    _ = BRDAlertManager.showOKAlert(withTitle: "Please Try Again", withMessage: error.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
        
                    })

        
    }
    
    
    

    private func validateCreditCard() -> String{
        var alertString = "Please enter valid"
        
        if self.txtFullName.text == "" {
            alertString = alertString + BRDRawStaticStrings.KNextLine + "Full Name"
        }
        
        if self.txtCardNumber.text == ""{
            alertString = alertString + BRDRawStaticStrings.KNextLine + "Car Number"
        }
        
        if self.txtMonthYear.text == ""{
            alertString = alertString + BRDRawStaticStrings.KNextLine + "Month and Year"
        }
        if self.txtCVV.text == ""{
            alertString = alertString + BRDRawStaticStrings.KNextLine + "CVV Number"
        }
        
        if alertString == "Please enter valid"{
            return "true"
        }
        return alertString

    }
    

}


