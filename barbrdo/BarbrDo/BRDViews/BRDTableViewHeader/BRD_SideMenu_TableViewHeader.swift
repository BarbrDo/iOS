//
//  BRD_SideMenu_TableViewHeader.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 03/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SDWebImage


let KBRD_SideMenu_TableViewHeader_CellIdentifier = "BRD_SideMenu_TableViewHeader_CellIdentifier"

class BRD_SideMenu_TableViewHeader: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnTranspartent: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgView?.layer.masksToBounds = false
        self.imgView?.layer.cornerRadius = (self.imgView?.frame.height)!/2
        self.imgView?.clipsToBounds = true
        
        if let objUser = BRDSingleton.sharedInstane.objBRD_UserInfoBO{
            self.lblName.text = objUser.first_name! + " " + objUser.last_name!
            
            // Set Profile Image
            
            self.activityIndicator.startAnimating()
            if objUser.picture != nil && objUser.picture != ""{
                let imagePath = KImagePathForServer +  objUser.picture!
                self.imgView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.imgView.image = image
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.imgView.image = UIImage(named:"ICON_PROFILEIMAGE.png")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
