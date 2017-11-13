//
//  ContactShopVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 22/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

class ContactShopVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var lblBarberName: UILabel!
    
    var objAppointmentInfo: BRD_AppointmentsInfoBO? = nil
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerToolBar: UIToolbar!
    
     var objshopData: BRD_ShopDataBO? = nil
    
    var arrayTableView = [String]()
    var shop_user_id: String? = nil
    
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
        
        if self.objshopData != nil{
            //self.lblBarberName.text = self.objshopData?.name
            
            var address = ""
            
            if let shopName = self.self.objshopData?.name{
                address = shopName + "\n"
            }else{
                address = "Pop's Barber Shop" + "\n"
            }
            if let shopDetails = self.self.objshopData?.address {
                address = address + shopDetails + ", \n"
            }
            if let city = self.self.objshopData?.city {
                address = address + city + ", "
            }
            if let state = self.self.objshopData?.state {
                address = address + state
            }
            self.lblBarberName.text = address
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true

            let picture: String? = nil //self.objAppointmentInfo?.barber_id?.picture
            
            
            
            //self.activityIndicator.startAnimating()
            if picture != nil && picture != ""{
                let imagePath = KImagePathForServer +  picture!
                self.imgView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.imgView.image = image
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
        
        if textView.text == ""{
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter your message", onViewController: self, returnBlock: { (clickedIN) in
                
            })
            
        }else{
            SwiftLoader.show(KLoading, animated: true)
            
            let header = BRDSingleton.sharedInstane.getHeaders()
            
            let userObj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
            
            
            
            let completeName = (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.first_name)! + (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.last_name)!
            
//            let inputParameters : [String: Any] =
//            ["from_name":,
//             "from_user_id": (BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id)!,
//             "to_user_id": (self.objshopData?._id)!,
//             "message": self.textView.text!]

            let inputParameters : [String: Any] =
                ["from_name": (self.objshopData?.name)!,
                 "from_email": (userObj?.email)!,
                 "from_user_id": (userObj?._id)!,
                 "to_user_id": self.shop_user_id!,
                 "to_shop_name":  (userObj?.first_name)! + " " + (userObj?.last_name)!,
                 "message": self.textView.text!]
            
            print(inputParameters)
            let urlString = KBaseURLString + KContactShopFromBarber
            
            BRDAPI.contactShop("post", inputParameter: inputParameters, header: header!, urlString: urlString, completionHandler: { (response, responsString, status, error) in
                
                self.textView.text = ""
                self.lblPlaceholder.text = "Type message here..."
                SwiftLoader.hide()
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: responsString, onViewController: self, returnBlock: { (clickedIN) in
                    
                })

            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toolBarButtonAction(_ sender: UIBarButtonItem) {
        
        switch sender.tag {
        case 101:
            //self.btnTime.setTitle("00", for: .normal)
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
        self.pickerView.isHidden = false
        self.pickerToolBar.isHidden = false
        
        
    }
    
}


extension ContactShopVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.characters.count > 0{
            self.lblPlaceholder.text = BRDRawStaticStrings.KEmptyString
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceholder.text = BRDRawStaticStrings.KEmptyString
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text == ""{
            self.lblPlaceholder.text = "Type message here..."
        }
        return true
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            self.lblPlaceholder.text = "Type message here..."
        }
    }
        

}



extension ContactShopVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
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

        return self.arrayTableView[row]
    }
    
    
}

