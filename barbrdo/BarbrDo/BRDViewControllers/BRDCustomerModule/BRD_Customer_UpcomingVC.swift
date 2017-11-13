//
//  BRD_Customer_UpcomingVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 14/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
import CoreLocation

let KBRD_Customer_UpcomingVC_StoryboardID = "BRD_Customer_UpcomingVC_StoryboardID"

class BRD_Customer_UpcomingVC: UIViewController, BRD_LocationManagerProtocol {
    func denyUpdateLocation() {
        
    }

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBarberBtn: UIButton!

    var arrayTableView = [BRD_AppointmentsInfoBO]()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: String(describing: BRD_Customer_Dashboard_TableViewCell.self), bundle: nil), forCellReuseIdentifier: KBRD_Customer_Dashboard_TableViewCell_CellIdentifier)
        self.viewBarberBtn.layer.shadowColor = UIColor.gray.cgColor
        self.viewBarberBtn.layer.shadowOffset =  CGSize(width:0,height:1.0)
        self.viewBarberBtn.layer.shadowRadius = 3.0;
        self.viewBarberBtn.layer.cornerRadius = 30.0;
        self.viewBarberBtn.layer.masksToBounds = false
        self.viewBarberBtn.layer.opacity = 1.0
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
    }
    
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.getListofAppointments()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if BRDSingleton.sharedInstane.latitude == nil || BRDSingleton.sharedInstane.latitude == ""{
            
            SwiftLoader.show(KFetchingLocation, animated: true)
            BRD_LocationManager.sharedLocationManger.delegate = self
            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
        }else{
            self.getListofAppointments()
        }
    }
    
    func didUpdateLocation(location: CLLocation) {
        
        SwiftLoader.hide()
        self.getListofAppointments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   @objc private func getListofAppointments() {
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
    
        SwiftLoader.show("Fetching data...", animated: true)
        
        BRD_AppointmentsInfoBOBL.initWithParameters("GET", inputParameters: nil, header: header!, urlComponent: KGetAllAppointmentURL) { (arrayUpcoming, arrayCompleted, error) in
            SwiftLoader.hide()
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
            BRDSingleton.sharedInstane.totalCuts = arrayCompleted?.count
            
            // Condition #1 - If arrayUpcoming count is zero, then go to arrayCompleted
            // condition #2 - If arrayUpcoming and arrayCompleted is zero then go to viewShops
            if arrayUpcoming?.count == 0 && arrayCompleted?.count != 0{
                
            }else if arrayUpcoming?.count == 0 && arrayCompleted?.count != 0{
                
            }
            
            
            
            
            
            
            if arrayCompleted != nil{
                var tempArray = [BRD_AppointmentsInfoBO]()
                for obj in arrayCompleted!{
                    
                    if obj.is_rating_given == false{
                        tempArray.append(obj)
                    }
                }
                
                if tempArray.count > 0{
                        // Present Rating View
                        BRDSingleton.removeEmptyMessage(self.view)
                        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "GetCustomerFeedbackVC") as! GetCustomerFeedbackVC
                        vc.arrayTableView = tempArray
                        vc.objAppointmentInfo = tempArray[0]
                        self .present(vc, animated: true, completion: nil)
                        
                }
                
                else if (arrayUpcoming?.count)! > 0{
                    //if (arrayUpcoming?.count)! > 0{
                    self.arrayTableView.removeAll()
                    self.arrayTableView = arrayUpcoming!
                    self.tableView.reloadData()
                    
                    BRDSingleton.removeEmptyMessage(self.view)
                }else if (arrayUpcoming?.count)! == 0{
                    self.arrayTableView.removeAll()
                    
                    let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_ScheduleAnAppointmentVC_StoryboardID) as! BRD_Customer_ScheduleAnAppointmentVC
                    self.navigationController?.pushViewController(vc, animated: false)
                    self.view.addSubview(BRDSingleton.showEmptyMessage("No haircuts scheduled", view: self.view))
                }
            }
            else if (arrayUpcoming?.count)! > 0{
                self.arrayTableView.removeAll()
                self.arrayTableView = arrayUpcoming!
                self.tableView.reloadData()
                BRDSingleton.removeEmptyMessage(self.view)
            }else{
                self.arrayTableView.removeAll()

                self.view.addSubview(BRDSingleton.showEmptyMessage("No haircuts scheduled", view: self.view))
            }
        }
    }
    
    @IBAction func btnAddAnAppointment(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_ScheduleAnAppointmentVC_StoryboardID) as! BRD_Customer_ScheduleAnAppointmentVC
        self.navigationController?.pushViewController(vc, animated: false)
    }

}

extension BRD_Customer_UpcomingVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BRD_Customer_Dashboard_TableViewCell = tableView.dequeueReusableCell(withIdentifier: KBRD_Customer_Dashboard_TableViewCell_CellIdentifier) as! BRD_Customer_Dashboard_TableViewCell
        cell.btnDetail.addTarget(self, action: #selector(_bookButtonAction(_:)), for: .touchUpInside)
        if(self.arrayTableView.count>0){
             cell.initWithData(obj: self.arrayTableView[indexPath.row])
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
            
            if let objAppointment = self.arrayTableView[indexPath.row] as? BRD_AppointmentsInfoBO{
            
                if objAppointment.barber_id != nil{
                    vc.objBarber = objAppointment.barber_id
                    vc.objSelectedShopData = objAppointment.shop_id
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

    
    @objc fileprivate func _bookButtonAction(_ button: UIButton) {
        let indexPath = BRDUtility.indexPath(self.tableView, button)
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_AppointmentDetail_StoryboardID) as! BRD_Customer_AppointmentDetail
        vc.objAppointment = self.arrayTableView[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
