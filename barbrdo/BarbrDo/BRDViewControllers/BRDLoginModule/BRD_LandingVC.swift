//
//  BRD_LandingVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 01/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit

let KBRD_LandingVC_StoryboardID = "BRD_LandingVC_StoryboardID"

class BRD_LandingVC: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
var hasComeFromSignUp: Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        if self.hasComeFromSignUp == true{
            self.hasComeFromSignUp = false
            self.btnLandingScreenAction(self.btnLogin)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func btnLandingScreenAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 101:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: KBRD_LoginVC_StoryboardID) as! BRD_LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 102:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: KBRD_RegisterVC_StoryboardID) as! BRD_RegisterVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
        
    }
}
