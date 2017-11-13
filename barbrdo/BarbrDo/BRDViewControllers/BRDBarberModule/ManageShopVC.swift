//
//  ManageShopVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 17/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

class ManageShopCell: UITableViewCell{
    
    @IBOutlet weak var imageViewShop: UIImageView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var imgViewDefault: UIImageView!
    @IBOutlet weak var lblShopAsDefault: UILabel!
    @IBOutlet weak var btnDefault: UIButton!
    
    override func awakeFromNib() {
        
        
    }
    
    
    func initWithData(objShopData: BRD_ShopDataBO){
        
        var address = ""
        if let shopName = objShopData.name{
            address = shopName + "\n"
        }
        if let shopDetails = objShopData.address {
            address = address + shopDetails + ", \n"
        }
        if let city = objShopData.city {
            address = address + city + ", "
        }
        if let state = objShopData.state {
            address = address + state + ", "
        }
        if let zip = objShopData.zip {
            address = address + zip
        }
        self.lblShopName.text = address
        
        if objShopData.is_Default == true{
            self.imgViewDefault.image = UIImage(named: "ICON_DEFAULTSHOP")
            self.lblShopAsDefault.text = "Default Shop"
        }else{
            self.imgViewDefault.image = UIImage(named: "ICON_NORMALSHOP")
            self.lblShopAsDefault.text = "Default Shop"
        }
    }
}

class ManageShopVC: BRD_BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddAShop: UIButton!
    
    var arrayTableView = [BRD_ShopDataBO]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.addTopNavigationBar(title: "Manage Your Shops")
        
        let header : NavigationBarWithTitleAndBack = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitleAndBack.self), owner: self, options: nil)![0] as! NavigationBarWithTitleAndBack
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.btnProfile.addTarget(self, action: #selector(btnProfileMenu), for: .touchUpInside)
        header.initWithTitle(title: "Manage Your Shops")
        header.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        self.view.addSubview(header)
        
    }
    func btnBackAction(){
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnProfileMenu(){
        
        let storyboard = UIStoryboard(name:"Barber", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_Profile_StoryboardID) as! BRD_Barber_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        getAllShops()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllShops(){
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        SwiftLoader.show("Fetching data...", animated: true)
        let userObj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
//
        let urlString: String = KBaseURLString + KBarberDetail + (userObj?._id)!
        print(urlString)
        BRDAPI.getAllShops("GET", inputParameters: nil, header: header, urlString: urlString) { (arrayShops, error) in
            
            
            SwiftLoader.hide()
            if arrayShops != nil{
                self.arrayTableView.removeAll()
                if (arrayShops?.count)! > 0{
                    self.arrayTableView = (arrayShops?[0].shops!)!
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    
    @IBAction func btnAddAShopAction(sender: UIButton){
        
        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddAShopVC") as! AddAShopVC
        self.navigationController?.pushViewController(vc, animated: false)

    }
}

extension ManageShopVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrayTableView.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageShopCell", for: indexPath) as? ManageShopCell
        
        cell?.initWithData(objShopData: self.arrayTableView[indexPath.row])
        cell?.btnDefault.addTarget(self, action: #selector
            (btnRequestBarberAction(_:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
//            KDeleteAssociatedShop
            var ShopID : String = ""
            if let obj = self.arrayTableView[indexPath.row] as? BRD_ShopDataBO{
                ShopID = obj._id!
            }
            
            SwiftLoader.show(KLoading, animated: true)
            
            let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
            if header ==  nil{return}
            
            let inputParameters = ["shop_id": ShopID] as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KDeleteAssociatedShop
            
            print(urlString)
            
            BRDAPI.deleteAssociatedShop("DELETE", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseMessage, statusCode, error) in
                
                SwiftLoader.hide()
                
                if statusCode == 200 {
                    // SUCCESS CASE
                    self.arrayTableView.remove(at: indexPath.row)
                    
                    self.tableView.reloadData()
                    
                }else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                        
                    })
                    return
                }
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // Request Barber
    @IBAction func btnRequestBarberAction(_ sender: UIButton) {
        
        var ShopID : String = ""
        
        // CAll API for MAKING SHOP AS DEFAULT
        
        for obj in self.arrayTableView{
            obj.is_Default = false
        }
        
        let indexPath = BRDUtility.indexPath(self.tableView, sender)

        
        if let obj = self.arrayTableView[indexPath.row] as? BRD_ShopDataBO{
            obj.is_Default = true
            ShopID = obj._id!
        }
        
        
        SwiftLoader.show(KLoading, animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()!
        if header ==  nil{return}
        
        let inputParameters = ["shop_id": ShopID] as [String: Any]
        print(inputParameters)
        let urlString = KBaseURLString + KMakeDefaultShop
        
        print(urlString)
        
        BRDAPI.makeChairAsDefault("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (response, responseMessage, statusCode, error) in
            
            SwiftLoader.hide()
            
            if statusCode == 200 {
                
                // SUCCESS CASE
                self.tableView.reloadData()
                
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
            }
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
        
        
    }
}
