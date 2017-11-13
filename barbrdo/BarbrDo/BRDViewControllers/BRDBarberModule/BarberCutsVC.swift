//
//  BarberCutsVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class BarberHairCuts: UITableViewCell{
    
    @IBOutlet weak var imgViewBarberHaricut: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCuts: UILabel!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.imgViewBarberHaricut.layer.borderWidth = 1.0
        self.imgViewBarberHaricut.layer.masksToBounds = false
        self.imgViewBarberHaricut.layer.borderColor = UIColor.white.cgColor
        self.imgViewBarberHaricut.layer.cornerRadius = self.imgViewBarberHaricut.frame.size.width/2
        self.imgViewBarberHaricut.clipsToBounds = true
    }
    
    func initWithData(obj: BRD_RatingsBO){
        self.lblName.text = obj.rated_by_name
        if obj.appointment_date != nil{
            self.lblCuts.text = 
                Date.convert(obj.appointment_date!, Date.DateFormat.yyyy_MM_dd_HH_mm_ss_, Date.DateFormat.MM_dd_yyYY)
        }
        self.starRatingView.value = CGFloat(obj.score!)
        
        
        if obj.picture != nil{
            let imagePath = KImagePathForServer + obj.picture!
            self.imgViewBarberHaricut.sd_setImage(with:  URL(string: imagePath), completed: { (image, error, cache, url) in
                
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        self.imgViewBarberHaricut.image = image
                    }else{
                        self.imgViewBarberHaricut.image = UIImage(named: "ICON_PROFILEIMAGE")
                    }
                })
            })
        }else{
            self.imgViewBarberHaricut.image = UIImage(named: "ICON_PROFILEIMAGE")
        }
    }
}

class BarberCutsVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var arrayTableView = [BRD_RatingsBO]()
    var objUserInfo: BRD_UserInfoBO = BRD_UserInfoBO.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let header : NavigationBarWithTitle = Bundle.main.loadNibNamed(String(describing: NavigationBarWithTitle.self), owner: self, options: nil)![0] as! NavigationBarWithTitle
        header.btnBack.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        header.initWithTitle(title: "Reviews")
        header.frame = CGRect(x:0, y:0, width:view.frame.width, height:100)
        self.view.addSubview(header)
    }
    
    func btnBackAction(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BarberCutsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BarberHairCuts = tableView.dequeueReusableCell(withIdentifier: "BarberHairCuts") as! BarberHairCuts
        cell.initWithData(obj: self.arrayTableView[indexPath.row])
        //cell.lblName.text = self.arrayTableView[indexPath.row]
        //cell.imgView.image = self.arrayImageView[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81.0
    }
  }


