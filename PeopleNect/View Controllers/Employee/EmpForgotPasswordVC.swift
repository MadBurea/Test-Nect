//
//  EmpForgotPasswordVC.swift
//  PeopleNect
//
//  Created by Apple on 11/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader

class EmpForgotPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtEmail: JVFloatLabeledTextField!
    @IBOutlet var lblEmailValidation: UILabel!
    var alertMessage = AlertMessageVC()
    var global = WebServicesClass()

    override func viewDidLoad() {
        super.viewDidLoad()

        lblEmailValidation.text = ""
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func clickBack(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)

        
    }
    
    @IBAction func clickSendOTP(_ sender: AnyObject) {
        
        txtEmail.resignFirstResponder()
        
        var isApiCall = Bool()
        
        isApiCall = true
        
        
        if (txtEmail.text?.isBlank)!
        {
            lblEmailValidation.text = Localization(string: "Enter email")

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
    
    
    
    
    func forgotPasswordApi()
    {
        SwiftLoader.show(animated: true)
        
        /*
         forgotEmployer	"{
         ""email"": ""johnsmithemp@gmail.com"",
         ""language"": ""2"",
         ""methodName"": ""forgotEmployer""
         }"
         
         
         */
        let param =  [WebServicesClass.METHOD_NAME: "forgotEmployer","email":"\(txtEmail.text!)","language":appdel.userLanguageForPassword] as [String : Any]
        
        
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
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                print(dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                    self.view.makeToast(Localization(string:"Invitation accepted!"), duration: 3.0, position: .bottom)

                    let VerifyOTPVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
                    self.navigationController?.pushViewController(VerifyOTPVC, animated: true)
                    
                }
                else
                {
                    self.alertMessage.strMessage = Localization(string:  "No user with this credential")
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                    
                }
                
                
            }
        }
        
    }
    

    // MARK: - TextField Email Validation Method
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
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
                lblEmailValidation.text = Localization(string: "Enter email")

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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
