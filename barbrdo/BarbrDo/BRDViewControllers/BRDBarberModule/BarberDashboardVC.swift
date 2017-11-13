
//
//  BarberDashboardVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 08/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SideMenu
import SwiftLoader
import SCLAlertView
import AVFoundation

enum Dashboard: Int{
    case general = 501,
    goOnline,
    goOffline,
    btnGoOnlineNow,
    btnGoOnline,
    btnCancel,
    btnOffline,
    btnToolBarDone,
    btnToolBarCancel,
    NoCustomerBooking,
    btnCheckIN,
    btnSendMessage,
    btnNotificationCancel,
    btnNotificationReply
}

class BarberDashboardNoCustomerBooking: UITableViewCell{
    
    
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var btnOffline: UIButton!
    @IBOutlet weak var lblRevenueFromApp: UILabel!
    @IBOutlet weak var lblTotalCutsFromApp: UILabel!
    
    @IBOutlet weak var btnGoToFinancialCenter: UIButton!
    override func awakeFromNib() {
        
    }
    
    func initWithData(revenue: String, totalCutsFromApp: String){
        
        
        if revenue != "" {
           self.lblRevenueFromApp.text = "$" + String(format: "%.02f", Double(revenue)!)
        }
        
        if totalCutsFromApp == ""{
            self.lblTotalCutsFromApp.text = "0"
        }else{
            self.lblTotalCutsFromApp.text = totalCutsFromApp
        }
    }

}

class BarberDashboardIsOnline: UITableViewCell{
    
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var btnOffline: UIButton!
    @IBOutlet weak var imageViewBarber: UIImageView!
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblBarberServices: UILabel!
    @IBOutlet weak var lblAppointmentTime: UILabel!
    @IBOutlet weak var btnCheckIN: UIButton!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    @IBOutlet weak var lblRevenueFromApp: UILabel!
    @IBOutlet weak var lblTotalCutsFromApp: UILabel!
    
    @IBOutlet weak var btnGoToFinancialCenter: UIButton!
    
    override func awakeFromNib() {
        btnOffline.layer.cornerRadius = 5
        btnOffline.clipsToBounds = true
        
        
        self.imageViewBarber.layer.borderWidth = 1.0
        self.imageViewBarber.layer.masksToBounds = false
        self.imageViewBarber.layer.borderColor = UIColor.white.cgColor
        self.imageViewBarber.layer.cornerRadius = self.imageViewBarber.frame.size.width/2
        self.imageViewBarber.clipsToBounds = true

    }
    
    func initWithData(objAppointmentData: AppointmentInfoBO?, revenue: String, totalCutsFromApp: String){
        
        if revenue != "" {
            self.lblRevenueFromApp.text = "$" + String(format: "%.02f", Double(revenue)!)
        }
        
        if totalCutsFromApp == ""{
            self.lblTotalCutsFromApp.text = "0"
        }else{
            self.lblTotalCutsFromApp.text = totalCutsFromApp
        }
        
        if objAppointmentData != nil{
            
            if let arrayServices: [BRD_ServicesBO] = objAppointmentData?.services {
                var strTotalService = ""
                for obj in arrayServices{
                    strTotalService = strTotalService + obj.name! + ", "
                }
                
                let endIndex = strTotalService.index(strTotalService.endIndex, offsetBy: -2)
                let truncated: String = strTotalService.substring(to: endIndex)
                
                self.lblBarberServices.text = truncated
                
                self.lblAppointmentTime.text = "Coming in @" + Date.convert((objAppointmentData?.appointment_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
                
                if let objCustomerInfo = objAppointmentData?.customerInfo[0]{
                    
                    let fullName = objCustomerInfo.first_name! + " " + objCustomerInfo.last_name!
                    self.lblBarberName.text = fullName
                    
                    if objCustomerInfo.picture != nil{
                        let imagePath = KImagePathForServer + objCustomerInfo.picture!
                        self.imageViewBarber.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                            
                            DispatchQueue.main.async(execute: {
                                if image != nil{
                                    self.imageViewBarber.image = image
                                    BRDSingleton.sharedInstane.customerImage = image
                                    BRDSingleton.sharedInstane.customerImageString = objCustomerInfo.picture
                                }else{
                                    self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
                                }
                            })
                        })
                    }else{
                        self.imageViewBarber.image = UIImage(named: "ICON_PROFILEIMAGE")
                    }
                }
            }
        }
    }
    
}


class BarberDashboardGeneral: UITableViewCell{
    
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var btnGoOnline: UIButton!
    
    @IBOutlet weak var lblRevenueFromApp: UILabel!
    @IBOutlet weak var lblTotalCutsFromApp: UILabel!
    
    @IBOutlet weak var btnGoToFinancialCenter: UIButton!
    
    override func awakeFromNib() {
        btnGoOnline.layer.cornerRadius = 5
        btnGoOnline.clipsToBounds = true
    }
    
    func initWithData(revenue: String, totalCutsFromApp: String){
        
        if revenue != "" {
            self.lblRevenueFromApp.text = "$" + String(format: "%.02f", Double(revenue)!)
        }
        
        if totalCutsFromApp == ""{
            self.lblTotalCutsFromApp.text = "0"
        }else{
            self.lblTotalCutsFromApp.text = totalCutsFromApp
        }
        
    }
}

class BarberDashboardHeader: UITableViewCell{
    
    @IBOutlet weak var imageViewBG: UIImageView!
    
    @IBOutlet weak var lblService1: UILabel!
    @IBOutlet weak var lblService2: UILabel!
    
    @IBOutlet weak var txtFieldHairCut: PaddingTextField!
    @IBOutlet weak var txtFieldShave: PaddingTextField!
    @IBOutlet weak var btnSelectShop: UIButton!
    @IBOutlet weak var btnGoOnline: UIButton!
    @IBOutlet weak var btnGoOnlineNow: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblRevenueFromApp: UILabel!
    @IBOutlet weak var lblTotalCutsFromApp: UILabel!
    
    @IBOutlet weak var btnGoToFinancialCenter: UIButton!
    
    override func awakeFromNib() {
        
        btnGoOnline.layer.cornerRadius = 5
        btnGoOnline.clipsToBounds = true
        
        self.btnSelectShop.setTitle("", for: .normal)
        self.btnGoOnlineNow.backgroundColor = UIColor.darkGray
    }
    
    func initWithData(hairCut: String, shaving: String,revenue: String, totalCutsFromApp: String, assciatedShops: [AssociatedShopsBO], arrayService: [BRD_ServicesBO] ){
        
        if arrayService.count > 0{
            let obj = arrayService[0]
            self.lblService1.text = obj.name
        }
        
        if arrayService.count > 1{
            let obj1 = arrayService[1]
            self.lblService2.text = obj1.name
        }
        
        self.txtFieldHairCut.text = hairCut
        self.txtFieldShave.text = shaving
        
        if revenue != ""{
            self.lblRevenueFromApp.text = "$" + String(format: "%.02f", Double(revenue)!)    
        }
        
        if totalCutsFromApp == ""{
            self.lblTotalCutsFromApp.text = "0"
        }else{
            self.lblTotalCutsFromApp.text = totalCutsFromApp
        }
        
//        if assciatedShops.count > 0{
//            let shopName = assciatedShops[0].shopInfo?[0].name
//            self.btnSelectShop.setTitle(shopName, for: .normal)
//        }
        
        for obj in assciatedShops{
            if obj.is_default == true{
                let shopName = obj.shopInfo?[0].name
                self.btnSelectShop.setTitle(shopName, for: .normal)
                break
            }
        }
        
        print("Blank Text", self.btnSelectShop.titleLabel?.text)
        
        if self.btnSelectShop.titleLabel?.text == nil ||
        self.btnSelectShop.titleLabel?.text == ""{
            
            if assciatedShops.count > 0 {
            
                
                if (assciatedShops[0].shopInfo?.count)! > 0{
                    let shopName = assciatedShops[0].shopInfo?[0].name
                    self.btnSelectShop.setTitle(shopName, for: .normal)
                }
            }
        }
    }
}


class BarberDashboardCell: UITableViewCell{
    
    @IBOutlet weak var imageViewBG: UIImageView!
    
    @IBOutlet weak var imageViewBarber: UIImageView!
    @IBOutlet weak var lblBarberAddress: UILabel!
    
    @IBOutlet weak var btnDefaultShop: UIButton!
    @IBOutlet weak var lblDefaultShop: UILabel!
    @IBOutlet weak var lblSeparator: UILabel!
    
    @IBOutlet weak var btnGoToManageShop: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BarberDashboardCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageViewBarber.layer.masksToBounds=true
        imageViewBarber.layer.borderWidth=1
        imageViewBarber.layer.borderColor = KLightBlueColor.cgColor
        imageViewBarber.layer.cornerRadius=imageViewBarber.bounds.width/2
    }
    
    func initWithData(associatedShop: AssociatedShopsBO, isBarberOnline: Bool){
        
        if let shopInfo = associatedShop.shopInfo{
        
            var address = ""
            if let shopName = shopInfo[0].name{
                address = shopName + "\n"
            }
            if let shopDetails = shopInfo[0].address {
                address = address + shopDetails + ", \n"
            }
            if let city = shopInfo[0].city {
                address = address + city + ", "
            }
            if let state = shopInfo[0].state {
                address = address + state
            }
            self.lblBarberAddress.text = address
        }
        
        if associatedShop.is_default == true && isBarberOnline == true{
            
            self.btnDefaultShop.isHidden = false
            self.lblDefaultShop.isHidden = false
            
            self.lblDefaultShop.text = "Active Shop"
        }
        else if associatedShop.is_default == true{
            
            self.btnDefaultShop.isHidden = false
            self.lblDefaultShop.isHidden = false
            
            self.lblDefaultShop.text = "Default Shop"
        }else{
            self.btnDefaultShop.isHidden = true
            self.lblDefaultShop.isHidden = true
            
            self.lblDefaultShop.text = "Default Shop"
        }
    }
}

class BarberDashboardFooter: UITableViewCell{
    
    @IBOutlet weak var imageViewBG: UIImageView!
    
    @IBOutlet weak var btnCustomer: UIButton!
    @IBOutlet weak var btnBarber: UIButton!
    @IBOutlet weak var txtBarberOrCustomer: UITextField!
    @IBOutlet weak var btnSendInvitation: UIButton!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    
    func initWithData(buttonTag: Int){
    
        switch buttonTag {
        case 901:
            self.btnCustomer.isSelected = true
            self.btnBarber.isSelected = false
            break
        case 902:
            self.btnCustomer.isSelected = false
            self.btnBarber.isSelected = true
            break
        default:
            self.btnCustomer.isSelected = true
            self.btnBarber.isSelected = false
            break
        }
    }
}

class BarberDashboardVC: BRD_BaseViewController {
    
    @IBOutlet weak var imageViewBGMain : UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tootBar: UIToolbar!
    @IBOutlet weak var btnToolBarCancel: UIBarButtonItem!
    @IBOutlet weak var btnToolBarDone: UIBarButtonItem!
    
    @IBOutlet weak var tableViewShopHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewShops: UITableView!
    
    
    var arrayTableView = [AssociatedShopsBO]()
    var arrayPickerView = [AssociatedShopsBO]()
    var arrayServices = [BRD_ServicesBO]()
    var selectedShop : AssociatedShopsBO!
    var objAppointmentInfo: AppointmentInfoBO? = nil
    var header:BarberDashboardHeader!
    var headerValue: Int = 501
    
    
    var footer:BarberDashboardFooter!
    var footerBtnSelected: Int = 0
    
    
    var strHairCutPrice: String = ""
    var strShavingPrice: String = ""
    var strPhoneNumberOrEmail: String = ""
    
    var strTotalRevenueFromApp: String = ""
    var strTotalNumberofCuts: String = ""
    
    var isBarberOnline: Bool = false
    
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

        // Do any additional setup after loading the view.
        self.addTopNavigationBar(title: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(BarberDashboardVC.menuTapNotification(notification:)), name: NSNotification.Name(rawValue: KBarberSideMenuTapped), object: nil)
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(BarberDashboardVC.receivePushNotification), name: NSNotification.Name(rawValue: KCustomerRequestToBarber), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BarberDashboardVC.receivePushNotification), name: NSNotification.Name(rawValue: KMessageToBarber), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BarberDashboardVC.receivePushNotification), name: NSNotification.Name(rawValue: KReloadAgain), object: nil)
        
        
        
        
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

        
    }
    
    func receivePushNotification(notification: NSNotification){
        
        print(notification.name)
        let notificationName = notification.name.rawValue
        
        switch notificationName {
        case KCustomerRequestToBarber:
            if let arrayObj = notification.object as? [String: Any]{
                
                print(arrayObj)
                
                if let dict = arrayObj["message"] as? [String: Any]{
                    
                    let obj = CustomerRequestToBarberBO.init(dictionary: dict as! NSDictionary)
                    
                    let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "BarberIncomingRequestVC") as! BarberIncomingRequestVC
                    vc.objCustomerNotification = obj
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            break
        case KMessageToBarber:
            
            self.playSound()
            
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

                
                 let fullName = (self.objCustomerInfo?.first_name)! + " " + (self.objCustomerInfo?.last_name)!
                
                var theCustomerImage: UIImage!
                /*
                if self.objCustomerInfo?.picture != nil && BRDSingleton.sharedInstane.customerImageString != nil && self.objCustomerInfo?.picture == BRDSingleton.sharedInstane.customerImageString{
                    
                    theCustomerImage = BRDSingleton.sharedInstane.customerImage
                }else{
                    theCustomerImage =  UIImage(named: "ICON_PROFILEIMAGE")
                }
                
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
                         "barber_id": (self.objAppointmentInfo?.barber_id)!]
                    print(inputParameters)
                    
                    let urlString = KBaseURLString + KBarberSendMessageToCustomer
                    SwiftLoader.show(KLoading, animated: true)
                    
                    BRDAPI.customerSendMessageToBarber("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseString, status, error) in
                        SwiftLoader.hide()
                        
                        if status == 200{
                           
                        }else{
                            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                                
                            })
                        }
                    }
                }
                alertView.addButton("Close", backgroundColor: UIColor.darkGray, textColor: UIColor.white, showDurationStatus: true) {
                    print("Duration Button tapped")
                }

               // alertView.showInfo(fullName, subTitle: (self.objCustomerInfo?.text)!)
                
                alertView.showInfo(fullName, subTitle: (self.objCustomerInfo?.text)!, circleIconImage: theCustomerImage)*/
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
                         "barber_id": (self.objAppointmentInfo?.barber_id)!]
                    print(inputParameters)
                    
                    let urlString = KBaseURLString + KBarberSendMessageToCustomer
                    SwiftLoader.show(KLoading, animated: true)
                    
                    BRDAPI.customerSendMessageToBarber("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseString, status, error) in
                        SwiftLoader.hide()
                        
                        if status == 200{
                            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Message sent successfully", onViewController: self, returnBlock: { (clickedIN) in
                                
                            })
                        }else{
                            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                                
                            })
                        }
                    }

                    
                }))
                
                alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { [weak alert] (_) in
                    
                }))
                
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)*/
            }
            break
        case KReloadAgain:
            
            
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Oops, we are sorry but it looks like the customer has to cancel the request.", onViewController: self, returnBlock: { (clickedIN) in
                
                self.getBarberDetails()
            })
            
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getBarberDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnToolBarAction(_ sender: UIBarButtonItem) {
        
        switch sender.tag {
        case Dashboard.btnToolBarCancel.rawValue:
            break
        case Dashboard.btnToolBarDone.rawValue:
            break
        default:
            break
        }
        
        self.tootBar.isHidden = true
        self.pickerView.isHidden = true
    }
    
    func getBarberDetails(){
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{return}
        SwiftLoader.show(KLoading, animated: true)
        let urlString = KBaseURLString + KBarberHome
        
        BRDAPI.barberHOMEAPI("GET", inputParameters: nil, header: header, urlString: urlString) { (appointmentData, associatedShops, services,revenue, barberStatus, error) in
            
            SwiftLoader.hide()
            
            self.isBarberOnline = barberStatus
            
            if barberStatus == true && appointmentData == nil{
                self.headerValue = 510
            }else if barberStatus == true{
                self.headerValue = 503
            }else{
                self.headerValue = 501
            }
            if appointmentData != nil{
                self.objAppointmentInfo = appointmentData
            }
            
            self.arrayTableView.removeAll()
            self.arrayPickerView.removeAll()
            if associatedShops != nil{
               
                self.arrayTableView = associatedShops!
            }
            
            for (index, obj) in self.arrayTableView.enumerated(){
                if obj.is_default == true{
                    let element = self.arrayTableView.remove(at: index)
                    self.arrayTableView.insert(obj, at: 0)
                }
            }
            self.arrayPickerView = self.arrayTableView
            
            self.arrayTableView.insert(AssociatedShopsBO(), at: 0)
            self.arrayTableView.append(AssociatedShopsBO())
            
            if services != nil{
                self.arrayServices  = services!
            }
            if revenue != nil{
                self.strTotalRevenueFromApp = String(describing: (revenue?.revenue!)!)
                self.strTotalNumberofCuts = String(describing: (revenue?.totalCuts!)!)
            }
            
            if associatedShops != nil{
                if (associatedShops?.count)! > 0{
                    self.selectedShop = associatedShops?[0]
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func menuTapNotification(notification:NSNotification) {
        self.navigationController?.popToRootViewController(animated: false)
        
        let strNotification = notification.object as! String
        let storyboard = UIStoryboard(name:"Barber", bundle: nil)
        
        switch strNotification {
            /*
             ["Home", "Gallery", "Financial Center", "Manage Calendar","Search for a Chair","Manage Requests","Manage Services","Invite Customer","Logout"]
             */
            
        case "Home":
            break
        case "Gallery" :
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_GalleryVC_StoryboardID) as! BRD_Barber_GalleryVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Financial Center" :
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_FinancialCenterVC_StoryboardID) as! BRD_Barber_FinancialCenterVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Manage Calendar" :
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_ManageCalendarVC_StoryboardID) as! BRD_Barber_ManageCalendarVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Search for a Chair":
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_SearchChairVC_StoryboardID) as! BRD_Barber_SearchChairVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Manage Requests":
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_ManageRequestVC_StoryboardID) as! BRD_Barber_ManageRequestVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Manage Services":
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_ManageServiceVC_StoryboardID) as! BRD_Barber_ManageServiceVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Notifications":
            let vc = storyboard.instantiateViewController(withIdentifier: "BarberNotificationVC") as! BarberNotificationVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Invite Customer":
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_InviteCustomerVC_StoryboardID) as! BRD_Barber_InviteCustomerVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Invite to BarbrDo":
            let vc = storyboard.instantiateViewController(withIdentifier: "BarberInviteToBarbrDoVC") as! BarberInviteToBarbrDoVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "In-App Purchase":
            let vc = storyboard.instantiateViewController(withIdentifier: "InAppPurchaseVC") as! InAppPurchaseVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Manage Shops":
            let vc = storyboard.instantiateViewController(withIdentifier: "ManageShopVC") as! ManageShopVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Contact BarbrDo":
            let vc = storyboard.instantiateViewController(withIdentifier: "ContactBarbrDoOfficeVC") as! ContactBarbrDoOfficeVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Logout":
            _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: KAlertTitle, withMessage: "Do you really want to logout from the application", buttonTitles: ["OK", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
            }, returnBlock: { response in
                let value: Int = response
                if value == 0{
                    // Logout
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    appDelegate.logout()
                    
                }else{
                    // Do not logout
                }
            })
            return
        default:
            break
        }
    }
}

extension BarberDashboardVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableViewShops{
            return self.arrayPickerView.count
        }
        return self.arrayTableView.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        if tableView == tableViewShops{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            
            if !(cell != nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            }
            
            let associatedShop = self.arrayPickerView[indexPath.row]
            cell!.textLabel?.text = associatedShop.shopInfo![0].name!
            cell?.textLabel?.textAlignment = NSTextAlignment.center
            cell?.textLabel?.font = UIFont.init(name: "Berlin Sans FB", size: 12.0)
            return cell!
        }else{
            
             self.tableViewShops.isHidden = true
            
            if self.isBarberOnline == true{
                tableView.backgroundView = UIImageView(image: UIImage(named: "ICON_SHADEGREEN"))
            }else{
                tableView.backgroundView = UIImageView(image: UIImage(named: "ICON_SHADERED"))
            }
            
            if indexPath.row == 0{
                
                switch self.headerValue {
                case Dashboard.general.rawValue:
                    
                    let theheader = tableView.dequeueReusableCell(withIdentifier: "BarberDashboardGeneral") as! BarberDashboardGeneral
                    theheader.btnGoOnline.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                    if self.isBarberOnline == true{
                        theheader.imageViewBG.image = UIImage(named: "ICON_SHADEGREEN")
                    }else{
                        theheader.imageViewBG.image = UIImage(named: "ICON_SHADERED")
                    }
                    theheader.initWithData(revenue: self.strTotalRevenueFromApp, totalCutsFromApp: self.strTotalNumberofCuts)
                    theheader.btnGoToFinancialCenter.addTarget(self, action: #selector(btnGoToFinancialCenterAction), for: .touchUpInside)
                    return theheader
                    
                case Dashboard.goOnline.rawValue:
                    header = tableView.dequeueReusableCell(withIdentifier: "BarberDashboardHeader") as! BarberDashboardHeader
                    header.btnGoOnlineNow.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                    header.btnCancel.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                    header.btnSelectShop.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
                    header.initWithData(hairCut: self.strHairCutPrice, shaving: self.strShavingPrice, revenue: self.strTotalRevenueFromApp, totalCutsFromApp: self.strTotalNumberofCuts, assciatedShops: self.arrayPickerView, arrayService: self.arrayServices)
                    
                    header.btnGoToFinancialCenter.addTarget(self, action: #selector(btnGoToFinancialCenterAction), for: .touchUpInside)
                    
                    if self.isBarberOnline == true{
                        header.imageViewBG.image = UIImage(named: "ICON_SHADEGREEN")
                    }else{
                        header.imageViewBG.image = UIImage(named: "ICON_SHADERED")
                    }
                    return header
                    
                case Dashboard.goOffline.rawValue:
                    
                    let headerGoOffline = tableView.dequeueReusableCell(withIdentifier: "BarberDashboardIsOnline") as! BarberDashboardIsOnline
                    headerGoOffline.btnOffline.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                    headerGoOffline.btnCheckIN.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                    if self.isBarberOnline == true{
                        headerGoOffline.imageViewBG.image = UIImage(named: "ICON_SHADEGREEN")
                    }else{
                        headerGoOffline.imageViewBG.image = UIImage(named: "ICON_SHADERED")
                    }
                    headerGoOffline.btnSendMessage.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                    headerGoOffline.initWithData(objAppointmentData: self.objAppointmentInfo, revenue: self.strTotalRevenueFromApp, totalCutsFromApp: self.strTotalNumberofCuts)
                    
                    headerGoOffline.btnGoToFinancialCenter.addTarget(self, action: #selector(btnGoToFinancialCenterAction), for: .touchUpInside)
                    return headerGoOffline
                    
                case Dashboard.NoCustomerBooking.rawValue:
                    let noCustomerBooking = tableView.dequeueReusableCell(withIdentifier: "BarberDashboardNoCustomerBooking") as! BarberDashboardNoCustomerBooking
                    noCustomerBooking.initWithData(revenue:  self.strTotalRevenueFromApp, totalCutsFromApp: self.strTotalNumberofCuts)
                    noCustomerBooking.btnOffline.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                    noCustomerBooking.btnGoToFinancialCenter.addTarget(self, action: #selector(btnGoToFinancialCenterAction), for: .touchUpInside)
                    if self.isBarberOnline == true{
                        noCustomerBooking.imageViewBG.image = UIImage(named: "ICON_SHADEGREEN")
                    }else{
                        noCustomerBooking.imageViewBG.image = UIImage(named: "ICON_SHADERED")
                    }
                    return noCustomerBooking
                default:
                    break
                }
            }else if indexPath.row == self.arrayTableView.count - 1 {
                
                footer = tableView.dequeueReusableCell(withIdentifier: "BarberDashboardFooter") as! BarberDashboardFooter
                footer.btnBarber.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                footer.btnCustomer.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
                footer.btnSendInvitation.addTarget(self, action: #selector(btnSendInvitationAction(_:)), for: .touchUpInside)
                footer.initWithData(buttonTag: self.footerBtnSelected)
                if self.isBarberOnline == true{
                    footer.imageViewBG.image = UIImage(named: "ICON_SHADEGREEN")
                }else{
                    footer.imageViewBG.image = UIImage(named: "ICON_SHADERED")
                }
                return footer
                
            } else{
                let cell:BarberDashboardCell = tableView.dequeueReusableCell(withIdentifier: "BarberDashboardCell") as! BarberDashboardCell
//                if indexPath.row == self.arrayTableView.count - 2{
//                    cell.lblSeparator.isHidden = true
//                }else{
//                    cell.lblSeparator.isHidden = false
//                }
                cell.initWithData(associatedShop: self.arrayTableView[indexPath.row], isBarberOnline: self.isBarberOnline)
                
                cell.btnGoToManageShop.addTarget(self, action: #selector(btnGoToManageShopAction), for: .touchUpInside)
                
                if self.arrayTableView[indexPath.row].is_default == true{
                    self.selectedShop = self.arrayTableView[indexPath.row]
                }
                
                if self.isBarberOnline == true{
                    cell.imageViewBG.image = UIImage(named: "ICON_SHADEGREEN")
                }else{
                    cell.imageViewBG.image = UIImage(named: "ICON_SHADERED")
                }
                return cell
            }
        }        
        return UITableViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.tableViewShops.isHidden = true
    }
  
    
    func btnGoToManageShopAction(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageShopVC") as! ManageShopVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func btnGoToFinancialCenterAction(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: KBRD_Barber_FinancialCenterVC_StoryboardID) as! BRD_Barber_FinancialCenterVC
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableViewShops{
            
            if self.arrayPickerView.count == 0{return}
            self.selectedShop = self.arrayTableView[indexPath.row]
            let associatedShop = self.arrayPickerView[indexPath.row]
            let title: String = associatedShop.shopInfo![0].name!
            header.btnSelectShop.setTitle(title, for: .normal)
            
            for obj in self.arrayTableView{
                obj.is_default = false
            }
            let index = indexPath.row + 1
            let obj = self.arrayTableView[index]
            obj.is_default = true
            
            var arrayIndexPath = [IndexPath]()
            
            for i in 1 ..< self.arrayTableView.count - 1 {
                let indexPath = IndexPath.init(row: i, section: 0)
                arrayIndexPath.append(indexPath)
            }
            self.tableView.reloadRows(at: arrayIndexPath, with: .automatic)
            
            self.tableViewShops.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableViewShops{
            if self.arrayPickerView.count <= 3{
                let valu : Int = self.arrayPickerView.count * 25
                self.tableViewShopHeightConstraint.constant = CGFloat(valu)
                
            }else{
                 self.tableViewShopHeightConstraint.constant = 80.0
            }
            
            
            return 25.0
        }else{
            if indexPath.row == 0{
                
                switch self.headerValue {
                case Dashboard.general.rawValue:
                    return 197.0
                case Dashboard.goOnline.rawValue:
                    return 397.0
                case Dashboard.goOffline.rawValue:
                    return 329.0
                case Dashboard.NoCustomerBooking.rawValue:
                    return 179.0
                default:
                    return 197.0
                }
                
            }else if indexPath.row == self.arrayTableView.count - 1{
                return 280.0
            }else{
                return 76.0
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        header = tableView.dequeueReusableCell(withIdentifier: "BarberDashboardHeader") as! BarberDashboardHeader
//        header.backgroundColor = UIColor.clear
//        header.initWithData(hairCut: self.strHairCutPrice, shaving: self.strShavingPrice)
//        return header
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0 //357
//    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        footer = tableView.dequeueReusableCell(withIdentifier: "BarberDashboardFooter") as! BarberDashboardFooter
//        footer.btnBarber.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
//        footer.btnCustomer.addTarget(self, action: #selector(btnBarberCustomerAction), for: .touchUpInside)
//        return footer
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0 //295.0
//    }
    
    func btnSendInvitationAction(_ sender: UIButton){
        let inputString = self.footer.txtBarberOrCustomer.text!
        
        if BRDRawStaticStrings.isValidEmail(testStr: inputString) {
            self.invite(key: "referee_email", value: inputString)
            return
        } else if BRDRawStaticStrings.checkPhoneNumber(inputString: inputString) {
            self.invite(key: "referee_phone_number", value: inputString)
            return
        } else {
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter valid input", onViewController: self, returnBlock: { (clickedIN) in
                
            })
        }
        
    }
    
    private func invite(key: String, value: String){
        SwiftLoader.show("Sending", animated: true)
        var userType: String = ""
        if self.footerBtnSelected == 901{
            userType = "customer"
        }else{
            userType = "barber"
        }
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
        if header ==  nil{return}
        
            let inputParameters = ["invite_as": userType,
                                   key: value] as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KAppToRefer
            print(urlString)
            BRDAPI.inviteToBarbrDo("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                
                SwiftLoader.hide()
                
                if status == 200 {
                    // SUCCESS CASE
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Invite Sent Successfully", onViewController: self, returnBlock: { (clickedIN) in
                        self.footer.txtBarberOrCustomer.text = ""
                    })
                }else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in})
                }
            }
    }
    
        
    @IBAction func btnBarberCustomerAction(sender: UIButton){
        switch sender.tag {
        case 901:
            self.footerBtnSelected = 901
            footer.btnCustomer.isSelected = true
            footer.btnBarber.isSelected = false
            
            footer.lblMessage.text = KCustomerText
            break
        case 902:
            
            self.footerBtnSelected = 902
            footer.btnCustomer.isSelected = false
            footer.btnBarber.isSelected = true
            footer.lblMessage.text = KBarberText
            break
        case Dashboard.btnGoOnlineNow.rawValue:
            
            self.updateBarberGoOnline()
            break
        case Dashboard.btnGoOnline.rawValue:
            if self.header != nil{
                self.header.btnGoOnlineNow.backgroundColor = UIColor.darkGray

            }
            self.strHairCutPrice = ""
            self.strShavingPrice = ""
            
            self.isBarberOnline = false
            self.headerValue = 502
            self.tableView.reloadData()
            break
        case Dashboard.btnCancel.rawValue:
            self.isBarberOnline = false
            self.headerValue = 501
            
            self.tableView.reloadData()
            break
        case Dashboard.btnOffline.rawValue:
            self.updateBarberGoOffline()
            break
        case Dashboard.btnCheckIN.rawValue:
            customerCheckIN()
            break
        case Dashboard.btnSendMessage.rawValue:
            
            let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_ContactCustomerVC_StoryboardID) as! BRD_Barber_ContactCustomerVC
            vc.objAppointment = self.objAppointmentInfo
            vc.objCustomer = self.objCustomerInfo
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case Dashboard.btnNotificationReply.rawValue:
            
            self.view.endEditing(true)
            if self.txtFieldMessage.text?.characters.count == 0{
                return
            }
            
            let header = BRDSingleton.sharedInstane.getHeaders()
            
            let inputParameters: [String: String] =
                ["text": (self.txtFieldMessage.text)!,
                 "customer_id": (self.objCustomerInfo?._id)!,
                 "barber_id": (self.objAppointmentInfo?.barber_id)!]
            print(inputParameters)
            
            let urlString = KBaseURLString + KBarberSendMessageToCustomer
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
        case Dashboard.btnNotificationCancel.rawValue:
            self.view.endEditing(true)
            self.viewNotification.isHidden = true
            break
        default:
            break
        }
        
    }
    
    func customerCheckIN(){
        
//        let inputParameters: [String: Any] =
//            ["request_check_in": Date()]
        
        let inputParameters: [String: Any] =
            ["request_check_in": Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_)]
        
        let appointmentID = self.objAppointmentInfo?._id
        let urlString = KBaseURLString + KCustomerCheckIN + appointmentID!
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{return}
        
        BRDAPI.barberAcceptRequest("PUT", inputParameter: inputParameters, header: header!, urlString: urlString, completionHandler: { (reponse, responseString, status, error) in
            
            if status == 200{
                self.isBarberOnline = true
                self.headerValue = 510
                self.tableView.reloadData()
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return

            }
        })

    }
    
    
    func updateBarberGoOnline(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        if let cell = self.tableView.cellForRow(at: indexPath) as? BarberDashboardHeader{
            
            if (cell.txtFieldShave.text?.isEmpty)! && (cell.txtFieldHairCut.text?.isEmpty)!{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please enter price", onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
            var arrayServices = [Any]()
            if !(cell.txtFieldHairCut.text?.isEmpty)!{
                
                if self.arrayServices.count > 0{
                    let obj = self.arrayServices[0]
                    
                    let dict1 = ["service_id": obj.service_id,
                                 "name": obj.name,
                                 "price": cell.txtFieldHairCut.text!]
                    
                    arrayServices.append(dict1)
                }
                
            }
            
            if !(cell.txtFieldShave.text?.isEmpty)!{
                
                let obj = self.arrayServices[1]
                
                let dict2 = ["service_id": obj.service_id!,
                             "name": obj.name!,
                             "price": cell.txtFieldShave.text!] as [String : Any]
                
                arrayServices.append(dict2)
            }
            
            let shopName = cell.btnSelectShop.titleLabel?.text
            var shopID : String = ""
            for obj in self.arrayPickerView{
                if obj.shopInfo?[0].name == shopName{
                    shopID = (obj.shopInfo?[0]._id)!
                    break
                }
            }
            
            if shopID == ""{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please select the desired shop", onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
            
            let urlString = KBaseURLString + KBarberGoOnline
            let inputDictionary = ["services":arrayServices, "shop_id":shopID] as [String : Any]
            
            print(inputDictionary)
            let header = BRDSingleton.sharedInstane.getHeaders()
            
            if header == nil{
                return
            }
            SwiftLoader.show(KLoading, animated: true)
            
            BRDAPI.barberWentOnline("POST", inputParameter: inputDictionary, header: header!, urlString: urlString) { (resoponse, responseString, status, error) in
                SwiftLoader.hide()
                
                if status == 200{
                    self.isBarberOnline = true
                    self.headerValue = 510
                   // self.getBarberDetails()
                }else{
                    
                    if responseString != nil{
                        _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                        return
                    }
                    self.isBarberOnline = false
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    func updateBarberGoOffline(){
        
        let urlString = KBaseURLString + KBarberGoOffline
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            return
        }
        
        SwiftLoader.show(KLoading, animated: true)
        
        BRDAPI.barberGoOffline("PUT", inputParameter: nil, header: header!, urlString: urlString) { (resoponse, responseString, status, error) in
            SwiftLoader.hide()
            
            if status == 200 {
                self.isBarberOnline = false
                self.headerValue = 501
                self.getBarberDetails()
                
            }else{
                self.isBarberOnline = true
                self.headerValue = 503
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
            self.tableView.reloadData()
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(textField.tag)
        
        switch textField.tag {
        case 801:
            self.strHairCutPrice = textField.text!
            break
        case 802:
            self.strShavingPrice = textField.text!
            break
        case 803:
            self.strPhoneNumberOrEmail = textField.text!
            break
        default:
            break
        }
        //self.tableView.reloadData()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.tableViewShops.isHidden = true
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let inputString  = textField.text! + string
        
        if headerValue == 502{
            if let countdots = inputString.components(separatedBy: ".") as? [String]{
                if countdots.count == 2{
                    if countdots[1].characters.count == 3{
                        return false
                    }
                }
            }else if (inputString.characters.count == 3){
                return false
            }
        }
        
        
        
        switch textField.tag {
        case 801:
            if inputString.characters.count == 1 && string == "" || inputString.characters.count == 0 && self.header.txtFieldShave.text?.characters.count == 0{
                self.header.btnGoOnlineNow.backgroundColor = UIColor.darkGray
            }else{
                self.header.btnGoOnlineNow.backgroundColor = kNavigationBarColor
            }
//            if (inputString.characters.count == 4) {
//                 return false
//            }
            
            if let countdots = inputString.components(separatedBy: ".") as? [String]{
                if countdots.count == 1{
                    if countdots[0].characters.count == 3{
                        return false
                    }
                }
            }
            
           
            break
        case 802:
            if self.header.txtFieldHairCut.text?.characters.count == 0 && inputString.characters.count == 1 && string == "" || inputString.characters.count == 0{
                self.header.btnGoOnlineNow.backgroundColor = UIColor.darkGray
            }else{
                self.header.btnGoOnlineNow.backgroundColor = kNavigationBarColor
                
            }
//            if (inputString.characters.count == 4) {
//                return false
//            }
            if let countdots = inputString.components(separatedBy: ".") as? [String]{
                if countdots.count == 1{
                    if countdots[0].characters.count == 3{
                        return false
                    }
                }
            }
            
            break
        case 803:
            if inputString.characters.count == 1 && string == "" || inputString.characters.count == 0{
                
                self.footer.btnSendInvitation.backgroundColor = UIColor.darkGray
            }else{
                self.footer.btnSendInvitation.backgroundColor = kNavigationBarColor
            }
            
            break
        case 804:
            if inputString.characters.count == 0{
                self.btnNotReply.backgroundColor = UIColor.darkGray
                
            }else{
                self.btnNotReply.backgroundColor = kNavigationBarColor
            }
            break
        default:
            break
        }
        
        return true
    }
    
  
    
    func showPicker(){
        
        self.header.txtFieldShave.resignFirstResponder()
        self.header.txtFieldHairCut.resignFirstResponder()
        
        if self.arrayPickerView.count == 0{
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Please add your associated shop first", onViewController: self, returnBlock: { (clickedIN) in
                
            })
            return
        }

        self.tableViewShops.isHidden = false
        self.tableViewShops.reloadData()
        
//        self.pickerView.isHidden = false
//        self.tootBar.isHidden = false
//        
//        self.pickerView.reloadAllComponents()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let associatedShop = self.arrayPickerView[row]
        let title: String = associatedShop.shopInfo![0].name!
        return title
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.arrayPickerView.count == 0{return}
        self.selectedShop = self.arrayTableView[row]
        let associatedShop = self.arrayPickerView[row]
        let title: String = associatedShop.shopInfo![0].name!
        header.btnSelectShop.setTitle(title, for: .normal)
        
        
        
        for obj in self.arrayTableView{
            obj.is_default = false
        }
        let index = row + 1
        let obj = self.arrayTableView[index]
        obj.is_default = true
        
        //self.tableView.reloadData()
        
//        let indexPath = NSIndexPath(forRow: rowNumber, inSection: 0)
//        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
        
        var arrayIndexPath = [IndexPath]()
        
        for i in 1 ..< self.arrayTableView.count - 1 {
             let indexPath = IndexPath.init(row: i, section: 0)
            arrayIndexPath.append(indexPath)
        }
        self.tableView.reloadRows(at: arrayIndexPath, with: .automatic)
    }
}

