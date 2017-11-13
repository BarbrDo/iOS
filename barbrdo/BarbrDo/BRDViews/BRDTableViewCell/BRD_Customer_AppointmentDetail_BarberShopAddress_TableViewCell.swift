//
//  BRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell_CellIdenfier = "BRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell_CellIdentifier"

class BRD_Customer_AppointmentDetail_BarberShopAddress_TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewBarberShopAddress: UIView!
    
    @IBOutlet weak var viewBarberShopMap: UIView!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnShowOnMap: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // self.viewBarberShopAddress.round(corners: [.topLeft, .topRight], radius: 3.0, borderColor: UIColor.clear, borderWidth: 1.0)
        //self.viewBarberShopMap.round(corners: [.bottomRight, .bottomLeft], radius: 3.0, borderColor: UIColor.clear, borderWidth: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithData(obj: BRD_AppointmentsInfoBO){
        let objData = obj.shop_id
        if let address = objData?.address{
            self.lblAddress.text = address
        }
        
    }
    
}
