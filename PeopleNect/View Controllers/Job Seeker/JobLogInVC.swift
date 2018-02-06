//
//  JobLogInVC.swift
//  PeopleNect
//
//  Created by Apple on 08/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Google
import JVFloatLabeledTextField
import SwiftLoader
import GoogleSignIn

class JobLogInVC: UIViewController,UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate{

    @IBOutlet var imgEmail: UIImageView!
    @IBOutlet var imgPassword: UIImageView!

    @IBOutlet var txtEmail: JVFloatLabeledTextField!
    @IBOutlet var txtPassword: JVFloatLabeledTextField!
    
    @IBOutlet var btnFBSignIn: UIButton!
    @IBOutlet var btnGoogleLogIn: UIButton!
    
    @IBOutlet var lblValidateEmail: UILabel!
    @IBOutlet var lblValidatePassword: UILabel!
    
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnForgotPassword: UIButton!
    
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet var btnBack: UIButton!
    var strMessage = String()
    


    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    

    //MARK: - View life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelBlankSetup()
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        if TARGET_IPHONE_SIMULATOR == 1 {
            //simulator
            txtEmail.text = "nirav.inexture@gmail.com"
            txtPassword.text = "123456"
        } else {
            //device
           
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - UIView Actoins -

    @IBAction func clickLogin(_ sender: Any) {
        appdel.isFromRegister = true

        txtPassword.resignFirstResponder()
        txtEmail.resignFirstResponder()
        
        var isApiCall = Bool()
        
        isApiCall = true
        
        
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
        
        if(txtPassword.text?.isBlank)!
        {
            lblValidatePassword.text = Localization(string: "Enter password")

            isApiCall = false
        }
        else if(txtPassword.text?.characters.count)! < 6
        {
            lblValidatePassword.text = strPasswordInvaild
            isApiCall = false
        }
        else
        {
            lblValidatePassword.text = ""
        }
        
        
        if isApiCall == true
        {
            
            self.loginApi(loginWith: "email", email: ("txtEmail.text"))
            
          }
        
    }
    
    
    @IBAction func clickForgotPassword(_ sender: Any) {
        
        let JobResetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "JobResetPasswordVC") as! JobResetPasswordVC
        
        navigationController?.pushViewController(JobResetPasswordVC, animated: true)
        
//        let empforgotpasswordvc = self.storyboard?.instantiateViewController(withIdentifier: "EmpForgotPasswordVC") as! EmpForgotPasswordVC
//        navigationController?.pushViewController(empforgotpasswordvc, animated: true)

    }
    @IBAction func clickGoogleLogIn(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
        appdel.isFromRegister = true

     //   self.registerSocialApi(socialType: "google", access_token: "userId", email: email!)

    }
    
    
    @IBAction func clickFBSignIn(_ sender: Any) {
        appdel.isFromRegister = true

        
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { LoginResult in
            switch LoginResult {
   
            case .failed(let error):
                
                print(error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):

                self.getUserrInfo(completion: { (userInfo, error) in
                    
                    if error != nil
                    {
                        self.alertMessage.strMessage = "Dang! something went wrong. Try again!"
                        
                        self.alertMessage.modalPresentationStyle = .overCurrentContext
                        
                        self.present(self.alertMessage, animated: false, completion: nil)
                        
                        print("error")
                    }
                    print("userInfo",userInfo!)
                    ////////////////////////////////////
                    if userInfo!["email"] != nil
                    {
                        
                        self.registerSocialApi(socialType: "facebook", access_token: userInfo!["id"]! as! String,email: userInfo!["email"]! as! String,firstName: userInfo!["name"]! as! String,lastName: "")
                        
                        print("email",(userInfo?["email"])!)
                        
                        if let userInfo = userInfo, let name = userInfo["name"], let id = userInfo["id"], let email = userInfo["email"]
                        {
                            self.txtEmail.text = (email as! String)
                            print("email",email)
                        }
                    }
                    else
                    {
                        self.alertMessage.strMessage = "Can't get your details, please login using Email."
                        
                        self.alertMessage.modalPresentationStyle = .overCurrentContext
                        
                        self.present(self.alertMessage, animated: false, completion: nil)
                        
                        print("api will not call")
                    }
                    
                })
                
//                self.getUserrInfo(completion: { (userInfo, error) in
//                    if error != nil
//                    {
//                        print("error")
//                    }
//                    print("userInfo",userInfo)
//                    self.registerSocialApi(socialType: "facebook", access_token: userInfo!["id"]! as! String,email: userInfo!["email"]! as! String,firstName: userInfo!["name"]! as! String,lastName: "")
//                    
//                    print("email",(userInfo?["email"])!)
//                    
//                    if let userInfo = userInfo, let name = userInfo["name"], let id = userInfo["id"], let email = userInfo["email"]
//                    {
//                        print("email",email)
//                    }
//                })
                
            }
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
        
        if textField == txtPassword
        {
            lblValidatePassword.text = ""
        }
        
        if textField == txtEmail {
            
            lblValidateEmail.text = ""
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
        
        
        if textField == txtPassword
        {
            if(txtPassword.text?.isBlank)!
            {
                lblValidatePassword.text = Localization(string: "Enter password")

            }
            else if(txtPassword.text?.characters.count)! < 6
            {
                lblValidatePassword.text = strPasswordInvaild
            }
            else
            {
                lblValidatePassword.text = ""
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
        else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    //MARK:- GIDSignInUIDelegate Method
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
        //   UIActivityIndicatorView.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            
            let userId = user.userID // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print("google sign in method called from app delegate")
            
            
            let firstNme1 = fullName?.components(separatedBy: " ").first!
            let lastName1 = fullName?.components(separatedBy: " ").last!
                    
            //   let password = user.profile
            print("UserID:",userId! + "Token",idToken! + "Full Name",fullName! + "givenName", givenName! + "Family Name",familyName! + "Email", email!)
            
            self.registerSocialApi(socialType: "google", access_token: userId!,email: email!,firstName: firstNme1!,lastName: lastName1!)
            
            
            txtEmail.text = GIDSignIn.sharedInstance().currentUser.profile.email
        } else {
            print("\(error.localizedDescription)")
        }
        
        
    }
    
    
    // MARK: - API Call
    
    func loginApi(loginWith: String, email: String)
    {
        /*
          "deviceId": "3e209683c165da83",
         "email": "johnsmith@gmail.com",
         "loginWith": "email",
         "password": "123456",
         "language": "en",
         "methodName": "login"
         }

         }"
         */
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "login","deviceId":UIDevice.current.identifierForVendor!.uuidString,"password":"\(txtPassword.text!)","email": "\(txtEmail.text!)","loginWith": loginWith,"language":appdel.userLanguage] as [String : Any]
        
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
                
                if status == 1
                {
                   if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary
                   {
                    
                    print("dataDict login dic is",dataDict)
                    
                     let loginDict =  NSMutableDictionary(dictionary: dataDict)
                    
                    
                    print("dataDict loginDict loginDict is",loginDict)

                    
                    let keys = loginDict.allKeys.filter({loginDict[$0] is NSNull})
                    
                    print(keys)
                    
                    for key in keys
                    {
                       // loginDict.setValue("", forKey: key as! String)
                        loginDict.removeObject(forKey:key)
                    }
                    
                    
                    print("after modification login dict is ",loginDict)
                    
                    if (loginDict.object(forKey: "exp_years")) == nil
                    {
                        
                        let JobSelectCatagoryVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectCatagoryVC") as! JobSelectCatagoryVC
                        JobSelectCatagoryVC.userDic = loginDict
                        self.navigationController?.pushViewController(JobSelectCatagoryVC, animated: true)
                        
                    }
                    else
                    {
                        
                        // Set Use Default
                        UserDefaults.standard.removeObject(forKey: kUserLoginDict)
                        UserDefaults.standard.set(loginDict, forKey: kUserLoginDict)
                        
                        appdel.loginUserDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
                        
                        
                        print("appdel.loginUserDict login dic is",appdel.loginUserDict)

                        
                        if appdel.deviceLanguage == "pt-BR"
                        {
                            self.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "userId")!)", userType: "2",message:"\(Response.object(forKey: "message") as! String)")
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
            }
        }
        
    }
    
    
    func registerSocialApi(socialType : String, access_token: String,email: String, firstName: String, lastName: String)
   // func registerSocialApi(socialType : String, access_token: String, email: String)
    {
        SwiftLoader.show(animated: true)
        
        
        let  EndTime  = "23:59"
        let StartTime = "00:00"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let startTimeLocal = formatter.date(from: StartTime)
        let EndTimeLocal = formatter.date(from: EndTime)
        
        
        let startAvailabilityTime = startTimeLocal?.currentUTCTimeZoneTime
        let endAvailabilityTime = EndTimeLocal?.currentUTCTimeZoneTime
        
        let param =  [WebServicesClass.METHOD_NAME: "register","access_identifier":"\(access_token)",
            "access_token":"\(access_token)",
            "city":"",
            "complement":"",
            "country":"",
            "country_code":"",
            "deviceId":UIDevice.current.identifierForVendor!.uuidString,
            "email":"\(email)",
            "lat":"",
            "lng":"",
            "name":firstName,
            "number":"",
            "password":"",
            "phone":"",
            "registerWith":"socialMedia",
            "state":"",
            "streetName":"",
            "surname":lastName,
            "zipcode":"",
            "language":appdel.userLanguage,
            "socialType":"\(socialType)",
            "startAvailabilityTime":startAvailabilityTime!,
            "endAvailabilityTime":endAvailabilityTime!,"local_diff":"\(getTimeZoneValue())"] as [String : Any]
        
        print("param",param)
        
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
                
                if status == 1
                {
                    if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary
                    {
                        let loginDict =  NSMutableDictionary(dictionary: dataDict)
                        
                      /*  if (loginDict.object(forKey: "exp_years")) is NSNull
                        {
                            loginDict.setValue("", forKey: "exp_years")
                        }
                        if (loginDict.object(forKey: "profile_description")) is NSNull
                        {
                            loginDict.setValue("", forKey: "profile_description")
                        }
                        if (loginDict.object(forKey: "hourly_compensation")) is NSNull
                        {
                            loginDict.setValue("", forKey: "hourly_compensation")
                        }
                        
                        if (loginDict.object(forKey: "availability")) is NSNull
                        {
                            loginDict.setValue("", forKey: "availability")
                        }
                        
                        UserDefaults.standard.set(loginDict, forKey: kJobSignUpDict)
                        
                        self.view.makeToast("\(String(describing: Response.object(forKey: "message")))", duration: 3.0, position: .bottom)

                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                        
                        let JobDashBoardVC = storyBoard.instantiateViewController(withIdentifier: "JobDashBoardVC") as! JobDashBoardVC
                        
                        self.navigationController?.pushViewController(JobDashBoardVC, animated: true)
                        
                        */
                        
                        
                        let keys = loginDict.allKeys.filter({loginDict[$0] is NSNull})
                        
                        print(keys)
                        
                        for key in keys {
                            
                            loginDict.setValue("", forKey: key as! String)

                            //loginDict.removeObject(forKey:key)
                        }
                        
                        
                        var phoneNo = String()
                        
                        var strEmpty = String()

                        strEmpty = ""

                        phoneNo = ""
                        
                        strEmpty = (loginDict.object(forKey: "exp_years")!) as! String
                        
                        if (loginDict.object(forKey: "phone")) != nil
                        {
                            phoneNo = loginDict.object(forKey: "phone") as! String
                        }
                        
                        print(loginDict)
                        
                        print("strEmpty",strEmpty.characters.count)

                        
                        
                        if phoneNo.characters.count == 0
                        {
                            
                            
                            let JobSignUpSocialVCObj = self.storyboard?.instantiateViewController(withIdentifier: "JobSignUpSocialVC") as! JobSignUpSocialVC
                            JobSignUpSocialVCObj.userDict = loginDict
                            self.navigationController?.pushViewController(JobSignUpSocialVCObj, animated: true)
                            
                        }
                        else if strEmpty == "0.00"

                        {
                           
                            
                            let JobSelectCatagoryVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectCatagoryVC") as! JobSelectCatagoryVC
                            JobSelectCatagoryVC.userDic = loginDict
                            self.navigationController?.pushViewController(JobSelectCatagoryVC, animated: true)
                            
                        }
                        else
                        {
                            
                            UserDefaults.standard.removeObject(forKey: kUserLoginDict)
                            
                            UserDefaults.standard.set(loginDict, forKey: kUserLoginDict)
                            
                            appdel.loginUserDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
                            
                            
                            if appdel.deviceLanguage == "pt-BR"
                            {
                                
                                self.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "userId")!)", userType: "2",message: "\(Response.object(forKey: "message") as! String)")
                            }
                            else
                            {
                                self.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "userId")!)", userType: "2",message: "\(Response.object(forKey: "message") as! String)")
                            }
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
                    
                    //self.view.makeToast(message, duration: 1.0, position: .bottom)

                    let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                    
                    let JobDashVC = storyBoard.instantiateViewController(withIdentifier: "JobDash") as! JobDash
                    let navigationController = SlideNavigationController(rootViewController: JobDashVC)
                    JobDashVC.toastLoginMessage = message
                    JobDashVC.toastLogin = true
                    let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuJobSeeker") as! LeftMenuJobSeeker
                    SlideNavigationController.sharedInstance().leftMenu = leftview
                    SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
                     navigationController.navigationBar.isHidden = true
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }
    

    
    // MARK: - Class Method -

    // Facebook GetUserInfo Method
    func getUserrInfo(completion: @escaping (_: [String: Any]?, _ : Error?) -> Void){
        
        SwiftLoader.show(animated: true)
        
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture"])
   
        SwiftLoader.hide()
        
        if (req.parameters?.isEmpty)!
        {
            print ("API will not called")
        }
        else
        {

            req.start {response , result in
                switch result{
                case .failed(let error):
                    completion(nil, error)
                case .success(let graphResponse):
                    completion(graphResponse.dictionaryValue, nil)
                    print(graphResponse)
                    print("graphResponse.dictionaryValue",graphResponse.dictionaryValue)
                    let DictImg = graphResponse.dictionaryValue! as NSDictionary
                    print("DictImg",DictImg)
                    
                    let dictImgUrl = DictImg.object(forKey: "picture") as! NSDictionary
                    
                    print("dictImgUrl",dictImgUrl)
                    
                    let url = dictImgUrl.object(forKey: "data") as! NSDictionary
                    
                    print(url)
                }
            }
            
        }
//        req.start {response , result in
//            switch result{
//            case .failed(let error):
//                completion(nil, error)
//            case .success(let graphResponse):
//                completion(graphResponse.dictionaryValue, nil)
//                print(graphResponse)
//                print("graphResponse.dictionaryValue",graphResponse.dictionaryValue)
//                let DictImg = graphResponse.dictionaryValue! as NSDictionary
//                print("DictImg",DictImg)
//                
//                let dictImgUrl = DictImg.object(forKey: "picture") as! NSDictionary
//                
//                print("dictImgUrl",dictImgUrl)
//                
//                let url = dictImgUrl.object(forKey: "data") as! NSDictionary
//                
//                print(url)
//                
//                
//            }
//        }
        
    }
    
    // MARK: Label setup
    
    func labelBlankSetup()
    {
        lblValidateEmail.text = ""
        lblValidatePassword.text = ""
        
    }
    
    // MARK: TextField Email Validation Method
    
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
