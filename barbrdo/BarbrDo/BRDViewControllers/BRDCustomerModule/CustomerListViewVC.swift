//
//  CustomerListViewVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 26/07/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

class BarberListingCell: UITableViewCell{
    
    //IBOutlets
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblBarberShopName: UILabel!
    @IBOutlet weak var lblBarberServices: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewStarImage: UIImageView!
    @IBOutlet weak var lblRatingValue: UILabel!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var btnOffline: UIButton!
    
    @IBOutlet weak var btnViewProfile: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "BarberListingCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgViewProfile.layer.borderWidth = 1.0
        self.imgViewProfile.layer.masksToBounds = false
        self.imgViewProfile.layer.borderColor = UIColor.white.cgColor
        self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.size.width/2
        self.imgViewProfile.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func initWithData(obj: BarberListBO){
        
        // Barber Image
        
        if obj.picture != nil{
            let imagePath = KImagePathForServer + obj.picture!
            self.activityIndicator.startAnimating()
            self.imgViewProfile.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.imgViewProfile.image = image
                    }else{
                        self.imgViewProfile.image = UIImage(named: "ICON_PROFILEIMAGE")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            })
        }else{
            self.imgViewProfile.image = UIImage(named: "ICON_PROFILEIMAGE")
            self.activityIndicator.hidesWhenStopped = true
        }
        print(String(obj.last_name!.characters.prefix(1)))
        
        self.lblBarberName.text =  obj.first_name!.capitalized + " " + String(obj.last_name!.characters.prefix(1)).capitalized
        
        var shopName = obj.barber_shops?.name
        shopName = shopName! + " (" + String(format: "%.0f", obj.distance!) + " mi" + ")"
        self.lblBarberShopName.text = shopName
        
        var services: String = ""
        
        for temp in obj.barber_services{
            services += temp.name! + ": $" + String(format: "%.02f", temp.price!)
            services += ", "
        }
        
        let endIndex = services.index(services.endIndex, offsetBy: -2)
        let truncated = services.substring(to: endIndex)
        
        var ratingValue: String = "0"
        
        if obj.ratings?.count == 0{
            ratingValue = "0.0"
        }else{
            var countVal: Float = 0.0
            for temp in obj.ratings!{
                let ratObj = temp as BRD_RatingsBO
                countVal = countVal + ratObj.score!
            }
            let meanVal: Float = countVal / Float((obj.ratings?.count)!)
            ratingValue =  String(format: "%.01f", meanVal)
        }
        self.lblRatingValue.text = ratingValue
        self.lblBarberServices.text = truncated
        
        
        // Add condition for offine or o
        if obj.is_online == true{
        
            self.btnOffline.isHidden = true
            self.btnRequest.isHidden = false
            self.lblBarberShopName.isHidden = false
            self.lblBarberServices.isHidden = false
        }else{
            self.btnOffline.isHidden = false
            self.btnRequest.isHidden = true
            self.lblBarberShopName.isHidden = true
            self.lblBarberServices.isHidden = true
        }
        
        // Add Condition for Star hidden or not
        if obj.is_favourite == true{
            self.imgViewStarImage.isHidden = false
        }else{
            self.imgViewStarImage.isHidden = true
        }
    }
}

class CustomerListViewVC: UIViewController {
    
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // Instance Variables
    var arrayTableView = [BarberListBO]()
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
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.fetchAllBarbers()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchAllBarbers()
    }
    
    
    func fetchAllBarbers(){
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        SwiftLoader.show("Fetching data...", animated: true)
        let urlString: String = KBaseURLString + KFetchAllBarbers
        print(urlString)
        BRDAPI.getAllBarber("GET", inputParameters: nil, header: header, urlString: urlString) { (arrayBarber, error) in
            
            SwiftLoader.hide()
            
            if arrayBarber != nil{
//                BRDSingleton.sharedInstane.objBarberInfo = objBarber
//                self.objProfile = objBarber
//                self.updateProfile(obj: objBarber!)
                
                if arrayBarber?.count == 0{
                    self.view.addSubview(BRDSingleton.showEmptyMessage("No barbers could be found", view: self.view))
                }else{
                     BRDSingleton.removeEmptyMessage(self.view)
                }
                
                self.arrayTableView.removeAll()
                self.arrayTableView = arrayBarber!
                self.tableView.reloadData()
            }else{
                self.view.addSubview(BRDSingleton.showEmptyMessage("No barbers could be found", view: self.view))
            }
        }
    }
}

extension CustomerListViewVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberListingCell", for: indexPath) as? BarberListingCell
        
        cell?.initWithData(obj: self.arrayTableView[indexPath.row])
        cell?.btnRequest.addTarget(self, action: #selector
            (btnRequestBarberAction(_:)), for: .touchUpInside)
        cell?.btnViewProfile.addTarget(self, action: #selector(btnViewProfileAction(_:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    // Request Barber
    @IBAction func btnRequestBarberAction(_ sender: UIButton) {
        
         let indexPath = BRDUtility.indexPath(self.tableView, sender)
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RequestBarberVC") as! RequestBarberVC
        vc.objBarberDetail = self.arrayTableView[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func btnViewProfileAction(_ sender: UIButton){
        
        let indexPath = BRDUtility.indexPath(self.tableView, sender)
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "BRD_ViewProfileVC") as? BRD_ViewProfileVC {
            
            vc.objBarberInfo = self.arrayTableView[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
