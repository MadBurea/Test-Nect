//
//  NewPasswordVC.swift
//  PeopleNect
//
//  Created by InexTure on 18/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader
class NewPasswordVC: UIViewController {

    @IBOutlet weak var validationLbl: UILabel!
    @IBOutlet weak var tfpassword: JVFloatLabeledTextField!
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    var email = String()
    var userId = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        validationLbl.text = ""

        print("email is",email)
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickonNewPassword(_ sender: Any) {
        
        tfpassword.resignFirstResponder()
        
        var isApiCall = Bool()
        
        isApiCall = true
        
        if(tfpassword.text?.isBlank)!
        {
            validationLbl.text = Localization(string: "Enter password")

            isApiCall = false
        }
        else if(tfpassword.text?.characters.count)! < 6
        {
            validationLbl.text = strPasswordInvaild
            isApiCall = false
        }
        else
        {
            validationLbl.text = ""
        }
        
        if isApiCall == true
        {
            self.forgotPasswordApi()
        }

    }
    
    @IBAction func clickBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    
    // MARK:- API call
    
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
        let param =  [WebServicesClass.METHOD_NAME: "resetPassword","userId":userId,"newPassword":tfpassword.text!] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {                SwiftLoader.hide()

                print("Error",error?.description as String!)
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
                        var array = self.navigationController?.viewControllers
                    self.navigationController?.popToViewController((array?[2])!, animated: true)
                    self.view.makeToast(Localization(string: "Your Password has been changed."), duration: 3.0, position: .bottom)
                }
                else
                {
                    
                    self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
                
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
        
        
        if textField == tfpassword
        {
            if(tfpassword.text?.isBlank)!
            {
                validationLbl.text = Localization(string: "Enter password")

            }
            else if(tfpassword.text?.characters.count)! < 6
            {
                validationLbl.text = strPasswordInvaild
            }
            else
            {
                validationLbl.text = ""
            }
        }
        
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == tfpassword
        {
            if (tfpassword.text?.isBlank)!
            {
                validationLbl.text = Localization(string: "Enter password")

            }
            else
            {
                validationLbl.text = ""
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if tfpassword == textField
        {
            tfpassword.resignFirstResponder()
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
