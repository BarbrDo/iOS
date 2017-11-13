
//  BRD_MapAnnotation.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 24/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_MapAnnotation: UITableViewCell {
    
   
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBarberCount: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnDetail: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithData(obj: BRD_ShopDataBO){
        self.lblName.text = obj.name
            if(obj.barberArray.count>0){
                self.lblBarberCount.text = String(describing: (obj.barberArray.count))
                self.lblDistance.text = String(describing: obj.distance!)
                
        }
        
        
        
    }
    
    @IBAction func btnDetailAction(_ sender: UIButton) {
        
        print("Hello World")
    }
    
    
}
