//
//  BRD_Customer_ViewShopsVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 11/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_Customer_ViewShopsVC_StoryboardID = "BRD_Customer_ViewShopsVC_StoryboardID"

class BRD_Customer_ViewShopsVC: UIViewController {
    
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
     var arrayTableView = [BRD_ShopDataBO]()
    
    var arraySearch = [Any]()
    
    var duplicateArray = [BRD_ShopDataBO]()
    var refreshControl: UIRefreshControl!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName:String(describing:BRD_Customer_ViewShops_TableViewCell.self), bundle:nil), forCellReuseIdentifier: KBRD_Customer_ViewShops_TableViewCell_CellIdentifier)
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.viewAllShops()
        refreshControl.endRefreshing()
    }
    
    func viewAllShops(){
        
       let header = BRDSingleton.sharedInstane.getHeaders()
        
        
//        let dictionary = [KLatitude: "30.538994",
//                          KLongitude:"75.955033",
//                          KUserID:(self.objBarberAppointments?.barber_id?._id)!]
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)

            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: KLocationServices, onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        SwiftLoader.show(KLoading, animated: true)
        
        BRD_ShopDataBOBL.initWithParameters("GET", inputParameters: nil, header: header, urlComponent: KViewAllShopsURL) { (obj, error) in
            
            SwiftLoader.hide()
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }
            
            if obj != nil{
                if obj?.count == 0{
                    self.view.addSubview(BRDSingleton.showEmptyMessage("No Shops Found", view: self.view))
                    self.arrayTableView.removeAll()
                    self.tableView.reloadData()
                }else{
                    BRDSingleton.removeEmptyMessage(self.view)
                    self.arrayTableView.removeAll()
                    self.arrayTableView = obj!
                    self.duplicateArray = obj!
                    self.tableView.reloadData()
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        self.viewAllShops()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         BRDSingleton.sharedInstane.dismissLoader(viewController: self)
    }
    
    func btnDetailAction(sender: UIButton)  {
        let indexPath = BRDUtility.indexPath(self.tableView, sender)
        if self.arrayTableView.count > indexPath.row {
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: BRDBarbrDetailVC.identifier()) as? BRDBarbrDetailVC {
                vc.shopDetail = self.arrayTableView[indexPath.row]
                
                BRDSingleton.sharedInstane.objShop_id = self.arrayTableView[indexPath.row]._id
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnShowMapAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_GoogleMapsVC_StoryboardID) as! BRD_GoogleMapsVC
        vc.arrayViewShop = self.arrayTableView
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
 }

extension BRD_Customer_ViewShopsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BRD_Customer_ViewShops_TableViewCell = tableView.dequeueReusableCell(withIdentifier: KBRD_Customer_ViewShops_TableViewCell_CellIdentifier) as! BRD_Customer_ViewShops_TableViewCell
            cell.initWithData(obj: self.arrayTableView[indexPath.row])
            cell.btnDetail.addTarget(self, action: #selector(btnDetailAction(sender:)), for: .touchUpInside)
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension BRD_Customer_ViewShopsVC: UITextFieldDelegate{
    
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
            print("Backspace was pressed")
            print("searchText \(string)")
            
            if textField.text?.characters.count == 1{
                self.arrayTableView.removeAll()
                self.arrayTableView = self.duplicateArray
                self.tableView.reloadData()
                return true
            }
            
            let name: String = textField.text!
            let truncated = name.substring(to: name.index(before: name.endIndex))
            let filterArray = self.duplicateArray.filter { (t) -> Bool in
                return (t.name?.lowercased().contains(truncated.lowercased()))!
            }
            
            self.arrayTableView.removeAll()
            self.arrayTableView = filterArray
            self.tableView.reloadData()
            return true
        }
        
        if string == BRDRawStaticStrings.KEmptyString{
            
            if self.txtSearchField.text == ""{
                print("Empty String")
                self.txtSearchField.resignFirstResponder()
                self.arrayTableView.removeAll()
                self.arrayTableView = self.duplicateArray
                self.tableView.reloadData()
            }
            
        }else{
            
            let str = textField.text! + string
            let filterArray = self.duplicateArray.filter { (t) -> Bool in
                return (t.name?.lowercased().contains(str.lowercased()))!
            }
            
            self.arrayTableView.removeAll()
            self.arrayTableView = filterArray
            self.tableView.reloadData()
        }
        
        
        
        return true
    }
    
}







