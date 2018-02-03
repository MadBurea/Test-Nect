//
//  LastDetailsVC.swift
//  PeopleNect
//
//  Created by Apple on 13/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader
import Alamofire




class Employeer_Cell: UITableViewCell
{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
}

class LastDetailsVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UserChosePhoto,UITableViewDataSource, UITableViewDelegate ,SlideNavigationControllerDelegate{

    @IBOutlet var btnprofilePic: UIButton!
    @IBOutlet var btnEditProfilePic: UIButton!
    @IBOutlet var lblLastDetails: UILabel!
    @IBOutlet var txtExpYears: JVFloatLabeledTextField!
    @IBOutlet var txtHourly: JVFloatLabeledTextField!
    @IBOutlet var lblMinSyggestedRate: UILabel!
    @IBOutlet var tfDescibeYourProfile: JVFloatLabeledTextView!
    @IBOutlet var btnFinish: UIButton!
    @IBOutlet var lblMaxTextLimit: UILabel!
    
    @IBOutlet var lblValidExpYears: UILabel!
    @IBOutlet var lblValidHourly: UILabel!
    
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var viewBtnFinish: UIView!
    
    @IBOutlet weak var tblEmp: UITableView!
    
    @IBOutlet weak var hightEmpTableConstraint: NSLayoutConstraint!
    //Last Employer -- 155, 82, 16
    @IBOutlet weak var lblLastEmployers: UILabel!
    
    @IBOutlet weak var btnAddLastEmployer: UIButton!
    
    
    var arrSubCategoryId = NSMutableArray()
    
    var categoryId = ""

    var imageFBPic = NSData()
    
    var arrLastEmp = NSMutableArray()
    var userInfoDict = NSMutableDictionary()
    var userDic = NSMutableDictionary()

    var global = WebServicesClass()
   // var LastEmp = String()
    
    // var text = String()
    
    var alertMessage = AlertMessageVC()
    var backJobSelectExpertices = JobSelectExpertisesVC()
    
    var imgCommonProfilePIC = UIImage()

    
   // var arrLast = NSMutableArray() as! String
    
    
    //MARK: - View life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        
        tfDescibeYourProfile.placeholder = Localization(string: "Describe your profile")
        lblLastEmployers.isHidden = true
        
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        backJobSelectExpertices = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectExpertisesVC") as! JobSelectExpertisesVC

        self.labelBlankSetup()
        self.hightEmpTableConstraint.constant = 0
        
        let attrs : [String: Any] = [
            NSFontAttributeName : UIFont(name: "Montserrat-Regular", size: 14)!,
            NSForegroundColorAttributeName : UIColor.darkGray,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        
        let boldString = NSMutableAttributedString(string: Localization(string: "Last Employer"), attributes:attrs)
        btnAddLastEmployer.setAttributedTitle(boldString, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.textFieldSetUp()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.textFieldSetUp()
        
        btnprofilePic.setImage(ImgJobSeekerProfilepic, for: .normal)

        btnprofilePic.layer.cornerRadius = btnprofilePic.bounds.size.width/2
        btnprofilePic.clipsToBounds = true
        btnprofilePic.layer.borderWidth = 1
        btnprofilePic.layer.borderColor = ColorProfilePicBorder.cgColor

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    // MARK: - UIView Actoins -

    @IBAction func clickSelectProfile(_ sender: Any) {
        
                   let jobSelectProfilrPicVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        
                    jobSelectProfilrPicVC.delegate = self
        
                    navigationController?.pushViewController(jobSelectProfilrPicVC, animated: true)
        
    }
    
    @IBAction func clickFinish(_ sender: Any) {
        
        
        txtHourly.resignFirstResponder()
        txtExpYears.resignFirstResponder()
        
        var isApiCall = Bool()
        
        isApiCall = true
        
        if (txtHourly.text?.isBlank)!
        {
            lblValidHourly.text = strHourlyEmpty
            isApiCall = false
            
        }
        else
        {
            lblValidHourly.text = ""
        }
        
        if (txtExpYears.text?.isBlank)!
        {
            lblValidExpYears.text = strExpYearsEmpty
            isApiCall = false
        }
        else
        {
            lblValidExpYears.text = ""
        }
        
        if btnprofilePic.imageView?.image == nil
        {
            
            self.view.makeToast(Localization(string: "Please Select an Image"), duration: 3.0, position: .bottom)
            isApiCall = false
        }

        if isApiCall == true
        {
            self.saveUserDetailsApi()

        }

    }
    
    
    @IBAction func AddEmployer(_ sender: Any) {
        
        if arrLastEmp.count == 3 {
            btnAddLastEmployer.isEnabled = false
        }
        else
        {
            btnAddLastEmployer.isEnabled = true
            self.alrtAddEmployer()
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
        
        if textField == txtExpYears
        {
            lblValidExpYears.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }

        }
        
        if textField == txtHourly {
            
            lblValidHourly.text = ""
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
        
        
        if textField == txtExpYears
        {
            if (txtExpYears.text?.isBlank)!
            {
                lblValidExpYears.text = strExpYearsEmpty
                
            }
            else
            {
                lblValidExpYears.text = ""
            }
        }
        
        
        if textField == txtHourly
        {
            if(txtHourly.text?.isBlank)!
            {
                lblValidHourly.text = strHourlyEmpty
            }
            else
            {
                lblValidHourly.text = ""
            }
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtExpYears == textField
        {
            txtExpYears.resignFirstResponder()
            txtHourly.becomeFirstResponder()
            
        }
        else if txtHourly == textField
        {
            txtHourly.resignFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        
        return true
    }
    
    
    //MARK: - UITextView Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == tfDescibeYourProfile{
            
            
            if (tfDescibeYourProfile.text?.characters.count)! > 500
            {
                return false
            }
            
            if tfDescibeYourProfile.text.characters.count > 0
            {
                let count = 500 - tfDescibeYourProfile.text.characters.count
                lblMaxTextLimit.text = "\(count)"
            }
            
        }
        
        return true
    }
    
    // MARK: - UITableView Methods -
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrLastEmp.count;
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let tablecell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Employeer_Cell
        
        tablecell.lblName.text = arrLastEmp.object(at: indexPath.row) as! String

        tablecell.btnRemove.tag = indexPath.row
        
        tablecell.btnRemove .addTarget(self, action: #selector(removeEmpExp(sender:)), for: .touchUpInside)
        
        return tablecell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}

    
    
    // MARK: - Class Method
    
    
    func alrtAddEmployer() {
        
        //last employer
     
        
        let alert = UIAlertController(title: Localization(string: Localization(string: "Add Employer")), message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = Localization(string: "Enter Your Last Employer")
            alert.addAction(UIAlertAction(title:Localization(string: "Add"), style: .default, handler: { [weak alert] (_) in
                
                if(textField.text?.characters.count != 0)
                {
                    self.lblLastEmployers.isHidden = false
                    self.arrLastEmp.add(textField.text!)
                    
                    self.setUpTableView()
                }
            }))
            
        }
        
        alert.addAction(UIAlertAction(title:  Localization(string: "CANCEL"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
           }
    
    
    func setUpTableView()
    {
        if(self.arrLastEmp.count == 0)
        {
            self.hightEmpTableConstraint.constant = 0
             lblLastEmployers.isHidden = true
        }
        else
        {
            self.hightEmpTableConstraint.constant = CGFloat(arrLastEmp.count * 35)
        }
        
        tblEmp.reloadData()
    }
    
    @IBAction func removeEmpExp(sender :UIButton)
    {
        let buttonrow = sender.tag
        
        var tempArray = NSMutableArray()
            tempArray = arrLastEmp.mutableCopy() as! NSMutableArray

        tempArray.removeObject(at: buttonrow)
        
        arrLastEmp = tempArray.mutableCopy() as! NSMutableArray
        
        
        if arrLastEmp.count == 3 {
            btnAddLastEmployer.isEnabled = false
        }
        else
        {
            btnAddLastEmployer.isEnabled = true
        }
        
        
        setUpTableView()
        
        
    }
    
    
    func labelBlankSetup()
    {
        lblValidExpYears.text = ""
        lblValidHourly.text = ""
        
    }
    
    // TextField setup
    
    func textFieldSetUp()
    {
        txtExpYears.underlined()
        txtHourly.underlined()
        
    }
    
    
    func userHasChosen(image: UIImage){
        
        if image.isEqual(nil){
        }
        else{
            
            btnprofilePic.setImage(image, for: .normal)
            
            ImgJobSeekerProfilepic = image

        }
    }

    
    // MARK: - Api Call
    
    func saveUserDetailsApi()
    {
        SwiftLoader.show(animated: true)
        
        /*
         /         //            "categoryId": "108",
         //         //            "description": "description text",
         //         //            "experience": "2",
         //         //            "lastEmployer": ["last employer","aaa"],
         //         //            "profilePic": profile pic as multipart,
         //         //            "rate": "28",
         //         //            "subCategoryId": "102,100,104,88",
         //         //            "userId": "77",
         //         //            "language": "en",
         //         //            "methodName": "saveUserDetails"
         //
         
         */
        
       
        
        let subCatagoryIDs = arrSubCategoryId.componentsJoined(by: ",")
        
        let lastEmpStr = arrLastEmp.componentsJoined(by: ",") as! String
        
        print("lastEmpStr",lastEmpStr)
        
        print("categoryId",categoryId)

        
        let param =  [WebServicesClass.METHOD_NAME: "saveUserDetails",
                      "categoryId":categoryId,
            "description":"\((tfDescibeYourProfile.text)!)",
            "experience":"\((txtExpYears.text)!)",
            "lastEmployer":arrLastEmp,
            "rate":"\((txtHourly.text)!)",
            "subCategoryId":"\(subCatagoryIDs)",
            "userId":"\(userDic.object(forKey: "userId")!)",
            "language":appdel.userLanguage,
            "profilePic":""] as [String : Any]
        
        print("param",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {                SwiftLoader.hide()

                print("Error",error?.description as String!)
            }
            else
            {
                
                let dict = Response as! NSDictionary
                
                print(dict)
                
                let status = dict.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                    
                    if let dataDict = (dict as AnyObject).object(forKey: "data") as? NSDictionary
                    {
                        // Set Use Default
                        UserDefaults.standard.removeObject(forKey: kUserLoginDict)
                        
                        for (key, value) in dataDict {
                            self.userDic[String(describing: key)] = String(describing: value)
                        }
                        
                        print("self.userDic",self.userDic)
                        
                        UserDefaults.standard.set(self.userDic, forKey: kUserLoginDict)
                        appdel.loginUserDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
                        
                        print("dataDict is",dataDict)
                        print("appdel.loginUserDict",appdel.loginUserDict)
                        
                        self.UpdateDeviceToken(userId: "\(appdel.loginUserDict.object(forKey: "userId")!)", userType: "2")
                    }
                    else
                    {
                        
                        if appdel.deviceLanguage == "pt-BR"
                        {
                            self.alertMessage.strMessage = "\((dict as AnyObject).object(forKey: "pt_message")!)"
                        }
                        else
                        {
                            self.alertMessage.strMessage = "\((dict as AnyObject).object(forKey: "message")!)"
                        }
                        
                        self.alertMessage.modalPresentationStyle = .overCurrentContext
                        self.present((self.alertMessage), animated: false, completion: nil)
                        
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
        //  }
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
                    self.UploadImage(image: ImgJobSeekerProfilepic, userID: userId,isEmployer:false)

                    let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                    
                    let JobDashVC = storyBoard.instantiateViewController(withIdentifier: "JobDash") as! JobDash
                    JobDashVC.fromLastDetail = true
                    let navigationController = SlideNavigationController(rootViewController: JobDashVC)
                    let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuJobSeeker") as! LeftMenuJobSeeker
                    SlideNavigationController.sharedInstance().leftMenu = leftview
                    SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
                     navigationController.navigationBar.isHidden = true
                    //self.present(navigationController, animated: true, completion: nil)
                    
                    appdel.window!.rootViewController = navigationController
                    
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
