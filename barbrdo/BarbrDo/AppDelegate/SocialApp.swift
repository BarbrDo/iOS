//
//  SASocialApplication.swift
//  SquadApp
//
//  Created by Vishwajeet Kumar on 1/17/17.
//  Copyright © 2017 Vishwajeet Kumar. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit

public let KFacebookSessionExpired     =    "Facebook session has been expired."

let parameteres: [String : Any] = ["fields": "id, name, gender, first_name, last_name, email, location, friends, hometown, picture.type(large)"]

public typealias FBLoginResponse = ([String: Any]?, Error?) -> Void

class SocialApp: NSObject {
    
    // MARK:  FACEBOOK
    public class func loginWithFacebook(_ viewController: UIViewController!, _ completionHandler: @escaping FBLoginResponse) {
        let fbSDKLoginManager = FBSDKLoginManager()
        if viewController != nil {
            if (FBSDKAccessToken.current() != nil) {
                SocialApp._getFBUserWithCompletionHandler(completionHandler)
            } else {
               
                fbSDKLoginManager.logIn(withReadPermissions: ["public_profile"], from: viewController, handler: { (result, error) -> Void in
                    if error == nil {
                        if (result?.isCancelled)! {
                            completionHandler(nil, NSError(domain: "Cancelled by user", code: 0, userInfo: nil))
                        } else {
                            SocialApp._getFBUserWithCompletionHandler(completionHandler)
                        }
                    } else {
                        completionHandler(nil, error)
                    }
                })
            }
        }
    }
    
    private class func _getFBUserWithCompletionHandler(_ completionHandler: @escaping FBLoginResponse) {
        FBSDKGraphRequest(graphPath: "/me", parameters: parameteres).start { (connection, user, error) in
            completionHandler(user as? [String: Any], error)
        }
    }
    
   public class func profilePictures(_ albumId: String, _ completionHandler: @escaping FBLoginResponse) {
        FBSDKGraphRequest(graphPath: "/\(albumId)/photos", parameters: parameteres, httpMethod: "GET").start { (connection, user, error) in
            completionHandler(user as? [String: Any], error)
        }
    }
    public class func checkFBSession(_ completionHandler: @escaping FBLoginResponse) {
        if (FBSDKAccessToken.current() != nil) {
            SocialApp._getFBUserWithCompletionHandler(completionHandler)
        }
        else {
            completionHandler(nil, NSError(domain: KFacebookSessionExpired, code: 0, userInfo: nil))
        }
    }

    class func facebookLogout() {
        let fbSDKLoginManager = FBSDKLoginManager()
        fbSDKLoginManager.logOut()
    }
}

