//
//  BRD_Barber_ManageServiceVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/18/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader


let KBRD_Barber_ManageServiceVC_StoryboardID = "BRD_Barber_ManageServiceVC_StoryboardID"
class ManageServiceCell:UITableViewCell
{
    @IBOutlet weak var barberBackgroundView : UIView!
    @IBOutlet weak var barberServiceLbl: UILabel!
    @IBOutlet weak var barberPriceLbl: UILabel!
    @IBOutlet weak var barberEditBtn: UIButton!
    @IBOutlet weak var barberDeleteBtn: UIButton!
    
    override func awakeFromNib() {
        self.barberBackgroundView.layer.cornerRadius = 2.0
    }
    
}

class BRD_Barber_ManageServiceVC: BRD_BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barberNoServiceLbl: UILabel!
    @IBOutlet weak var barberAddServiceLbl: UILabel!
    @IBOutlet weak var barberDirectionImage: UIImageView!
    
    var serviceId: String = ""
    var arrayTableView = [BRD_ServicesBO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTopNavigationBar(title: KManageServices)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getAllServices()
    }
    
    
    //MARK:-  UIButton Action Method
    
    @IBAction func plusButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: KBRD_Barber_AddManageServiceVC_StoryboardID) as! BRD_Barber_AddManageServiceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- UITableView DataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(self.arrayTableView.count)
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageservicecell", for: indexPath as IndexPath) as! ManageServiceCell
        cell.backgroundView?.layer.cornerRadius  = 2.0
        
        let obj = self.arrayTableView[indexPath.row]
        let priceString : String =   String(format: "%.2f", obj.price!)
        //"\(String(describing: obj.price!))"
        
        cell.barberServiceLbl.text = obj.name
        cell.barberPriceLbl.text = "$" + priceString
        
        cell.barberEditBtn.tag = indexPath.row
        cell.barberDeleteBtn.tag = indexPath.row
        cell.barberEditBtn.addTarget(self, action: #selector(BRD_Barber_ManageServiceVC.editButtonClicked), for: .touchUpInside)
        
        cell.barberDeleteBtn.addTarget(self, action: #selector(BRD_Barber_ManageServiceVC.deleteButtonClicked), for: .touchUpInside)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    // MARK: - TableViewCell Button Action Method.
    
    func editButtonClicked(sender:UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: KBRD_Barber_ServicePriceVC_StoryboardID) as! BRD_Barber_ServicePriceVC
        let buttonRow = sender.tag
        //        let obj = self.arrayTableView[buttonRow]
        //        print(obj.price)
        //        vc.servicePrice = "\(String(describing: obj.price!))"
        
        vc.objBarberService = self.arrayTableView[buttonRow]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func deleteButtonClicked(sender:UIButton) {
        
        
        
        _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: KAlertTitle, withMessage: "Do you really want to delete this service", buttonTitles: ["Ok", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
        }, returnBlock: { response in
            let value: Int = response
            if value == 0{
                // Ok
                let buttonRow = sender.tag
                let obj = self.arrayTableView[buttonRow]
                self.serviceId = obj.service_id!
                self.deleteServices()
                
            }else{
                // Cancel
            }
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func getAllServices(){
        
        SwiftLoader.show("Getting All Services", animated: true)
        
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let latitude = BRDSingleton.sharedInstane.latitude
        let longitude = BRDSingleton.sharedInstane.longitude
        
        let header: [String: String] =
            [KLatitude : latitude!,
             KLongitude : longitude!,
             KUserID : (obj?._id)!,
             KBarberID : (obj?._id)!]
        
        let urlString = KBaseURLString + KBarberServices + (obj?._id)!
        
        BRDAPI.getAllListofBarberServices("GET", inputParameters: nil, header: header, urlString: urlString) { (response, arrayServices, status, error) in
            
            SwiftLoader.hide()
            if arrayServices != nil{
                if (arrayServices?.count)! > 0{
                    BRDSingleton.removeEmptyMessage(self.view)
                    self.barberNoServiceLbl.isHidden = true
                    self.barberAddServiceLbl.isHidden = true
                    self.barberDirectionImage.isHidden = true
                    self.arrayTableView = arrayServices!
                    self.tableView.reloadData()
                }else{
                    self.arrayTableView.removeAll()
                    self.tableView.reloadData()
                    self.barberNoServiceLbl.isHidden = false
                    self.barberAddServiceLbl.isHidden = false
                    self.barberDirectionImage.isHidden = false
                }
            }
            else{
                self.arrayTableView.removeAll()
                self.tableView.reloadData()
                self.barberNoServiceLbl.isHidden = false
                self.barberAddServiceLbl.isHidden = false
                self.barberDirectionImage.isHidden = false
            }
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
    }
    @objc private func deleteServices(){
        let obj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let latitude = BRDSingleton.sharedInstane.latitude
        let longitude = BRDSingleton.sharedInstane.longitude
        
        let header: [String: String] =
            [KLatitude : latitude!,
             KLongitude : longitude!,
             KUserID: (obj?._id)!,
             KBarberServiceID : serviceId]
        
        let urlString = KBaseURLString + KDeleteServices + serviceId
        
        BRDAPI.deleteServices("DELETE", inputParameters: nil, header: header, urlString: urlString) { (response, responseMessage, status, error) in
            
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            print(response!)
            
            if responseMessage == "Deleted successfully"{
                self.arrayTableView.removeAll()
                self.getAllServices()
            }
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
    }
}
