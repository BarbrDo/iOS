
import Foundation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

let FB = Facebook()

class Facebook {
    
    func addLoginButton(view : UIView) -> UIButton
    {
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        return loginButton
    }
    
    func doFBLogin(completionHandler:@escaping (_ success:Bool,_ fbUserObject:AnyObject?)-> Void) {
        
        let permissions: [AnyObject] = ["public_profile" as AnyObject, "email" as AnyObject]
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        //fbLoginManager.loginBehavior = .SystemAccount
        fbLoginManager.logIn(withReadPermissions: permissions, from: nil, handler: { (result, error) -> Void in
            
            if (error == nil){
                
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if fbloginresult.isCancelled == false
                {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        FB.getUserInfo(completionHandler: { (success, fbUserObject) -> Void in
                            print(fbUserObject)
                            if(success) {
                                
                                completionHandler(true, fbUserObject)
                                
                            }
                            else {
                                completionHandler(false, nil)
                            }
                        })
                        
                    }
                    else
                    {
                        completionHandler(false, nil)

                    }
                }
                else {
                       completionHandler(false, nil)
                }
            }
        })

    }
    
    func initFB(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func getUserInfo(completionHandler:@escaping (_ success:Bool,_ fbUserObject:AnyObject?)-> Void)
    {
       
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name,first_name,last_name,email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
               // Helper.FGSLog("Error: \(error)")
                completionHandler(false, error as AnyObject?)
            }
            else
            {
                //Helper.FGSLog("fetched user: \(result)")
                completionHandler(true, result as AnyObject?)
            }
        })
        //completion block ends for getting user details from FB
    }
    
    func handleDidBecomeActive(){
         FBSDKAppEvents.activateApp()
    }
    
    
//    func parseUserData(data: [String: AnyObject]) -> User
//    {
//       let tempUser : User = User()
//        tempUser.socialmedia_id = data["id"] as! String? ?? ""
//        tempUser.socialmedia_name = data["name"] as! String? ?? ""
////        tempUser.username = data[SOCIALMEDIAPARAM.FB.username.rawValue] as! String? ?? ""
//        tempUser.first_name = data["first_name"] as! String? ?? ""
//        tempUser.last_name = data["last_name"] as! String? ?? ""
//        tempUser.email = data["email"] as! String? ?? ""
//        tempUser.date_of_birth = ""
//        tempUser.phone_no = ""
//       // tempUser.socialmedia_type = SocialMediaType.facebook
//        
//        return tempUser
//    }

    func signOut()
    {
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        
//        FBSession.activeSession.closeAndClearTokenInformation()
//        
//        // Clear the cookies.
//        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
//        {
//            [storage deleteCookie:cookie];
//        }
    }
}
