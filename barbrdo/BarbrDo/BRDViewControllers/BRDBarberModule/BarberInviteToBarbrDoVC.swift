//
//  BarberInviteToBarbrDoVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 02/09/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KCustomerText = "Invite 10 customers to BarbrDo and when they register, we will email you a $5 amazon gift card as a token of our appreciation."



let KBarberText = "Invite a Barber to Download the BarbrDo app and when they accept their first request we will email you a $5 Amazon Gift Card as a token of our appreciation."

class BarberCellInviteBC: UITableViewCell{
    
    @IBOutlet weak var btnCustomer: UIButton!
    @IBOutlet weak var btnBarber: UIButton!
    
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    
   
    
    override func awakeFromNib() {
        self.btnCustomer.isSelected = true
    }
}

class BarberInviteToBarbrDoVC: BRD_BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var inviteCell: BarberCellInviteBC!
    
    var userType : String = "customer"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header : NavigationBarWithTitleAndBack = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitleAndBack.self), owner: self, options: nil)![0] as! NavigationBarWithTitleAndBack
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.btnProfile.addTarget(self, action: #selector(btnProfileMenu), for: .touchUpInside)
        header.initWithTitle(title: "Invite to BarbrDo")
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

extension BarberInviteToBarbrDoVC: UITableViewDataSource, UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        self.inviteCell = tableView.dequeueReusableCell(withIdentifier: "BarberCellInviteBC", for: indexPath) as? BarberCellInviteBC
        
        self.inviteCell?.btnBarber.addTarget(self, action: #selector(InviteScreenBtnAction(_:)), for: .touchUpInside)
        self.inviteCell?.btnCustomer.addTarget(self, action: #selector(InviteScreenBtnAction(_:)), for: .touchUpInside)
        self.inviteCell?.btnSubmit.addTarget(self, action: #selector(InviteScreenBtnAction(_:)), for: .touchUpInside)
        return self.inviteCell!
    }
    
    @IBAction func InviteScreenBtnAction(_ sender: UIButton){
        
        
        switch sender.tag {
        case 601:
            self.inviteCell.btnCustomer.isSelected = true
            self.inviteCell.btnBarber.isSelected = false
            self.userType = "customer"
            self.inviteCell.lblMessage.text = KCustomerText
            break
        case 602:
            self.inviteCell.btnCustomer.isSelected = false
            self.inviteCell.btnBarber.isSelected = true
            self.userType = "barber"
            self.inviteCell.lblMessage.text = KBarberText
            break
        case 603:
            var alertMessage: String = ""
            
            if (self.inviteCell.txtEmailID.text?.isEmpty)! && (self.inviteCell.txtMobileNumber.text?.isEmpty)!{
                alertMessage = "Please enter email address or mobile number"
            }else if (self.inviteCell.txtEmailID.text?.characters.count)! > 0{
                if BRDRawStaticStrings.isValidEmail(testStr: self.inviteCell.txtEmailID.text!){
                    
                    self.referYourApp(key: "referee_email", value: self.inviteCell.txtEmailID.text!)
                    return
                }else{
                    alertMessage = "Please enter valid email address"
                }
            }else if self.inviteCell.txtMobileNumber.text?.characters.count == 14{
                alertMessage = "Invite request sent"
                
                
                self.referYourApp(key: "referee_phone_number", value: BRDSingleton.getMobileNumber(self.inviteCell.txtMobileNumber.text!))
                return
            }else{
                alertMessage = "Please enter valid mobile number"
            }
            
            self.showAlertWithMessage(alertMessage: alertMessage)
            break
        default:
            break
        }
    }
    
    private func showAlertWithMessage(alertMessage: String){
        _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: alertMessage, onViewController: self, returnBlock: { (clickedIN) in
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
    
    
    func referYourApp(key: String, value : String){
        
        SwiftLoader.show("Sending", animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
        if header ==  nil{return}
        
        if let userInfo = BRDSingleton.sharedInstane.objBRD_UserInfoBO{
            
            let inputParameters = ["invite_as": self.userType,
                                   key: value] as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KAppToRefer
            
            print(urlString)
            
            BRDAPI.inviteToBarbrDo("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if status == 200 {
                    
                    self.inviteCell.txtEmailID.text = ""
                    self.inviteCell.txtMobileNumber.text = ""
                    
                    // SUCCESS CASE
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Invite Sent Successfully", onViewController: self, returnBlock: { (clickedIN) in
                         self.inviteCell.btnSubmit.backgroundColor = UIColor.darkGray
                    })
                }else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in})
                }
            }
        }
    }
}



extension BarberInviteToBarbrDoVC: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.inviteCell.txtEmailID{
            
            self.inviteCell.txtMobileNumber.text = ""
            
            let strMesage = textField.text! + string
            
            if strMesage.characters.count == 1 && string == "" || strMesage.characters.count == 0{
                
                self.inviteCell.btnSubmit.backgroundColor = UIColor.darkGray
            }else{
                self.inviteCell.btnSubmit.backgroundColor = kNavigationBarColor
            }
        }
        
        if textField == self.inviteCell.txtMobileNumber{
            
            self.inviteCell.txtEmailID.text = ""
            
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
                self.inviteCell.btnSubmit.backgroundColor = UIColor.darkGray
            }else{
                self.inviteCell.btnSubmit.backgroundColor = kNavigationBarColor
            }
        }
        return true
    }
}
