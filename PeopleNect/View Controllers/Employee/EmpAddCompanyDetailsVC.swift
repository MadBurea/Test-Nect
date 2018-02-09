//
//  EmpAddCompanyDetailsVC.swift
//  PeopleNect
//
//  Created by Apple on 08/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader
import Alamofire
import Toast_Swift

class EmpAddCompanyDetailsVC: UIViewController, UITextFieldDelegate,PlaceSearchTextFieldDelegate,UserChosePhoto {

    @IBOutlet var lblAdressValidation: UILabel!
    @IBOutlet var lblCompanyValidation: UILabel!
    @IBOutlet var lblStreetValidation: UILabel!
    @IBOutlet var lblNumberValidation: UILabel!
    @IBOutlet var lblComplementValidation: UILabel!
    @IBOutlet var lblCountryValidation: UILabel!
    @IBOutlet var lblStateValidation: UILabel!
    @IBOutlet var lblZipCodeValidation: UILabel!
    @IBOutlet var lblCityValidation: UILabel!
    
    @IBOutlet var streeetView: UIView!
    @IBOutlet var addressView: UIView!
    @IBOutlet var txtState: JVFloatLabeledTextField!
    @IBOutlet var txtCountry: JVFloatLabeledTextField!
    @IBOutlet var txtZipCode: JVFloatLabeledTextField!
    @IBOutlet var txtCity: JVFloatLabeledTextField!
    @IBOutlet var txtComplement: JVFloatLabeledTextField!
    @IBOutlet var txtNumber: JVFloatLabeledTextField!
    @IBOutlet var txtStreetName: JVFloatLabeledTextField!
    @IBOutlet var txtAddress: MVPlaceSearchTextField!
    @IBOutlet var txtCompanyName: JVFloatLabeledTextField!
    @IBOutlet var btnCompanyImage: UIButton!
    
    let apiURL = "https://maps.googleapis.com/maps/api/geocode/json"
    //let apiKey = "AIzaSyBmAVuEWk6HKzILcIHRhgfBHrLj8r713ws"

    let apiKey = "AIzaSyAg5YUbdJukqM_BY7yu_ZN6UOf1MvLH3Zw"

    var userLocationCoordinate = CLLocationCoordinate2D()
    var strAddress = ""
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()

    var loginDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        btnCompanyImage.layer.cornerRadius = btnCompanyImage.bounds.size.width/2
        btnCompanyImage.clipsToBounds = true
        btnCompanyImage.layer.borderWidth = 1
        btnCompanyImage.layer.borderColor = ColorProfilePicBorder.cgColor

        // for image Picker
        appdel.isFromRegister = true

        // set up view
        self.setupView()

               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
 
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.textFieldSetUp()
       
        
        btnCompanyImage.layer.cornerRadius = btnCompanyImage.bounds.size.width/2
        
        btnCompanyImage.layer.borderWidth = 1.0
        btnCompanyImage.layer.borderColor = UIColor.lightGray.cgColor

      //  txtAddress.frame = CGRect(x: txtCompanyName.frame.origin.x, y: txtCompanyName.frame.origin.y, width: txtCompanyName.frame.size.width, height: txtCompanyName.frame.size.height)
        
        txtAddress.autoCompleteRegularFontName =  "Montserrat-Bold"
        txtAddress.autoCompleteBoldFontName = "Montserrat-Regular"
        txtAddress.autoCompleteTableCornerRadius=0.0
        txtAddress.autoCompleteRowHeight=35
        txtAddress.autoCompleteFontSize=14
        txtAddress.autoCompleteTableBorderWidth=1.0
        txtAddress.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=true
        txtAddress.autoCompleteShouldHideOnSelection=true
        txtAddress.autoCompleteShouldHideClosingKeyboard=true
        txtAddress.autoCompleteTableFrame = CGRect(x: 16 , y: txtAddress.frame.origin.y + txtAddress.frame.size.height, width: addressView.frame.size.width, height: 200)
            
            //CGRect(x: txtStreetName.frame.origin.x , y: txtAddress.frame.origin.y + txtAddress.frame.size.height, width: txtStreetName.frame.size.width, height: 200)
        
        txtAddress.placeSearchDelegate = self

       // txtAddress.autoCompleteTableView.delegate = self
       // txtAddress.autoCompleteShouldSelectOnExactMatchAutomatically = true

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
        
       userLocationCoordinate = responseDict.coordinate
        
        print("responseDict",responseDict)
        
        strAddress = (responseDict.formattedAddress as NSString!) as String
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(responseDict.coordinate) { (respose, error ) in
            
            if respose?.firstResult()?.postalCode != nil {
                self.txtZipCode.text = (respose?.firstResult()?.postalCode!  as! String)
                self.lblZipCodeValidation.text = ""
            }
            
           
        }
        
        for component in responseDict.addressComponents!
        {
            print(component.type)
            //print(component.name)
            
            if component.type == "sublocality_level_1"
            {
                print("Sub Locality : \(component.name)")
                
                txtStreetName.text = component.name
                
                lblStreetValidation.text = ""
            }
            
            if component.type == "postal_code"
            {
                print("Postal Code : \(component.name)")
                
//                txtZipCode.text = component.name
//
//                lblZipCodeValidation.text = ""

            }
            
            
            
            if component.type == "locality"
            {
                print("Locality : \(component.name)")
            }
            
            
            
            if component.type == "administrative_area_level_2"
            {
                print("city : \(component.name)")
                txtCity.text = component.name
                
                lblCityValidation.text = ""

            }
            
            if component.type == "administrative_area_level_1"
            {
                print("State : \(component.name)")
                txtState.text = component.name
                
                lblStateValidation.text = ""

            }
            
            if component.type == "country"
            {
                print("Country : \(component.name)")
                txtCountry.text = component.name
                
                lblCountryValidation.text = ""

            }
            
        }

    }
 
    // MARK: - Actions

    @IBAction func clickAddProfilePicker(_ sender: AnyObject) {
        
        
        let jobSelectProfilrPicVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        
        jobSelectProfilrPicVC.delegate = self
        
        navigationController?.pushViewController(jobSelectProfilrPicVC, animated: true)
        
    }
    
    func userHasChosen(image: UIImage){
        
        if image.isEqual(nil){
            print("Choose An Image!")
        }
        else{
            
                 btnCompanyImage.setImage(image, for: .normal)
            
            //btnCompanyImage.image = image
        }
    }
    
    @IBAction func clickBack(_ sender: AnyObject) {
        
        
        // is_loggedIn
        
        if (loginDict.object(forKey: "is_loggedIn")) as! Int != 1
        {
            _ = self.navigationController?.popViewController(animated: true)

        }
        
    }
    @IBAction func clickCreateAccount(_ sender: AnyObject) {
        
        
        txtCompanyName.resignFirstResponder()
        txtAddress.resignFirstResponder()
        txtStreetName.resignFirstResponder()
        txtNumber.resignFirstResponder()
        txtComplement.resignFirstResponder()
        txtCity.resignFirstResponder()
        txtZipCode.resignFirstResponder()
        txtState.resignFirstResponder()
        txtCountry.resignFirstResponder()
        
        var isApiCall = Bool()
        
        isApiCall = true
        
        
            if (txtCompanyName.text?.isBlank)!
            {
                lblCompanyValidation.text = Localization(string: "Enter company name")

                isApiCall = false

            }
            else
            {
                lblCompanyValidation.text = ""
            }
        
            if (txtAddress.text?.isBlank)!
            {
                lblAdressValidation.text = Localization(string: "Enter address")

                isApiCall = false

            }
            else
            {
                lblAdressValidation.text = ""
            }
       
            if (txtStreetName.text?.isBlank)!
            {
                lblStreetValidation.text = Localization(string: "Enter street")

                isApiCall = false

            }
            else
            {
                lblStreetValidation.text = ""
            }
       
            if(txtNumber.text?.isBlank)!
            {
                lblNumberValidation.text = Localization(string: "Enter number")

                isApiCall = false

            }
            else
            {
                lblNumberValidation.text = ""
            }
       
            if(txtComplement.text?.isBlank)!
            {
                lblComplementValidation.text = Localization(string: "Enter complement")

                isApiCall = false

            }
            else
            {
                lblComplementValidation.text = ""
            }
       
            if(txtCity.text?.isBlank)!
            {
                lblCityValidation.text = Localization(string: "Enter City")

                isApiCall = false

            }
            else
            {
                lblCityValidation.text = ""
            }
      
            if(txtZipCode.text?.isBlank)!
            {
                lblZipCodeValidation.text = Localization(string: "Enter Zipcode")

                isApiCall = false
            }
            else
            {
                lblZipCodeValidation.text = ""
            }
       
            if(txtState.text?.isBlank)!
            {
                lblStateValidation.text = Localization(string: "Enter State")

                isApiCall = false
            }
            else
            {
                lblStateValidation.text = ""
            }
       
            if(txtCountry.text?.isBlank)!
            {
                lblCountryValidation.text = Localization(string: "Enter Country")

                isApiCall = false
            }
            else
            {
                lblCountryValidation.text = ""
            }
        

        if isApiCall == true
        {
            self.employeeRegisterApi()
            
           /* let empsignupVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpAddCompanyDetailsVC") as! EmpAddCompanyDetailsVC
            navigationController?.pushViewController(empsignupVC, animated: true)*/
        }

    }
    
    // MARK: - Api Call
    
    func placeApi()
    {
        
        SwiftLoader.show(animated: true)
        //print("Load pois")
       
        let uri = apiURL + "?address=\(strAddress)&key=\(apiKey)"
        print(uri)
        let url = URL(string: uri)
        print(url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        print(session.configuration)
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            
            DispatchQueue.main.async(execute: {() -> Void in
                SwiftLoader.hide()
            })
            
            if let error = error {
                //print(error)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    
                    
                    //print(data!)
                    //print(response!)
                    
                    
                    do {
                        
                        
                        let responseObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        
                            //let results = responseObject["results"] as? Array<NSDictionary>
                        
                            let results = responseObject["results"] as? NSDictionary
                        
                            let addressComponent = results?["address_components"]
                        
                            
                           /* for placeDict in addressComponent {
                                
                                let type = placeDict.value(forKey: "country")
                                if type != nil
                                {
                                    let country = placeDict.value(forKey: "long_name")
  
                                }

                            }
                            */
                        
                       
                        
                    }
                    catch _ as NSError {
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func UpdateDeviceToken(userId:String,userType:String)  {
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
                    empdashboardVC.firstTimeRegistered = true
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
    

    
    func employeeRegisterApi()
    {
        SwiftLoader.show(animated: true)
        
        print("loginDict",loginDict)
        
        /*
         updateEmployersDetails	"{
         - ""countryId"": ""India"",
         - ""password"": """",
         - ""street_name"": ""Thaltej cross road"",
         - ""country_code"": """",
         - ""address2"": ""Near Sola"",
         - ""stateId"": ""Gujarat"",
         - ""phone"": """",
         - ""address1"": ""25"",
         - ""lng"": ""72.5117241"",
         - ""company_name"": ""Parle"",
         - ""employerId"": ""37"",
         - ""surname"": """",
         - ""name"": """",
         - ""methodName"": ""updateEmployersDetails"",
         - ""profilepic"": """",
         ""lat"": ""23.0497364"",
         ""zip"": ""380059"",
         ""cityId"": ""Ahmedabad""
         }"
         */
        
        
        
        let param =  [WebServicesClass.METHOD_NAME: "updateEmployersDetails",
                      "employerId":"\(loginDict.object(forKey: "employerId")!)",
            "country_code":"\(loginDict.object(forKey: "country_code")!)",
            "street_name":"\(txtStreetName.text!)",
            "password":"",
            "lng":appdel.userLocationLng,
            "lat":appdel.userLocationLat,
            "countryId":"\(txtCountry.text!)",
            "address2":"\(txtComplement.text!)",
            "stateId":"\(txtState.text!)",
            "company_name":"\(txtCompanyName.text!)",
            "phone":"\(loginDict.object(forKey: "phoneNo")!)",
            "address1":"\(txtNumber.text!)",
            "name":"\(loginDict.object(forKey: "name")!)",
            "surname":"\(loginDict.object(forKey: "surname")!)",
            "zip":"\(txtZipCode.text!)",
            "cityId":"\(txtCity.text!)"] as [String : Any]
        
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            
            if self.imageIsNull(imageName: ImgEmployerProfilepic) {
                let currentImage = UIImage(named: "company_profile")
                MultipartFormData.append(UIImageJPEGRepresentation(currentImage!, 1.0)!, withName: "profilepic", fileName: "file.png", mimeType: "image/png")
            }else{
                
                MultipartFormData.append(UIImageJPEGRepresentation(ImgEmployerProfilepic, 1.0)!, withName: "profilepic", fileName: "file.png", mimeType: "image/png")
            }
            
            for (key, value) in param
            {
                MultipartFormData.append(((value as! String).data(using: .utf8))!, withName: key)
            }
            
            }, to: WebServicesClass.WEB_SERVICE_URL) { (result:SessionManager.MultipartFormDataEncodingResult) in
                
                
                switch result
                {
                case .success(let upload,_ , _):
                    upload.response
                        {
                            
                            [weak self] response in
                            guard self != nil else
                            {
                                return
                            }
                            
                            do{
                                let dict = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                let status = (dict as AnyObject).object(forKey: "status") as! Int
                                
                                if status == 1{
                                    
                                    
                                    
                                    if let dataDict = (dict as AnyObject).object(forKey: "data") as? NSDictionary
                                    {
                                        
                                         let loginDict =  NSMutableDictionary(dictionary: dataDict)
                                        
                                        // Set User Default
                                        UserDefaults.standard.removeObject(forKey: kEmpLoginDict)
                                        UserDefaults.standard.set(loginDict, forKey: kEmpLoginDict)
                                        
                                        appdel.loginUserDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
                                        
                                    self?.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "employerId")!)", userType: "1")
                                
                                    }
                                    else
                                    {
                                        self?.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                                        self?.alertMessage.modalPresentationStyle = .overCurrentContext
                                        
                                        self?.present((self?.alertMessage)!, animated: false, completion: nil)

                                    }
                            }
                    }
                            
                    catch {
                        
                        
                        let errorObj = error as NSError
                        print("ERROR : ",errorObj.localizedDescription)
                        self?.alertMessage.strMessage = "Error: \(errorObj.localizedDescription)"
                        
                        self?.present((self?.alertMessage)!, animated: false, completion: nil)
                        
                        
//                        self?.alertMessage.strMessage = "\(response.object(forKey: "message")!)"
//                        
//                        self?.alertMessage.modalPresentationStyle = .overCurrentContext
//                        
//                        self?.present(self?.alertMessage, animated: false, completion: nil)

                        
                            }
                            
                            
                    }
                case .failure(let encodingError):
                    
                    print("error:\(encodingError)")

                }
        }
        
        
    }

    // MARK: - Label setup
    
    func labelBlankSetup()
    {
        lblStateValidation.text = ""
        lblComplementValidation.text = ""
        lblCityValidation.text = ""
        lblNumberValidation.text = ""
        lblCountryValidation.text = ""
        lblZipCodeValidation.text = ""
        lblStreetValidation.text = ""
        lblCompanyValidation.text = ""
        lblAdressValidation.text = ""

        
    }
    
    // MARK: - TextField setup
    
    func textFieldSetUp()
    {
        txtState.underlined()
        txtComplement.underlined()
        txtCity.underlined()
        txtNumber.underlined()
        txtCountry.underlined()
        txtStreetName.underlined()
        txtCompanyName.underlined()
       // txtAddress.underlined()
        
    }
    
    
    // MARK: - TextField Email Validation Method
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    // MARK: - TextField Delegate Method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtAddress{
            
         
            //self.scrollViewObj.isScrollEnabled = false
            
           // btnlocationleft.isHidden = false
          //  self.btnlocationleft.frame = CGRect(x: self.txtLocation.frame.origin.x + 10, y: self.txtLocation.frame.origin.y + 10, width: 25 , height: 25)
           
           // txtAddress.autoCompleteTableView.frame = CGRect(x: txtAddress.frame.origin.x , y: txtAddress.frame.origin.y + txtAddress.frame.size.height, width: txtAddress.frame.size.width, height: 200)
            
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
        
        if textField == txtCompanyName
        {
            lblCompanyValidation.text = ""
        }
        
        if textField == txtAddress
        {
            lblAdressValidation.text = ""
        }
        
        if textField == txtStreetName
        {
            lblStreetValidation.text = ""
        }
        if textField == txtNumber
        {
            lblNumberValidation.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
          /*  if (txtNumber.text?.characters.count)! > 15
            {
                return false
            }*/

        }
        if textField == txtComplement
        {
            lblComplementValidation.text = ""
        }
        if textField == txtCity
        {
            lblCityValidation.text = ""
        }
        if textField == txtZipCode
        {
            lblZipCodeValidation.text = ""
            
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
          /*  if (txtZipCode.text?.characters.count)! > 15
            {
                return false
            }*/

        }
        if textField == txtState
        {
            lblStateValidation.text = ""
        }
        if textField == txtCountry
        {
            lblCountryValidation.text = ""
        }
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }

        
      
        
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtCompanyName
        {
            if (txtCompanyName.text?.isBlank)!
            {
                lblCompanyValidation.text = Localization(string: "Enter company name")

            }
            else
            {
                lblCompanyValidation.text = ""
            }
        }
        
        if textField == txtAddress
        {
            if (txtAddress.text?.isBlank)!
            {
                lblAdressValidation.text = Localization(string: "Enter address")

            }
            else
            {
                lblAdressValidation.text = ""
            }
        }
        
        if textField == txtStreetName
        {
            if (txtStreetName.text?.isBlank)!
            {
                lblStreetValidation.text = Localization(string: "Enter street")

            }
            else
            {
                lblStreetValidation.text = ""
            }
        }
        
        if textField == txtNumber
        {
            if(txtNumber.text?.isBlank)!
            {
                lblNumberValidation.text = Localization(string: "Enter number")

            }
            else
            {
                lblNumberValidation.text = ""
            }
            
        }
        
        
        if textField == txtComplement
        {
            if(txtComplement.text?.isBlank)!
            {
                lblComplementValidation.text = Localization(string: "Enter complement")

            }
            else
            {
                lblComplementValidation.text = ""
            }
        }
        
        if textField == txtCity
        {
            if(txtCity.text?.isBlank)!
            {
                lblCityValidation.text = Localization(string: "Enter City")

            }
            else
            {
                lblCityValidation.text = ""
            }
        }

        if textField == txtZipCode
        {
            if(txtZipCode.text?.isBlank)!
            {
                lblZipCodeValidation.text = Localization(string: "Enter Zipcode")

            }
            else
            {
                lblZipCodeValidation.text = ""
            }
        }

        if textField == txtState
        {
            if(txtState.text?.isBlank)!
            {
                lblStateValidation.text = Localization(string: "Enter State")

            }
            else
            {
                lblStateValidation.text = ""
            }
        }
        if textField == txtCountry
        {
            if(txtCountry.text?.isBlank)!
            {
                lblCountryValidation.text = Localization(string: "Enter Country")

            }
            else
            {
                lblCountryValidation.text = ""
            }
        }

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtCompanyName == textField
        {
            txtCompanyName.resignFirstResponder()
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
    
    // MARK: - Class Method
    func setupView()
    {
        self.labelBlankSetup()
        
        txtAddress.delegate = self
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        btnCompanyImage.layer.cornerRadius = btnCompanyImage.bounds.size.width/2
        
        
        
        btnCompanyImage.setImage(UIImage(named: "company_profile.png"), for: .normal)

    }

  
}
