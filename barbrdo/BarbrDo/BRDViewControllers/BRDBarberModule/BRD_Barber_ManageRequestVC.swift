//
//  BRD_Barber_ManageRequestVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/18/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
let KBRD_Barber_ManageRequestVC_StoryboardID = "BRD_Barber_ManageRequestVC_StoryboardID"


class BRD_Barber_ManageRequestVC: BRD_BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
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
    
    func getManageRequestList()
    {
        
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{return}
        
        
        
        if  let user_id =   BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id
        {
            SwiftLoader.show("Loading Requests...", animated: true)
            
            let urlString = KBaseURLString + kShopchairrequests + "/" + user_id
            
            BRDAPI.getManageChairListing(requestType: "GET", inputParameters: nil, header: header!, urlString: urlString) { (response, arrayServices, status, error) in
                
                SwiftLoader.hide()
                self.arrayTableView.removeAll()
                
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
        }
        else
        {
            self.view.addSubview(BRDSingleton.showEmptyMessage("No Request Found.", view: self.view))
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: nil, onViewController: self, returnBlock: { (clickedIN) in
                
                
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
        if  (obj.isActive == true){
            
            let barberObj = BRDSingleton.sharedInstane.objManageRequestInfo?[indexPath.row]
            
            let barberInfo =  BRDSingleton.sharedInstane.objShopChairInfo
            
            cell.titleLbl.text = barberInfo?[indexPath.row].name
            cell.barberLbl.text = self.convertDateString(obj: (barberObj?.booking_date)!)
            if (BRDSingleton.sharedInstane.objManageRequestInfo != nil){
                cell.initWithData(obj: barberObj?.barberInfo?[0])
            }

            if(obj.availability?.lowercased() == booked)
            {
                cell.profileImage.image = UIImage(named : "ICON_PROFILEIMAGE")
                cell.chairSplitLbl.isHidden = false
                
                if let shopPercent = obj.shop_percentage{
                    cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                }else{
                    cell.chairSplitLbl.text = "Chair Split : 0/0"
                }
                if (obj.type == "self"){
                    cell.chairSplitLbl.text = "Booked by Non-BarbrDo Barber"
                }
            }else if ( obj.availability?.lowercased() == available){
                
                if(obj.type == monthly){
                   
                    cell.chairSplitLbl.isHidden = false
                    
                    if let amount = obj.amount{
                        let convertAmount = String(format: "%.1f", amount)
                        cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/month"
                    }
                }
                else if(obj.type == weekly){
                    
                    cell.chairSplitLbl.isHidden = false
                    
                    if let amount = obj.amount{
                        let convertAmount = String(format: "%.1f", amount)
                        cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/week"
                    }
                }
                else if(obj.type == percentage){
                    
                    cell.chairSplitLbl.isHidden = false
                    
                    if let shopPercent = obj.shop_percentage{
                        cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                    }
                }
            }else if (obj.availability?.lowercased() == closed  && obj.type?.lowercased() == percentage ){
                
                cell.chairSplitLbl.isHidden = false
                
                if let shopPercent = obj.shop_percentage{
                    cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                }
            }else if (obj.availability?.lowercased() == closed ){
                
                if(obj.type == monthly)
                {
                    cell.chairSplitLbl.isHidden = false
                    
                    if let amount = obj.amount{
                        let convertAmount = String(format: "%.1f", amount)
                        cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/month"
                    }
                }
                else if(obj.type == weekly){
                    cell.chairSplitLbl.isHidden = false
                    if let amount = obj.amount{
                        let convertAmount = String(format: "%.1f", amount)
                        cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/week"
                    }
                }
                else{
                    cell.chairSplitLbl.isHidden = true
                }
            }
        }
        
        cell.acceptBtn.tag = indexPath.row
        cell.rejectBtn.tag = indexPath.row
        
        cell.acceptBtn.addTarget(self, action: #selector(BRD_Barber_ManageRequestVC.acceptBtnAction), for: .touchUpInside)
        
        cell.rejectBtn.addTarget(self, action: #selector(BRD_Barber_ManageRequestVC.rejectBtnAction), for: .touchUpInside)
        
        
        return cell
    }
    

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(BRDSingleton.sharedInstane.objShopChairInfo?[indexPath.row]._id! )
        
        if let shopInfo = BRDSingleton.sharedInstane.objShopChairInfo?[indexPath.row]._id
        {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: KBRD_Barber_RequestDetailVC_StoryboardID) as! BRD_Barber_RequestDetailVC
//        let objShopData = BRDSingleton.sharedInstane.objShop_id
//        vc.objBarberShops = 
        let dateStr = Date.stringFromDate(Date(), Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz)
        let currentDateStr = Date.convert(dateStr, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.yyyy_MM_dd)
//            let barberObj = BRDSingleton.sharedInstane.objManageRequestInfo?[indexPath.row]
//            
//            let barberInfo =  BRDSingleton.sharedInstane.objShopChairInfo
        vc.arrayTableView = self.arrayTableView
        vc.calendarSelectedDate = currentDateStr
        vc.shopId = shopInfo
        vc.manageRequestFlag = true
//       vc.objBarberShops = self.
        
        self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    // MARK :- Date conversion
    func convertDateString(obj: String) -> String?{
        let myDate = obj //obj.appointment_date // "2016-06-20T13:01:46.457+02:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:myDate)!
        dateFormatter.dateFormat = "MMM dd"
        let dateString = dateFormatter.string(from:date)
        
        print(dateString)
        
        return dateString
    }

    
    func acceptBtnAction(sender:UIButton) {
        
        let chairInfoObj = self.arrayTableView[sender.tag]
        let manageRequest =    BRDSingleton.sharedInstane.objManageRequestInfo
        
        SwiftLoader.show("Updating", animated: true)
        
        
        
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
                        _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Shop updated successfully", onViewController: self, returnBlock: { (clickedIN) in
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
        
        SwiftLoader.show("Updating", animated: true)
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

