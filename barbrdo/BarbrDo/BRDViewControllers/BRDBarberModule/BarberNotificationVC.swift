//
//  BarberNotificationVC.swift
//  BarbrDo
//
//  Created by Shami Kumar on 24/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberNotificationVC: BRD_BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    var arrayTableView : [NotificationDisplay]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.getNotifications()
        
        tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
        
        self.tableView.backgroundColor = UIColor.clear
        
        //BRDSingleton.sharedInstane.objBRD_UserInfoBO
        // Do any additional setup after loading the view.
        self.addTopNavigationBar(title: "")
    }
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.getNotifications()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getNotifications ()
    {
        let email =    UserDefaults.standard.object(forKey: KEmail)
        let password = UserDefaults.standard.object(forKey: KPassword)
        
        
        let inputParameters = ["email": email, "password": password]
        
        let headers = BRDSingleton.sharedInstane.getLatitudeLongitude()
        if headers == nil
        {
            self.hideLoader()
            
            _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
                BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
            })
            
            return
        }
        
        self.showLoader(message: "Loading...")
        
        BRD_UserInfoBOBL.initWithFacebook("POST", urlComponent: KLoginURL, inputParameters: inputParameters, headers: headers!, completionHandler: { (obj, error) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            
            
        })
        
        self.hideLoader()
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //        self.arrayTableView = BRDSingleton.sharedInstane.objBRD_UserInfoBO?.notification
        if((BRDSingleton.sharedInstane.objBRD_UserInfoBO?.notification!.count)! > 0)
        {
            return (BRDSingleton.sharedInstane.objBRD_UserInfoBO?.notification!.count)!
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath as IndexPath) as! NotificationCell
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO?.notification?[indexPath.row]
        cell.titleLbl.text = obj?.text
        cell.dateLbl.text = Date.convert((obj?.created_date!)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMM_dd)

        //        cell.lblServiceCost.text = String(describing: obj.price!)
        return cell
    }
    
    
    


}
