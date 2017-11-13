//
//  BRD_Barber_AddManageServiceVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/24/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader


let KBRD_Barber_AddManageServiceVC_StoryboardID = "BRD_Barber_AddManageServiceVC_StoryboardID"
class AddManageCell:UITableViewCell
{
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var serviceLbl: UILabel!
    
    override func awakeFromNib() {
        
        self.whiteBackgroundView.layer.cornerRadius = 4.0
        
    }
    
}
class BRD_Barber_AddManageServiceVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    var selectedIndex :[IndexPath] = []
    var serviceID: String = ""
    var serviceName: String = ""
    var arrayTableView = [BRD_ServicesBO]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextBtn.backgroundColor = UIColor.darkGray
        self.nextBtn.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        
        
        let header = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as? NavigationBarWithTitle
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        header?.initWithTitle(title: KManageMyServices)
        self.view.addSubview(header!)

    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.getActiveServices()
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if (serviceID == ""){
            self.nextBtn.isUserInteractionEnabled = false
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: KBRD_Barber_ServicePriceVC_StoryboardID) as! BRD_Barber_ServicePriceVC
            vc.selectedServiceID = self.serviceID
            vc.selectedServicename = self.serviceName
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UITableView DataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addservicecell", for: indexPath as IndexPath) as! AddManageCell
        
        
        let obj = self.arrayTableView[indexPath.row]
        cell.serviceLbl.text = obj.name
        
        if self.selectedIndex.contains(indexPath) {
            cell.whiteBackgroundView.backgroundColor = KBlueSelectionColor
            cell.serviceLbl.textColor = UIColor.white
            
        } else {
            cell.whiteBackgroundView.backgroundColor = UIColor.white
            cell.serviceLbl.textColor = UIColor.darkGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.selectedIndex = []
        self.selectedIndex.append(indexPath)
        
        let obj = self.arrayTableView[indexPath.row]
        serviceID = obj.service_id!
        serviceName = obj.name!
        self.nextBtn.isUserInteractionEnabled = true
        self.nextBtn.backgroundColor = KAppRedColor
        tableView.reloadData()
        
    }
    @objc private func getActiveServices(){
        
        SwiftLoader.show(KLoadingActiveServices, animated: true)
        let header: [String: String] = BRDSingleton.sharedInstane.getHeaders()!
        
        let urlString = KBaseURLString + KActiveServices
        
        BRDAPI.getAllListofBarberServices("GET", inputParameters: nil, header: header, urlString: urlString) { (response, arrayServices, status, error) in
            SwiftLoader.hide()
            
            print(arrayServices!)
            if (arrayServices?.count)! > 0{
                BRDSingleton.removeEmptyMessage(self.view)
                self.arrayTableView = arrayServices!
                self.tableView.reloadData()
            }
            else{
                self.view.addSubview(BRDSingleton.showEmptyMessage("No services", view: self.view))
            }
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
