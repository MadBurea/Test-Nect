//
//  JobResetPasswordVC.swift
//  PeopleNect
//
//  Created by Apple on 11/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader

class JobResetPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var imgSendOTP: UIImageView!
    @IBOutlet var txtEmail: JVFloatLabeledTextField!
    @IBOutlet var btnSendOTP: UIButton!
    @IBOutlet var lblEmailValidation: UILabel!
    
    @IBOutlet var lblEnterEmailToReceive: UILabel!
    
    

    
    var global = WebServicesClass()
    
    var alertMessage = AlertMessageVC()

    //MARK: - View life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmailValidation.text = ""
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        lblEmailValidation.text = ""

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UIView Actoins -

    @IBAction func clickSendOTP(_ sender: Any){
    
    txtEmail.resignFirstResponder()
    
    var isApiCall = Bool()
    
    isApiCall = true
    
    
    if (txtEmail.text?.isBlank)!
    {
    lblEmailValidation.text = strEmailEmpty
    isApiCall = false
    }
    
    else if !(txtEmail.text?.isEmail)!
    {
    lblEmailValidation.text = strEmailInvalid
    isApiCall = false
    
    }
    else
    {
    lblEmailValidation.text = ""
    }
    
    if isApiCall == true
    {
        self.forgotPasswordApi()
     }
    
    }
    
    
    @IBAction func clickBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

    
    // MARK: - TextField Delegate Method
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Backspace Validation
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            //print("Backspace was pressed")
            return true
        }
        
        if textField == txtEmail {
            
            lblEmailValidation.text = ""
            if (validateEmail(candidate: txtEmail.text!))
            {
                return true
            }
            
        }
        
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtEmail
        {
            if (txtEmail.text?.isBlank)!
            {
                lblEmailValidation.text = strEmailEmpty
            }
                
            else if !(txtEmail.text?.isEmail)!
            {
                lblEmailValidation.text = strEmailInvalid
                
            }
            else
            {
                lblEmailValidation.text = ""
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtEmail == textField
        {
            txtEmail.resignFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: - Class Method

    //  TextField Email Validation Method
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }

    
    
    
    // MARK: - Api Call
    
    func forgotPasswordApi()
    {
        /*
         "email": "dharmesh@gmail.com",
         "language": "2",
         "methodName": "forgotPassword"
          */
        
        SwiftLoader.show(animated: true)
        
            let param =  [WebServicesClass.METHOD_NAME: "forgotPassword",
                          "language":"2",
                          "email":"\(txtEmail.text!)"] as [String : Any]
        
         global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            print(param)
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
                
                
                self.alertMessage.strMessage = "Dang! something went wrong. Try again!"
                
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                
                self.present(self.alertMessage, animated: false, completion: nil)
                
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print(dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                if status == 1
                {
                    self.view.makeToast("\(String(describing: Response.object(forKey: "message")!))", duration: 3.0, position: .bottom)
                    
                    if dictResponse.object(forKey: "OTP") != nil
                    {
                        let OTP = dictResponse.object(forKey: "OTP") as! NSNumber
                        
                        let userId = dictResponse.object(forKey: "userId") as! String
                        
                        print("OTP is",OTP)
                        
                        
                        let VerifyOTPVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
                        
                        VerifyOTPVC.OTP = OTP.stringValue
                        VerifyOTPVC.email = self.txtEmail.text!
                        VerifyOTPVC.userId = userId
                        
                        self.navigationController?.pushViewController(VerifyOTPVC, animated: true)
                    }
   
                }
                else
                {
                    self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
                    
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
        }
        
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
