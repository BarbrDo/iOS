//
//  BRD_Shop_DashboardVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 5/31/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLoader

let KBRD_Shop_DashboardVC_StoryboardID = "BRD_Shop_DashboardVCStoryboardID"
let KShopSideMenuTapped = "SideMenuTapped"
class BookedChairCell:UITableViewCell
{
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var chairLbl: UILabel!
    @IBOutlet weak var BarberLbl: UILabel!
    @IBOutlet weak var chairSplitLbl: UILabel!
    @IBOutlet weak var chairImage: UIImageView!
    @IBOutlet weak var manageButton: UIButton!
    
    @IBOutlet weak var barberLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chairLblTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.chairImage?.layer.masksToBounds = false
        self.chairImage?.layer.cornerRadius = (self.chairImage?.frame.height)!/2
        self.chairImage?.clipsToBounds = true
        self.manageButton.layer.cornerRadius = 4.0
        self.whiteBackgroundView.layer.cornerRadius = 4.0
    }
    
}
class RequestChairCell:UITableViewCell
{
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var chairImage: UIImageView!
    @IBOutlet weak var chairLbl: UILabel!
    @IBOutlet weak var manageButton: UIButton!
    
    override func awakeFromNib() {
        self.chairImage?.layer.masksToBounds = false
        self.chairImage?.layer.cornerRadius = (self.chairImage?.frame.height)!/2
        self.chairImage?.clipsToBounds = true
        self.manageButton.layer.cornerRadius = 4.0
        self.whiteBackgroundView.layer.cornerRadius = 4.0
    }
    
}


class BRD_Shop_DashboardVC: BRD_BaseViewController,UITableViewDelegate, UITableViewDataSource, BRD_LocationManagerProtocol  {
    func denyUpdateLocation() {
        
    }

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var arrayTableView = [BRD_ChairInfo]()
    var location : CLLocation = CLLocation()
    var locManager = CLLocationManager()
    var latitude : Double?
    var longitude : Double?
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTopNavigationBar(title: "")
        NotificationCenter.default.addObserver(self, selector: #selector(BRD_Shop_DashboardVC.menuTapNotification(notification:)), name: NSNotification.Name(rawValue: KShopSideMenuTapped), object: nil)
        // Do any additional setup after loading the view.
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
        
        
        
    }
    @IBAction func addChairBtnAction(_ sender: Any) {
        
        self.addChairShop()
    }
    
    func addChairShop ()
    {
        SwiftLoader.show("Updating", animated: true)
        
        let userObj = BRDSingleton.sharedInstane.objBRD_UserInfoBO
        
        let header: [String: String]? = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{
            return
        }
        
        let shop_id = BRDSingleton.sharedInstane.objShop_id
        
        if let shopInfo = shop_id
        {
            let inputParameters = ["_id": shopInfo] as [String: Any]
            print(inputParameters)
            let urlString = KBaseURLString + KAddChairShop
            
            print(urlString)
            BRDAPI.addChairShop("POST", inputParameters: inputParameters, header: header!, urlString: urlString) { (reponse, responseMessage, status, error) in
                SwiftLoader.hide()
                
                if let serverMessage = responseMessage {
                    if serverMessage == "Chair successfully added."{
                        
                        self.getShopsList()
                        // SUCCESS CASE
                        //                            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: "Chair successfully added.", onViewController: self, returnBlock: { (clickedIN) in
                        //
                        //                            })
                    }
                }
                else{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    })
                }
                
                if error != nil{
                    _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    })
                    return
                }
            }
        }
    }
    
    
    func getShopsList()
    {
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{return}
        SwiftLoader.show("Loading ...", animated: true)
        
        let user_id =   BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id
        let urlString = KBaseURLString + KShopsList + "/" + user_id!
        
        BRDAPI.getShopsListing("GET", inputParameters: nil, header: header!, urlString: urlString) { (response, arrayServices, status, error) in
            
            SwiftLoader.hide()
            self.arrayTableView.removeAll()
            if(arrayServices != nil)
            {
                
                if  (arrayServices?.count)! > 0
                    
                {
                    BRDSingleton.removeEmptyMessage(self.view)
                    
                    for obj in arrayServices!
                    {
                        if(obj.isActive == true)
                        {
                            self.arrayTableView.append(obj)
                        }
                    }
                    
                    
                    self.tableView.reloadData()
                    
                    
                    
                }
                print("couuuuuuu --\(self.arrayTableView.count)")
                if(self.arrayTableView.count == 0 || self.arrayTableView == nil)
                {
                    self.arrayTableView.removeAll()
                    self.view.addSubview(BRDSingleton.showEmptyMessage("No chairs", view: self.view))
                }
            }
            else
            {
                self.arrayTableView.removeAll()
                self.view.addSubview(BRDSingleton.showEmptyMessage("No chairs", view: self.view))
            }
            
            
            if error != nil{
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
        
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.getShopsList()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if BRDSingleton.sharedInstane.latitude == nil || BRDSingleton.sharedInstane.latitude == ""{
            
            SwiftLoader.show("Fetching Location...", animated: true)
            BRD_LocationManager.sharedLocationManger.delegate = self
            BRD_LocationManager.sharedLocationManger.locationManager.startUpdatingLocation()
        }else{
            self.getShopsList()
        }
        
        
        
    }
    
    func didUpdateLocation(location: CLLocation) {
        
        
        //BRD_LocationManager.sharedLocationManger.locationManager.stopUpdatingLocation()
        SwiftLoader.hide()
        getShopsList()
    }
    
    
    func menuTapNotification(notification:NSNotification) {
        self.navigationController?.popToRootViewController(animated: false)
        
        let strNotification = notification.object as! String
        let storyboard = UIStoryboard(name:"Shop", bundle: nil)
        
        switch strNotification {
            /*
             ["Home", "Gallery", "Financial Center", "Manage Calendar","Search for a Chair","Manage Requests","Manage Services","Invite Customer","Logout"]
             */
            
        case "Home":
            break
        case "Financial Center" :
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_FinancialCenter_StoryboardID) as! BRD_Shop_FinancialCenterVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Manage Requests" :
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_ManageRequestVC_StoryboardID) as! BRD_Shop_ManageRequestVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "View Daily Calendar" :
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_DailyCalendarVC_StoryboardID) as! BRD_Shop_DailyCalendarVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
        case "Contact BarbrDo Office":
            
            let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_ContactOfficeVC_StoryboardID) as! BRD_Shop_ContactOfficeVC
            self.navigationController?.pushViewController(vc, animated: false)
            break
            
        case "Logout":
            
            _ =  BRDAlertManager.showAlertWithSimilarButtonsType(.default, withTitle: "BarbrDo", withMessage: "Do you really want to logout from the application", buttonTitles: ["OK", "Cancel"], onViewController: self, animated: true, presentationCompletionHandler: {
            }, returnBlock: { response in
                let value: Int = response
                if value == 0{
                    // Logout
               

                    
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    appDelegate.logout()
                    
                }else{
                    // Do not logout
                }
                
            })
            return
        default:
            break
        }
    }
    
    //MARK:- UITableView DataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("no of row --\(self.arrayTableView.count)")
        
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookedchaircell", for: indexPath as IndexPath) as! BookedChairCell
        cell.chairLbl.text = nil
        cell.BarberLbl.text = nil
        cell.chairSplitLbl.text = nil
        cell.chairImage.image = nil
        
        if (arrayTableView != nil)
        {
            
            let obj = self.arrayTableView[indexPath.row]
            let barberobj = self.arrayTableView[indexPath.row].barberArray
            if  (obj.isActive == true)
            {
                
                if(obj.barber_id != nil)
                {
                    cell.chairImage.image = #imageLiteral(resourceName: "ICON_PROFILEIMAGE")
                    
                }
                else
                {
                    cell.chairImage.image =  #imageLiteral(resourceName: "ICON_CHAIR")
                    
                }
                if(obj.availability?.lowercased() == booked)
                {
                    cell.chairSplitLbl.isHidden = false
                    cell.chairLblTopConstraint.constant = 10
                    
                    cell.chairLbl.text = obj.name
                    
                    
                    
                    if let shopPercent = obj.shop_percentage
                    {
                        cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                        
                    }
                        
                        
                        //
                        
                    else   if (obj.type?.lowercased() == "self")
                    {
                        
                        
                        cell.chairSplitLbl.text = "Booked by Non-BarbrDo Barber"
                        cell.chairLblTopConstraint.constant = 30
                        
                    }
                        
                    else    if(obj.type == monthly)
                    {
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden  = true
                        cell.chairSplitLbl.isHidden = false
                        cell.chairLblTopConstraint.constant = 30
                        
                        if let amount = obj.amount
                        {
                            let convertAmount = String(format: "%g", amount)
                            cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/month"
                        }
                        
                    }
                    else    if(obj.type == weekly)
                    {
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden  = true
                        cell.chairSplitLbl.isHidden = false
                        cell.chairLblTopConstraint.constant = 30
                        
                        if let amount = obj.amount
                        {
                            let convertAmount = String(format: "%g", amount)
                            cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/week"
                        }
                    }
                    else if(obj.type == percentage)
                    {
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden = true
                        cell.chairSplitLbl.isHidden = false
                        
                        if let shopPercent = obj.shop_percentage
                        {
                            cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                            cell.chairLblTopConstraint.constant = 30
                            
                        }
                    }
                        
                        
                    else
                    {
                        cell.chairSplitLbl.text = "Chair Split : 0/0"
                        cell.chairLblTopConstraint.constant = 30
                    }
                    
                    if    barberobj != nil
                    {
                        if ((barberobj?.count)! > 0)
                            
                        {
                            if let barberName = barberobj?[0].first_name
                            {
                                cell.BarberLbl.isHidden = false
                                cell.chairLblTopConstraint.constant = 10
                                cell.barberLblTopConstraint.constant = 7
                                
                                cell.BarberLbl.text =  String(format : "By: %@ %@" ,barberName,(barberobj?[0].last_name!)!)
                            }
                            if let obj1 =  barberobj?[0].picture
                            {
                                
                                let imagePath = KImagePathForServer + obj1
                                if imagePath.characters.count > 0{
                                    cell.chairImage.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                                        
                                        DispatchQueue.main.async(execute: {
                                            if image != nil{
                                                cell.chairImage.image =  self.imageWithImage(image: image!, scaledToSize: CGSize(width: cell.chairImage.frame.size.width/2, height: cell.chairImage.frame.size.height/2)).withRenderingMode(UIImageRenderingMode.automatic)
                                                cell.chairImage.layer.masksToBounds = false
                                                //        self.profileImage.layer.borderColor = UIColor.white.cgColor
                                                cell.chairImage.layer.cornerRadius =  cell.chairImage.frame.size.height/2
                                                cell.chairImage.clipsToBounds = true
                                            }
                                            
                                        })
                                    }) }
                            }
                            
                            
                        }
                    }
                }
                    
                    
                else if ( obj.availability?.lowercased() == available )
                    
                {
                    
                    if(obj.type == monthly)
                    {
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden  = true
                        cell.chairSplitLbl.isHidden = false
                        cell.chairLblTopConstraint.constant = 30
                        
                        if let amount = obj.amount
                        {
                            let convertAmount = String(format: "%g", amount)
                            cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/month"
                        }
                        
                    }
                    else    if(obj.type == weekly)
                    {
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden  = true
                        cell.chairSplitLbl.isHidden = false
                        cell.chairLblTopConstraint.constant = 30
                        
                        if let amount = obj.amount
                        {
                            let convertAmount = String(format: "%g", amount)
                            cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/week"
                        }
                    }
                    else if(obj.type == percentage)
                    {
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden = true
                        cell.chairSplitLbl.isHidden = false
                        
                        if let shopPercent = obj.shop_percentage
                        {
                            cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                            cell.chairLblTopConstraint.constant = 30
                            
                        }
                    }
                    
                }
                    
                    
                    
                    
                    
                else if (obj.availability?.lowercased() == closed  && obj.type?.lowercased() == percentage )
                {
                    cell.chairLbl.text = obj.name
                    cell.BarberLbl.isHidden  = true
                    cell.chairSplitLbl.isHidden = false
                    cell.chairLblTopConstraint.constant = 30
                    
                    if let shopPercent = obj.shop_percentage
                    {
                        cell.chairSplitLbl.text = "Chair Split : \(shopPercent)/\(obj.barber_percentage!)"
                        
                    }
                    
                    
                    
                    
                }
                    
                    
                else if (obj.availability?.lowercased() == closed )
                {
                    
                    if(obj.type == monthly)
                    {
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden  = true
                        cell.chairSplitLbl.isHidden = false
                        cell.chairLblTopConstraint.constant = 30
                        
                        if let amount = obj.amount
                        {
                            let convertAmount = String(format: "%g", amount)
                            cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/month"
                        }
                        
                    }
                    else    if(obj.type == weekly)
                    {
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden  = true
                        cell.chairSplitLbl.isHidden = false
                        cell.chairLblTopConstraint.constant = 30
                        
                        if let amount = obj.amount
                        {
                            let convertAmount = String(format: "%g", amount)
                            cell.chairSplitLbl.text = "Chair Rental : $\(convertAmount)/week"
                        }
                        
                    }
                        
                    else
                    {
                        
                        cell.barberLblTopConstraint.constant = 0
                        cell.chairLblTopConstraint.constant = 30
                        cell.chairLbl.text = obj.name
                        cell.BarberLbl.isHidden = false
                        cell.BarberLbl.text = "empty"
                        cell.chairSplitLbl.isHidden = true
                    }
                }
                
                
            }
        }
        
        //        else if(obj.isActive == false)
        //        {
        //
        //        }
        
        
        //            cell.chairLbl.text = obj.chair.name
        
        cell.manageButton.tag = indexPath.row
        cell.manageButton.addTarget(self, action: #selector(BRD_Shop_DashboardVC.manageBookedButtonClicked), for: .touchUpInside)
        return cell
        
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let barberID = self.arrayTableView[indexPath.row].barber_id
        {
            let objBarber : BRD_BarberInfoBO = BRD_BarberInfoBO.init()
            
            let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
                
                
                
                objBarber._id = barberID
                vc.objBarber = objBarber
                UserDefaults.standard.set(true, forKey: "ShopDashboard")
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    // MARK: - TableViewCell Button Action Method.
    
    func manageBookedButtonClicked(sender:UIButton) {
        let storyboard = UIStoryboard(name:"Shop", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_ManageBooked_StoryboardID) as! BRD_Shop_ManageBookChairVC
        
        let obj = self.arrayTableView[sender.tag]
        vc.chairInfoObj = obj
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func manageRequestButtonClicked(sender:UIButton) {
        let storyboard = UIStoryboard(name:"Shop", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Shop_ManageRequestChair_StoryboardID) as! BRD_Shop_ManageRequestChairVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}



