//
//  BarberAcceptedRequestVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 03/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
import GoogleMaps
import MapKit
import SCLAlertView
import AVFoundation


class BarberAcceptedRequestVC: UIViewController {
    
    @IBOutlet weak var imageViewBarber: UIImageView!
    @IBOutlet weak var imageViewStar: UIImageView!
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblBeThere: UILabel!
    @IBOutlet weak var btnMapIt: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnGoToBarberView: UIButton!
    
    
    @IBOutlet weak var lblShopAddress: UILabel!
    
    
    var objBarberConfirmAppointment: BarberConfirmAppointmentBO?
    var objCustomerInfo: CustomerInfo? = nil
    var player: AVAudioPlayer?
    
    
    // UINotification View
    
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var imageViewNotification: UIImageView!
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var txtFieldMessage: UITextField!
    @IBOutlet weak var btnNotReply: UIButton!
    @IBOutlet weak var btnNotCancel: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.viewNotification.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.btnNotReply.layer.shadowColor = UIColor.black.cgColor
        self.btnNotCancel.layer.shadowColor = UIColor.black.cgColor
        self.viewNotification.isHidden = true
        
        self.txtFieldMessage.layer.borderColor = kNavigationBarColor.cgColor
        self.txtFieldMessage.layer.borderWidth = 1.0
        
        
        self.imageViewNotification.layer.borderWidth = 1.0
        self.imageViewNotification.layer.masksToBounds = false
        self.imageViewNotification.layer.borderColor = UIColor.white.cgColor
        self.imageViewNotification.layer.cornerRadius = self.imageViewNotification.frame.size.width/2
        self.imageViewNotification.clipsToBounds = true
        
        
        self.btnMapIt.backgroundColor = .clear
        self.btnMapIt.layer.borderWidth = 1
        self.btnMapIt.layer.borderColor = UIColor.white.cgColor
        
        
        self.imageViewBarber.layer.borderWidth = 1.0
        self.imageViewBarber.layer.masksToBounds = false
        self.imageViewBarber.layer.borderColor = UIColor.white.cgColor
        self.imageViewBarber.layer.cornerRadius = self.imageViewBarber.frame.size.width/2
        self.imageViewBarber.clipsToBounds = true

        // Do any additional setup after loading the view.
        
         NotificationCenter.default.addObserver(self, selector: #selector(BarberAcceptedRequestVC.receiveCustomerNotification), name: NSNotification.Name(rawValue: KMessageToCustomer), object: nil)
        
        if self.objBarberConfirmAppointment != nil{
            
            if let objBarber = self.objBarberConfirmAppointment?.barberInfo{
                let fullName = objBarber.first_name!.capitalized + " " + objBarber.last_name!.capitalized
                
                self.lblBarberName.text = fullName
                
                if objBarber.picture != nil{
                    self.activityIndicator.startAnimating()

                    let imagePath = KImagePathForServer + objBarber.picture!
                    self.imageViewBarber.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                        
                        DispatchQueue.main.async(execute: {
                            if image != nil{
                                self.imageViewBarber.image = image
                                BRDSingleton.sharedInstane.barberImageString = objBarber.picture
                                BRDSingleton.sharedInstane.barberImage = image
                            }else{
                                self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
                            }
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.hidesWhenStopped = true
                        })
                    })
                }else{
                    self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
                    self.activityIndicator.hidesWhenStopped = true
                }
                
                self.lblRating.text = (String(format: "%.1f", objBarber.rating_score!))
                
//                var shopName = objBarber.shopName
//                shopName = shopName! + " (" + String(format: "%.0f", obj.distance!) + " mi" + ")"
//                self.lblShopName.text = shopName
                
                self.lblShopAddress.text = BRDSingleton.sharedInstane.fullShopAddress
                
                if BRDSingleton.sharedInstane.shopNameAndDistance != nil{
                    self.lblShopName.text = BRDSingleton.sharedInstane.shopNameAndDistance
                }
                
                let appointmentTime = Date.convert((objBarberConfirmAppointment?.appointmentInfo?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
                
                self.lblBeThere.text = "Be there @ " + appointmentTime + "\n and be next in the chair"
            }
        }
    }
    
    
    @IBAction func btnViewBarberProfileAction(sender: UIButton){
        
        
        
        let dict = self.objBarberConfirmAppointment?.barberInfo?.dictionaryRepresentation()
        let objBarberData  = BarberListBO.init(dictionary: dict!)
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
            
            vc.objBarberInfo = objBarberData
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Stop Customer Timer
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: KStopCustomerTimer), object: nil)
    }
    
    
    
    func receiveCustomerNotification(notification: NSNotification){
        
        print(notification.name)
        let notificationName = notification.name.rawValue
        
        switch notificationName {
        case KMessageToCustomer:
            
            playSound()
            
            if let arrayObj = notification.object as? [String: Any]{
                
                if let dict = arrayObj["message"] as? [String: Any]{
                    
                    self.objCustomerInfo = CustomerInfo.init(dictionary: dict["customerInfo"] as! NSDictionary)
                    
                    if let text = dict["text"] as? String{
                        self.objCustomerInfo?.text = text
                    }
                }
                
                self.viewNotification.isHidden = false
                if self.objCustomerInfo?.picture != nil{
                    let imagePath = KImagePathForServer + (self.objCustomerInfo?.picture!)!
                    self.imageViewNotification.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                        
                        DispatchQueue.main.async(execute: {
                            if image != nil{
                                self.imageViewNotification.image = image
                            }else{
                                self.imageViewNotification.image = UIImage(named: "ICON_PROFILEIMAGE")
                            }
                        })
                    })
                }else{
                    self.imageViewNotification.image = UIImage(named: "ICON_PROFILEIMAGE")
                }
                self.lblSenderName.text = (self.objCustomerInfo?.first_name)! + " " + (self.objCustomerInfo?.last_name)!
                self.txtViewMessage.text = (self.objCustomerInfo?.text)!
                
                /*
                var theBarberImage: UIImage!
                
                if self.objCustomerInfo?.picture != nil && BRDSingleton.sharedInstane.barberImageString != nil && self.objCustomerInfo?.picture == BRDSingleton.sharedInstane.barberImageString{
                    
                    theBarberImage = BRDSingleton.sharedInstane.barberImage
                }else{
                    theBarberImage =  UIImage(named: "ICON_PROFILEIMAGE")
                }

                
                let fullName = (self.objCustomerInfo?.first_name)! + " " + (self.objCustomerInfo?.last_name)!
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                let textField = alertView.addTextField("Type Message here")                
                alertView.addButton("Reply") {
                    print("Text value: \(textField.text)")
                    
                    
                    if textField.text?.characters.count == 0{
                        return
                    }
                    
                    let header = BRDSingleton.sharedInstane.getHeaders()
                    
                    let inputParameters: [String: String] =
                        ["text": (textField.text)!,
                         "customer_id": (self.objCustomerInfo?._id)!,
                         "barber_id": (self.objBarberConfirmAppointment?.appointmentInfo?.barber_id)!]
                    
                    
                    print(inputParameters)
                    
                    let urlString = KBaseURLString + KCustomerSendMessageToBarber
                    SwiftLoader.show(KLoading, animated: true)
                    
                    BRDAPI.customerSendMessageToBarber("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseString, status, error) in
                        SwiftLoader.hide()
                        
                        if status == 200{
                            //                            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Message sent successfully", onViewController: self, returnBlock: { (clickedIN) in
                            //
                            //                            })
                        }else{
                            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                                
                            })
                        }
                    }
                }
                alertView.addButton("Close", backgroundColor: UIColor.darkGray, textColor: UIColor.white, showDurationStatus: true) {
                    print("Duration Button tapped")
                }
//                alertView.showInfo(fullName, subTitle: (self.objCustomerInfo?.text)!)
              
                alertView.showInfo(fullName, subTitle: (self.objCustomerInfo?.text)!, circleIconImage: theBarberImage)
                */
                
                
                /*
                //1. Create the alert controller.
                let alert = UIAlertController(title: KAlertTitle, message: self.objCustomerInfo?.text, preferredStyle: .alert)
                
                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    //textField.text = "Some default text"
                }
                
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    if textField?.text?.characters.count == 0{
                        return
                    }
                    
                    let header = BRDSingleton.sharedInstane.getHeaders()
                    
                    let inputParameters: [String: String] =
                        ["text": (textField?.text)!,
                         "customer_id": (self.objCustomerInfo?._id)!,
                         "barber_id": (self.objBarberConfirmAppointment?.appointmentInfo?.barber_id)!]
                    
                    
                    print(inputParameters)
                    
                    let urlString = KBaseURLString + KCustomerSendMessageToBarber
                    SwiftLoader.show(KLoading, animated: true)
                    
                    BRDAPI.customerSendMessageToBarber("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseString, status, error) in
                        SwiftLoader.hide()
                        
                        if status == 200{
//                            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Message sent successfully", onViewController: self, returnBlock: { (clickedIN) in
//                                
//                            })
                        }else{
                            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                                
                            })
                        }
                    }
                    
                    
                }))
                
                alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { [weak alert] (_) in
                    
                }))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
 
 */
            }
            break
        default:
            break
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func barberAcceptedBtnAction(sender: UIButton){
        
        switch sender.tag {
        case 301:
            //Cancel
            
            _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: KAlertTitle, withMessage: "Do you really want to cancel this appointment", buttonTitles: ["OK", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
            }, returnBlock: { response in
                let value: Int = response
                if value == 0{
                    // OK
                    //customer/appointment/cancel/
                    let appointmentID = self.objBarberConfirmAppointment?.appointmentInfo?._id
                    let urlString = KBaseURLString + KCustomerCancelAppointment + appointmentID!
                    let header = BRDSingleton.sharedInstane.getHeaders()
                    if header == nil{return}
                    
                    let inputParameters: [String: Any] =
                        ["request_cancel_on": Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_)]
                    
                    BRDAPI.barberAcceptRequest("PUT", inputParameter: inputParameters, header: header!, urlString: urlString, completionHandler: { (reponse, responseString, status, error) in
                        
                        if status == 200{
                            self.navigationController?.popToRootViewController(animated: true)
                        }else{
                            
                            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                                
                            })
                            return
                            
                        }
                    })
                }else{
                    // Cancel
                    
//                    let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "BRD_Customer_ContactBarberVC") as! BRD_Customer_ContactBarberVC
//                    self.navigationController?.pushViewController(vc, animated: false)
                }
            })
            
            break
        case 302:
            // Send Message
            
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_ContactBarberVC_StoryboardID) as! BRD_Customer_ContactBarberVC
            vc.objAppointmentInfo = self.objBarberConfirmAppointment
            self.navigationController?.pushViewController(vc, animated: false)

            break
        case 303:
            //Map it
//            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "MapItVC") as! MapItVC
//            
//            vc.objAppointment = self.objBarberConfirmAppointment
//            vc.customerLatLong = (self.objBarberConfirmAppointment?.customer_lat_long)!
//            self.navigationController?.pushViewController(vc, animated: false)
            
            
            
            let strAddress = self.lblShopAddress.text
            
            let refineAddress = strAddress?.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
            
            let source = CLLocationCoordinate2D.init(latitude: (self.objBarberConfirmAppointment?.customer_lat_long?[1])!, longitude: (self.objBarberConfirmAppointment?.customer_lat_long?[0])!)
            let destination = CLLocationCoordinate2D.init(latitude: BRDSingleton.sharedInstane.barberShopLatLong[1], longitude: BRDSingleton.sharedInstane.barberShopLatLong[0])
            
            print("Source\(source.latitude, source.longitude))")
            print("Destination\(BRDSingleton.sharedInstane.barberShopLatLong[1], BRDSingleton.sharedInstane.barberShopLatLong[0]))")
            
             print(URL(string: String(format: "http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f&&dirflg=d", source.latitude,source.longitude,destination.latitude ,destination.longitude))!)
            // First Priority Google Maps
            
            print(UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!))
            
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
                // Google Maps
                
                /* This if for source address and destination address
                 
                UIApplication.shared.openURL(URL(string: String(format: "http://maps.google.com/?saddr=%f,%f&daddr=%f,%f&directionsmode=drive", source.latitude,source.longitude,destination.latitude ,destination.longitude))!)
                 */
                
                let urlString = String(format: "http://maps.google.com/?daddr=" + refineAddress! + "&directionsmode=drive")
                
                let escapedString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                
                UIApplication.shared.openURL(URL(string: escapedString!)!)
                
                
            }else{
                // Apple Maps
//                 UIApplication.shared.openURL(URL(string: String(format: "http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f&&dirflg=d", source.latitude,source.longitude,destination.latitude ,destination.longitude))!)
                UIApplication.shared.openURL(URL(string: String(format: "http://maps.apple.com/?daddr=%f,%f&&dirflg=d",destination.latitude ,destination.longitude))!)
            }
            
            
            break
        case 304:
            // Close
            self.viewNotification.isHidden = true
            break
        case 305:
            // Reply
            
                print("Text value: \(self.txtFieldMessage.text!)")
                
                if self.txtFieldMessage.text?.characters.count == 0{
                    return
                }
                
                let header = BRDSingleton.sharedInstane.getHeaders()
                
                let inputParameters: [String: String] =
                    ["text": (self.txtFieldMessage.text)!,
                     "customer_id": (self.objCustomerInfo?._id)!,
                     "barber_id": (self.objBarberConfirmAppointment?.appointmentInfo?.barber_id)!]
                
                
                print(inputParameters)
                
                let urlString = KBaseURLString + KCustomerSendMessageToBarber
                SwiftLoader.show(KLoading, animated: true)
                
                BRDAPI.customerSendMessageToBarber("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseString, status, error) in
                    SwiftLoader.hide()
                    
                    if status == 200{
                        self.txtFieldMessage.text = ""
                        self.viewNotification.isHidden = true
                    }else{
                        _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                }
                
            break
        default:
            break
        }
        
    }

   
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Accept", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

extension BarberAcceptedRequestVC: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let strValue: String = self.txtFieldMessage.text! + string
        
        if strValue.characters.count == 0{
            self.btnNotReply.backgroundColor = UIColor.darkGray
           
        }else{
             self.btnNotReply.backgroundColor = kNavigationBarColor
        }
        
        return true
    }
    
}
