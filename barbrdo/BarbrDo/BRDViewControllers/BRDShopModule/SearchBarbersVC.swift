//
//  SearchBarbersVC.swift
//  BarbrDo
//
//  Created by Shami Kumar on 14/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader
class SearchBarbersVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var arrayTableView = [BarberSearch]()
    var searchActive : Bool = false
    var filtered:[BarberSearch] = []
    var objBarberShops: BRD_ShopDataBO? = nil
    var refreshControl: UIRefreshControl!
    var inputParameters = [String: Any]()
    var chairInfoObj : BRD_ChairInfo?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let urlString = KBaseURLString + KBarberSearch
         self.getBarbers(urlString)
        
        tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    
   
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        let urlString = KBaseURLString + KBarberSearch
        self.getBarbers(urlString)
        refreshControl.endRefreshing()
    }

    // MARK :- Search Barbers Delegates
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        let urlString = KBaseURLString + KBarberSearch
        self.getBarbers(urlString)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        
        searchBar.resignFirstResponder()
        self.searchBarber(searchString: searchBar.text!)

    }
    
    
    func searchBarber(searchString: String){
        let urlString = KBaseURLString + KBarberShopSearch + searchString
        self.getBarbers(urlString)
        
               }
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty)
        {
             searchBar.resignFirstResponder()
            let urlString = KBaseURLString + KBarberShopSearch
            self.getBarbers(urlString)
        }
    }
    
    
// MARK :- Date conversion
    func convertDateString(obj: String) -> String?{
        let myDate = obj //obj.appointment_date // "2016-06-20T13:01:46.457+02:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:myDate)!
        dateFormatter.dateFormat = "MMM yyyy"
        let dateString = dateFormatter.string(from:date)
        
        print(dateString)
        
        return dateString
    }

    //MARK:- UITableView DataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print ("rowaaa -- \(self.arrayTableView.count)")
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "barberSearchCell", for: indexPath as IndexPath) as! BarberSearchCell
        
        let barberObj = self.arrayTableView[indexPath.row]
    
        
        if let firstName = barberObj.first_name
        {
            if let lastName = barberObj.last_name
            {
                cell.nameLbl.text = firstName + " " + lastName

            }
        }
        
        if let sinceDate = barberObj.created_date
        {
            if let convertDate = self.convertDateString(obj: sinceDate)
            {
            cell.sinceLbl.text =  String(format : "Member Since : %@",convertDate)
        }
        }
        
        if let rating = barberObj.ratings as? NSArray
        {
            var totalScore : Float? = 0.0
            for obj in rating
            {
               if let score = (obj as AnyObject).value(forKey: "score") as? Float
               {
               totalScore  = (totalScore! + score)
                
                cell.starView.isUserInteractionEnabled = false
                cell.starView.value = CGFloat(totalScore!/Float(rating.count))
                cell.starView.isUserInteractionEnabled = false
                }
            }
            
           
            
//             cell.starView.value = CGFloat(Float(score!))
            
        }
        cell.requestBtn.tag = indexPath.row
        cell.requestBtn.addTarget(self, action: #selector(SearchBarbersVC.requestBtnAction), for: .touchUpInside)
        return cell
        
        
    }
func requestBtnAction(sender:UIButton)
{
    let date = Date()
    let formatter = DateFormatter()
    
    formatter.dateFormat = "yyyy-MM-dd"
    
    let finalDate = formatter.string(from: date)
    
   
    
    
//    let shopDetails = BRDSingleton.sharedInstane.objBRD_UserInfoBO
    
    let shopInfo = self.chairInfoObj
    
    
    let objChairBarber = self.arrayTableView[sender.tag]
    
    let chairID: String = (shopInfo?._id)!
    let barberID: String = (objChairBarber._id)!
    let barberName: String  = (objChairBarber.first_name)! + " " + (objChairBarber.last_name)!
    
    let chairName : String? = shopInfo?.name
    let amount : Float? = shopInfo?.amount
    
    
    let barberPercentage : Int? = shopInfo?.barber_percentage
    
    let shop_percentage : Int? = shopInfo?.shop_percentage
    
    
    let chairType : String? = shopInfo?.type
    let shopID: String = BRDSingleton.sharedInstane.objShop_id!

    
//           inputParameters = ["shop_id": shopID,
//                           "chair_id": chairID,
//                           "barber_id": barberID,
//                           "barber_name": barberName,
//                           "booking_date": finalDate  ,"user_type" : "shop", "chair_name" : chairName == nil ? "" : chairName! ]
//    
    
    
        inputParameters = ["shop_id": shopID,
                           "chair_id": chairID,
                           "barber_id": barberID,
                           "barber_name": barberName,
                           "booking_date": finalDate ,"user_type" : "shop", "chair_name" : chairName == nil ? "" : chairName! , "barber_percentage" : barberPercentage == nil ? 0 : barberPercentage! , "shop_percentage" : shop_percentage == nil ? 0 : shop_percentage! ,"chair_amount" : amount == nil ? 0 : amount! ,"chair_type" : chairType == nil ? "" : chairType! ]
        
    
    
    
    
    let latitude = BRDSingleton.sharedInstane.latitude
    let longitude = BRDSingleton.sharedInstane.longitude
    
    let userID = BRDSingleton.sharedInstane.objBRD_UserInfoBO?._id
//    let header: [String: String] = [ "device_latitude": "40.749485", "device_longitude": "-73.991769", "user_id": KUserID]

    let header: [String: String] = [KLatitude : latitude!,
                                    KLongitude : longitude!,
                                    KUserID : userID!]
    
    
    
    let urlString = KBaseURLString + KRequestChairToBarberShop
    
    SwiftLoader.show(KLoading, animated: true)
    BRDAPI.postShopBarberRequest("POST", inputParameter: inputParameters, header: header, urlString: urlString) { (reponse, responseMessage, status, error) in
        SwiftLoader.hide()
        
        
        if let serverMessage = responseMessage {
            
            
                // SUCCESS CASE
                                            _ = BRDAlertManager.showOKAlert(withTitle: "BarbrDo", withMessage: serverMessage, onViewController: self, returnBlock: { (clickedIN) in
                
                                            })
            
        }
        else{
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                
            })
        }
        
        
        if error != nil{
            _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                
                
            })

        
        
        }

    }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK :- Get Barber Listing
    func getBarbers(_ url : String)
    {
        let header = BRDSingleton.sharedInstane.getHeaders()
        
        if header == nil{return}
        
        SwiftLoader.show("Loading Barbers...", animated: true)
        
    BRDAPI.getBarberList(requestType: "GET", inputParameter: nil, header: header!, urlString: url) { (response, arrayServices, status, error) in
            
            SwiftLoader.hide()
            self.arrayTableView.removeAll()
        
        if(arrayServices != nil)
        {
        
            if  (arrayServices?.count)! > 0
                
            {
                BRDSingleton.removeEmptyMessage(self.view)
                
                for obj in arrayServices!
                {
                
                        self.arrayTableView.append(obj)
                    
                    
                    
                               }
                
                self.tableView.reloadData()
            }
            
            else
            {
                self.arrayTableView.removeAll()
                self.tableView.reloadData()
                self.view.addSubview(BRDSingleton.showEmptyMessage("No Barber found.", view: self.view))
            }
            
            
            if error != nil{
                self.arrayTableView.removeAll()
                _ = BRDAlertManager.showOKAlert(withTitle: nil, withMessage: error?.localizedDescription, onViewController: self, returnBlock: { (clickedIN) in
                    
                    
                })
                return
            }
        }
        }
        
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
    
    _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
