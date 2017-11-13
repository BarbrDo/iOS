//
//  BRD_Barber_ServicePriceVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/24/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_Barber_ServicePriceVC_StoryboardID = "BRD_Barber_ServicePriceVC_StoryboardID"
class BRD_Barber_ServicePriceVC: BRD_BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var priceTextField: BRD_TextField!
    @IBOutlet weak var submitButton: UIButton!
    var selectedServiceID: String = ""
    var selectedServicename: String = ""
    var strUpdatePrice: String? = nil
    
    var objBarberService: BRD_ServicesBO? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.initWithTitle(title: KManageMyServices)
        self.view.addSubview(header!)
        
        self.priceTextField.addImage(name: "ICON_DOLLAR")
        self.serviceLbl.text =  "  " + (selectedServicename)
        if self.objBarberService != nil{
            
            let price = String(describing: (self.objBarberService?.price)!)
            self.serviceLbl.text =  "  " + String(describing: (self.objBarberService?.name)!)
            
            self.priceTextField.text = price
            self.priceTextField.becomeFirstResponder()
            
        }else{
            self.submitButton.isUserInteractionEnabled = false
            self.submitButton.backgroundColor = UIColor.gray
        }
        
        
        self.whiteBackgroundView.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.objBarberService = nil
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        

        
        
        
        let inputString  = textField.text! + string
//        if (inputString.characters.count == 4) {
//            return false
//        }
        
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            print("searchText \(string)")
            
            if textField.text?.characters.count == 1{
                self.submitButton.isUserInteractionEnabled = false
                self.submitButton.backgroundColor = UIColor.gray
            }else{
                self.submitButton.isUserInteractionEnabled = true
                self.submitButton.backgroundColor = KAppRedColor
            }
        }else{
            
            self.submitButton.isUserInteractionEnabled = true
            self.submitButton.backgroundColor = KAppRedColor
        }
        
        
            var maxLength : Int = 0
            let currentString: NSString = textField.text! as NSString
            
            if currentString.contains(".") {
                maxLength = 6
            }
            else{
                maxLength = 3
            }
            
            if string == "." && !currentString.contains(".") {
                maxLength = 6
            }
            
            if string == "." && currentString.contains(".") {
                return false
            }
            
            if currentString.contains(".") {
                
                let arrayOfString : [String] = currentString.components(separatedBy: ".")
                print(arrayOfString)
                let str : String =  arrayOfString[1] // arrayOfString .object(at: 1) as! String
                if str.characters.count == 2 {
                    if string == "" {
                        return true
                    }  else{
                        return false
                    }
                }
            }
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == BRDRawStaticStrings.KEmptyString{
            textField.resignFirstResponder()
        }
        
        
        var value = self.priceTextField.text!
        
        if !(value.contains(".")){
            value = value + ".00"
        }
        else{
            let array = value.components(separatedBy: ".")
            let stri = array[1]
            if stri.characters.count == 1 {
                value = value + "0"
            }
            else if stri.characters.count == 0 {
                value = value + "00"
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if ((textField.text?.characters.count)! > 0){
        //        self.submitButton.isUserInteractionEnabled = true
        //        self.submitButton.backgroundColor = UIColor.red
        //        }
        //        if ((textField.text?.characters.count) == 0){
        //            self.submitButton.isUserInteractionEnabled = false
        //            self.submitButton.backgroundColor = UIColor.gray
        //        }
        
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        
        if self.objBarberService == nil{
            self.addServices()
        }else{
            self.updateService()
        }
    }
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func updateService(){
        
        let latitude = BRDSingleton.sharedInstane.latitude
        let longitude = BRDSingleton.sharedInstane.longitude
        
        if latitude == nil || latitude == ""{return}
        
        
        SwiftLoader.show(KUpdatingPrice, animated: true)
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        let header: [String: String] =
            [ KLatitude: latitude!,
              KLongitude: longitude!,
              KUserID: (obj?._id)!,
              KBarberServiceID: (self.objBarberService?.service_id)!]
        
        print(header)
        
        let inputParameters = ["price": self.priceTextField.text!] as [String: Any]
        print(inputParameters)
        let urlString = KBaseURLString + kAddService + "/" + (self.objBarberService?.service_id)!
        
        print(urlString)
        BRDAPI.updateService("PUT", inputParameters: inputParameters, header: header, urlString: urlString) { (reponse, responseMessage, status, error) in
            SwiftLoader.hide()
            
            if let serverMessage = responseMessage {
                if serverMessage == "Updated successfully"{
                    
                    // SUCCESS CASE
                    _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Service Successfully updated", onViewController: self, returnBlock: { (clickedIN) in
                        var objVC: UIViewController? = nil
                        if let viewControllers = self.navigationController?.viewControllers {
                            for viewController in viewControllers {
                                // some process
                                if viewController .isKind(of: BRD_Barber_ManageServiceVC.self) {
                                    objVC = viewController
                                    break
                                }
                            }
                        }
                        if objVC != nil{
                            self.navigationController?.popToViewController(objVC!, animated: true)
                        }else{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: KBRD_Barber_ManageServiceVC_StoryboardID) as! BRD_Barber_ManageServiceVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                }
            }
            else{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
            
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
        
    }
    
    @objc private func addServices(){
        
        SwiftLoader.show("Adding a Barber Service...", animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }

        
        let inputParameters = ["service_id": selectedServiceID,
                               "name": selectedServicename,
                               "price": self.priceTextField.text!] as [String: Any]
        
        let urlString = KBaseURLString + kAddService
        
        BRDAPI.addService("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseMessage, status, error) in
            
            SwiftLoader.hide()
            if let serverMessage = responseMessage {
                
                // SUCCESS CASE
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: serverMessage, onViewController: self, returnBlock: { (clickedIN) in
                    var objVC: UIViewController? = nil
                    if let viewControllers = self.navigationController?.viewControllers {
                        for viewController in viewControllers {
                            // some process
                            if viewController .isKind(of: BRD_Barber_ManageServiceVC.self) {
                                objVC = viewController
                                break
                            }
                        }
                    }
                    if objVC != nil{
                        self.navigationController?.popToViewController(objVC!, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: KBRD_Barber_ManageServiceVC_StoryboardID) as! BRD_Barber_ManageServiceVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
            else{
                self.view.addSubview(BRDSingleton.showEmptyMessage("No services", view: self.view))
            }
            
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
