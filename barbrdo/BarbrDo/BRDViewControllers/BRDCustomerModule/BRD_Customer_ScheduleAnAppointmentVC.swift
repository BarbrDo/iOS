    //
//  BRD_Customer_ScheduleAnAppointmentVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 11/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
//import PageMenu


let KBRD_Customer_ScheduleAnAppointmentVC_StoryboardID = "BRD_Customer_ScheduleAnAppointmentVC_StoryboardID"

private enum ScheduleAnAppointment: Int{
    
    case btnUpcoming = 101
    case btnCompleted
}

class BRD_Customer_ScheduleAnAppointmentVC: BRD_BaseViewController , CAPSPageMenuDelegate{
    
    @IBOutlet weak var btnViewShops: UIButton!
    @IBOutlet weak var btnViewBarbers: UIButton!
    
    @IBOutlet weak var viewShops: UIView!
    @IBOutlet weak var viewBarbers: UIView!
    
    
    var pageMenu : CAPSPageMenu?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTopNavigationBar(title: "")
        var controllerArray = [UIViewController]()
        
        let controller1 : BRD_Customer_ViewShopsVC = self.storyboard!.instantiateViewController(withIdentifier: KBRD_Customer_ViewShopsVC_StoryboardID) as! BRD_Customer_ViewShopsVC
        controller1.title = "View Shops"
       
        controllerArray.append(controller1)

        
        let controller2 : BRD_Customer_ViewBarbersVC = self.storyboard!.instantiateViewController(withIdentifier: KBRD_Customer_ViewBarbersVC_StoryboardID) as! BRD_Customer_ViewBarbersVC
        controller2.title = "View Barbers"
        
        controllerArray.append(controller2)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(KAppGreyColor),
            .viewBackgroundColor(KAppGreyColor),
            .bottomMenuHairlineColor(KAppGreyColor),
            .selectionIndicatorColor(UIColor.white),
            .menuMargin(20.0),
            .menuHeight(0.0),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
            .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0)
        ]

        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 115, width: self.view.frame.width, height: self.view.frame.height-115), pageMenuOptions: parameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        
        self.view.addSubview(pageMenu!.view)
        self.addChildViewController(pageMenu!)
        
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
        if index == 0{
            
            self.btnViewShops.setTitleColor(UIColor.white, for: .normal)
            self.btnViewBarbers.setTitleColor(UIColor.lightGray, for: .normal)
            
            self.viewShops.backgroundColor = KWhiteColor
            self.viewBarbers.backgroundColor = KThemeBackgroundColor
            
        }else{
            self.btnViewShops.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnViewBarbers.setTitleColor(UIColor.white, for: .normal)
            
            self.viewShops.backgroundColor = KThemeBackgroundColor
            self.viewBarbers.backgroundColor = KWhiteColor
            
        }
    }
    override func didMove(toParentViewController parent: UIViewController?) {
        
    }
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        print(index)
    }
    
    override func didReceiveMemoryWarning() {
        //super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func scheduleAppointmentButtonAction(sender: UIButton){
        if sender.tag == 101{
            pageMenu?.moveToPage(0)
        }else{
            pageMenu?.moveToPage(1)
        }
    }
    
}
