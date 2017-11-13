//
//  ProvideCustomerRating.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 22/06/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftyStarRatingView


class ProvideCustomerRating: UIViewController {
    
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var objAppointmentInfo : BRD_AppointmentsInfoBO?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSubmitAction(sender: UIButton){
        
    }

    @IBAction func backButtonAction(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
