//
//  DashboardVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 26/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation


//let KSideMenuTapped = "SideMenuTapped"

private enum CustomerDashboardScreenButton: Int{
    
    case btnUpcoming = 101
    case btnCompleted
}

class CustomerDashboardVC: BRD_BaseViewController , CAPSPageMenuDelegate {
    
    
    var pageMenu : CAPSPageMenu?
    var arrayTableView = [Any]()
    
    var locationManager: BRD_LocationManager?
    var callOnce: Bool = true
    
    var controllerArray = [UIViewController]()
    
    var showCompleted: Bool? = false
    
    @IBOutlet weak var btnUpcoming: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    
    @IBOutlet weak var viewUpComing: UIView!
    @IBOutlet weak var viewCompleted: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTopNavigationBar(title: "")
        var controllerArray = [UIViewController]()
        
        let controller1 : CustomerMapViewVC = self.storyboard!.instantiateViewController(withIdentifier: "CustomerMapViewVC") as! CustomerMapViewVC
        controller1.title = "MAP VIEW"
        
        controllerArray.append(controller1)
        
        let controller2 : CustomerListViewVC = self.storyboard!.instantiateViewController(withIdentifier: "CustomerListViewVC") as! CustomerListViewVC
        controller2.title = "LIST VIEW"
        
        controllerArray.append(controller2)
        //
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(kPageMenuColor),
            .viewBackgroundColor(kPageMenuColor),
            .bottomMenuHairlineColor(kPageMenuColor),
            .selectionIndicatorColor(UIColor.white),
            .menuMargin(20.0),
            .menuHeight(40.0),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
            .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2),
            .menuItemSeparatorPercentageHeight(0)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 74, width: self.view.frame.width, height: self.view.frame.height-74), pageMenuOptions: parameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
        self.addChildViewController(pageMenu!)
        
        
        // Do any additional setup after loading the view.
        //        self.addTopNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(BRD_Barber_DashboardVC.menuTapNotification(notification:)), name: NSNotification.Name(rawValue: KBarberSideMenuTapped), object: nil)
        
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(customerModuleReceivePushNotification(notification:)), name: NSNotification.Name(rawValue: KBarberConfirmAppointment), object: nil)
        
        // Register for Barber Cancel Appointment
        
        NotificationCenter.default.addObserver(self, selector: #selector(customerModuleReceivePushNotification(notification:)), name: NSNotification.Name(rawValue: KBarberCancelAppointment), object: nil)

        // Barber Completed Appointment
        NotificationCenter.default.addObserver(self, selector: #selector(customerModuleReceivePushNotification(notification:)), name: NSNotification.Name(rawValue: KBarberCompletedAppointment), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
        
//        self.view.updateConstraintsIfNeeded()
        self.view.updateConstraints()
        
        if controllerArray.count > 0{
        
            let obj = controllerArray[0]
            obj.view.layoutSubviews()
        }
        
        
    }
    
    
    
    func customerModuleReceivePushNotification(notification: NSNotification){
        
        
        let notificationName = notification.name.rawValue
        
        switch notificationName{
        
            case KBarberConfirmAppointment:
                if let arrayObj = notification.object as? [String: Any]{
                    
                    if let dict = arrayObj["message"] as? [String: Any]{
                        
                        let obj = BarberConfirmAppointmentBO.init(dictionary: dict as NSDictionary)
                        
                        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "BarberAcceptedRequestVC") as! BarberAcceptedRequestVC
                        vc.objBarberConfirmAppointment = obj
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            break
        
            case KBarberCancelAppointment:
                
                var declineMessage = ""
                if let notificationObj = notification.object as? NSDictionary{
                    
                    if let aps = notificationObj["aps"] as? NSDictionary {
                         if let alert = aps["alert"] as? NSString {
                            //Do stuff
                            declineMessage = alert as String
                        }
                    }
                }
                // Stop Customer Timer
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KBarberDeclineRequest), object: nil)
                    
                    break
        case KBarberCompletedAppointment:
            
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RateYourExperienceVC") as! RateYourExperienceVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        default:
            break
        
        }
        
    }
    
    
    
    @IBAction func DashboardScreenbtnAction(_ sender: UIButton) {
        
        if sender.tag == 101{
            pageMenu?.moveToPage(0)
        }else{
            pageMenu?.moveToPage(1)
        }
    }
    
    
    
    func menuTapNotification(notification:NSNotification) {
        self.navigationController?.popToRootViewController(animated: false)
        
        let strNotification = notification.object as! String
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        
        switch strNotification {
            
        case "Home":
            break
        case "Gallery" :
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_GalleryVC_StoryboardID) as! BRD_Customer_GalleryVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Notifications" :
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_NotificationVC_StoryboardID) as! BRD_Customer_NotificationVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Invite Barber":
            
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_InviteCustomerVC_StoryboardID) as! BRD_Barber_InviteCustomerVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Favorite Barbers":
            let vc = storyboard.instantiateViewController(withIdentifier: "FavoriteBarbersVC") as! FavoriteBarbersVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Contact BarbrDo":
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomerContactBarbrDoVC") as! CustomerContactBarbrDoVC
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
            break
        case "Edit":
            
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    
    @IBAction func btnAddAnAppointment(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_ScheduleAnAppointmentVC_StoryboardID) as! BRD_Customer_ScheduleAnAppointmentVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
