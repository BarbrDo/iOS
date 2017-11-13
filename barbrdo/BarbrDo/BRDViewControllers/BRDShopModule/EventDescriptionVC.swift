//
//  EventDescriptionVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

class EventCell: UITableViewCell{
    
    @IBOutlet weak var lblServiceName : UILabel!
    @IBOutlet weak var lblServiceCost: UILabel!
    
    override func awakeFromNib() {
    
    
    }
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "EventCell"
    }
    
}

class EventDescriptionVC: UIViewController {
    
    
    
    var objDDCalendarEvent : DDCalendarEvent?
    
    var objBarber : BRD_BarberInfoBO? = nil
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAppointmentDate: UILabel!
    @IBOutlet weak var lblAppointmentTime: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    var strEventID: String? = nil
    
    var arrayTableView = [BRD_ServicesBO]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var isTypeEvent : Bool = false
        if let checkObj = objDDCalendarEvent?.userInfo{
            
            if let objTemp = checkObj["event"] as? EventsBO{
                isTypeEvent = true
                self.lblTitle.text = "Event Details"
            }else{
                self.lblTitle.text = "Appointment Details"
            }
        }
        
        
        if BRDSingleton.sharedInstane.objBRD_UserInfoBO?.user_type == UserType.Barber.rawValue && isTypeEvent == true{
            self.btnDelete.isHidden = false
            self.btnEdit.isHidden = false
            
        }else{
            self.btnDelete.isHidden = true
            self.btnEdit.isHidden = true
        }
        
        
        if objDDCalendarEvent != nil{
            
            print(objDDCalendarEvent?.userInfo)
            
            if let obj = objDDCalendarEvent?.userInfo as? [String: Any]{
                
                if let obj1 = obj["event"] as? EventsBO{
                    
                    
                    self.strEventID = obj1._id
                    
                    if obj1.objShopEvents != nil{
                        
                        
                        self.lblAppointmentDate.text = "Appointment Date: " + Date.convert((obj1.objShopEvents?.appointment_date!)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.EEEE_MMMM_dd_yyyy)
                        
                        
                        self.lblAppointmentTime.text = "Appointment Time: " + Date.convert((obj1.objShopEvents?.appointment_date!)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
                        
                        
                        self.arrayTableView = (obj1.objShopEvents?.services)!
                        self.tableView.reloadData()
                    }else{
                        self.lblAppointmentDate.text = "Appointment Date: " + Date.convert(obj1.startsAt!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.EEEE_MMMM_dd_yyyy)
                        
                        
                        self.lblAppointmentTime.text = "Appointment Time: " + Date.convert(obj1.endsAt!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
                    }                    
                    
                }else if let obj1 = obj["event"] as? BarberAppointmentBO{
                    self.lblAppointmentDate.text = "Appointment Date: " + Date.convert(obj1.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.EEEE_MMMM_dd_yyyy)
                    
                    
                    self.lblAppointmentTime.text = "Appointment Time: " + Date.convert(obj1.appointment_date!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.TimeFormat.hh_mm_a)
                    
                    
                    self.arrayTableView = (obj1.services)!
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func btnEditAction(_ sender: UIButton){
        
        let storyboard = UIStoryboard(name: barberStoryboard, bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
        vc.objCalendar = self.objDDCalendarEvent
        let strDate = Date.stringFromDate((self.objDDCalendarEvent?.dateBegin)!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_)
        
        vc.strSelectedDate = Date.convert(strDate, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_, Date.DateFormat.yyyy_MM_dd)
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        
        
        _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: KAlertTitle, withMessage: "Do you really want to delete from the event", buttonTitles: ["OK", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
        }, returnBlock: { response in
            let value: Int = response
            if value == 0{
                
                // Delete
                let header = BRDSingleton.sharedInstane.getHeaders()
                if header == nil{
                    BRDSingleton.sharedInstane.dismissLoader(viewController: self)
                    
                    _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
                    })
                    return
                }
                
                SwiftLoader.show(KLoading, animated: true)
                
                if self.strEventID == nil{
                    return
                }
                let urlString = KBaseURLString + KGetAllEvents + self.strEventID!
                
                
                BRDAPI.deletAnEvent("DELETE", inputParameter: nil, header: header!, urlString: urlString) { (response, responseString, status, error) in
                    
                    SwiftLoader.hide()
                    
                    if error != nil{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                        return
                    }
                    
                    if let deleteMessage = response?["msg"] as? String{
                        _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: deleteMessage, onViewController: self, returnBlock: { (clickedIN) in
                            
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                    
                   
                }
                
            }else{
                // Cancel
            }
            
        })
    }
    
    
    @IBAction func backbtnAction(){

        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}


extension EventDescriptionVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier(), for: indexPath as IndexPath) as! EventCell
      
        let obj = self.arrayTableView[indexPath.row]
        cell.lblServiceName.text = obj.name!
        cell.lblServiceCost.text = String(describing: obj.price!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.arrayTableView.count > 0{
            return 20.0
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.arrayTableView.count > 0{
            return 20.0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier()) as! EventCell
        
        header.lblServiceName.text = "Service Name"
        header.lblServiceCost.text = "Service Cost"
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier()) as! EventCell
        
        footer.lblServiceName.text = "Total"
        
        var total : Float = 0.0
        for obj in self.arrayTableView{
            
            total += Float(obj.price!)
        }
        footer.lblServiceCost.text = "$ " + String(describing: total)
        return footer
    }
    
}
