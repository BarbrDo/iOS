//
//  BarberNotAcceptedVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 04/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

class BarberNotAcceptedVC: UIViewController {
    
    @IBOutlet weak var btnSearchAgain: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        btnSearchAgain.backgroundColor = .clear
        btnSearchAgain.layer.borderWidth = 2
        btnSearchAgain.layer.borderColor = UIColor.white.cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSearchAgainAction(sender: UIButton){
    
        self.navigationController?.popToRootViewController(animated: true)
    }

    

}
