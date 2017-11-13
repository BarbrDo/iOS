//
//  BRD_Shop_ManageRequestChairVC.swift
//  BarbrDo
//
//  Created by Paritosh Srivastava on 6/1/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_Shop_ManageRequestChair_StoryboardID = "BRD_Shop_ManageRequestChairVCStoryboardID"
class BRD_Shop_ManageRequestChairVC: BRD_BaseViewController {
    
    
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var chairSplitLbl: UILabel!
    @IBOutlet weak var percentageSlider: UISlider!
    @IBOutlet weak var percentageLbl: UILabel!
    @IBOutlet weak var rentChairBtn: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    
    @IBOutlet weak var priceValueTextField: BRDTextField!
    
    var isSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightConstraint.constant = 0
        self.whiteBackgroundView.layer.cornerRadius = 4.0
        self.percentageLbl.text  = "35 %"
        // self.priceValueTextField.addImage(name: "ICON_DOLLAR")
        self.percentageSlider.setThumbImage(UIImage(named: "active_radio"), for:.normal)
        
        self.percentageSlider.setThumbImage(UIImage(named: "active_radio"), for:.highlighted)
        self.monthlyBtn.isHidden = true
        self.weeklyBtn.isHidden = true
        self.priceValueTextField.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderPercentageChanged(_ sender: UISlider) {
        let currentValue = Int(sender .value)
        DispatchQueue.main.async(execute: {
            self.percentageLbl.text = "\(currentValue) %"
            //
        })
        
    }
    
    @IBAction func rentChairButtonAction(_ sender: Any) {
        
        if isSelected
        {
            heightConstraint.constant = 0
            isSelected = false
            self.monthlyBtn.isHidden = true
            self.weeklyBtn.isHidden = true
            self.priceValueTextField.isHidden = true
            
        }
        else {
            heightConstraint.constant = 84
            isSelected = true
            self.monthlyBtn.isHidden = false
            self.weeklyBtn.isHidden = false
            self.priceValueTextField.isHidden = false
            
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
