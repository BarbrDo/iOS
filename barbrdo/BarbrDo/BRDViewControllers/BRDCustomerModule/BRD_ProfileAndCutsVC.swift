//
//  BRD_ProfileAndCutsVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 27/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_ProfileAndCutsVC_StoryboardID = "BRD_ProfileAndCutsVC_StoryboardID"

class BRD_ProfileAndCutsVC: BRD_BaseViewController, CAPSPageMenuDelegate{
    
    var pageMenu : CAPSPageMenu?
    var controllerArray = [UIViewController]()
    var header: BRD_ProfileViewHeader? = nil
    var objProfile: BRD_UserInfoBO? = nil
    var showCuts: Bool = false
    
    var objSelectedBarber: BRD_BarberInfoBO? = nil
    var objSelectedShopData: BRD_ShopDataBO? = nil
    
    var objUserProfile : BRD_UserProfileBO? = nil
    
    @IBOutlet weak var viewTopBar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.header = (Bundle.main.loadNibNamed(String(describing: BRD_ProfileViewHeader.self), owner: self, options: nil)![0] as? BRD_ProfileViewHeader)!
        self.header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:210)
        self.header?.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        
        if self.objUserProfile != nil{
            self.header?.lblProfile.text = "Customer Profile"
        }else{
            self.header?.lblProfile.text =  "Barber Profile"
        }
        self.header?.btnPhoto.addTarget(self, action: #selector(ProfileScreenButtonAction(sender:)), for: .touchUpInside)
        self.header?.btnCuts.addTarget(self, action: #selector(ProfileScreenButtonAction(sender:)), for: .touchUpInside)
        
        if self.objUserProfile != nil {
            
            self.header?.initWithData(obj: nil, objUserProfile: self.objUserProfile)
        }else if self.objProfile != nil{
            self.header?.initWithData(obj: objProfile!)
        }else{
           let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
            self.header?.initWithData(obj: obj!)
        }
        
        self.viewTopBar.addSubview(self.header!)
        
        let controller1 : BRD_ProfilePhotoVC = self.storyboard!.instantiateViewController(withIdentifier: KBRD_ProfilePhotoVC_StoryboardID) as! BRD_ProfilePhotoVC
        controller1.objBarberInfo = self.objProfile
        controller1.objSelectedBarber = self.objSelectedBarber
        controller1.objSelectedShopData = self.objSelectedShopData
        
        if let arrayPics = self.objProfile?.gallery{
            controller1.arrayCollectionView = arrayPics
        }
        if self.objUserProfile != nil{
            controller1.objUserProfile = self.objUserProfile!
            if let arrayPics = self.objUserProfile?.gallery{
                controller1.arrayCollectionView = arrayPics
            }
        }
        controllerArray.append(controller1)
        
        let controller2 : BRD_ProfileCutsVC = self.storyboard!.instantiateViewController(withIdentifier: KBRD_ProfileCutsVC_StoryboardID) as! BRD_ProfileCutsVC
        controller2.objSelectedBarber = self.objSelectedBarber
        controller2.objSelectedShopData = self.objSelectedShopData
        if self.objUserProfile != nil{
            
            if let arrayRating = self.objUserProfile?.ratings{
                controller2.arrayTableView = arrayRating
            }
        }else if let customerProfile = self.objProfile?.rating{
            controller2.arrayTableView = customerProfile
        }
        
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 210, width: self.view.frame.width, height: self.view.frame.height-210), pageMenuOptions: parameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        
        self.view.addSubview(pageMenu!.view)
        self.addChildViewController(pageMenu!)
        
        self.header?.btnPhoto.setTitleColor(kNavigationBarColor, for: .normal)
        self.header?.btnCuts.setTitleColor(UIColor.gray, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if showCuts == true{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                // Put your code which should be executed with a delay here
                
                self.showCuts = false
                let btn = UIButton()
                btn.tag = 102
                self.ProfileScreenButtonAction(sender: btn)
            })
        }
    }
    
    @objc private func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func ProfileScreenButtonAction(sender: UIButton){
        
        if sender.tag == 101{
            self.header?.btnPhoto.setTitleColor(kNavigationBarColor, for: .normal)
            self.header?.btnCuts.setTitleColor(UIColor.gray, for: .normal)
            
            pageMenu?.moveToPage(0)
        }else{
            self.header?.btnPhoto.setTitleColor(UIColor.gray, for: .normal)
            self.header?.btnCuts.setTitleColor(kNavigationBarColor, for: .normal)
            pageMenu?.moveToPage(1)
        }
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {

        if index == 0{
            self.header?.btnPhoto.setTitleColor(kNavigationBarColor, for: .normal)
            self.header?.btnCuts.setTitleColor(UIColor.gray, for: .normal)
            
        }else{
            self.header?.btnPhoto.setTitleColor(UIColor.gray, for: .normal)
            self.header?.btnCuts.setTitleColor(kNavigationBarColor, for: .normal)
        }
    }
    
    
}
