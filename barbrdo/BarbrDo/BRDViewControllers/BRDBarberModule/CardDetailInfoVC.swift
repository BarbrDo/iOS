
import UIKit
import SVProgressHUD
class CardDetailInfoVC: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    var dateFormate = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
@IBAction func donate(_ sender: AnyObject) {
    let reachability = Reachability()!
    
    
    if reachability.isReachable
    {
        
        
        let subscription:SubscriptionDetails=SubscriptionDetails()
        subscription.doctor_id = "8"
        subscription.cvv = cvcTextField.text
        subscription.cardnumber = cardNumberTextField.text
        subscription.creditcardtype = "Visa"
        subscription.expdate = expireDateTextField.text
        subscription.card_holder = emailTextField.text
        AppInstance.applicationInstance.subscriptionDetails = subscription
        let bizObject:BusinessLayer=BusinessLayer()
        
        bizObject.subscriptionPayPal
            {
                
                (success, errorMessage) -> Void in
                
                if(success == true)
                {
                    
                    // get access token
                    
//                    self.moveToMainView()
                    SVProgressHUD.dismiss()
                    
                    
                }
                    
                else
                {
                    
                    SVProgressHUD.dismiss()
                    
                }
                
        }
        
    }
        
    else
    {
        self.alert(message: INTERNET_ERROR, title: "")
    }

    }
    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == cardNumberTextField)
        {
        guard let text = cardNumberTextField.text
            else
        {
            return true
        }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 16 // Bool
        }
   else     if(textField == cvcTextField)
        {
            guard let text = cvcTextField.text
                else
            {
                return true
            }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 3 // Bool
        }
        else     if(textField == emailTextField)
        {
            guard let text = emailTextField.text
                else
            {
                return true
            }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 30 // Bool
        }

        else     if(textField == expireDateTextField)
        {
            if (expireDateTextField?.text?.characters.count == 2) || (expireDateTextField?.text?.characters.count == 8) {
                //Handle backspace being pressed
                if !(string == "") {
                    // append the text
                    expireDateTextField?.text = (expireDateTextField?.text)! + "/"
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.characters.count > 6  && (string.characters.count ) > range.length)
        }
                return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
