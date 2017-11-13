//
//  BRD_Barber_ContactCustomerVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 30/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import SwiftLoader

let KBRD_Barber_ContactCustomerVC_StoryboardID = "BRD_Barber_ContactCustomerVC_StoryboardID"

class BRD_Barber_ContactCustomerVC: UIViewController, UITextViewDelegate {
    
    
    
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnCancelAppointment: UIButton!
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblPlaceholderText: UILabel!
    
    
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var btnCustomerWasNo: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    
    @IBOutlet weak var txtReason: UITextField!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    
    
    var objAppointment: AppointmentInfoBO?
    var objCustomer: CustomerInfo? = nil
    
    var appointmentDate: String? = nil
    var arrayTableView = [String]()
    var objBarber: BRD_BarberAppointmentsBO? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Bundle.main.loadNibNamed(String(describing: BRD_NavBarWithoutProfilePicture.self), owner: self, options: nil)![0] as? BRD_NavBarWithoutProfilePicture
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.viewNavigationBar.addSubview(header!)
        
        
        if self.objBarber != nil{
            if let shop = self.objBarber?.shop_id{
                self.lblShopName.text = shop.name
            }
        }

        // Do any additional setup after loading the view.
        self.arrayTableView = ["5 Minutes", "10 Minutes", "15 Minutes"]
        self.viewCancel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.viewCancel.layer.shadowColor = UIColor.black.cgColor
        self.viewCancel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc private func backButtonAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func btnSendAction(_ sender: UIButton) {
        
        if self.txtView.text.characters.count == 0 {
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter your message", onViewController: self, returnBlock: { (clickedIN) in
                
            })
            return
        }
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        let inputParameters: [String: String] =
            ["text": (self.txtView?.text)!,
             "customer_id": (self.objAppointment?.customer_id)!,
             "barber_id": (self.objAppointment?.barber_id)!]
        print(inputParameters)
        
        let urlString = KBaseURLString + KBarberSendMessageToCustomer
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.customerSendMessageToBarber("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseString, status, error) in
            SwiftLoader.hide()
            
            if status == 200{
                
                self.navigationController?.popViewController(animated: true)

            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
        }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let strMesage = self.txtView.text + text
        
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
    
    @IBAction func btnCancelAppointmentAction(_ sender: UIButton) {
        
        
        
        self.viewCancel.isHidden = false
        self.txtReason.isHidden = true
 
    }
    
    func barberDeclineRequest(cancelReason: String){
        // Decline
        let inputParameter: [String: String] =
            ["cancel_reason": cancelReason,
             "request_cancel_on": Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_)]
        
        let appointmentID = self.objAppointment?._id
        let urlString = KBaseURLString + KDeclineCustomerRequest + appointmentID!
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{return}
        
        BRDAPI.barberAcceptRequest("PUT", inputParameter: inputParameter, header: header!, urlString: urlString, completionHandler: { (reponse, responseString, status, error) in
            
            if status == 200{
                _ = self.navigationController?.popToRootViewController(animated: true)
                
            }else{
                
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
        })
    }
    
    @IBAction func btnAlertAction(sender: UIButton){
        
        switch sender.tag {
        case 513:
            self.txtReason.isHidden = true
            self.btnCustomerWasNo.isSelected = !self.btnCustomerWasNo.isSelected
            self.btnOther.isSelected = false
            break
        case 514:
            self.txtReason.isHidden = false
            self.btnOther.isSelected = !self.btnOther.isSelected
            self.btnCustomerWasNo.isSelected = false
            break
        case 515:
            // Cancel
            self.viewCancel.isHidden  = true
            break
        case 516:
            // OK
            if self.btnOther.isSelected == true{
                if self.txtReason.text?.characters.count == 0{
                    // SHow alert
                    _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please enter resaon for cancelling", onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }else{
                    // Call API
                    self.barberDeclineRequest(cancelReason: self.txtReason.text!)
                }
            }else{
                // Call api
                self.barberDeclineRequest(cancelReason: "Customer was no show")
            }
            
            break
        default:
            break
        }
        
    }
    
}

