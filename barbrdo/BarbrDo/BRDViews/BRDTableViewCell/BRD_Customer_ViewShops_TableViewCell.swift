//
//  BRD_Customer_ViewShops_TableViewCell.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 11/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Customer_ViewShops_TableViewCell_CellIdentifier = "BRD_Customer_ViewShops_TableViewCell_CellIdentifier"

class BRD_Customer_ViewShops_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblBarberCount: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var btnDetail: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithData(obj: BRD_ShopDataBO){
        
        self.lblShopName.text = obj.name
        self.lblBarberCount.text = String(describing: obj.barbers!)
        self.lblDistance.text = String(format:"%.2f", obj.distance!) + " Miles"
    }
    
    
    
    
    
    
}
