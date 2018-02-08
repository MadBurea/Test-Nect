//
//  EmpNoBalance.swift
//  PeopleNect
//
//  Created by BAPS on 10/27/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class noBalanceCell: UICollectionViewCell {
    
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var balanceView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        balanceView.layer.borderColor = UIColor.white.cgColor
        balanceView.layer.borderWidth = 1.0
    }
    
}

class EmpNoBalance: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,PayPalPaymentDelegate{

    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var balanceCollView: UICollectionView!
    var global = WebServicesClass()
    var payPalConfig = PayPalConfiguration()
    var alertMessage = AlertMessageVC()
    var packageListingArray = NSArray()
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

       self.packageListing()

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        payPalConfig = PayPalConfiguration()
        payPalConfig.acceptCreditCards = true
        
        
        // tap gesture for Collection Scrolling
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.leftScroll))
        self.leftView.addGestureRecognizer(tapGesture)
        
        let tapRightGesture = UITapGestureRecognizer()
        tapRightGesture.addTarget(self, action: #selector(self.rightScroll))
        self.rightView.addGestureRecognizer(tapRightGesture)
        
        self.leftBtn.addTarget(self, action: #selector(self.leftScroll), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(self.rightScroll), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: -Collection Scroll method
    
    func leftScroll()  {
        
        let collectionBounds = self.balanceCollView.bounds
        let contentOffset = CGFloat(floor(self.balanceCollView.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    func rightScroll()  {
        
        let collectionBounds = self.balanceCollView.bounds
        let contentOffset = CGFloat(floor(self.balanceCollView.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        
    }
    func moveCollectionToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : self.balanceCollView.contentOffset.y ,width : self.balanceCollView.frame.width,height : self.balanceCollView.frame.height)
        self.balanceCollView.scrollRectToVisible(frame, animated: true)
        
    }
    
    // MARK: - Click Action

    @IBAction func AddBalanceClick(_ sender: Any) {
        let payment = PayPalPayment()
        payment.amount = NSDecimalNumber(string: "\(((self.packageListingArray.object(at: selectedIndex)) as! NSDictionary).value(forKey: "amount")!)")
        payment.currencyCode = "USD"
        payment.shortDescription = "PeopleNect"
        payment.items = nil
        payment.paymentDetails = nil
        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
        present(paymentViewController as? UIViewController ?? UIViewController(), animated: true) { _ in }
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
        self.navigationController?.pushViewController(empdashboardVC, animated: true)
    }
    // MARK: - Collection Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packageListingArray.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noBalanceCell", for: indexPath) as! noBalanceCell
        Cell.lblBalance.text  = "$" + "\(((self.packageListingArray.object(at: indexPath.item)) as! NSDictionary).value(forKey: "amount")!)"
        
        if  indexPath.item == selectedIndex {
            
            Cell.balanceView.backgroundColor = UIColor.white
            Cell.lblBalance.textColor = UIColor.init(colorLiteralRed: 36.0/255.0, green: 36.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        }else{
            Cell.balanceView.backgroundColor = UIColor.clear
            Cell.lblBalance.textColor = UIColor.white
        }

        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.balanceCollView.reloadData()
    }
    
    //MARK: - packageListing
    
    func packageListing()
    {
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "packageListing",
                      "employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        /*
         let param =  [WebServicesClass.METHOD_NAME: "packageListing",
         "employerId":"1",
         "language":"en"] as [String : Any]
         
         */
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()

            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                self.balanceCollView.delegate = self
                 self.balanceCollView.dataSource = self
                 self.balanceCollView.reloadData()
                let dictResponse = Response as! NSDictionary
                self.packageListingArray  = (dictResponse.object(forKey: "data") as! NSArray)
                print("dictResponse",self.packageListingArray)
            }
        }
    }

    
    //MARK: - Payment Delegates
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
        paymentViewController.dismiss(animated: true, completion: nil)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, willComplete completedPayment: PayPalPayment, completionBlock: @escaping PayPalPaymentDelegateCompletionBlock) {
        
        print("payment  willComplete complted")
        
        let confirmation = completedPayment.confirmation as NSDictionary
        
        let id = (confirmation.value(forKey: "response")as! NSDictionary).value(forKey: "id") as! String
        print("id is ",id)
        self.addBalanceFromPayPal(paymentId: id)
        paymentViewController.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Add Payment Service
    func addBalanceFromPayPal(paymentId:String)
    {
        SwiftLoader.show(animated: true)
        
    
        let param =  [WebServicesClass.METHOD_NAME: "addBalanceFromPayPal",
                      "employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage, "paymentId":paymentId] as [String : Any]
        
        
        print("param for balance is",param)
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            if error != nil
            {
                self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                self.present(self.alertMessage, animated: false, completion: nil)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                if status == 1 {
                    
                }else if status == 2 {
                    self.alertMessage.strMessage = Localization(string:  "Balance already added.")
                }else{
                    self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                }
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                self.present(self.alertMessage, animated: false, completion: nil)
            }
        }
    }
    

}
extension EmpNoBalance: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print("Called")
        return CGSize(width:(collectionView.frame.size.width - 20)/3.0 , height: collectionView.frame.size.height)
}
}
