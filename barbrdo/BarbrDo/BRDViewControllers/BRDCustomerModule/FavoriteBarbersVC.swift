//
//  FavoriteBarbersVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 02/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

class FavoriteBarberCell: UITableViewCell{
    
    //IBOutlets
    @IBOutlet weak var lblBarberName: UILabel!
    @IBOutlet weak var lblBarberShopName: UILabel!
    @IBOutlet weak var lblBarberServices: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewStarImage: UIImageView!
    
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var btnOffline: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnViewBarberProfile: UIButton!
    
    @IBOutlet weak var lblRating: UILabel!
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "FavoriteBarberCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnOffline.isHidden = true
        
        self.lblBarberShopName.isHidden = true
        self.lblBarberServices.isHidden = true
        self.activityIndicator.isHidden = true
        
        
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
        
        
        self.lblBarberName.text = obj.first_name!.capitalized + " " + String(obj.last_name!.characters.prefix(1)).capitalized
        
        
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
        self.lblRating.text = ratingValue
//        
//        var shopName = obj.barber_shops?.name
//        shopName = shopName! + "(" + "0.2" + "mi" + ")"
//        
//        self.lblBarberShopName.text = shopName
//        self.lblBarberServices.text = ""
        
//        // Add Condition for Star hidden or not
//        self.imgViewStarImage.isHidden = true
//        
//        // Add condition for offine or o
//        self.btnOffline.isHidden = true
//        self.btnRequest.isHidden = false
        
        
        
        // Add condition for offine or o
//        if obj.is_online == true{
//            
//            self.btnOffline.isHidden = true
//            self.btnRequest.isHidden = false
//            self.lblBarberShopName.isHidden = false
//            self.lblBarberServices.isHidden = false
//        }else{
//            self.btnOffline.isHidden = false
//            self.btnRequest.isHidden = true
//            self.lblBarberShopName.isHidden = true
//            self.lblBarberServices.isHidden = true
//        }
        
    }
    
}

class FavoriteBarbersVC: BRD_BaseViewController {
    
    //IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayTableView = [BarberListBO]()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let header = Bundle.main.loadNibNamed(String(describing: BRD_NavigationBar.self), owner: self, options: nil)![0] as? BRD_NavigationBar
//        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
//        header?.lblTitle.text = "Favorite Barber"
//        header?.btnSideMenu.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
//        self.view.addSubview(header!)
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
        
        let header : NavigationBarWithTitleAndBack = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitleAndBack.self), owner: self, options: nil)![0] as! NavigationBarWithTitleAndBack
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.btnProfile.addTarget(self, action: #selector(btnProfileMenu), for: .touchUpInside)
        header.initWithTitle(title: "Favorite Barber")
        header.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        self.view.addSubview(header)
        
    }
    func btnBackAction(){
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnProfileMenu(){
        
        let storyboard = UIStoryboard(name:customerStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KBRD_Customer_Profile_StoryboardID) as! BRD_Customer_ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        self.getFavoriteBarber()
        refreshControl.endRefreshing()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getFavoriteBarber()
    }

//    override func toggleMenu() {
//        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getFavoriteBarber(){
        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        SwiftLoader.show("Fetching data...", animated: true)
        let urlString: String = KBaseURLString + KFavoriteBarbers
        print(urlString)
        BRDAPI.getAllBarber("GET", inputParameters: nil, header: header, urlString: urlString) { (arrayBarber, error) in
            
            
            SwiftLoader.hide()
            if arrayBarber != nil{
                
                print(arrayBarber?.count)
                self.arrayTableView.removeAll()
                self.arrayTableView = arrayBarber!
                self.tableView.reloadData()
            }
        }
    }

}


extension FavoriteBarbersVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //mark
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteBarberCell", for: indexPath) as? FavoriteBarberCell
        cell?.initWithData(obj: self.arrayTableView[indexPath.row])
        cell?.btnRequest.addTarget(self, action: #selector(btnRemoveFavBarberAction(_:)), for: .touchUpInside)
         cell?.btnViewBarberProfile.addTarget(self, action: #selector(btnViewProfileAction(_:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.5
    }
    
    
    // Remove Barber as Favorite
    
    @IBAction func btnRemoveFavBarberAction(_ sender: UIButton) {
        //customer/favouritebarber
        
        let indexPath = BRDUtility.indexPath(self.tableView, sender)
        
        let obj = self.arrayTableView[indexPath.row]

        
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{
            BRDSingleton.sharedInstane.dismissLoader(viewController: self)
            
            _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Kindly enable location services from the settings", onViewController: self, returnBlock: { (clickedIN) in
            })
            return
        }
        
        SwiftLoader.show("Fetching data...", animated: true)
        let urlString: String = KBaseURLString + KRemoveFavoriteBarber + obj._id!
        print(urlString)
        
        BRDAPI.deleteFavoriteBarber("DELETE", inputParameters: nil, header: header!, urlString: urlString) { (response, responseString, status, error) in
            
            SwiftLoader.hide()
            
            if status == 200{
                self.arrayTableView.remove(at: indexPath.row)
                self.tableView.reloadData()
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                })
                return
            }
            
        }
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
