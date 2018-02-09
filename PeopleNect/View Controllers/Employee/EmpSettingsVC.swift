//
//  EmpSettingsVC.swift
//  PeopleNect
//
//  Created by Apple on 09/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader
import Toast_Swift

class EmpSettingsVC: UIViewController,PlaceSearchTextFieldDelegate, UITextFieldDelegate, UserChosePhoto,SlideNavigationControllerDelegate {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet var lblNameValidation: UILabel!
    @IBOutlet var lblSurnameValidation: UILabel!
    @IBOutlet var lblEmailValidation: UILabel!
    @IBOutlet var lblCountryCodeValidation: UILabel!
    @IBOutlet var lblMobileValidation: UILabel!
    @IBOutlet var lblPasswordValidation: UILabel!
    
    @IBOutlet var lblCompanyNameValidation: UILabel!
    @IBOutlet var lblSearchAddressValidation: UILabel!
    @IBOutlet var lblStreetNameValidation: UILabel!
    @IBOutlet var lblNumberValidation: UILabel!
    @IBOutlet var lblComplementValidation: UILabel!
    @IBOutlet var lblCityValidation: UILabel!
    @IBOutlet var lblZipCodeValidation: UILabel!
    @IBOutlet var lblStateValidation: UILabel!
    @IBOutlet var lblCountryValidation: UILabel!
    
    @IBOutlet var txtName: JVFloatLabeledTextField!
    @IBOutlet var txtSurname: JVFloatLabeledTextField!
    @IBOutlet var txtEmail: JVFloatLabeledTextField!
    @IBOutlet var txtCountryCode: JVFloatLabeledTextField!
    @IBOutlet var txtMobile: JVFloatLabeledTextField!
    @IBOutlet var txtPassword: JVFloatLabeledTextField!
    
    @IBOutlet var txtCompanyName: JVFloatLabeledTextField!
    @IBOutlet var txtSearchAddress: MVPlaceSearchTextField!
    @IBOutlet var txtStreetName: JVFloatLabeledTextField!
    @IBOutlet var txtNumber: JVFloatLabeledTextField!
    @IBOutlet var txtComplement: JVFloatLabeledTextField!
    @IBOutlet var txtCity: JVFloatLabeledTextField!
    @IBOutlet var txtZipCode: JVFloatLabeledTextField!
    @IBOutlet var txtState: JVFloatLabeledTextField!
    @IBOutlet var txtCountry: JVFloatLabeledTextField!
    
    @IBOutlet var btnProfilePic : UIButton!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var viewStartTypingAdd : UIView!
    
    var alertMessage = AlertMessageVC()
    var global = WebServicesClass()
    
    let apiURL = "https://maps.googleapis.com/maps/api/geocode/json"
    let apiKey = "AIzaSyAg5YUbdJukqM_BY7yu_ZN6UOf1MvLH3Zw"

    
    var lat = ""
    var lng = ""

    
    // MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtPassword.text = "123456"
        self.txtPassword.textColor = UIColor.lightGray
        
        if imageIsNull(imageName: ImgEmployerProfilepic )
        {
            self.setEmployerImage(btnProfilePic:btnProfilePic)
        }
        else
        {
            btnProfilePic.setImage(ImgEmployerProfilepic, for: .normal)
        }
        self.employersDetailsApi()
        self.setupView()
        self.intialSetupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if imageIsNull(imageName: ImgEmployerProfilepic ){
            self.setImageForJobSeeker(btnProfilePic:btnProfilePic)
        }else{
            btnProfilePic.setImage(ImgEmployerProfilepic, for: .normal)
            
        }
        
        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2
        btnProfilePic.clipsToBounds = true
        btnProfilePic.layer.borderWidth = 1
        btnProfilePic.layer.borderColor = ColorProfilePicBorder.cgColor
        
        
        txtSearchAddress.autoCompleteRegularFontName =  "Montserrat-Bold"
        txtSearchAddress.autoCompleteBoldFontName = "Montserrat-Regular"
        txtSearchAddress.autoCompleteTableCornerRadius=0.0
        txtSearchAddress.autoCompleteRowHeight=35
        txtSearchAddress.autoCompleteFontSize=14
        txtSearchAddress.autoCompleteTableBorderWidth=1.0
        txtSearchAddress.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=true
        txtSearchAddress.autoCompleteShouldHideOnSelection=true
        txtSearchAddress.autoCompleteShouldHideClosingKeyboard=true
        txtSearchAddress.autoCompleteTableFrame = CGRect(x: 15 , y: txtSearchAddress.frame.origin.y + txtSearchAddress.frame.size.height, width: viewStartTypingAdd.frame.size.width, height: 200)
        
        txtSearchAddress.placeSearchDelegate = self
    }
    
    
    // MARK: - UIView Actions

    func intialSetupView()
    {
        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0
    }
    @IBAction func btnBackClick(sender : UIButton) {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)
    }
    
    @IBAction func btnEditProfileClick(sender : UIButton) {
        print("btnEditProfileClick")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let JobSelectProfilrPicVC = storyBoard.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        
        JobSelectProfilrPicVC.delegate = self
        appdel.isFromRegister = true
        
        self.navigationController?.pushViewController(JobSelectProfilrPicVC, animated: true)

    }
    
    @IBAction func btnChangePasswordClick(sender: UIButton) {
        
        txtPassword.text = ""
        txtPassword.textColor = UIColor.black
        txtPassword.isUserInteractionEnabled = true
        txtPassword.becomeFirstResponder()
    }
    
    @IBAction func btnSaveClick(sender : UIButton) {
        
        self.view.endEditing(true)
        
        txtName.resignFirstResponder()
        txtSurname.resignFirstResponder()
        txtMobile.resignFirstResponder()
        txtCountry.resignFirstResponder()
        txtState.resignFirstResponder()
        txtZipCode.resignFirstResponder()
        txtCity.resignFirstResponder()
        txtComplement.resignFirstResponder()
        txtNumber.resignFirstResponder()
        txtStreetName.resignFirstResponder()
        txtSearchAddress.resignFirstResponder()
        txtCountryCode.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        var isApiCall = true
        
        if (txtName.text?.isBlank)! {
            lblNameValidation.text = Localization(string: "Enter name")

            isApiCall = false
        }
        else {
            lblNameValidation.text = ""
        }
        
        if (txtSurname.text?.isBlank)! {
            lblSurnameValidation.text = Localization(string: "Enter surname")

            isApiCall = false
        }
        else {
            lblSurnameValidation.text = ""
        }
        
        if (txtEmail.text?.isBlank)! {
            lblEmailValidation.text = Localization(string: "Enter email")

            isApiCall = false
        }
            
        else if !(txtEmail.text?.isEmail)! {
            lblEmailValidation.text = strEmailInvalid
            isApiCall = false
        }
        else {
            lblEmailValidation.text = ""
        }
        
        if(txtCountryCode.text?.isBlank)! {
            lblCountryCodeValidation.text = Localization(string: "Enter country code")

            isApiCall = false
        }
        else {
            lblCountryCodeValidation.text = ""
        }
        
        if(txtMobile.text?.isBlank)! {
            lblMobileValidation.text = Localization(string: "Enter mobile")

            isApiCall = false
        }
        else if((txtMobile.text?.characters.count)! < 10) {
            lblMobileValidation.text = strMobileInvalid
            isApiCall = false
        }
        else {
            lblMobileValidation.text = ""
        }
        
//        if(txtPassword.text?.isBlank)! {
//            lblPasswordValidation.text = strPasswordEmpty
//            isApiCall = false
//        }
//        else if(txtPassword.text?.characters.count)! < 6 {
//            lblPasswordValidation.text = strPasswordInvaild
//            isApiCall = false
//        }
//        else {
//            lblPasswordValidation.text = ""
//        }
        
        if (txtCompanyName.text?.isBlank)! {
            lblCompanyNameValidation.text = Localization(string: "Enter company name")

            isApiCall = false
        }
        else {
            lblCompanyNameValidation.text = ""
        }
        
        if (txtCountry.text?.isBlank)! {
            lblCountryValidation.text = Localization(string: "Enter Country")

            isApiCall = false
        }
        else {
            lblCountryValidation.text = ""
        }
        
        if (txtState.text?.isBlank)! {
            lblStateValidation.text = Localization(string: "Enter State")

            isApiCall = false
        }
        else {
            lblStateValidation.text = ""
        }
        
        if (txtZipCode.text?.isBlank)! {
            lblZipCodeValidation.text = Localization(string: "Enter Zipcode")

            isApiCall = false
        }
        else {
            lblZipCodeValidation.text = ""
        }
        
        if (txtCity.text?.isBlank)! {
            lblCityValidation.text = Localization(string: "Enter City")

            isApiCall = false
        }
        else {
            lblCityValidation.text = ""
        }
        
        if (txtComplement.text?.isBlank)! {
            lblComplementValidation.text = Localization(string: "Enter complement")

            isApiCall = false
        }
        else {
            lblComplementValidation.text = ""
        }
        
        if (txtNumber.text?.isBlank)! {
            lblNumberValidation.text = Localization(string: "Enter number")

            isApiCall = false
        }
        else {
            lblNumberValidation.text = ""
        }
        
        if (txtStreetName.text?.isBlank)! {
            lblStreetNameValidation.text = Localization(string: "Enter street")

            isApiCall = false
        }
        else {
            lblStreetNameValidation.text = ""
        }
        
//        if (txtSearchAddress.text?.isBlank)!
//        {
//            lblSearchAddressValidation.text = strAddressEmpty
//            isApiCall = false
//        }
//        else
//        {
//            lblSearchAddressValidation.text = ""
//        }
        
        if isApiCall == true {
            self.updateEmployersDetails()
        }
        
    }
    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    
    // MARK: - Api Call
    
    func updateEmployersDetails() {
        
        SwiftLoader.show(animated: true)
        
   
        
        let param =  [WebServicesClass.METHOD_NAME: "updateEmployersDetails",
                      "employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage,
            "deviceId":UIDevice.current.identifierForVendor!.uuidString,
            "lat":self.lat,
            "lng":self.lng,
            "profilepic":"",
            "name":"\(txtName.text!)",
            "surname":"\(txtSurname.text!)",
            "country_code":"\(txtCountryCode.text!)",
            "phone":"\(txtMobile.text!)",
            "password": "\(txtPassword.text!)",
            "company_name":"\(txtCompanyName.text!)",
            "street_name":"\(txtStreetName.text!)",
            "address1":"\(txtNumber.text!)",
            "address2":"\(txtComplement.text!)",
            "cityId":"\(txtCity.text!)",
            "zip":"\(txtZipCode.text!)",
            "stateId":"\(txtState.text!)",
            "countryId":"\(txtCountry.text!)"] as [String : Any]
        
        print(param)

        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()

            if error != nil {
                print("ErrorGetUserInfo:",error?.localizedDescription as String!)
                SwiftLoader.hide()
            }
            else {
                let dictResponse = Response as! NSDictionary
                
                print("ResponseGetUserInfo",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1 {
                    
                    
                    if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary {
                        
                        
                        let loginDict =  NSMutableDictionary(dictionary: dataDict)
                        let keys = loginDict.allKeys.filter({loginDict[$0] is NSNull})
                        
                        print(keys)
                        
                        for key in keys {
                            loginDict.setValue("", forKey: key as! String)
                          //  loginDict.removeObject(forKey:key)
                        }
                        
                        UserDefaults.standard.removeObject(forKey: kEmpLoginDict)
                        UserDefaults.standard.set(loginDict, forKey: kEmpLoginDict)
                        appdel.loginUserDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                        let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
                        
                        empdashboardVC.SettingDetailUPdated = true
                        
                        self.navigationController?.pushViewController(empdashboardVC, animated: true)
                     
                        let userID = "\(appdel.loginUserDict.object(forKey: "employerId")!)"
                    
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeImageEmployer"), object: nil)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EmpchangeImageFromEmpSetting"), object: nil)
                        
                        if self.imageIsNull(imageName: ImgEmployerProfilepic ){
                        }else{
                            self.UploadImage(image: ImgEmployerProfilepic, userID: userID, isEmployer:true)
                        }
                    }
                }
                else {
                    self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
        }
    }
    
    func employersDetailsApi() {

        SwiftLoader.show(animated: true)
        
        
      
        
        let param =  [WebServicesClass.METHOD_NAME: "employersDetails",
                      "employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
                      "language":appdel.userLanguage] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            
            if error != nil {
                print("ErrorGetUserInfo:",error?.description as String!)
            }
            else {
                let dictResponse = Response as! NSDictionary
                
                print("ResponseGetUserInfo",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1 {
                    
                    if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary {
                      
                        
                        self.txtName.text = "\(dataDict.object(forKey: "name")!)"
                        self.txtSurname.text = "\(dataDict.object(forKey: "surname")!)"
                        self.txtEmail.text = "\(dataDict.object(forKey: "email")!)"
                        self.txtCountryCode.text = "\(dataDict.object(forKey: "country_code")!)"
                        self.txtMobile.text = "\(dataDict.object(forKey: "phoneNo")!)"

                        self.txtCompanyName.text = "\(dataDict.object(forKey: "companyName")!)"
                        
                        self.lat = "\(dataDict.object(forKey: "lat")!)"
                        self.lng = "\(dataDict.object(forKey: "lng")!)"

                        print("get lat lng is",self.lat,self.lng)

                        self.txtStreetName.text = "\(dataDict.object(forKey: "street_name")!)"
                        self.txtNumber.text = "\(dataDict.object(forKey: "address1")!)"
                        self.txtComplement.text = "\(dataDict.object(forKey: "address2")!)"
                        self.txtCity.text = "\(dataDict.object(forKey: "city")!)"
                        self.txtZipCode.text = "\(dataDict.object(forKey: "zip")!)"
                        self.txtState.text = "\(dataDict.object(forKey: "state")!)"
                        self.txtCountry.text = "\(dataDict.object(forKey: "country")!)"
                        
                    }
                }
                else {
                    self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
        }
        
    }

   
    // MARK: - TextField Delegate Method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtSearchAddress{
            txtSearchAddress.autoCompleteTableView.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Backspace Validation
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            //print("Backspace was pressed")
            return true
        }
        
        if textField == txtSurname {
            lblSurnameValidation.text = ""
        }
        
        if textField == txtName {
            lblNameValidation.text = ""
        }
        
        if textField == txtPassword {
            lblPasswordValidation.text = ""
        }
        
        if textField == txtEmail {
            lblEmailValidation.text = ""
            if (validateEmail(candidate: txtEmail.text!)) {
                return true
            }
        }
        else if textField == txtCountryCode {
            lblCountryCodeValidation.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil) {
                return false
            }
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField == txtMobile {
            lblMobileValidation.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil) {
                return false
            }
            
            if (txtMobile.text?.characters.count)! > 14 {
                return false
            }
        }
        else if textField == txtCompanyName {
            lblCompanyNameValidation.text = ""
        }
        else if textField == txtSearchAddress {
            lblSearchAddressValidation.text = ""
        }
        else if textField == txtCity {
            lblCityValidation.text = ""
        }
        else if textField == txtState {
            lblStateValidation.text = ""
        }
        else if textField == txtNumber {
            lblNumberValidation.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil) {
                return false
            }
        }
        else if textField == txtCountry {
            lblCountryCodeValidation.text = ""
        }
        else if textField == txtZipCode {
            lblZipCodeValidation.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                return false
            }
        }
        else if textField == txtComplement {
            lblComplementValidation.text = ""
        }
        else if textField == txtStreetName {
            lblStreetNameValidation.text = ""
        }
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtName {
            if (txtName.text?.isBlank)! {
                lblNameValidation.text = Localization(string: "Enter name")

            }
            else {
                lblNameValidation.text = ""
            }
        }
        
        if textField == txtSurname {
            if (txtSurname.text?.isBlank)! {
                lblSurnameValidation.text = Localization(string: "Enter surname")

            }
            else {
                lblSurnameValidation.text = ""
            }
        }
        
        if textField == txtEmail {
            if (txtEmail.text?.isBlank)! {
                lblEmailValidation.text = Localization(string: "Enter email")

            }
            else if !(txtEmail.text?.isEmail)! {
                lblEmailValidation.text = strEmailInvalid
            }
            else {
                lblEmailValidation.text = ""
            }
        }
        
        if textField == txtCountryCode {
            if(txtCountryCode.text?.isBlank)! {
                lblCountryCodeValidation.text = Localization(string: "Enter country code")

            }
            else {
                lblCountryCodeValidation.text = ""
            }
        }
        
        
        if textField == txtMobile {
            if(txtMobile.text?.isBlank)! {
                lblMobileValidation.text = Localization(string: "Enter mobile")

            }
            else if((txtMobile.text?.characters.count)! < 10) {
                lblMobileValidation.text = strMobileInvalid
            }
            else {
                lblMobileValidation.text = ""
            }
        }
        
        if textField == txtPassword {
            if(txtPassword.text?.isBlank)! {
                lblPasswordValidation.text = Localization(string: "Enter password")

            }
            else if(txtPassword.text?.characters.count)! < 6 {
                lblPasswordValidation.text = strPasswordInvaild
            }
            else {
                lblPasswordValidation.text = ""
            }
        }
        
        if textField == txtCompanyName {
            if (txtCompanyName.text?.isBlank)! {
                lblCompanyNameValidation.text = Localization(string: "Enter company name")

            }
            else {
                lblCompanyNameValidation.text = ""
            }
        }
        
        if textField == txtCity {
            if (txtCity.text?.isBlank)! {
                lblCityValidation.text = Localization(string: "Enter City")

            }
            else {
                lblCityValidation.text = ""
            }
        }
        
        if textField == txtState {
            if (txtState.text?.isBlank)! {
                lblStateValidation.text = Localization(string: "Enter State")

            }
            else {
                lblStateValidation.text = ""
            }
        }
        
        if textField == txtNumber {
            if (txtNumber.text?.isBlank)! {
                lblNumberValidation.text = Localization(string: "Enter number")

            }
            else {
                lblNumberValidation.text = ""
            }
        }
        
        if textField == txtCountry {
            if (txtCountry.text?.isBlank)! {
                lblCountryCodeValidation.text = Localization(string: "Enter Country")

            }
            else {
                lblCountryCodeValidation.text = ""
            }
        }
        
        if textField == txtZipCode {
            if (txtZipCode.text?.isBlank)! {
                lblZipCodeValidation.text = Localization(string: "Enter Zipcode")

            }
            else {
                lblZipCodeValidation.text = ""
            }
        }
        
        if textField == txtComplement {
            if (txtComplement.text?.isBlank)! {
                lblComplementValidation.text = Localization(string: "Enter complement")

            }
            else {
                lblComplementValidation.text = ""
            }
        }
        
        if textField == txtStreetName {
            if (txtStreetName.text?.isBlank)! {
                lblStreetNameValidation.text = Localization(string: "Enter street")

            }
            else {
                lblStreetNameValidation.text = ""
            }
        }
        
        if textField == txtSearchAddress {
            if (txtSearchAddress.text?.isBlank)! {
                lblSearchAddressValidation.text = Localization(string: "Enter address")

            }
            else {
                lblSearchAddressValidation.text = ""
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
            txtMobile.becomeFirstResponder()
        }
        else if txtMobile == textField
        {
            txtMobile.resignFirstResponder()
            txtCompanyName.becomeFirstResponder()
        }
        else if txtCompanyName == textField
        {
            txtCompanyName.resignFirstResponder()
            txtSearchAddress.becomeFirstResponder()
        }
        else if txtSearchAddress == textField
        {
            txtSearchAddress.resignFirstResponder()
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
            txtPassword.becomeFirstResponder()
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
    
    
    
    // MARK: - Class Methods
    
    func userHasChosen(image: UIImage){
        
        if image.isEqual(nil){
            print("Choose An Image!")
        }
        else{
            btnProfilePic.setImage(image, for: .normal)
            ImgEmployerProfilepic = image
        }
    }
    
    func setupView()
    {
        alertMessage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        txtPassword.isUserInteractionEnabled = false
        
        lblPasswordValidation.text = ""
        lblMobileValidation.text = ""
        lblCountryCodeValidation.text = ""
        lblEmailValidation.text = ""
        lblSurnameValidation.text = ""
        lblNameValidation.text = ""
        
        lblCompanyNameValidation.text = ""
        lblSearchAddressValidation.text = ""
        lblStreetNameValidation.text = ""
        lblNumberValidation.text = ""
        lblComplementValidation.text = ""
        lblCityValidation.text = ""
        lblZipCodeValidation.text = ""
        lblStateValidation.text = ""
        lblCountryValidation.text = ""
    }

    //  TextField Email Validation Method
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }

    

    
    // MARK: - MVPlaceSearchTextField Delegate Methods
    
    public func placeSearch(_ textField: MVPlaceSearchTextField!, resultCell cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
        
    }
    
    public func placeSearchWillHideResult(_ textField: MVPlaceSearchTextField!) {
        
    }
    
    public func placeSearchWillShowResult(_ textField: MVPlaceSearchTextField!) {
        
    }
    
    public func placeSearch(_ textField: MVPlaceSearchTextField!, responseForSelectedPlace responseDict: GMSPlace!) {
        
        txtSearchAddress.text = responseDict.formattedAddress
        txtStreetName.text = ""
        txtZipCode.text = ""
        txtCity.text = ""
        txtState.text = ""
        txtCountry.text = ""
        
        self.lat = "\(responseDict.coordinate.latitude)"
        self.lng = "\(responseDict.coordinate.longitude)"
        
        print("selected lat lng is",self.lat,self.lng)

        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(responseDict.coordinate) { (respose, error ) in
            
            if respose?.firstResult()?.postalCode != nil {
                self.txtZipCode.text = (respose?.firstResult()?.postalCode!  as! String)
                self.lblZipCodeValidation.text = ""
            }
        }
        
        for component in responseDict.addressComponents! {
            print(component.type)
            //print(component.name)
            
            if component.type == "sublocality_level_1" {
//                print("Sub Locality : \(component.name)")
                txtStreetName.text = component.name
                self.lblStreetNameValidation.text = ""
            }
            
            if component.type == "postal_code" {
//                print("Postal Code : \(component.name)")
//                txtZipCode.text = component.name
//                self.lblZipCodeValidation.text = ""

            }
            
            if component.type == "locality" {
//                print("Locality : \(component.name)")
            }
            
            if component.type == "administrative_area_level_2" {
//                print("city : \(component.name)")
                txtCity.text = component.name
                self.lblCityValidation.text = ""

            }
            
            if component.type == "administrative_area_level_1" {
//                print("State : \(component.name)")
                txtState.text = component.name
                self.lblStateValidation.text = ""

            }
            
            if component.type == "country" {
//                print("Country : \(component.name)")
                txtCountry.text = component.name
                self.lblCountryValidation.text = ""

            }
        }
    }
    
}
