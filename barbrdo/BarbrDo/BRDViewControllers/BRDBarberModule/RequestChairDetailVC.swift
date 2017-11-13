//
//  RequestChairDetailVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 14/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class RequestDetailTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var lblChairDetail: UILabel!
    @IBOutlet weak var btnContactBarberShop: UIButton!
    
    
    
    
    // MARK: - Identifier
    static func identifier() -> String {
        return "RequestDetailTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.imageViewBarber?.layer.masksToBounds = false
//        self.imageViewBarber?.layer.cornerRadius = (self.imageViewBarber?.frame.height)!/2
//        self.imageViewBarber?.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(objChairBarber: BRD_ChairInfo, objBarberShop: BRD_ShopDataBO){
        
        /*if objChairBarber.chair?.booking_date != nil{
            self.lblDate.text = Date.convert((objChairBarber.chair?.booking_date)!, Date.DateFormat.yyyy_MM_dd_T_HH_mm_ss_ssz, Date.DateFormat.EEEE_MMMM_dd)
        }*/
        
        
        if objChairBarber.type == "weekly"{
            // Weekly
            
            self.lblChairDetail.text = "Chair Rental: $ " + String(describing: objChairBarber.amount!) + "/week"
            
        }else if (objChairBarber.type == "monthly"){
            
            self.lblChairDetail.text = "Chair Rental: $ " + String(describing: objChairBarber.amount!) + "/month"
            
        }else{
            // Show Percentage
            
            var ShopPercentage: String = ""
            var barberPercentage: String = ""
            
            if objChairBarber.shop_percentage != nil{
                ShopPercentage = String(describing: objChairBarber.shop_percentage!)
            }
            if objChairBarber.barber_percentage != nil{
                barberPercentage = String(describing: objChairBarber.barber_percentage!)
            }
            let chairSplitRatio = "Chair Split : " + barberPercentage + "/" + ShopPercentage
            
            self.lblChairDetail.text = chairSplitRatio
            
        }
        
        if objBarberShop.address != nil{
            var address = ""
            if let shopName = objBarberShop.name {
                address = shopName + "\n"
            }else{
                address = "Pop's Barber Shop" + "\n"
            }
            if let shopDetails = objBarberShop.address {
                address = address + shopDetails + ", \n"
            }
            if let city = objBarberShop.city {
                address = address + city + ", "
            }
            if let state = objBarberShop.state {
                address = address + state
            }
            self.lblAdress?.text =  address
        }
        
    }
    
}

class RequestChairDetailVC: BRD_BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var strAddress: String? = nil
    var strChairDetail: String? = nil
    
    
    var objChairRequest : ChairRequestInfo? = nil
    var objBarberShopInfo: BRD_ShopDataBO? = nil
    var objChairInfo: BRD_ShopChairs? = nil

    var bookingDate: String? = nil
    var objChairBarber: BRD_ChairInfo? = nil
    
    var shop_user_id: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.addTopNavigationBar(title: "Pending Chair Request Details")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RequestChairDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: RequestDetailTableViewCell.identifier()) as? RequestDetailTableViewCell
        if cell == nil {
            cell = RequestDetailTableViewCell(style: .value1, reuseIdentifier: RequestDetailTableViewCell.identifier())
        }
        cell?.lblDate.text = Date.convert(self.bookingDate!, Date.DateFormat.yyyy_MM_dd, Date.DateFormat.EEEE_MMMM_dd)
        cell?.initWithData(objChairBarber: self.objChairBarber!, objBarberShop: self.objBarberShopInfo!)
        cell?.btnContactBarberShop.addTarget(self, action: #selector(btnContactBarberShopAction), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 417.0
    }

    @objc private func btnContactBarberShopAction(){
        
        let storyboard = UIStoryboard(name:barberStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactShopVC") as!
        ContactShopVC
        //vc.appointmentDate = self.bookingDate
        vc.objshopData = self.objBarberShopInfo
        vc.shop_user_id = self.shop_user_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
