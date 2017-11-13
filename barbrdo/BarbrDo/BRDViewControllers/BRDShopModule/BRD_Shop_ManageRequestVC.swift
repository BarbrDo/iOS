//
//  BRD_Shop_ManageRequestVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/31/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
let KBRD_Shop_ManageRequestVC_StoryboardID = "BRD_Shop_ManageRequestVCStoryboardID"
class BRD_Shop_ManageRequestVC: BRD_BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var arrayTableView = [BRD_ChairInfo]()
    var refreshControl: UIRefreshControl!
    
    var barberInfo = [BRD_BarberInfoBO]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTopNavigationBar(title: "")
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.getManageRequestList()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getManageRequestList()
    }
    
    func getManageRequestList(){
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{return}
        
        if  let user_id =   BRDSingleton.sharedInstane.objShopInfo?._id
        {
            SwiftLoader.show("Loading Requests...", animated: true)
            
            let urlString = KBaseURLString + kbarberchairrequests + "/" + user_id
            
            BRDAPI.getManageChairListing(requestType: "GET", inputParameters: nil, header: header!, urlString: urlString) { (response, arrayServices, status, error) in
                
                SwiftLoader.hide()
                self.arrayTableView.removeAll()
                if(arrayServices != nil)
                {
                if  (arrayServices?.count)! > 0
                    
                {
                    BRDSingleton.removeEmptyMessage(self.view)
                    
                    for obj in arrayServices!
                    {
                        if(obj.isActive == true)
                        {
                            self.arrayTableView.append(obj)
                        }
                        
                    }
                    
                    
                    self.tableView.reloadData()
                }
                    
                else
                {
                    self.arrayTableView.removeAll()
                    self.tableView.reloadData()
                    self.view.addSubview(BRDSingleton.showEmptyMessage("No Request Found.", view: self.view))
                }
                
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                        
                        
                    })
                    return
                }
            }
            }}
        else
        {
            self.view.addSubview(BRDSingleton.showEmptyMessage("No Request Found.", view: self.view))
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Could not connect to server", onViewController: self, returnBlock: { (clickedIN) in
                
                
            })
            return
        }
        
    }
    
    
    //MARK:- UITableView DataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("no of row --\(self.arrayTableView.count)")
        
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! ManageChairRequestCell
        cell.chairSplitLbl.text = nil
        cell.barberLbl.text = nil
        cell.titleLbl.text = nil
        let obj = self.arrayTableView[indexPath.row]
        
        
            
            if(obj.availability?.lowercased() == booked)
            {
                cell.profileImage.image = UIImage(named : "ICON_PROFILEIMAGE")
                cell.chairSplitLbl.isHidden = false
                // cell.chairLblTopConstraint.constant = 10
                
                cell.titleLbl.text = obj.name
                //                if let barberName = obj.barber_name
                //                {
                //                    cell.barberLbl.text = "By: \(barberName)"
                //                }
                if let shopPercent = obj.shop_percentage
                {
                    cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                    
                }
                else
                {
                    cell.chairSplitLbl.text = "Chair Split : 0/0"
                    // cell.chairLblTopConstraint.constant = 30
                }
                if (obj.type == "self")
                {
                    cell.chairSplitLbl.text = "Booked by Non-BarbrDo Barber"
                }
                
                
            }
                
                
            else if ( obj.availability?.lowercased() == available )
                
            {
                
                if(obj.type == monthly)
                {
                    cell.titleLbl.text = obj.name
                    // cell.barberLbl.isHidden  = true
                    cell.chairSplitLbl.isHidden = false
                    // cell.chairLblTopConstraint.constant = 30
                    
                    if let amount = obj.amount
                    {
                        let convertAmount = String(format: "%.1f", amount)
                        cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/month"
                    }
                    
                }
                else    if(obj.type == weekly)
                {
                    cell.titleLbl.text = obj.name
                    // cell.barberLbl.isHidden  = true
                    cell.chairSplitLbl.isHidden = false
                    // cell.chairLblTopConstraint.constant = 30
                    
                    if let amount = obj.amount
                    {
                        let convertAmount = String(format: "%.1f", amount)
                        cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/week"
                    }
                }
                else if(obj.type == percentage)
                {
                    cell.titleLbl.text = obj.name
                    // cell.barberLbl.isHidden = true
                    cell.chairSplitLbl.isHidden = false
                    
                    if let shopPercent = obj.shop_percentage
                    {
                        cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                        // cell.chairLblTopConstraint.constant = 30
                        
                    }
                }
            
                
                
                
            else if (obj.availability?.lowercased() == closed  && obj.type?.lowercased() == percentage )
            {
                cell.titleLbl.text = obj.name
                // cell.barberLbl.isHidden  = true
                cell.chairSplitLbl.isHidden = false
                // cell.chairLblTopConstraint.constant = 30
                
                if let shopPercent = obj.shop_percentage
                {
                    cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                    
                }
                
                
                
                
            }
                
                
            else if (obj.availability?.lowercased() == closed )
            {
                
                if(obj.type == monthly)
                {
                    cell.titleLbl.text = obj.name
                    // cell.barberLbl.isHidden  = true
                    cell.chairSplitLbl.isHidden = false
                    // cell.chairLblTopConstraint.constant = 30
                    
                    if let amount = obj.amount
                    {
                        let convertAmount = String(format: "%.1f", amount)
                        cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/month"
                    }
                    
                }
                else    if(obj.type == weekly)
                {
                    cell.titleLbl.text = obj.name
                    // cell.barberLbl.isHidden  = true
                    cell.chairSplitLbl.isHidden = false
                    // cell.chairLblTopConstraint.constant = 30
                    
                    if let amount = obj.amount
                    {
                        let convertAmount = String(format: "%.1f", amount)
                        cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/week"
                    }
                    
                }
                    
                else
                {
                    
                    cell.barberLblTopConstraint.constant = 0
                    // cell.chairLblTopConstraint.constant = 30
                    cell.titleLbl.text = obj.name
                    // cell.barberLbl.isHidden = false
                    cell.barberLbl.text = "empty"
                    cell.chairSplitLbl.isHidden = true
                }
            }
            
            
        }
        
        
        //
        
        
        
        //
        
        if (BRDSingleton.sharedInstane.objManageRequestInfo != nil)
        {
            let barberObj = BRDSingleton.sharedInstane.objManageRequestInfo?[indexPath.row]
            
            if(barberObj?.requested_by?.lowercased() == "shop")
            {
                cell.acceptBtn.isHidden = true
                cell.rejectBtn.isHidden = true
                cell.pendingBtn.isHidden = false
                cell.pendingBtn.isUserInteractionEnabled = false

            }
            else
            {
                cell.acceptBtn.isHidden = false
                cell.rejectBtn.isHidden = false
                cell.pendingBtn.isHidden = true

            }
            
            
            cell.initWithData(obj: barberObj?.barberInfo?[0])
        }

      
        cell.acceptBtn.tag = indexPath.row
        cell.rejectBtn.tag = indexPath.row
        
        cell.acceptBtn.addTarget(self, action: #selector(BRD_Shop_ManageRequestVC.acceptBtnAction), for: .touchUpInside)
        
        cell.rejectBtn.addTarget(self, action: #selector(BRD_Shop_ManageRequestVC.rejectBtnAction), for: .touchUpInside)
        
        
        return cell
        
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let barberArray = BRDSingleton.sharedInstane.objManageRequestInfo?[indexPath.row].barberInfo
          let   barberID = barberArray?[0]._id
//        if let barberID = BRDSingleton.sharedInstane.objBarberdetailInfo?[indexPath.row]._id
        do {
            let objBarber : BRD_BarberInfoBO = BRD_BarberInfoBO.init()
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
                
                
                objBarber._id = barberID
                vc.objBarber = objBarber
                UserDefaults.standard.set(true, forKey: "ShopDashboard")
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }

    func acceptBtnAction(sender:UIButton) {
        
        let chairInfoObj = self.arrayTableView[sender.tag]
        let manageRequest =    BRDSingleton.sharedInstane.objManageRequestInfo
        
        SwiftLoader.show(KUpdating, animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        if let obj = chairInfoObj._id
        {
            
            let inputParameters = ["chair_request_id": manageRequest?[sender.tag]._id   , "request_type" : "accept" ]
                as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KAcceptRejectRequest
            
            print(urlString)
            BRDAPI.updateService("PUT", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if let serverMessage = responseMessage {
                    if serverMessage == "Shop chair request accepted successfully"{
                        
                        // SUCCESS CASE
                        _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Shop chair request accepted successfully", onViewController: self, returnBlock: { (clickedIN) in
                        })
                        self.getManageRequestList()
                    }
                }
                else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please add chair information in order to post chair to barbers.", onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }
                
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please add chair information in order to post chair to barbers.", onViewController: self, returnBlock: { (clickedIN) in
                        
                        
                    })
                    return
                }
            }
        }
        
        self.tableView.reloadData()
        
        
    }
    
    
    
    
    func rejectBtnAction(sender:UIButton) {
        
        let chairInfoObj = self.arrayTableView[sender.tag]
        let manageRequest =    BRDSingleton.sharedInstane.objManageRequestInfo
        
        SwiftLoader.show(KUpdating, animated: true)
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        if let obj = chairInfoObj._id
        {
            
            
            let inputParameters = ["chair_request_id": manageRequest?[sender.tag]._id!   , "request_type" : "decline" ]
                as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KAcceptRejectRequest
            
            print(urlString)
            BRDAPI.updateService("PUT", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if let serverMessage = responseMessage {
                    if serverMessage == "Chair request is successfully declined."{
                        
                        // SUCCESS CASE
                        _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Chair request is successfully declined.", onViewController: self, returnBlock: { (clickedIN) in
                        })
                        self.getManageRequestList()
                        
                    }
                }
                else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please add chair information in order to post chair to barbers.", onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                }
                
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Please add chair information in order to post chair to barbers.", onViewController: self, returnBlock: { (clickedIN) in
                        
                        
                    })
                    return
                }
            }
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
