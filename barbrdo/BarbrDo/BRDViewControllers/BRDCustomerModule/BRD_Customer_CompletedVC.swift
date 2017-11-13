//
//  BRD_Customer_CompletedVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 14/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_Customer_CompletedVC_StoryboardID = "BRD_Customer_CompletedVC_StoryboardID"

class BRD_Customer_CompletedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arrayTableView = [Any]()
    var refreshControl: UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: String(describing: BRD_Customer_RebookTableViewCell.self), bundle: nil), forCellReuseIdentifier: KBRD_Customer_RebookTableViewCell_CellIdentifier)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getListofAppointments()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.getListofAppointments()
        refreshControl.endRefreshing()
    }
    
    
    func getListofAppointments() {
        
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
            if (arrayCompleted?.count)! > 0{
                
                BRDSingleton.removeEmptyMessage(self.view)
                self.arrayTableView.removeAll()
                self.arrayTableView = arrayCompleted!
                self.tableView.reloadData()
            }else if (arrayCompleted?.count)! == 0{
                self.view.addSubview(BRDSingleton.showEmptyMessage("No haircuts scheduled", view: self.view))
                self.arrayTableView.removeAll()
                self.tableView.reloadData()
            }
            else{
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


extension BRD_Customer_CompletedVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BRD_Customer_RebookTableViewCell = tableView.dequeueReusableCell(withIdentifier: KBRD_Customer_RebookTableViewCell_CellIdentifier) as! BRD_Customer_RebookTableViewCell
        cell.btnReBook.addTarget(self, action: #selector(_bookButtonAction(_:)), for: .touchUpInside)
        
        if let objAppointmentData = self.arrayTableView[indexPath.row] as? BRD_AppointmentsInfoBO{
            cell.initWithData(obj: objAppointmentData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    @objc fileprivate func _bookButtonAction(_ button: UIButton) {
        let indexPath = BRDUtility.indexPath(self.tableView, button)
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_CompleteAppointmentDetailVC_StoryboardID) as? BRD_Customer_CompleteAppointmentDetailVC{
            vc.objAppointment = self.arrayTableView[indexPath.row] as? BRD_AppointmentsInfoBO
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
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
    
}
