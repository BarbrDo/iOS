//
//  BRD_Shop_ContactOfficeVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/31/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_Shop_ContactOfficeVC_StoryboardID = "BRD_Shop_ContactOfficeVCStoryboardID"
class BRD_Shop_ContactOfficeVC: BRD_BaseViewController,UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var redView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTopNavigationBar(title: "")
        textView.text = "Type message here..."
        textView.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type message here..."
            
            textView.textColor = UIColor.lightGray
        }
    }
    func sendMail()
    {
        
        SwiftLoader.show("Sending", animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
        if header ==  nil{return}
        
        let shopInfoObj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        if let shopInfo = shopInfoObj
        {
            
            
            let inputParameters = ["name": shopInfo.first_name! + " " + shopInfo.last_name!    , "email" : shopInfo.email!   , "message" : textView.text!] as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KContact
            
            print(urlString)
            BRDAPI.addChairShop("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if let serverMessage = responseMessage {
                   
                        
                        
                        // SUCCESS CASE
                        _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: serverMessage, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                        _ = self.navigationController?.popViewController(animated: true)
                    
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
    }
    
    @IBAction func callUsBtnAction(_ sender: Any) {
        
        let phoneNumber = "9177173813"
        if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
//        let shopInfoObj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
//        }
//        
//        
//        if let shopInfo = shopInfoObj
//        {
//            
//            if let url = NSURL(string: "tel://\( shopInfo.mobile_number!)"), UIApplication.shared.canOpenURL(url as URL) {
//                UIApplication.shared.openURL(url as URL)
//            }
//        }
    }
    @IBAction func sendBtnAction(_ sender: Any)
    {
        if textView.text == ""
        {
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please enter the message", onViewController: self, returnBlock: { (clickedIN) in
                
            })
        }
        else
        {
            self.sendMail()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    
}
