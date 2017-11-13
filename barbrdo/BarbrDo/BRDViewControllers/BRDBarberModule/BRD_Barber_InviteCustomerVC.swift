//
//  BRD_Barber_InviteCustomerVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/18/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
let KBRD_Barber_InviteCustomerVC_StoryboardID = "BRD_Barber_InviteCustomerVC_StoryboardID"

class BRD_Barber_InviteCustomerVC: BRD_BaseViewController {
    
    @IBOutlet weak var txtEmailAddress: BRD_TextField!
    @IBOutlet weak var txtMobileNumber: BRD_TextField!
    
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    var detectUserInput = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.addTopNavigationBar(title: "Invite Customer to BarbrDo")
        
        self.txtEmailAddress.addImage(name: "ICON_USERNAME_GREY")
        self.txtMobileNumber.addImage(name: "TelephoneGrey")
        self.whiteBackgroundView.layer.cornerRadius = 4.0
        self.whiteBackgroundView.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        let header : NavigationBarWithTitleAndBack = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitleAndBack.self), owner: self, options: nil)![0] as! NavigationBarWithTitleAndBack
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.btnProfile.addTarget(self, action: #selector(btnProfileMenu), for: .touchUpInside)
        header.initWithTitle(title: "Invite Barber to BarbrDo")
        header.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        self.view.addSubview(header)
        
    }
    func btnBackAction(){
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnProfileMenu(){
        
        let storyboard = UIStoryboard(name:"Barber", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_Profile_StoryboardID) as! BRD_Barber_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sumbitButtonAction(_ sender: Any) {
       
        var alertMessage: String = ""
        
        if (self.txtEmailAddress.text?.isEmpty)! && (self.txtMobileNumber.text?.isEmpty)!{
             alertMessage = "Please enter email address or mobile number"
        }else if (self.txtEmailAddress.text?.characters.count)! > 0{
            if BRDRawStaticStrings.isValidEmail(testStr: self.txtEmailAddress.text!){
                
//                let urlString = "mailto:" + self.txtEmailAddress.text!
//                let url = URL(string:urlString)
//                UIApplication.shared.openURL(url!)

                self.referYourApp(key: "referee_email", value: self.txtEmailAddress.text!)
                return
            }else{
                alertMessage = "Please enter valid email address"
            }
        }else if self.txtMobileNumber.text?.characters.count == 14{
            alertMessage = "Invite request sent"
            
//            let number = "sms:" + BRDSingleton.getMobileNumber(self.txtMobileNumber.text!)
//            UIApplication.shared.openURL(NSURL(string: number)! as URL)
//            return
            
             self.referYourApp(key: "referee_phone_number", value: BRDSingleton.getMobileNumber(self.txtMobileNumber.text!))
            return
        }else{
            alertMessage = "Please enter valid mobile number"
        }
        
        self.showAlertWithMessage(alertMessage: alertMessage)
    }
    
    func referYourApp(key: String, value : String){
        
        SwiftLoader.show("Sending", animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
        if header ==  nil{return}
        
        if let userInfo = BRDSingleton.sharedInstane.objBRD_UserInfoBO{
            
            let inputParameters = ["invite_as": "barber",
                                   key: value] as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KAppToRefer
            
            print(urlString)
            
            
            BRDAPI.inviteToBarbrDo("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if status == 200 {
                    
                    self.txtEmailAddress.text = ""
                    self.txtMobileNumber.text = ""
                    
                    // SUCCESS CASE
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Invite Sent Successfully", onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in})
                }
            }
        }
    }
    
    private func showAlertWithMessage(alertMessage: String){
        _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: alertMessage, onViewController: self, returnBlock: { (clickedIN) in
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
}

extension BRD_Barber_InviteCustomerVC: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtEmailAddress{
            
            self.txtMobileNumber.text = ""
            
            let strMesage = textField.text! + string
            
            if strMesage.characters.count == 1 && string == "" || strMesage.characters.count == 0{
                self.btnSubmit.backgroundColor = UIColor.darkGray
            }else{
               self.btnSubmit.backgroundColor = kNavigationBarColor
            }
        }
        
        if textField == self.txtMobileNumber{
            
            self.txtEmailAddress.text = ""
            
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
            let strMesage = textField.text! + string
            
            if strMesage.characters.count == 1 && string == "" || strMesage.characters.count == 0{
                self.btnSubmit.backgroundColor = UIColor.darkGray
            }else{
                self.btnSubmit.backgroundColor = kNavigationBarColor
            }
        }
        return true
    }
}
