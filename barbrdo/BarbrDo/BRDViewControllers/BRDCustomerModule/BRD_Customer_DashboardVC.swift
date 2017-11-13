//
//  BRD_Customer_DashboardVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 03/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation

let KBRD_Customer_DashboardVC_StoryboardID = "BRD_Customer_DashboardVCStoryboardID"
let KSideMenuTapped = "SideMenuTapped"

private enum CustomerDashboardScreenButton: Int{
    
    case btnUpcoming = 101
    case btnCompleted
}

class BRD_Customer_DashboardVC: BRD_BaseViewController , CAPSPageMenuDelegate{
    
    
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
        
        let controller1 : BRD_Customer_UpcomingVC = self.storyboard!.instantiateViewController(withIdentifier: KBRD_Customer_UpcomingVC_StoryboardID) as! BRD_Customer_UpcomingVC
        controller1.title = "UPCOMING"
        
        controllerArray.append(controller1)
        
        
        let controller2 : BRD_Customer_CompletedVC = self.storyboard!.instantiateViewController(withIdentifier: KBRD_Customer_CompletedVC_StoryboardID) as! BRD_Customer_CompletedVC
        controller2.title = "COMPLETED"
        
        controllerArray.append(controller2)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(KAppGreyColor),
            .viewBackgroundColor(KAppGreyColor),
            .bottomMenuHairlineColor(KAppGreyColor),
            .selectionIndicatorColor(UIColor.white),
            .menuMargin(0),
            .menuHeight(0.0),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
            .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(0),
            .menuItemSeparatorPercentageHeight(0)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 115, width: self.view.frame.width, height: self.view.frame.height-115), pageMenuOptions: parameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        
        self.view.addSubview(pageMenu!.view)
        self.addChildViewController(pageMenu!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BRD_Customer_DashboardVC.menuTapNotification(notification:)), name: NSNotification.Name(rawValue: KSideMenuTapped), object: nil)
        
        
        if showCompleted == true{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                // Put your code which should be executed with a delay here
                
                self.showCompleted = false
                let btn = UIButton()
                btn.tag = 102
                self.DashboardScreenbtnAction(btn)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
        if index == 0{
            
            self.btnUpcoming.setTitleColor(UIColor.white, for: .normal)
            self.btnCompleted.setTitleColor(UIColor.lightGray, for: .normal)
            
            self.viewUpComing.backgroundColor = KWhiteColor
            self.viewCompleted.backgroundColor = KThemeBackgroundColor

        }else{
            self.btnUpcoming.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnCompleted.setTitleColor(UIColor.white, for: .normal)
            
            self.viewUpComing.backgroundColor = KThemeBackgroundColor
            self.viewCompleted.backgroundColor = KWhiteColor
            
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
        case "Invite Customer":
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_InviteCustomerVC_StoryboardID) as! BRD_Barber_InviteCustomerVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Favorite Barbers":
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_InviteCustomerVC_StoryboardID) as! FavoriteBarbersVC
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






