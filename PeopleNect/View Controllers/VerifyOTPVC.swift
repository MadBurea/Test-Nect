//
//  VerifyOTPVC.swift
//  PeopleNect
//
//  Created by InexTure on 15/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader

class VerifyOTPVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtVerifyOTP: JVFloatLabeledTextField!
    @IBOutlet var lblOTPValidation: UILabel!
    var alertMessage = AlertMessageVC()
    var global = WebServicesClass()
    var OTP = String()
    var email = String()
    var userId = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblOTPValidation.text = ""
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func clickBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickVerifyOTP(_ sender: AnyObject) {
        
        txtVerifyOTP.resignFirstResponder()
        
        var isApiCall = Bool()
        
        isApiCall = true
        
        
        if (txtVerifyOTP.text?.isBlank)!
        {
            lblOTPValidation.text = strOTPEmpty
            isApiCall = false
        }
        else
        {
            lblOTPValidation.text = ""
        }
        
        
        if isApiCall == true
        {
            
            if OTP == txtVerifyOTP.text {
                
                let JobResetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
                
                JobResetPasswordVC.email = email
                JobResetPasswordVC.userId = userId
                
                navigationController?.pushViewController(JobResetPasswordVC, animated: true)
            }
            else
            {
            self.view.makeToast("Incorrect OTP", duration: 3.0, position: .bottom)
            }
          }
        
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
        
        
        if textField == txtVerifyOTP
        {
            lblOTPValidation.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
        }

        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtVerifyOTP
        {
            if (txtVerifyOTP.text?.isBlank)!
            {
                lblOTPValidation.text = strOTPEmpty
            }
            else
            {
                lblOTPValidation.text = ""
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtVerifyOTP == textField
        {
            txtVerifyOTP.resignFirstResponder()
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
