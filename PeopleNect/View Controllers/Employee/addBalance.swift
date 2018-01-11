//
//  addBalance.swift
//  PeopleNect
//
//  Created by BAPS on 10/14/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class addBalance: UIViewController ,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,PayPalPaymentDelegate{

    @IBOutlet weak var tfBalance: UITextField!
    var global = WebServicesClass()
    let pickerView = UIPickerView()
    var packageListingArray = NSArray()
    let tapGesture = UITapGestureRecognizer()
    var payPalConfig = PayPalConfiguration()
    var alertMessage = AlertMessageVC()

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfBalance.isHidden = true

        packageListing()

         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        tapGesture.addTarget(self, action: #selector(self.dismissView))
        self.view.addGestureRecognizer(tapGesture)
        
        payPalConfig = PayPalConfiguration()
        payPalConfig.acceptCreditCards = true

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        pickerView.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 253)
       pickerView.delegate = self
        pickerView.dataSource = self

    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Click Action

    func dismissView()
    {
      tfBalance.resignFirstResponder()
    }
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func adBalanceClicked(_ sender: Any) {
        
        if (tfBalance.text?.isBlank)!{
            
        }else{
            let payment = PayPalPayment()
            var balance = "\(tfBalance.text!)" as NSString
            balance = balance.replacingOccurrences(of: "$", with: "") as NSString
            print("balance is",balance)
            payment.amount = NSDecimalNumber(string: balance as String)
            
            payment.currencyCode = "USD"
            payment.shortDescription = "PeopleNect"
            payment.items = nil
            payment.paymentDetails = nil
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController as? UIViewController ?? UIViewController(), animated: true) { _ in }
        }
    }
    
    //MARK: - Textfield  Delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == tfBalance{
            self.rightArrow(edit: false)
           tfBalance.inputView = self.pickerView
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.rightArrow(edit: true)
    }
    //MARK: - General methods

    func rightArrow(edit:Bool) {
        
        let paddingRight = UIView()
        paddingRight.frame = CGRect(x: 0, y: 0, width:tfBalance.layer.frame.size.height , height: tfBalance.layer.frame.size.height)
        let btn = UIButton()
        btn.frame = paddingRight.frame
        if edit {
            btn.setImage(UIImage.init(named: "Rarrow"), for:.normal)
        }else{
            btn.setImage(UIImage.init(named: "down_arrow_"), for:.normal)
        }
        paddingRight.addSubview(btn)
        tfBalance.rightViewMode = .always
        tfBalance.rightView = paddingRight
    }
    func next()  {
        tfBalance.resignFirstResponder()
    }
    
    //MARK: - PickerView  Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return packageListingArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "$" + "\(((self.packageListingArray.object(at: row)) as! NSDictionary).value(forKey: "amount")!)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tfBalance.text = "$" + "\(((self.packageListingArray.object(at: row)) as! NSDictionary).value(forKey: "amount")!)"
    }
    
    //MARK: - PickerView  Delegate
    
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
                let dictResponse = Response as! NSDictionary
                
                self.packageListingArray  = (dictResponse.object(forKey: "data") as! NSArray)
                
                if self.packageListingArray.count > 0{
                    self.tfBalance.isHidden = false
                     self.tfBalance.text = "$" + "\(((self.packageListingArray.object(at: 0)) as! NSDictionary).value(forKey: "amount")!)"
                }
                
                if self.packageListingArray.count == 0{
                    self.tfBalance.isHidden = true
                }
                
                
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

        
        // id = "PAY-22488313YY568532NLHRAE2Y";
//        NSDictionary *confirmation = completedPayment.confirmation;
//        [self addbalance:[[confirmation valueForKey:@"response"]valueForKey:@"id"]];
//        [self dismissViewControllerAnimated:YES completion:nil];

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

            print("response is",Response)
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                print("dictResponse",dictResponse)
                if appdel.deviceLanguage == "pt-BR"
                {
                    self.alertMessage.strMessage = "\(dictResponse.value(forKey: "pt_message")!)"
                }
                else
                {
                    self.alertMessage.strMessage = "\(dictResponse.value(forKey: "message")!)"
                }
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                self.present(self.alertMessage, animated: false, completion: nil)
            }
        }
    }
   
}
