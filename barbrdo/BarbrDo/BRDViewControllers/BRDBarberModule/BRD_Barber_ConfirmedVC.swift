//
//  BRD_Barber_ConfirmedVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/18/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
import CoreLocation

let KBRD_Barber_ConfirmedVC_StoryboardID = "BRD_Barber_ConfirmedVC_StoryboardID"

class BRD_Barber_Confirmed_TableViewCell: UITableViewCell{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageViewBarber: UIImageView!
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lbldateTime: UILabel!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var btnDetail: UIButton!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BRD_Barber_Confirmed_TableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageViewBarber?.layer.masksToBounds = false
        self.imageViewBarber?.layer.cornerRadius = (self.imageViewBarber?.frame.height)!/2
        self.imageViewBarber?.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(obj: BRD_BarberAppointmentsBO){
        
        if let objCustomer = obj.customer_id{
            if objCustomer.first_name != nil && objCustomer.last_name != nil{
                let name = objCustomer.first_name! + " " + objCustomer.last_name!
                self.lblBarberName.text = name
            }
            
            let month = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.MMMM_dd)
            let time = Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
            self.lbldateTime.text = month + " @ " + time
            
            if let objShop = obj.shop_id{
                self.lblPlace.text = objShop.name
            }
            
            self.activityIndicator.startAnimating()
            if objCustomer.picture != nil && objCustomer.picture != ""{
                let imagePath = KImagePathForServer +  objCustomer.picture!
                self.imageViewBarber.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.imageViewBarber.image = image
                        }else{
                            self.imageViewBarber.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.imageViewBarber.image = UIImage(named:"ICON_PROFILEIMAGE.png")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
        }
    }
}


class BRD_Barber_ConfirmedVC: UIViewController, BRD_LocationManagerProtocol {
    func denyUpdateLocation() {
        
    }

    
    @IBOutlet weak var tableView: UITableView!
    var arrayTableView = [BRD_BarberAppointmentsBO]()
    
    @IBOutlet weak var lblNoConfirmedAppointment: UILabel!
     var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if BRDSingleton.sharedInstane.latitude == nil || BRDSingleton.sharedInstane.latitude == ""{
            BRD_LocationManager.sharedLocationManger.delegate = self as BRD_LocationManagerProtocol
            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
        }else{
            self.getAllBarberAppoinments()
        }
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.getAllBarberAppoinments()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didUpdateLocation(location: CLLocation) {
        self.getAllBarberAppoinments()
    }
    
    private func getAllBarberAppoinments(){
        
        var userId: String? = nil
        if let barberID = BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id{
            userId = barberID
        }
        
        if userId == nil{
            return
        }
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        SwiftLoader.show(KLoading, animated: true)
        
        BRD_BarberAppointmentsBOBL.initWithParameters("GET", inputParameters: nil, header: header, urlComponent: KBarberAppointmentsURL) { (arrayPending, arrayConfirmed, error) in
            SwiftLoader.hide()
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }
            
            if (arrayConfirmed?.count)! == 0{
                self.arrayTableView.removeAll()
                self.tableView.reloadData()
            }
            
            if (arrayConfirmed?.count)! > 0{
                self.arrayTableView.removeAll()
                self.arrayTableView = arrayConfirmed!
                self.tableView.reloadData()
            }
        }
    }
}
extension BRD_Barber_ConfirmedVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.arrayTableView.count == 0{
            self.tableView.isHidden = true
        }else{
            self.tableView.isHidden = false
        }
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: BRD_Barber_Confirmed_TableViewCell.identifier()) as? BRD_Barber_Confirmed_TableViewCell
        if cell == nil {
            cell = BRD_Barber_Confirmed_TableViewCell(style: .value1, reuseIdentifier: BRD_Barber_PendingTableViewCell.identifier())
        }
        cell?.initWithData(obj: self.arrayTableView[indexPath.row])
        cell?.btnDetail.addTarget(self, action: #selector(btnDetailAction(_:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let customerID = self.arrayTableView[indexPath.row].customer_id
        {
            let objBarber : BRD_BarberInfoBO = BRD_BarberInfoBO.init()
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
                
                
                objBarber._id = customerID._id
                vc.objCustomer = customerID
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc fileprivate func _bookButtonAction(_ button: UIButton) {
        let indexPath = BRDUtility.indexPath(self.tableView, button)
        
        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_PendingAppointmentDetailVC_StoryboardID) as!
            BRD_Barber_PendingAppointmentDetailVC

        vc.objBarberAppointment = self.arrayTableView[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @objc private func btnDetailAction(_ button: UIButton){
        
        let indexPath = BRDUtility.indexPath(self.tableView, button)
    
        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_ConfirmedAppointmentDetailVC_StoryboardID) as? BRD_Barber_ConfirmedAppointmentDetailVC
        vc?.objBarberAppointment = self.arrayTableView[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}
