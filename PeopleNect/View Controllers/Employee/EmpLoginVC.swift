//
//  EmpLoginVC.swift
//  PeopleNect
//
//  Created by Apple on 11/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader
import Toast_Swift



class EmpLoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var lblPasswordValidation: UILabel!
    @IBOutlet var lblEmailValidation: UILabel!
    @IBOutlet var txtPassword: JVFloatLabeledTextField!
    @IBOutlet var txtEmail: JVFloatLabeledTextField!
    
    var alertMessage = AlertMessageVC()
    var global = WebServicesClass()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        
        if TARGET_IPHONE_SIMULATOR == 1 {
            //simulator
            txtEmail.text = "dharmeshd.inexture@gmail.com"
            txtPassword.text = "123456"
        } else {
            //device
            
        }
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        self.labelBlankSetup()
        // Do any additional setup after loading the view.
        
        
       
           
        }
  
    
    @IBAction func clickBack(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickForgorPassword(_ sender: AnyObject) {
        
        let JobResetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "JobResetPasswordVC") as! JobResetPasswordVC
        
        navigationController?.pushViewController(JobResetPasswordVC, animated: true)
    }
    
    @IBAction func clickLogin(_ sender: AnyObject) {
        
        txtPassword.resignFirstResponder()
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
        
        if(txtPassword.text?.isBlank)!
        {
            lblPasswordValidation.text = Localization(string: "Enter password")

            isApiCall = false
        }
        else if(txtPassword.text?.characters.count)! < 6
        {
            lblPasswordValidation.text = strPasswordInvaild
            isApiCall = false
        }
        else
        {
            lblPasswordValidation.text = ""
        }
        
        
        if isApiCall == true
        {
            self.loginApi()
           /* let empsignupVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpAddCompanyDetailsVC") as! EmpAddCompanyDetailsVC
            navigationController?.pushViewController(empsignupVC, animated: true)*/
        }

        
    }
    
    
    // MARK: - Api Call
    
    func loginApi()
    {
        /*
         employerLogin	"{
         ""deviceId"": ""device id"",
         ""email"": ""johnsmithemp@gmail.com"",
         ""password"": ""123456"",
         ""methodName"": ""employerLogin""
         }"
         */
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "employerLogin","deviceId":UIDevice.current.identifierForVendor!.uuidString,"password":"\(txtPassword.text!)","email":"\(txtEmail.text!)"] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            if error != nil
            {
                print("Login Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print(dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                    if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary
                    {
                        //  if (agentsDict.object(forKey: "lat")) is NSNull
                        
                        let loginDict =  NSMutableDictionary(dictionary: dataDict)
                        
                        
                        let keys = loginDict.allKeys.filter({loginDict[$0] is NSNull})
                        
                        print(keys)
                        
                        for key in keys {
                           // loginDict.setValue("", forKey: key as! String)
                            loginDict.removeObject(forKey:key)
                        }
                       
                        if (loginDict.object(forKey: "companyName")) == nil
                        {
                            let empsignupVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpAddCompanyDetailsVC") as! EmpAddCompanyDetailsVC
                            empsignupVC.loginDict = loginDict
                                self.navigationController?.pushViewController(empsignupVC, animated: true)

                        }
                        else
                        {
                            
                            // Set User Default
                            UserDefaults.standard.removeObject(forKey: kEmpLoginDict)
                            UserDefaults.standard.set(loginDict, forKey: kEmpLoginDict)
                            
                            appdel.loginUserDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
                            
                            if appdel.deviceLanguage == "pt-BR"
                            {
                                self.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "employerId")!)", userType: "1",message:"Bem vindo!")
                            }
                            else
                            {
                                self.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "employerId")!)", userType: "1",message:"\(Response.object(forKey: "message") as! String)")
                            }
                            
                        }
                        
                    }
                    
                }
                else
                {
                    self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                    
                    //print(Response.object(forKey: "message"))
                }
                
                
            }
        }
        
    }
    
    func UpdateDeviceToken(userId:String,userType:String,message:String)  {
        let parameters =
            [
                WebServicesClass.METHOD_NAME: "updateDeviceToken",
                "userId":userId,"userType":userType,"deviceToken":appdel.deviceToken,"deviceId":UIDevice.current.identifierForVendor!.uuidString,"deviceType":"2","fcmToken":appdel.fcmToken
        ]
        
        print("parameters of update Device token is",parameters)
        SwiftLoader.show(animated: true)
        global.callWebService(parameter: parameters as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                print("dictResponse is",dictResponse)
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1
                {

                    let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                    let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
                   
                    let navigationController = SlideNavigationController(rootViewController: empdashboardVC)
                let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuViewController") as! LeftMenuViewController
                    SlideNavigationController.sharedInstance().leftMenu = leftview
                    SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
                    navigationController.navigationBar.isHidden = true
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }
    


    // MARK: - Label setup
    
    func labelBlankSetup()
    {
        lblPasswordValidation.text = ""
        lblEmailValidation.text = ""
        
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
        
       
        if textField == txtPassword
        {
            lblPasswordValidation.text = ""
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
        
        
        if textField == txtPassword
        {
            if(txtPassword.text?.isBlank)!
            {
                lblPasswordValidation.text = Localization(string: "Enter password")

            }
            else if(txtPassword.text?.characters.count)! < 6
            {
                lblPasswordValidation.text = strPasswordInvaild
            }
            else
            {
                lblPasswordValidation.text = ""
            }
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtEmail == textField
        {
            txtEmail.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        }
        else if txtPassword == textField
        {
            txtPassword.resignFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
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
