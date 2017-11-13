//
//  BRD_Barber_DashboardVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/18/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation

let KBRD_Barber_DashboardVC_StoryboardID = "BRD_Barber_DashboardVCStoryboardID"
let KBarberSideMenuTapped = "SideMenuTapped"
private enum BarberDashboardScreenButton: Int{
    
    case btnPending = 101
    case btnConfirmed
}


class BRD_Barber_DashboardVC: BRD_BaseViewController, CAPSPageMenuDelegate {
    
    var pageMenu : CAPSPageMenu?
    var arrayTableView = [Any]()
    
    var locationManager: BRD_LocationManager?
    var callOnce: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var lblPending: UILabel!
    @IBOutlet weak var btnConfirmed: UIButton!
    @IBOutlet weak var lblConfirmed: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTopNavigationBar(title: "")
        var controllerArray = [UIViewController]()
        
        let controller1 : BRD_Barber_PendingVC = self.storyboard!.instantiateViewController(withIdentifier: KBRD_Barber_PendingVC_StoryboardID) as! BRD_Barber_PendingVC
        controller1.title = "PENDING"
        
        controllerArray.append(controller1)
        
        let controller2 : BRD_Barber_ConfirmedVC = self.storyboard!.instantiateViewController(withIdentifier: KBRD_Barber_ConfirmedVC_StoryboardID) as! BRD_Barber_ConfirmedVC
        controller2.title = "CONFIRMED"
        
        controllerArray.append(controller2)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(kPageMenuColor),
            .viewBackgroundColor(kPageMenuColor),
            .bottomMenuHairlineColor(KAppGreyColor),
            .selectionIndicatorColor(UIColor.white),
            .menuMargin(20.0),
            .menuHeight(40.0),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
            .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 75, width: self.view.frame.width, height: self.view.frame.height-75), pageMenuOptions: parameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
        self.addChildViewController(pageMenu!)
        // Do any additional setup after loading the view.
        //        self.addTopNavigationBar()
        //
        NotificationCenter.default.addObserver(self, selector: #selector(BRD_Barber_DashboardVC.menuTapNotification(notification:)), name: NSNotification.Name(rawValue: KBarberSideMenuTapped), object: nil)
        // Do any additional setup after loading the view.
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
            
        case "In-App Purchase":
            
            let vc = storyboard.instantiateViewController(withIdentifier: "InAppPurchaseVC") as! InAppPurchaseVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
            
        case "Logout":
            
            _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: "BarbrDo", withMessage: "Do you really want to logout from the application", buttonTitles: ["OK", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func barberDashboardScreenButtonAction(_ sender: UIButton) {
        
        //        switch sender.tag {
        //        case CustomerDashboardScreenButton.btnUpcoming.rawValue:
        //            self.btnUpcoming.isSelected = true
        //            self.btnCompleted.isSelected = false
        //
        //            self.lblUpcoming.backgroundColor = UIColor.white
        //            self.lblCompleted.backgroundColor = UIColor.init(colorLiteralRed: 37/255.0, green: 63/255.0, blue: 159/255.0, alpha: 1.0)
        //            break
        //        case CustomerDashboardScreenButton.btnCompleted.rawValue:
        //            self.btnUpcoming.isSelected = false
        //            self.btnCompleted.isSelected = true
        //
        //            self.lblCompleted.backgroundColor = UIColor.white
        //            self.lblUpcoming.backgroundColor = UIColor.init(colorLiteralRed: 37/255.0, green: 63/255.0, blue: 159/255.0, alpha: 1.0)
        //            break
        //        default:
        //            self.btnUpcoming.isSelected = true
        //            self.btnCompleted.isSelected = false
        //
        //            self.lblUpcoming.backgroundColor = UIColor.white
        //            self.lblCompleted.backgroundColor = UIColor.init(colorLiteralRed: 37/255.0, green: 63/255.0, blue: 159/255.0, alpha: 1.0)
        //            break
        //        }
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
