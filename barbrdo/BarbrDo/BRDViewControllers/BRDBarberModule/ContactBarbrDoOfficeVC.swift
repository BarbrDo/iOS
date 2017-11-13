//
//  ContactBarbrDoOfficeVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 19/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

class ContactBarbrDoOfficeVC: BRD_BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var lblPlaceholderText: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnCallUs: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.addTopNavigationBar(title: "Contact BarbrDo Office")
        self.activityIndicator.isHidden = true

        let header : NavigationBarWithTitleAndBack = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitleAndBack.self), owner: self, options: nil)![0] as! NavigationBarWithTitleAndBack
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.btnProfile.addTarget(self, action: #selector(btnProfileMenu), for: .touchUpInside)
        header.initWithTitle(title: "Contact BarbrDo Office")
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
    
    
    
    @IBAction func btnContactBarbrDoOfficeAction(sender: UIButton){
        
        switch sender.tag {
        case 350:
            
            if !(self.txtViewMessage.text.isEmpty){
                self.sendMessageToBarbrDo()
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter message", onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
            break
        case 351:
            let phoneNumber = "9177173813"
            if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
            break
        default:
            break
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let strMesage = self.txtViewMessage.text + text
        
        if strMesage.characters.count == 1 && text == "" {
            self.lblPlaceholderText.isHidden = false
            self.btnSend.backgroundColor = UIColor.darkGray
            
            
        }else if strMesage.characters.count == 0{
            self.lblPlaceholderText.isHidden = false
            self.btnSend.backgroundColor = UIColor.darkGray
        }else{
            
            self.lblPlaceholderText.isHidden = true
            self.btnSend.backgroundColor = kNavigationBarColor
        }
        return true
    }
    
    
    func sendMessageToBarbrDo(){
        
        SwiftLoader.show("Sending", animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
        if header ==  nil{return}
        
        if let userInfo = BRDSingleton.sharedInstane.objBRD_UserInfoBO{
            
            
            let inputParameters = ["name": userInfo.first_name! + " " + userInfo.last_name!    , "email" : userInfo.email!   , "message" : self.txtViewMessage.text!] as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KContact
            
            print(urlString)
            BRDAPI.addChairShop("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if let serverMessage = responseMessage {
                    
                    // SUCCESS CASE
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: serverMessage, onViewController: self, returnBlock: { (clickedIN) in
                        
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    })
                }else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in})
                }
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in})
                    return
                }
            }
        }
    }
    

}
