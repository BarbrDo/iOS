//
//  BRD_ForgotPasswordVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 02/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import SwiftLoader

let KBRD_ForgotPasswordVC_StoryboardID = "BRD_ForgotPasswordVC_StoryboardID"

private enum ForgotPasswordButtons: Int {
    case btnBack = 101
    case btnForgotPassword
}

class BRD_ForgotPasswordVC: BRD_BaseViewController {
    
    @IBOutlet weak var txtEmailAddress: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = false
        
        self.txtEmailAddress?.attributedPlaceholder = NSAttributedString(string: "Email address",attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPasswordScreenButtonActions(_ sender: UIButton) {
        
        switch sender.tag {
        case ForgotPasswordButtons.btnBack.rawValue:
                self.navigationController?.popViewController(animated: true)
            break
        case ForgotPasswordButtons.btnForgotPassword.rawValue:
                let isValid =  BRDRawStaticStrings.isValidEmail(testStr: (self.txtEmailAddress?.text)!)
                
                if isValid == false{
                    _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: "Please enter valid email address", onViewController: self, returnBlock: { (clickedIN) in
                        
                    })
                    return
                }
                SwiftLoader.show(KLoading, animated: true)
                
                let inputParameters: [String: String] = ["email": self.txtEmailAddress.text!]
                print(inputParameters)
                let urlString = KBaseURLString + KForgotURL
                BRDAPI.forgotPassword("POST", inputParameters: inputParameters, header: nil, urlString: urlString, completionHandler: { (response, responseString, status, error) in
                    
                    SwiftLoader.hide()
                    
                    if responseString != nil{
                        _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }else{
                        var errorMessage: String? = nil
                        if error == nil{
                            errorMessage = "This email address does not exist"
                        }else{
                            errorMessage = error?.localizedDescription
                        }
                        _ = BRDAlertManager.showOKAlert(withTitle: KAlertTitle, withMessage: errorMessage, onViewController: self, returnBlock: { (clickedIN) in
                            
                        })
                    }
                })
            break
        default:
            break
        }
    }
    
}


