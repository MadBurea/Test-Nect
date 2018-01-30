//
//  JobSignUpSocialVC.swift
//  PeopleNect
//
//  Created by Apple on 11/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import Google
import SwiftLoader


class JobSignUpSocialVC: UIViewController, UITextFieldDelegate, UITableViewDelegate,PlaceSearchTextFieldDelegate
{
 
   
    
    @IBOutlet var txtName: JVFloatLabeledTextField!
    @IBOutlet var txtSurname: JVFloatLabeledTextField!
    @IBOutlet var txtCountryCode: JVFloatLabeledTextField!
    @IBOutlet var txtPhoneNo: JVFloatLabeledTextField!
    @IBOutlet var txtEmail: JVFloatLabeledTextField!
    @IBOutlet var txtStreetName: JVFloatLabeledTextField!
    @IBOutlet var txtNumber: JVFloatLabeledTextField!
    @IBOutlet var txtComplement: JVFloatLabeledTextField!
    @IBOutlet var txtCity: JVFloatLabeledTextField!
    @IBOutlet var txtZipCode: JVFloatLabeledTextField!
    @IBOutlet var txtState: JVFloatLabeledTextField!
    @IBOutlet var txtCountry: JVFloatLabeledTextField!
    
    
    @IBOutlet var txtAddress: MVPlaceSearchTextField!
    
    @IBOutlet weak var viewStartTypingAdd: UIView!
    @IBOutlet var lblValidateName: UILabel!
    @IBOutlet var lblValidateSurname: UILabel!
    @IBOutlet var lblValidateEmail: UILabel!
    @IBOutlet var lblValidateCountryCode: UILabel!
    @IBOutlet var lblValidatePhoneNo: UILabel!
    @IBOutlet var lblValidateStartTypingAdd: UILabel!
    @IBOutlet var lblValidateStreetName: UILabel!
    @IBOutlet var lblValidateComplement: UILabel!
    @IBOutlet var lblValidateNumber: UILabel!
    @IBOutlet var lblValidateCity: UILabel!
    @IBOutlet var lblValidateZipCode: UILabel!
    @IBOutlet var lblValidateState: UILabel!
    @IBOutlet var lblValidateCountry: UILabel!
   
    
    var imageFBPic = Data()
    
    var global = WebServicesClass()
    let apiURL = "https://maps.googleapis.com/maps/api/geocode/json"
    let apiKey = "AIzaSyAg5YUbdJukqM_BY7yu_ZN6UOf1MvLH3Zw"

    @IBOutlet var btnRegister: UIButton!
    
    var termsOfUse = TermsUseVC()
    
    var alertMessage = AlertMessageVC()
    var userDict = NSMutableDictionary()


    //MARK: - View life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        termsOfUse = self.storyboard?.instantiateViewController(withIdentifier: "TermsUseVC") as! TermsUseVC
        
     
        
        self.labelBlankSetup()
      //  txtAddress.delegate = self


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.textFieldSetUp()

        self.labelBlankSetup()

        txtAddress.autoCompleteRegularFontName =  "Montserrat-Bold"
        txtAddress.autoCompleteBoldFontName = "Montserrat-Regular"
        txtAddress.autoCompleteTableCornerRadius=0.0
        txtAddress.autoCompleteRowHeight=35
        txtAddress.autoCompleteFontSize=14
        txtAddress.autoCompleteTableBorderWidth=1.0
        txtAddress.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=true
        txtAddress.autoCompleteShouldHideOnSelection=true
        txtAddress.autoCompleteShouldHideClosingKeyboard=true
        txtAddress.autoCompleteTableFrame = CGRect(x: 16 , y: txtAddress.frame.origin.y + txtAddress.frame.size.height, width: viewStartTypingAdd.frame.size.width, height: 200)

        txtAddress.placeSearchDelegate = self
        
        setUpView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView()
    {
        
        
        txtEmail.isUserInteractionEnabled = false
        txtEmail.text = userDict.object(forKey: "email") as? String
        txtName.text = userDict.object(forKey: "first_name") as? String
        txtSurname.text = userDict.object(forKey: "last_name") as? String
        
    }
    
    // MARK: - UIView Actoins -
    
    @IBAction func clickRegister(_ sender: Any) {
        appdel.isFromRegister = true
        txtName.resignFirstResponder()
        txtSurname.resignFirstResponder()
        txtPhoneNo.resignFirstResponder()
        txtCountry.resignFirstResponder()
        txtState.resignFirstResponder()
        txtZipCode.resignFirstResponder()
        txtCity.resignFirstResponder()
        txtComplement.resignFirstResponder()
        txtNumber.resignFirstResponder()
        txtStreetName.resignFirstResponder()
        txtAddress.resignFirstResponder()
        txtCountryCode.resignFirstResponder()
        txtEmail.resignFirstResponder()
       
        
        var isApiCall = Bool()
        
        isApiCall = true
        
        
        if (txtName.text?.isBlank)!
        {
            lblValidateName.text = Localization(string: "Enter name")

            isApiCall = false
        }
        else
        {
            lblValidateName.text = ""
        }
        
        if (txtSurname.text?.isBlank)!
        {
            lblValidateSurname.text = Localization(string: "Enter surname")

            isApiCall = false
        }
        else
        {
            lblValidateSurname.text = ""
        }
        
        if (txtEmail.text?.isBlank)!
        {
            lblValidateEmail.text = Localization(string: "Enter email")

            isApiCall = false
        }
            
        else if !(txtEmail.text?.isEmail)!
        {
            lblValidateEmail.text = strEmailInvalid
            isApiCall = false
            
        }
        else
        {
            lblValidateEmail.text = ""
        }
        
        if(txtCountryCode.text?.isBlank)!
        {
            lblValidateCountryCode.text = Localization(string: "Enter country code")

            isApiCall = false
        }
        else
        {
            lblValidateCountryCode.text = ""
        }
        
        
        if(txtPhoneNo.text?.isBlank)!
        {
            lblValidatePhoneNo.text = Localization(string: "Enter mobile")

            isApiCall = false
        }
        else if((txtPhoneNo.text?.characters.count)! < 10)
        {
            lblValidatePhoneNo.text = strMobileInvalid
            isApiCall = false
        }
        else
        {
            lblValidatePhoneNo.text = ""
        }
        
        
        if (txtCountry.text?.isBlank)!
        {
            lblValidateCountry.text = Localization(string: "Enter Country")

            isApiCall = false
        }
        else
        {
            lblValidateCountry.text = ""
        }
        
        if (txtState.text?.isBlank)!
        {
            lblValidateState.text = Localization(string: "Enter State")

            isApiCall = false
        }
        else
        {
            lblValidateState.text = ""
        }
        
        if (txtZipCode.text?.isBlank)!
        {
            lblValidateZipCode.text = Localization(string: "Enter Zipcode")

            isApiCall = false
        }
        else
        {
            lblValidateZipCode.text = ""
        }
        
        if (txtCity.text?.isBlank)!
        {
            lblValidateCity.text = Localization(string: "Enter City")

            isApiCall = false
        }
        else
        {
            lblValidateCity.text = ""
        }
        
        if (txtComplement.text?.isBlank)!
        {
            lblValidateComplement.text = Localization(string: "Enter complement")

            isApiCall = false
        }
        else
        {
            lblValidateComplement.text = ""
        }
        
        if (txtNumber.text?.isBlank)!
        {
            lblValidateNumber.text = Localization(string: "Enter number")

            isApiCall = false
        }
        else
        {
            lblValidateNumber.text = ""
        }
        
        if (txtStreetName.text?.isBlank)!
        {
            lblValidateStreetName.text = Localization(string: "Enter street")

            isApiCall = false
        }
        else
        {
            lblValidateStreetName.text = ""
        }
        if (txtAddress.text?.isBlank)!
        {
            lblValidateStartTypingAdd.text = Localization(string: "Enter address")

            isApiCall = false
        }
        else
        {
            lblValidateStartTypingAdd.text = ""
        }
        
        
        if isApiCall == true
        {
            
            self.updateUserDetailApi()
            
        }
        
        
     

        
        
    }
    
    
    @IBAction func clickTermsCondition(_ sender: Any) {
        
        self.termsOfUse.modalPresentationStyle = .overCurrentContext
        
        self.present(self.termsOfUse, animated: false, completion: nil)
        
    }
    
    
    @IBAction func clickBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    
    
    // MARK: - TextField Delegate Method

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtAddress{
            
            txtAddress.autoCompleteTableView.isHidden = false
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Backspace Validation
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            //print("Backspace was pressed")
            return true
        }
        
        if textField == txtSurname
        {
            lblValidateSurname.text = ""
        }
        
        if textField == txtName
        {
            lblValidateName.text = ""
        }
        
        
        if textField == txtEmail {
            
            lblValidateEmail.text = ""
            if (validateEmail(candidate: txtEmail.text!))
            {
                return true
            }
            
        }
            
        else if textField == txtCountryCode
        {
            
            lblValidateCountryCode.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                return false
            }
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
            
        else if textField == txtPhoneNo{
            
            lblValidatePhoneNo.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
            if (txtPhoneNo.text?.characters.count)! > 14
            {
                return false
            }
            //            else if((txtPhoneNo.text?.characters.count)! < 10)
            //            {
            //                return false
            //
            //            }
        }
        else if textField == txtAddress
        {
            lblValidateStartTypingAdd.text = ""
        }
            
        else if textField == txtCity
        {
            lblValidateCity.text = ""
        }
        else if textField == txtState
        {
            lblValidateState.text = ""
        }
        else if textField == txtNumber
        {
            lblValidateNumber.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
            
        }
        else if textField == txtCountry
        {
            lblValidateCountry.text = ""
        }
        else if textField == txtZipCode
        {
            lblValidateZipCode.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
            
        }
        else if textField == txtComplement
        {
            lblValidateComplement.text = ""
        }
            
        else if textField == txtStreetName
        {
            lblValidateStreetName.text = ""
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
                lblValidateName.text = Localization(string: "Enter name")

            }
            else
            {
                lblValidateName.text = ""
            }
        }
        
        if textField == txtSurname
        {
            if (txtSurname.text?.isBlank)!
            {
                lblValidateSurname.text = Localization(string: "Enter surname")

            }
            else
            {
                lblValidateSurname.text = ""
            }
        }
        
        if textField == txtEmail
        {
            if (txtEmail.text?.isBlank)!
            {
                lblValidateEmail.text = Localization(string: "Enter email")

            }
            else if !(txtEmail.text?.isEmail)!
            {
                lblValidateEmail.text = strEmailInvalid
                
            }
            else
            {
                lblValidateEmail.text = ""
            }
        }
        
        if textField == txtCountryCode
        {
            if(txtCountryCode.text?.isBlank)!
            {
                lblValidateCountryCode.text = Localization(string: "Enter country code")

            }
            else
            {
                lblValidateCountryCode.text = ""
            }
            
        }
        
        
        if textField == txtPhoneNo
        {
            if(txtPhoneNo.text?.isBlank)!
            {
                lblValidatePhoneNo.text = Localization(string: "Enter mobile")

            }
            else if((txtPhoneNo.text?.characters.count)! < 14)
            {
                if((txtPhoneNo.text?.characters.count)! < 10)
                {
                    lblValidatePhoneNo.text = strMobileInvalid
                    
                }
                else
                {
                    
                }
                //lblValidatePhoneNo.text = strMobileInvalid
            }
                
            else if((txtPhoneNo.text?.characters.count)! < 10)
            {
                lblValidatePhoneNo.text = strMobileInvalid
            }
            else
            {
                lblValidatePhoneNo.text = ""
            }
        }
        
        
        if textField == txtCity
        {
            if (txtCity.text?.isBlank)!
            {
                lblValidateCity.text = Localization(string: "Enter City")

            }
            else
            {
                lblValidateCity.text = ""
            }
        }
        
        if textField == txtState
        {
            if (txtState.text?.isBlank)!
            {
                lblValidateState.text = Localization(string: "Enter State")

            }
            else
            {
                lblValidateState.text = ""
            }
        }
        
        if textField == txtNumber
        {
            if (txtNumber.text?.isBlank)!
            {
                lblValidateNumber.text = Localization(string: "Enter number")

            }
            else
            {
                lblValidateNumber.text = ""
            }
        }
        
        if textField == txtCountry
        {
            if (txtCountry.text?.isBlank)!
            {
                lblValidateCountry.text = Localization(string: "Enter Country")

            }
            else
            {
                lblValidateCountry.text = ""
            }
        }
        if textField == txtZipCode
        {
            if (txtZipCode.text?.isBlank)!
            {
                lblValidateZipCode.text = Localization(string: "Enter Zipcode")

            }
            else
            {
                lblValidateZipCode.text = ""
            }
        }
        if textField == txtComplement
        {
            if (txtComplement.text?.isBlank)!
            {
                lblValidateComplement.text = Localization(string: "Enter complement")

            }
            else
            {
                lblValidateComplement.text = ""
            }
        }
        if textField == txtStreetName
        {
            if (txtStreetName.text?.isBlank)!
            {
                lblValidateStreetName.text = Localization(string: "Enter street")

            }
            else
            {
                lblValidateStreetName.text = ""
            }
        }
        if textField == txtAddress
        {
            if (txtAddress.text?.isBlank)!
            {
                lblValidateStartTypingAdd.text = Localization(string: "Enter address")

            }
            else
            {
                lblValidateStartTypingAdd.text = ""
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
        else if txtCountryCode == textField
        {
            txtCountryCode.resignFirstResponder()
            txtPhoneNo.becomeFirstResponder()
        }
        else if txtPhoneNo == textField
        {
            txtPhoneNo.resignFirstResponder()
            txtAddress.becomeFirstResponder()
        }
        else if txtAddress == textField
        {
            txtAddress.resignFirstResponder()
            txtStreetName.becomeFirstResponder()
        }
        else if txtStreetName == textField
        {
            txtStreetName.resignFirstResponder()
            txtNumber.becomeFirstResponder()
        }
        else if txtNumber == textField
        {
            txtNumber.resignFirstResponder()
            txtComplement.becomeFirstResponder()
        }
        else if txtComplement == textField
        {
            txtComplement.resignFirstResponder()
            txtCity.becomeFirstResponder()
        }
        else if txtCity == textField
        {
            txtCity.resignFirstResponder()
            txtZipCode.becomeFirstResponder()
        }
        else if txtZipCode == textField
        {
            txtZipCode.resignFirstResponder()
            txtState.becomeFirstResponder()
        }
            
        else if txtState == textField
        {
            txtState.resignFirstResponder()
            txtCountry.becomeFirstResponder()
        }
        else if txtCountry == textField
        {
            txtCountry.resignFirstResponder()
      
        }
        else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    

    
    // MARK: - MVPlaceSearchTextField Delegate Methods
    
    @available(iOS 2.0, *)
    public func placeSearch(_ textField: MVPlaceSearchTextField!, resultCell cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
        
    }
    
    public func placeSearchWillHideResult(_ textField: MVPlaceSearchTextField!) {
        
    }
    
    public func placeSearchWillShowResult(_ textField: MVPlaceSearchTextField!) {
        
        
    }
    
    public func placeSearch(_ textField: MVPlaceSearchTextField!, responseForSelectedPlace responseDict: GMSPlace!) {
        
        
        txtAddress.text = responseDict.formattedAddress
        
        txtStreetName.text = ""
        txtZipCode.text = ""
        txtCity.text = ""
        txtState.text = ""
        txtCountry.text = ""
        
        
        /* let lat : NSNumber = NSNumber(value: userCurrentLocation.latitude)
         let lng : NSNumber = NSNumber(value: userCurrentLocation.longitude)*/
        
        for component in responseDict.addressComponents!
        {
            print(component.type)
            //print(component.name)
            
            if component.type == "sublocality_level_1"
            {
                print("Sub Locality : \(component.name)")
                
                txtStreetName.text = component.name
            }
            
            if component.type == "postal_code"
            {
                print("Postal Code : \(component.name)")
                
                txtZipCode.text = component.name
            }
            
            
            
            if component.type == "locality"
            {
                print("Locality : \(component.name)")
            }
            
            
            
            if component.type == "administrative_area_level_2"
            {
                print("city : \(component.name)")
                txtCity.text = component.name
            }
            
            if component.type == "administrative_area_level_1"
            {
                print("State : \(component.name)")
                txtState.text = component.name
            }
            
            if component.type == "country"
            {
                print("Country : \(component.name)")
                txtCountry.text = component.name
            }
            
        }
        
    }

    

    // MARK: - Api Call
    
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
                    self.view.makeToast(message, duration: 1.0, position: .bottom)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                    
                    let JobDashVC = storyBoard.instantiateViewController(withIdentifier: "JobDash") as! JobDash
                    let navigationController = SlideNavigationController(rootViewController: JobDashVC)
                    let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuJobSeeker") as! LeftMenuJobSeeker
                    SlideNavigationController.sharedInstance().leftMenu = leftview
                    SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
                    navigationController.navigationBar.isHidden = true
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }

    func updateUserDetailApi()
    {
        SwiftLoader.show(animated: true)
        
        /*
         {
         
         
         //         "categoryId": "108",
         //         "city": "Ahmedabad",
         //         "complement": "Near sola",
         //         "country": "India",
         //         "country_code": "+1",
         //         "description": "description text",
         //         "email": "johnsmith@gmail.com",
         //         "experience": "2.00",
         //         "firstName": "John",
         //         "lastEmployer": [
         //         "last employer"
         //         ],
         //         "lastName": "Smith",
         //         "lat": 23.0498393,
         //         "lng": 72.51730529999999,
         //         "number": "25",
         //         "password": "",
         //         "phone": "12 3456-7890",
         //         "profile_pic": "",
         //         "rate": "28.00",
         //         "state": "Gujarat",
         //         "streetName": "Sarkhej - Gandhinagar Highway",
         //         "subCategoryId": "102,100,104,88",
         //         "userId": "77",
         //         "zipcode": "380054",
         //         "language": "en",
         //         "methodName": "updateUserDetails"
        
         }

 */
        
        
      // \(loginDict.object(forKey: "categoryId")!)
        let param =  [WebServicesClass.METHOD_NAME: "updateUserDetails",
                      "categoryId":"",
                      "city":"\(txtCity.text!)",
            "complement":"\(txtComplement.text!)",
            "country":"\(txtCountry.text!)",
            "country_code":"\(txtCountryCode.text!)",
            "description": "",
            "email": "\(txtEmail.text!)",
            "experience": "",
            "firstName": "\(txtName.text!)",
            
            "lastEmployer": "",
            "lastName": "\(txtSurname.text!)",
            "lat": appdel.userLocationLat,
            "lng": appdel.userLocationLng,
            "number": "\(txtNumber.text!)",
            "password": "",
            "phone": "\(txtPhoneNo.text!)",
            "profile_pic": "",
            "rate": "",
            "state": "\(txtState.text!)",
            "streetName": "\(txtStreetName.text!)",
            "subCategoryId": "",
            "userId": "\(userDict.object(forKey: "userId")!)",
            "zipcode": "\(txtZipCode.text!)",
            "language": appdel.userLanguage
            ] as [String : Any]


        print(param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            if error != nil
            {
                print("Error",error?.description as String!)
                
                
                
                self.alertMessage.strMessage = (error?.description)!
                
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
                    if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary
                    {
                        
                        
                        let loginDict =  NSMutableDictionary(dictionary: dataDict)
                        
                        let keys = loginDict.allKeys.filter({loginDict[$0] is NSNull})
                        
                        print(keys)
                        
                        for key in keys
                        {
                            loginDict.setValue("", forKey: key as! String)

                            
                          //  loginDict.removeObject(forKey:key)
                        }
                        
                    
                        
                        
                        print(loginDict)
                        
                        let strEmptyKey = (loginDict.object(forKey: "exp_years")) as! String
                        
                        if strEmptyKey == ""
                        {
                            
                            let JobSelectCatagoryVCObj = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectCatagoryVC") as! JobSelectCatagoryVC
                            JobSelectCatagoryVCObj.userDic = loginDict
                            self.navigationController?.pushViewController(JobSelectCatagoryVCObj, animated: true)
                            
                        }
                        else
                        {
                            // Set Use Default
                            UserDefaults.standard.removeObject(forKey: kUserLoginDict)
                            UserDefaults.standard.set(loginDict, forKey: kUserLoginDict)
                            
                            appdel.loginUserDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
                            
                            
                            if appdel.deviceLanguage == "pt-BR"
                            {
                                self.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "userId")!)", userType: "2",message:"Bem vindo!")
                            }
                            else
                            {
                                self.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "userId")!)", userType: "2",message:"\(Response.object(forKey: "message") as! String)")
                            }
                        }
                        
                        
                    }
                    else
                    {
                        if appdel.deviceLanguage == "pt-BR"
                        {
                            self.alertMessage.strMessage = "\(Response.object(forKey: "pt_message")!)"
                        }
                        else
                        {
                            self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
                        }
                        
                        self.alertMessage.modalPresentationStyle = .overCurrentContext
                        
                        self.present(self.alertMessage, animated: false, completion: nil)
                        
                        print(Response.object(forKey: "message")!)
                    }
                    
                }
                else
                {
                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.alertMessage.strMessage = "\(Response.object(forKey: "pt_message")!)"
                    }
                    else
                    {
                        self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
                    }
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    
                    self.present(self.alertMessage, animated: false, completion: nil)
                    
                    print(Response.object(forKey: "message")!)
                }
                
                
                
//                if status == 1
//                {
//                    if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary
//                    {
//                        let loginDict =  NSMutableDictionary(dictionary: dataDict)
//                        
//                        let keys = loginDict.allKeys.filter({loginDict[$0] is NSNull})
//                        
//                        print(keys)
//                        
//                        for key in keys {
//                            loginDict.removeObject(forKey:key)
//                        }
//                        
//                        
//                        UserDefaults.standard.removeObject(forKey: kJobSignUpDict)
//                        
//                        UserDefaults.standard.set(loginDict, forKey: kJobSignUpDict)
//                        
//                        self.view.makeToast("\(Response.object(forKey: "message") as! String)", duration: 1.0, position: .bottom)
//                        
//                    
//                            let JobSelectCatagoryVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectCatagoryVC") as! JobSelectCatagoryVC
//                            
//                            self.navigationController?.pushViewController(JobSelectCatagoryVC, animated: true)
//                            
//                       
//                    }
//                    
//                }
//                else
//                {
//                    self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
//                    
//                    self.alertMessage.modalPresentationStyle = .overCurrentContext
//
//                    self.present(self.alertMessage, animated: false, completion: nil)
//
//                   // print(Response.object(forKey: "message"))
//                }
                
                
            }
        }
        
    }
    
    
    
    
    
 
    
    // MARK: - Class Method
    
   
    
    
    
    // Label setup
    
    func labelBlankSetup()
    {
        lblValidateEmail.text = ""
        lblValidateCity.text = ""
        lblValidateName.text = ""
        lblValidateState.text = ""
        lblValidateNumber.text = ""
        lblValidateCountry.text = ""
        lblValidatePhoneNo.text = ""
        lblValidateSurname.text = ""
        lblValidateZipCode.text = ""
        lblValidateComplement.text = ""
        lblValidateStreetName.text = ""
        lblValidateCountryCode.text = ""
        lblValidateStartTypingAdd.text = ""
    }
    
    //  TextField setup
    
    func textFieldSetUp()
    {
        txtName.underlined()
        txtState.underlined()
        txtCountry.underlined()
        txtPhoneNo.underlined()
        txtSurname.underlined()
        txtComplement.underlined()
        
    }
    
    //  TextField Email Validation Method
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
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
