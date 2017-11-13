//
//  InAppPurchaseVC.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 09/08/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit
import StoreKit
import SwiftLoader

class InAppPurchaseCell: UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    func initWithData(obj: SKProduct){
        
        self.lblTitle?.text = obj.localizedTitle
        print(obj.price)
        self.lblPrice.text = String(describing: obj.price)
    }
    
}



class InAppPurchaseVC: BRD_BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayTableView = [String]()
    var arrayServiceSidePlans = [ServerPlans]()
    
    /* Variables */
    let MONTH_SUBSCRIPTION = "com.BarbrDo.30"
    let YEARLY_SUBSCRIPTION = "com.BarbrDo.365"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()

    var selectedPlan : String? = nil
    
    var index: Int? = nil
    var nonConsumablePurchaseMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseMade")
    var coins = UserDefaults.standard.integer(forKey: "coins")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Bundle.main.loadNibNamed(String(describing: BRD_NavBarWithoutProfilePicture.self), owner: self, options: nil)![0] as? BRD_NavBarWithoutProfilePicture
        header?.frame = CGRect(x:0, y:0, width:view.frame.width, height:75)
        header?.btnBack.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(header!)
        
        SwiftLoader.show(KLoading, animated: true)
       
        fetchProductsForBarbrDO()
        
        _fetchAvailableProducts()
    }
    
    
    
    func fetchProductsForBarbrDO(){
        
        let headers = BRDSingleton.sharedInstane.getLatitudeLongitude()
        if headers == nil{return}
        
        SwiftLoader.show(KLoading, animated: true)
        let urlString = KBaseURLString + KSubscriptionPlans
        
        BRDAPI.getSubscriptionPlans("GET", inputParameters: nil, header: headers!, urlString: urlString) { (response, plans, status, error) in
            print(response ?? "No Response")
            //SwiftLoader.hide()
            
            if plans != nil{
                if (plans?.count)! > 0{
                    self.arrayServiceSidePlans = plans!
                }
            }
        }
    }
    
    @objc private func backButtonAction(){
        
        self.dismiss(animated: true) { 
            
        }
//        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//        appDelegate.logout()
       // self.navigationController?.popViewController(animated: true)
        
    }
    
    func getSelectedPlanByUser(planID: String){
        
        for obj in self.arrayServiceSidePlans{
            if obj.apple_id == planID{
                self.selectedPlan = obj._id
                return
            }
        }
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension InAppPurchaseVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    fileprivate func _fetchAvailableProducts() {
        
        SwiftLoader.show(KLoading, animated: true)
        let productIdentifiers = NSSet(objects: MONTH_SUBSCRIPTION,YEARLY_SUBSCRIPTION)
        self.productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        self.productsRequest.delegate = self
        self.productsRequest.start()
    }
    
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        print(response)
        if (response.products.count > 0) {
            self.iapProducts = response.products.reversed()
            self.tableView.reloadData()
            
//            for product in self.iapProducts {
//                let subscription = Subscription()
//                let months = product.localizedTitle.components(separatedBy: " ")
//                if months.count > 1 {
//                    subscription?.duration = months[0]
//                    subscription?.month = months[1]
//                    subscription?.price = String(format: "%.2f",(Float(product.price.floatValue) / Float(months[0])!))
//                }
//                subscription?.currenySymbol = product.priceLocale.currencySymbol ?? "$"
//                subscription?.identifier = product.productIdentifier
//                self.subscriptions.append(subscription!)
//            }
//            DispatchQueue.main.async {
//                self.continueButton.isEnabled = true
//                self.collectionView.reloadData()
//            }
            
            SwiftLoader.hide()
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
    }
    
    // MARK: - RESTORE IAP PRODUCTS
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        UIAlertController.show(self, KAlertTitle, "Hello")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    fileprivate func _purchaseMyProduct(_ product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            if let payment = SKPayment(product: product) as? SKPayment {
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
                
                SwiftLoader.hide()
            }
            self.productID = product.productIdentifier
        } else {
            UIAlertController.show(self, KAlertTitle, "In-app purchase is disable")
        }
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ : SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                   // self._updatePackageAPI()
                    // error: Array
                    // Payment Siccessful
                    var arr = [Any]()
                    arr.append(trans)
                    paymentDoneSuccessfully(array: arr)
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                default:
                    break
                    
                }
            }
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.iapProducts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//            
//            if !(cell != nil) {
//                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
//            }
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "InAppPurchaseCell", for: indexPath) as? InAppPurchaseCell
        
            cell?.initWithData(obj: self.iapProducts[indexPath.row])
            return cell!
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SwiftLoader.show("Please wait", animated: true)
        index = indexPath.row
       _purchaseMyProduct(self.iapProducts[indexPath.row])
        
        
        print(self.iapProducts[indexPath.row].localizedDescription)
        self.getSelectedPlanByUser(planID: self.iapProducts[indexPath.row].productIdentifier)
    }
    
    
    func paymentDoneSuccessfully(array: [Any]){
        
        
//        {
//            "plan_id": "59a42611001c511b9cac3ab1",
//            "tranaction_response": [
//            {
//            "developerPayload": "bGoa+V7g/yqDXvKRqq+JTFn4uQZbPiQJo4pf9RzJ",
//            "orderId": "GPA.1234-5678-9012-34567",
//            "packageName": "com.app.barbrdo",
//            "productId": "59a3e478dba0d40f54ccf677",
//            "purchaseState": 0,
//            "purchaseTime": "1345678900000",
//            "purchaseToken": "opaque-token-up-to-1000-characters"
//            }
//            ]
//        }
        
       // let array = [Any]()
        let inputParameters: [String: Any] =
            ["plan_id": self.selectedPlan!,
             "tranaction_response": array]
        
        let urlString = KBaseURLString + KUpdateSubscribePLan
        let header = BRDSingleton.sharedInstane.getHeaders()
        if header == nil{return}
        
        SwiftLoader.show(KLoading, animated: true)
        BRDAPI.updateSubcribePlantoTheServer("POST", inputParameter: inputParameters, header: header!, urlString: urlString, completionHandler: { (reponse, responseString, status, error) in
            
            SwiftLoader.hide()
            if status == 200{
//                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: "Payment Done Successfully", onViewController: self, returnBlock: { (clickedIN) in
//                    
//                })
                
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                
                let storyboard = UIStoryboard(name: barberStoryboard, bundle: nil)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "BarberDashboardVC") as! BarberDashboardVC
                let navCon = UINavigationController(rootViewController: rootViewController)
                appDelegate.window?.rootViewController = navCon
            }else{
                _ = BRDAlertManager.showOKAlert(withTitle: KApplicationTitle, withMessage: responseString, onViewController: self, returnBlock: { (clickedIN) in
                    
                })
                return
                
            }
        })
        
        
    }
    
}
