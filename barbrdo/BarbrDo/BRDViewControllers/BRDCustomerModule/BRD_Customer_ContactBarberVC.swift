//
//  BRD_Customer_ContactBarberVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 18/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_Customer_ContactBarberVC_StoryboardID = "BRD_Customer_ContactBarberVC_StoryboardID"

class BRD_Customer_ContactBarberVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblPlaceholder: UILabel!    
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    @IBOutlet weak var txtView: UITextView!
    var objAppointmentInfo: BarberConfirmAppointmentBO? = nil

    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerToolBar: UIToolbar!
    @IBOutlet weak var btnTime: UIButton!
    
    @IBOutlet weak var btnSend: UIButton!
    

    @IBOutlet weak var tableView: UITableView!
    
    var arrayTableView = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imgView?.layer.masksToBounds = false
        self.imgView?.layer.cornerRadius = (self.imgView?.frame.height)!/2
        self.imgView?.clipsToBounds = true
        
        //self.addTopNavigationBar()
        let header = Bundle.main.loadNibNamed(String(describing: BRD_TopBar.self), owner: self, options: nil)![0] as? BRD_TopBar
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.btnProfile.addTarget(self, action: #selector(btnProfileAction), for: .touchUpInside)
        self.viewNavigationBar.addSubview(header!)
        
        if self.objAppointmentInfo != nil{
            
            
            let name = (self.objAppointmentInfo?.barberInfo?.first_name)! + " "
            + (self.objAppointmentInfo?.barberInfo?.last_name)!
            let shopName = BRDSingleton.sharedInstane.shopName ?? ""
            let appointmentTime = Date.convert((self.objAppointmentInfo?.appointmentInfo?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
            
            
            if let theRating: Double = self.objAppointmentInfo?.barberInfo?.rating_score{
            
              self.lblRating.text  = String(format: "%.01f", theRating)
               // self.lblRating.text = theRating.rounded(1)
                
//                if let objdd = theRating.round(1){
//                    self.lblRating.text = String(describing: , objdd)
//                }
                
            }
            
            
            
            self.lblBarberName.text = name
            self.lblShopName.text = shopName
            self.lblTime.text = "At: " + appointmentTime
            
            let picture = self.objAppointmentInfo?.barberInfo?.picture
            
            self.activityIndicator.startAnimating()
            if picture != nil && picture != ""{
                let imagePath = KImagePathForServer +  picture!
                self.imgView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.imgView.image = image
                        }else{
                            self.imgView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.imgView.image = UIImage(named:"ICON_PROFILEIMAGE.png")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
        }
        
        self.arrayTableView = ["5 Minutes", "10 Minutes", "15 Minutes"]
    }
    
    func btnProfileAction() {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnSendAction(_ sender: UIButton) {
        
        let user = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        let delayTime = self.btnTime.titleLabel?.text
        
        let message = "I am running late by " + delayTime! + "mins" + "\n" + self.txtView.text!
        
        let inputParameters: [String: String] =
            ["text": message,
             "customer_id": (self.objAppointmentInfo?.appointmentInfo?.customer_id)!,
             "barber_id": (self.objAppointmentInfo?.appointmentInfo?.barber_id)!]
        print(inputParameters)
        
        let urlString = KBaseURLString + KCustomerSendMessageToBarber
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.customerSendMessageToBarber("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseString, status, error) in
            print(response)
            SwiftLoader.hide()
            
            if status == 200{
                self.navigationController?.popViewController(animated: true)
               
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
        }
    }
    
    @IBAction func cancelAppointment(_ sender: UIButton){
        _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: KAlertTitle, withMessage: "Do you really want to cancel this request", buttonTitles: ["OK", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
        }, returnBlock: { response in
            let value: Int = response
            if value == 0{
                
                //customer/appointment/cancel/
                let appointmentID = self.objAppointmentInfo?.appointmentInfo?._id
                let urlString = KBaseURLString + KCustomerCancelAppointment + appointmentID!
                let header = BRDSingleton.sharedInstane.getHeaders()
                if header == nil{return}
                
                BRDAPI.barberAcceptRequest("PUT", inputParameter: nil, header: header!, urlString: urlString, completionHandler: { (reponse, responseString, status, error) in
                    
                    if status == 200{
                        
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }else{
                        
                        _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                        return
                        
                    }
                })
                
            }else{
                // Do not logout
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toolBarButtonAction(_ sender: UIBarButtonItem) {
        
        switch sender.tag {
        case 101:
            self.btnTime.setTitle("05", for: .normal)
            break
        case 102:
            
            break
        default:
            break
        }
        
        self.pickerView.isHidden = true
        self.pickerToolBar.isHidden = true
    }
    @IBAction func btnTimeAction(_ sender: UIButton) {
//        self.pickerView.isHidden = false
//        self.pickerToolBar.isHidden = false

        self.tableView.isHidden = false
        self.tableView.reloadData()
    }

}

extension BRD_Customer_ContactBarberVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.characters.count > 0{
            self.lblPlaceholder.text = BRDRawStaticStrings.KEmptyString
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceholder.text = BRDRawStaticStrings.KEmptyString
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            self.lblPlaceholder.text = "Add optional message"
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let strMesage = self.txtView.text + text
        
        if strMesage.characters.count == 1 && text == "" {
            
            self.lblPlaceholder.isHidden = false
            self.btnSend.backgroundColor = UIColor.darkGray
            
            
        }else if strMesage.characters.count == 0{
            self.lblPlaceholder.isHidden = false
            self.btnSend.backgroundColor = UIColor.darkGray
        }else{
            
            self.lblPlaceholder.isHidden = true
            self.btnSend.backgroundColor = kNavigationBarColor
        }
        return true
    }
}

extension BRD_Customer_ContactBarberVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.arrayTableView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(self.arrayTableView[row])
        
        let str = self.arrayTableView[row]
        let startIndex = str.index(str.startIndex, offsetBy: 2)
        let value = str.substring(to: startIndex)
        self.btnTime.setTitle(value, for: .normal)
        
        return self.arrayTableView[row]
    }
}

extension BRD_Customer_ContactBarberVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return  self.self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        cell!.textLabel?.text = self.arrayTableView[indexPath.row]
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        cell?.textLabel?.font = UIFont.init(name: "Berlin Sans FB", size: 12.0)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = self.arrayTableView[indexPath.row]
        let startIndex = str.index(str.startIndex, offsetBy: 2)
        let value = str.substring(to: startIndex)
        self.btnTime.setTitle(value, for: .normal)
        
        self.tableView.isHidden = true
    }

}
