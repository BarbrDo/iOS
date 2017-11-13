

//
//  BRD_Customer_ViewBarbersVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLoader


let KBRD_Customer_ViewBarbersVC_StoryboardID = "BRD_Customer_ViewBarbersVC_StoryboardID"

private enum viewBarberScreenButton: Int{
    
    case viewShops = 101
    case viewBarbers
}


class BRD_Customer_ViewBarbersVC: UIViewController {
    
    
    @IBOutlet weak var txtSearchField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayTableView = [BRD_BarberInfoBO]()
    var duplicateArray = [BRD_BarberInfoBO]()
    var shopArray = [BRD_ShopDataBO]()
    var locationManager: BRD_LocationManager?
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
        
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.viewAllBarbers()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.register(UINib(nibName:String(describing: BRD_Customer_ViewBarbers_TableViewCell.self), bundle:nil), forCellReuseIdentifier: KBRD_Customer_ViewBarbers_TableViewCell_CellIdentifier)
        
        BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
        
        self.viewAllBarbers()
    }
    
    func viewAllBarbers(){
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        SwiftLoader.show(KLoading, animated: true)
        
        BRD_BarberDataBOBL.initWithParameters("GET", inputParameters: nil, header: header!, urlComponent: KViewAllBarbersURL) { (obj, error) in
            
            SwiftLoader.hide()
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
            
            if (obj?.count)! > 0{
                BRDSingleton.removeEmptyMessage(self.view)
                self.arrayTableView.removeAll()
                self.arrayTableView = obj!
                self.duplicateArray = obj!
                self.tableView.reloadData()
            }else{
                self.view.addSubview(BRDSingleton.showEmptyMessage("No Barbers Found", view: self.view))
            }
        }
    }
    
    func btnBookAction(sender: UIButton) {
        let indexPath = BRDUtility.indexPath(self.tableView, sender)
        if self.arrayTableView.count > indexPath.row {
            
            if let barber = self.arrayTableView[indexPath.row] as? BRD_BarberInfoBO{
                let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: BRDBookAppointmentVC.identifier()) as? BRDBookAppointmentVC {
                    vc.barberDetails = barber
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}

extension BRD_Customer_ViewBarbersVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BRD_Customer_ViewBarbers_TableViewCell = tableView.dequeueReusableCell(withIdentifier: KBRD_Customer_ViewBarbers_TableViewCell_CellIdentifier) as! BRD_Customer_ViewBarbers_TableViewCell
        cell.initWithData(obj: self.arrayTableView[indexPath.row])
        cell.btnBook.addTarget(self, action: #selector(btnBookAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
            vc.objBarber = self.arrayTableView[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension BRD_Customer_ViewBarbersVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtSearchField.text == BRDRawStaticStrings.KEmptyString{
            txtSearchField.resignFirstResponder()
        }
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            
            if textField.text?.characters.count == 1{
                self.arrayTableView.removeAll()
                self.arrayTableView = self.duplicateArray
                self.tableView.reloadData()
                return true
            }
            
            let name: String = textField.text!
            let truncated = name.substring(to: name.index(before: name.endIndex))
            let filterArray = self.duplicateArray.filter { (t) -> Bool in
                return (t.first_name?.lowercased().contains(truncated.lowercased()))!
            }
            
            self.arrayTableView.removeAll()
            self.arrayTableView = filterArray
            self.tableView.reloadData()
            return true
        }
        
        if string == BRDRawStaticStrings.KEmptyString{
            
            if self.txtSearchField.text == ""{
                self.txtSearchField.resignFirstResponder()
                self.arrayTableView.removeAll()
                self.arrayTableView = self.duplicateArray
                self.tableView.reloadData()
            }
        }else{
            
            let str = textField.text! + string
            let filterArray = self.duplicateArray.filter { (t) -> Bool in
                return (t.first_name?.lowercased().contains(str.lowercased()))!
            }
            
            self.arrayTableView.removeAll()
            self.arrayTableView = filterArray
            self.tableView.reloadData()
        }
        return true
    }
    
}

