//
//  SAAlertController.swift
//  SquadApp
//
//  Created by Vishwajeet Kumar on 1/16/17.
//  Copyright © 2017 Vishwajeet Kumar. All rights reserved.
//

import UIKit

/**
 * Constant will use for AlertView and Actionsheet
 */
let KOk                       =       "Ok"
let KSettings                 =       "Settings"
let KCancel                   =       "Cancel"
let KYes                      =       "Yes"
let KNo                       =       "No"
let KGalary                   =       "Gallery"

private  let iPad = UIDevice.current.userInterfaceIdiom == .pad && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 1024.0
private  let iPadRetina = UIDevice.current.userInterfaceIdiom == .pad && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 1366.0

typealias VSAlertActionHandler  = ((_ buttonPressed: String) -> Void)?
typealias VSButtonActionHandler = ((_ buttonPressed: String,_ text:String) -> Void)?


extension UIAlertController {
    
    // Alert with message
    class func show(_ sender: UIViewController, _ title : String?, _ message : String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: KOk, style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
    // Alert with button action
    class func show(_ sender: UIViewController, _ title: String?, _ message: String?, _ buttonTitles : [String], completion: VSAlertActionHandler) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for buttonTitle in buttonTitles {
            alertView.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: {
                (action : UIAlertAction) -> Void in
                completion!(action.title!)
            }))
        }
        sender.present(alertView, animated: true, completion: nil)
    }
    
    // Alert with textfield
    class func show(_ sender: UIViewController, _ title: String?, _ message: String?, _ buttonTitles : [String], _ completion: VSButtonActionHandler){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView .addTextField(configurationHandler: { (textField) in
        })
        
        for buttonTitle in buttonTitles {
            alertView.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: {
                (action : UIAlertAction) -> Void in
                let textField = alertView.textFields![0] as UITextField
                completion!(action.title!,textField.text! as String)
            }))
        }
        sender.present(alertView, animated: true, completion: nil)
    }
    
    // Actionsheet
    class func show(_ sender: UIViewController, _ title: String?, _ message: String?, _ cancelButtonTitle: String, _ destructiveButtonTitle: String, _ otherButtonTitles: [String], _ completion: VSAlertActionHandler) {
        
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if ((cancelButtonTitle.isEmpty) == false) {
            actionSheetController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
                (action : UIAlertAction) -> Void in
                completion!(action.title!)
            }))
        }
        if ((destructiveButtonTitle.isEmpty) == false) {
            actionSheetController.addAction(UIAlertAction(title: destructiveButtonTitle, style: .destructive, handler: {
                (action : UIAlertAction) -> Void in
                completion!(action.title!)
            }))
        }
        for buttonTitle in otherButtonTitles {
            actionSheetController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: {
                (action : UIAlertAction) -> Void in
                completion!(action.title!)
            }))
        }
        
        if iPad || iPadRetina {
            actionSheetController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            actionSheetController.popoverPresentationController?.sourceRect = self .sourceRectForBottomAlertController(actionSheetController)();
            actionSheetController.popoverPresentationController!.sourceView = sender.view;
            sender.present(actionSheetController, animated: true, completion: nil)
            
        }
        else {
            sender.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    func sourceRectForBottomAlertController() -> CGRect {
        var sourceRect :CGRect = CGRect.zero
        sourceRect.origin.x = self.view.bounds.midX - self.view.frame.origin.x/2.0
        sourceRect.origin.y = self.view.bounds.midY
        return sourceRect
    }
}
