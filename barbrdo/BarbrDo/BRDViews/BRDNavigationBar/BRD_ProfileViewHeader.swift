//
//  BRD_ProfileViewHeader.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 27/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BRD_ProfileViewHeader: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnCuts: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userImageView?.layer.borderWidth = 2
        self.userImageView?.layer.masksToBounds = false
        self.userImageView?.layer.cornerRadius = (self.userImageView?.frame.height)!/2
        self.userImageView?.clipsToBounds = true
        self.userImageView?.layer.borderColor = UIColor.white.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func initWithData(obj : BRD_UserInfoBO){
        self.lblName.text = obj.first_name! + " " + obj.last_name!
        
        // Set Profile Image
        
        self.activityIndicator.startAnimating()
        if obj.picture != nil && obj.picture != ""{
            let imagePath = KImagePathForServer +  obj.picture!
            self.userImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.userImageView.image = image
                    }else{
                         self.userImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            })
        }else{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
        
        if let images = obj.barberProfile?.gallery{
            let count = String(describing: images.count) + " Photos"
            self.btnPhoto.setTitle(count, for: .normal)
        }else{
           if let images = obj.gallery{
                let count = String(describing: images.count) + " Photos"
                self.btnPhoto.setTitle(count, for: .normal)
            }
        }
        
        if let cuts = obj.rating{
            let count = String(describing: cuts.count) + " Cuts"
            self.btnCuts.setTitle(count, for: .normal)
        }
    }
    
    
    func initWithData(obj : BRD_UserInfoBO?, objUserProfile: BRD_UserProfileBO?){
        
        if obj != nil{
            self.lblName.text = (obj?.first_name!)! + " " + (obj?.last_name!)!
            
            // Set Profile Image
            
            self.activityIndicator.startAnimating()
            if obj?.picture != nil && obj?.picture != ""{
                let imagePath = KImagePathForServer +  (obj?.picture!)!
                self.userImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.userImageView.image = image
                        }else{
                            self.userImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
            
            if let images = obj?.barberProfile?.gallery{
                let count = String(describing: images.count) + " Photos"
                self.btnPhoto.setTitle(count, for: .normal)
            }else{
                if let images = obj?.gallery{
                    let count = String(describing: images.count) + " Photos"
                    self.btnPhoto.setTitle(count, for: .normal)
                }
            }
            
            if let cuts = obj?.rating{
                let count = String(describing: cuts.count) + " Cuts"
                self.btnCuts.setTitle(count, for: .normal)
            }

        }
        
        if objUserProfile != nil{
            self.lblName.text = (objUserProfile?.first_name!)! + " " + (objUserProfile?.last_name!)!
            
            // Set Profile Image
            
            self.activityIndicator.startAnimating()
            if objUserProfile?.picture != nil && objUserProfile?.picture != ""{
                let imagePath = KImagePathForServer +  (objUserProfile?.picture!)!
                self.userImageView.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                    
                    DispatchQueue.main.async(execute: {
                        if image != nil{
                            self.userImageView.image = image
                        }else{
                            self.userImageView.image = UIImage.init(named: "ICON_PROFILEIMAGE")
                        }
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    })
                })
            }else{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
            
            if let images = objUserProfile?.gallery{
                let count = String(describing: images.count) + " Photos"
                self.btnPhoto.setTitle(count, for: .normal)
            }else{
                if let images = objUserProfile?.gallery{
                    let count = String(describing: images.count) + " Photos"
                    self.btnPhoto.setTitle(count, for: .normal)
                }
            }
            
            if let cuts = objUserProfile?.ratings{
                let count = String(describing: cuts.count) + " Cuts"
                self.btnCuts.setTitle(count, for: .normal)
            }
            
        }
        
    }
}
