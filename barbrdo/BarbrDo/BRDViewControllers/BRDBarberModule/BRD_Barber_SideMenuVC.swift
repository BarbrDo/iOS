//
//  BRD_Barber_SideMenuVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/17/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit


let KBRD_Barber_SideMenuVC_StoryboardID = "BRD_Barber_SideMenuVC_StoryboardID"

class BRD_Barber_SideMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayTableView = [String]()
    var arrayImageView = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = kNavigationBarColor
        
        // Do any additional setup after loading the view.
        
        self.arrayTableView = ["Home", "Gallery", "Financial Center","Manage Shops","Invite to BarbrDo","Contact BarbrDo","Logout"]
        self.arrayImageView = [#imageLiteral(resourceName: "ICON_HOME"), #imageLiteral(resourceName: "ICON_GALLERY"), #imageLiteral(resourceName: "ICON_FINANCIAL"),#imageLiteral(resourceName: "ManageSHopsicon"),#imageLiteral(resourceName: "ICON_INVITECUSTOMER"),#imageLiteral(resourceName: "ICON_MOBILENUMBER"),#imageLiteral(resourceName: "ICON_LOGOUT")]
        
        
        self.tableView.register(UINib(nibName: "BRD_SideMenu_TableViewHeader", bundle: nil), forCellReuseIdentifier: KBRD_SideMenu_TableViewHeader_CellIdentifier)
        self.tableView.register(UINib(nibName: "BRD_SideMenu_TableViewCell", bundle: nil), forCellReuseIdentifier: KBRD_SideMenu_TableViewCell_CellIdentifier)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension BRD_Barber_SideMenuVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BRD_SideMenu_TableViewCell = tableView.dequeueReusableCell(withIdentifier: KBRD_SideMenu_TableViewCell_CellIdentifier) as! BRD_SideMenu_TableViewCell
        
        cell.lblName.text = self.arrayTableView[indexPath.row]
        cell.imgView.image = self.arrayImageView[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header:BRD_SideMenu_TableViewHeader = tableView.dequeueReusableCell(withIdentifier: KBRD_SideMenu_TableViewHeader_CellIdentifier) as! BRD_SideMenu_TableViewHeader
        header.btnProfile.addTarget(self, action: #selector(BRD_Barber_SideMenuVC.profileButtonAction), for: .touchUpInside)
        header.btnTranspartent.addTarget(self, action: #selector(BRD_Barber_SideMenuVC.profileButtonAction), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BRD_Barber_SideMenuVC.profileButtonAction(_:)))
        header.addGestureRecognizer(tapGesture)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 244.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async(execute: {
            
            self.dismiss(animated: true, completion: {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name(KBarberSideMenuTapped), object: self.arrayTableView[indexPath.row])
            })
        })
        
       
        
    }
    func profileButtonAction(_ gestureRecognizer: UIGestureRecognizer) {
    
        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Barber_Profile_StoryboardID) as! BRD_Barber_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}
