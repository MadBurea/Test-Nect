
//
//  EmpSignUpVC.swift
//  PeopleNect
//
//  Created by Apple on 08/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader
import Toast_Swift

class EmpSignUpVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var lblPasswordValidation: UILabel!
    @IBOutlet var lblMobileValidation: UILabel!
    @IBOutlet var lblCountryCodeValidation: UILabel!
    @IBOutlet var lblEmailValidation: UILabel!
    @IBOutlet var lblSurnameValidation: UILabel!
    @IBOutlet var lblNameValidation: UILabel!
    
    @IBOutlet var txtSurname: JVFloatLabeledTextField!
    @IBOutlet var txtName: JVFloatLabeledTextField!
    @IBOutlet var txtPassword: JVFloatLabeledTextField!
    @IBOutlet var txtMobile: JVFloatLabeledTextField!
    @IBOutlet var txtCountryCode: JVFloatLabeledTextField!
    @IBOutlet var txtEmail: JVFloatLabeledTextField!
 
    var alertMessage = AlertMessageVC()

    var global = WebServicesClass()

    @IBOutlet var btnRegister: UIButton!
    
    var termsOfUse = TermsUseVC()

    
    //MARK: - View life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // set up view
        self.setupView()
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        termsOfUse = self.storyboard?.instantiateViewController(withIdentifier: "TermsUseVC") as! TermsUseVC
        
     //   txtName.becomeFirstResponder()
       
    }
   
    override func viewDidAppear(_ animated: Bool) {
           self.textFieldSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIView Actoins -
    @IBAction func clickTermsofUse(_ sender: AnyObject) {
        
//        let termsuse = self.storyboard?.instantiateViewController(withIdentifier: "TermsUseVC") as! TermsUseVC
//        self.present(termsuse, animated: false, completion: nil)
        
        self.termsOfUse.modalPresentationStyle = .overCurrentContext
        self.present(self.termsOfUse, animated: false, completion: nil)
    }
    
    
    @IBAction func clickBack(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func clickOnRegister(_ sender: AnyObject) {
        
        txtName.resignFirstResponder()
        txtSurname.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtCountryCode.resignFirstResponder()
        txtMobile.resignFirstResponder()
        
     var isApiCall = Bool()
        
        isApiCall = true
  
    
        if (txtName.text?.isBlank)!
        {
            lblNameValidation.text = Localization(string: "Enter name")

            isApiCall = false
        }
        else
        {
            lblNameValidation.text = ""
        }
        
        if (txtSurname.text?.isBlank)!
        {
            lblSurnameValidation.text = Localization(string: "Enter surname")

            isApiCall = false
        }
        else
        {
            lblSurnameValidation.text = ""
        }
        
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
        
        if(txtCountryCode.text?.isBlank)!
        {
            lblCountryCodeValidation.text = Localization(string: "Enter country code")

            isApiCall = false
        }
        else
        {
            lblCountryCodeValidation.text = ""
        }
        
        
        if(txtMobile.text?.isBlank)!
        {
            lblMobileValidation.text = Localization(string: "Enter mobile")

            isApiCall = false
        }
        else if((txtMobile.text?.characters.count)! < 10)
        {
            lblMobileValidation.text = strMobileInvalid
            isApiCall = false
        }
        else
        {
            lblMobileValidation.text = ""
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

            self.registerApi()
            
            /*let empsignupVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpAddCompanyDetailsVC") as! EmpAddCompanyDetailsVC
            navigationController?.pushViewController(empsignupVC, animated: true)*/
        }

    }
    
    // MARK: - TextField Delegate Method
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func containsOnlyLetters(input: String) -> Bool {
        for chr in input.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Backspace Validation
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        if (isBackSpace == -92) {
            //print("Backspace was pressed")
            return true
        }
        
        if textField == txtSurname
        {
            lblSurnameValidation.text = ""
            
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                return false
            }
            
        }
        
        if textField == txtName
        {
            lblNameValidation.text = ""
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                return false
            }
            
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
            
        else if textField == txtCountryCode
        {
            lblCountryCodeValidation.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                return false
            }
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
            
        else if textField == txtMobile{
            
            lblMobileValidation.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
            if (txtMobile.text?.characters.count)! > 14
            {
                return false
            }
            
        }
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtName
        {
            if (txtName.text?.isBlank)!
            {
                lblNameValidation.text = Localization(string: "Enter name")

            }
            else
            {
                lblNameValidation.text = ""
            }
        }
        
        if textField == txtSurname
        {
            if (txtSurname.text?.isBlank)!
            {
                lblSurnameValidation.text = Localization(string: "Enter surname")

            }
            else
            {
                lblSurnameValidation.text = ""
            }
        }
        
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
        
        if textField == txtCountryCode
        {
            if(txtCountryCode.text?.isBlank)!
            {
                lblCountryCodeValidation.text = Localization(string: "Enter country code")

            }
            else
            {
                lblCountryCodeValidation.text = ""
            }
            
        }
        
        
        if textField == txtMobile
        {
            if(txtMobile.text?.isBlank)!
            {
                lblMobileValidation.text = Localization(string: "Enter mobile")

            }
            else if((txtMobile.text?.characters.count)! < 14)
            {
                if((txtMobile.text?.characters.count)! < 10)
                {
                    lblMobileValidation.text = strMobileInvalid
                    
                }
                else
                {
                    
                }
                //lblValidatePhoneNo.text = strMobileInvalid
            }
                
            else if((txtMobile.text?.characters.count)! < 10)
            {
                lblMobileValidation.text = strMobileInvalid
            }
            else
            {
                lblMobileValidation.text = ""
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
        
        if txtName == textField
        {
            txtName.resignFirstResponder()
            txtSurname.becomeFirstResponder()
        }
        else if txtSurname == textField
        {
            txtSurname.resignFirstResponder()
            txtEmail.becomeFirstResponder()
        }
        else if txtEmail == textField
        {
            txtEmail.resignFirstResponder()
            txtCountryCode.becomeFirstResponder()
            
        }
        else if txtPassword == textField
        {
            txtPassword.resignFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        
        
        
        return true
    }

    
    // MARK: - API Call
    
    func registerApi()
    {
        SwiftLoader.show(animated: true)
        
        /*
         "countryId": "",
         "deviceId": "",
         "password": "123456",
         "country_code": "+99",
         "address2": "",
         "stateId": "",
         "email": "jhonsmithemp@gmail.com",
         "phone": "12 3456-7890",
         "address1": "",
         "companyName": "",
         "name": "John",
         "surname": "Smith",
         "methodName": "registerEmployer",
         "zip": "",
         "cityId": ""

*/
        
        let param =  [WebServicesClass.METHOD_NAME: "registerEmployer",
                      "country_code":"+\(txtCountryCode.text!)",
            "deviceId":UIDevice.current.identifierForVendor!.uuidString,
            "password":"\(txtPassword.text!)",
            "countryId":"",
            "address2":"",
            "stateId":"",
            "email":"\(txtEmail.text!)",
            "phone":"\(txtMobile.text!)",
            "address1":"",
            "companyName":"",
            "name":"\(txtName.text!)",
            "surname":"\(txtSurname.text!)",
            "zip":"",
            "cityId":""] as [String : Any]
        
        print(param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
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
                                            
                        if (loginDict.object(forKey: "lat")) is NSNull
                        {
                            
                            loginDict.setValue("", forKey: "lat")
                            loginDict.setValue("", forKey: "lng")
                        }
                        
                        if loginDict.object(forKey: "companyName") is NSNull
                        {
                            loginDict.setValue("", forKey: "companyName")
                        }
                        
                        
                        let empsignupVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpAddCompanyDetailsVC") as! EmpAddCompanyDetailsVC
                        empsignupVC.loginDict = loginDict
                         self.navigationController?.pushViewController(empsignupVC, animated: true)

                    }
                    
                }
                else
                {
                    self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    
                    if Response.object(forKey:"pt_message") != nil {
                        if appdel.deviceLanguage == "pt-BR"
                        {
                            self.alertMessage.strMessage = "\(Response.object(forKey: "pt_message") as! String)"
                        }
                        else
                        {
                            self.alertMessage.strMessage = "\(Response.object(forKey: "message") as! String)"
                        }
                    }
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
                
                
            }
        }

    }

    
    
    
    // MARK: - Class Method
    func setupView()
    {
        
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        lblPasswordValidation.text = ""
        lblMobileValidation.text = ""
        lblCountryCodeValidation.text = ""
        lblEmailValidation.text = ""
        lblSurnameValidation.text = ""
        lblNameValidation.text = ""

        

    }
    
    func textFieldSetUp()
    {
        txtName.underlined()
        txtSurname.underlined()
        //        txtCountryCode.underlined()
        //        txtPassword.underlined()
        txtMobile.underlined()
        
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






