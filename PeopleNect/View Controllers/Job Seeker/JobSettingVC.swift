//
//  JobSettingVC.swift
//  PeopleNect
//
//  Created by Apple on 03/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader

class Employeer_Cell1: UITableViewCell
{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
}



class JobSettingVC: UIViewController, PlaceSearchTextFieldDelegate, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource,UITextViewDelegate, UserChosePhoto {
   
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
    @IBOutlet var txtPassword: JVFloatLabeledTextField!
    @IBOutlet var txtBusiness: JVFloatLabeledTextField!
    @IBOutlet var txtSubCategory: JVFloatLabeledTextField!
    @IBOutlet var txtExperiance: JVFloatLabeledTextField!
    @IBOutlet var txtRate: JVFloatLabeledTextField!
    @IBOutlet var tfDescribeYourProfile: JVFloatLabeledTextView!
    
    @IBOutlet var lblMaxNumber: UILabel!
    
    @IBOutlet var lblLastEmployers: UILabel!
    
    @IBOutlet var txtAddress: MVPlaceSearchTextField!
    @IBOutlet var bynLastEmployer: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnProfilePic: UIButton!
    
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
    @IBOutlet var lblValidatePassword: UILabel!
    @IBOutlet var lblValidateBusiness: UILabel!
    @IBOutlet var lblValideSubCategory: UILabel!
    @IBOutlet var lblValideexperiance: UILabel!
    @IBOutlet var lblValideRate: UILabel!
    @IBOutlet var tfBusiness: JVFloatLabeledTextView!
    
    @IBOutlet weak var lblBussiness: UILabel!
    @IBOutlet weak var lblSubcategory: UILabel!
    @IBOutlet var lblPlaceholderBusiness: UILabel!
    
    @IBOutlet var tblLastEmploter: UITableView!
    @IBOutlet var constrainHe3ightTblLastEmp: NSLayoutConstraint!
    @IBOutlet weak var btnEditExperiance: UIButton!
    @IBOutlet weak var btnEditRate: UIButton!
    
    @IBOutlet var constrainHeightChangePassword: NSLayoutConstraint!
    
    var imageFBPic = Data()
    
    var arrnameSubCategory = NSMutableArray()
    var nameSubCategory = String()
    var nameCategory = String()
    var IdCategory = String()

    @IBOutlet var btnChangePassword: UIButton!
    
    
    var global = WebServicesClass()
    
    let apiURL = "https://maps.googleapis.com/maps/api/geocode/json"
    let apiKey = "AIzaSyBZV6Rtb7qIizc1yrGKbYQ1M"

    var alertMessage = AlertMessageVC()
    var arrLastEmp = NSArray()
    var arrNonLastEmp = NSMutableArray()
    @IBOutlet weak var viewTop: UIView!
    
    var lat = ""
    var lng = ""

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.txtPassword.text = "123456"
        self.txtPassword.isSecureTextEntry = true
        self.txtPassword.textColor = UIColor.lightGray
        
        if nameCategory != ""
        {
            lblBussiness.text = nameCategory
        }
        
        self.getUserDetailsApi()
        self.labelBlankSetup()
        
        tblLastEmploter.delegate = self
        tblLastEmploter.dataSource = self
        lblLastEmployers.isHidden = true
        
        self.constrainHe3ightTblLastEmp.constant = 0

        //lblPlaceholderBusiness.isHidden = false
       // self.lblPlaceholderBusiness.text = "Business"
        
        txtRate.isUserInteractionEnabled = false
        txtExperiance.isUserInteractionEnabled = false
        txtPassword.isUserInteractionEnabled = false
        //tfBusiness.isUserInteractionEnabled = false
       // txtSubCategory.isUserInteractionEnabled = false
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateCategorySel), name: NSNotification.Name(rawValue: "UpdateCategorySel"), object: nil)

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if imageIsNull(imageName: ImgJobSeekerProfilepic ){
            self.setImageForJobSeeker(btnProfilePic:btnProfilePic)
        }else{
            btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
        }
        
        //  self.btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
        
        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2
        btnProfilePic.clipsToBounds = true
        btnProfilePic.layer.borderWidth = 1
        btnProfilePic.layer.borderColor = ColorProfilePicBorder.cgColor
        
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
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - UIView Actoins -

    
    @IBAction func clickAddEmployer(_ sender: Any) {
        
    }
    
    @IBAction func clickSave(_ sender: Any) {
        
        self.updateUserDetails()
        
    }
    
    
    @IBAction func clickProfilePicture(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let JobSelectProfilrPicVC = storyBoard.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        
        JobSelectProfilrPicVC.delegate = self
         appdel.isFromRegister = true

        self.navigationController?.pushViewController(JobSelectProfilrPicVC, animated: true)
    }
    
    @IBAction func clickChangePassword(_ sender: Any) {
        
        self.txtPassword.text = ""
        self.txtPassword.becomeFirstResponder()
        self.txtPassword.textColor = UIColor.black
        
        self.txtPassword.isUserInteractionEnabled = true
        
      //  txtPassword.text = txtPassword.placeholder
        
    }
    
    @IBAction func clickEditExpertices(_ sender: Any) {
        
        txtExperiance.isUserInteractionEnabled = true
        print("txtExperiance.placeholder",txtExperiance.placeholder!)

//        if txtExperiance.placeholder != "Experience"
//        {
//            txtExperiance.text = txtExperiance.placeholder
//
//        }
        
        
        txtExperiance.textColor = UIColor.black
        
        txtExperiance.placeholder = "Experience"
        txtExperiance.becomeFirstResponder()
        
       // self.btnEditExperiance.isUserInteractionEnabled = false

    }
    
    @IBAction func clickEditBusiness(_ sender: Any) {
        
       // self.tfBusiness.placeholder = "Business"
      //  tfBusiness.isUserInteractionEnabled = true
        
        let jobSettingSelectCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSettingSelectCategoryVC") as! JobSettingSelectCategoryVC
        
        navigationController?.pushViewController(jobSettingSelectCategoryVC, animated: true)

    }
    
    @IBAction func clickEditRate(_ sender: Any) {
        
        txtRate.isUserInteractionEnabled = true
        print("txtRate.placeholder",txtRate.placeholder!)
        //txtRate.text = txtRate.placeholder
        
        
        
//        if txtRate.placeholder != "Rate"
//        {
//            txtRate.text = txtExperiance.placeholder
//            
//        }
        
        txtRate.textColor = UIColor.black

        txtRate.placeholder = "Rate"
        txtRate.becomeFirstResponder()
        
       // self.btnEditRate.isUserInteractionEnabled = fals
    }
    
    
    @IBAction func AddEmployer(_ sender: Any) {
        
        if arrLastEmp.count == 3 {
            bynLastEmployer.isEnabled = false
            bynLastEmployer.isHidden = true
        }
        else
        {
            bynLastEmployer.isEnabled = true
            bynLastEmployer.isHidden = false
            self.alrtAddEmployer()
        }
        
        
    }

    
    @IBAction func clickNext(_ sender: Any) {
        
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)

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
            
        else if textField == txtCountryCode
        {
            
            lblValidateCountryCode.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
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
            
        else if textField == txtExperiance
        {
            lblValideexperiance.text = ""
            if  (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
            
        }

        else if textField == txtRate
        {
            lblValideRate.text = ""
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
                lblValidateName.text = strNameEmpty
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
                lblValidateSurname.text = strSurnameEmpty
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
                lblValidateEmail.text = strEmailEmpty
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
                lblValidateCountryCode.text = strCountryCodeEmpty
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
                lblValidatePhoneNo.text = strMobileEmpty
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
        
        if textField == txtPassword
        {
            if(txtPassword.text?.isBlank)!
            {
                lblValidatePassword.text = strPasswordEmpty
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
        
        if textField == txtCity
        {
            if (txtCity.text?.isBlank)!
            {
                lblValidateCity.text = strCityEmpty
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
                lblValidateState.text = strStateEmpty
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
                lblValidateNumber.text = strNumberEmpty
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
                lblValidateCountry.text = strCountryEmpty
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
                lblValidateZipCode.text = strZipcodeEmpty
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
                lblValidateComplement.text = strComplementEmpty
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
                lblValidateStreetName.text = strStreetEmpty
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
                lblValidateStartTypingAdd.text = strAddressEmpty
            }
            else
            {
                lblValidateStartTypingAdd.text = ""
            }
        }
        if textField == txtExperiance
        {
            if (txtExperiance.text?.isBlank)!
            {
                lblValideexperiance.text = strExperanceEmpty
            }
            else
            {
                lblValideexperiance.text = ""
            }
        }
        if textField == txtRate
        {
            if (txtRate.text?.isBlank)!
            {
                lblValideRate.text = strRateEmpty
            }
            else
            {
                lblValideRate.text = ""
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
            txtPassword.becomeFirstResponder()
        }
            
        else if txtCountry == textField
        {
            txtCountry.resignFirstResponder()
           // tfBusiness.becomeFirstResponder()
        }
//        else if tfBusiness == textField
//        {
//            tfBusiness.resignFirstResponder()
//            txtSubCategory.becomeFirstResponder()
//        }
//        else if txtSubCategory == textField
//        {
//            txtSubCategory.resignFirstResponder()
//            txtExperiance.becomeFirstResponder()
//        }
        else if txtExperiance == textField
        {
            txtExperiance.resignFirstResponder()
            txtRate.becomeFirstResponder()
        }
        else if txtRate == textField
        {
            txtRate.resignFirstResponder()
            tfDescribeYourProfile.becomeFirstResponder()
        }
        else if tfDescribeYourProfile == textField
        {
            tfDescribeYourProfile.resignFirstResponder()
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
    
    
    // UITextView Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == tfDescribeYourProfile{
            
            
            if (tfDescribeYourProfile.text?.characters.count)! > 500
            {
                return false
            }
            
            if tfDescribeYourProfile.text.characters.count > 0
            {
                let count = 500 - tfDescribeYourProfile.text.characters.count
                lblMaxNumber.text = "\(count)"
            }
            
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
        
        self.lat = "\(responseDict.coordinate.latitude)"
        self.lng = "\(responseDict.coordinate.longitude)"
        
        
        print("selected lat lng is",self.lat,self.lng)
        
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
    
    // MARK: - UITableView Methods -
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        print("arrLastEmp.count",arrLastEmp.count)
        return arrLastEmp.count;
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let tablecell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Employeer_Cell1
        
        let str = arrLastEmp.object(at: indexPath.row) as? String
    
        //arrLastEmp
        //arrNonLastEmp
        tablecell.lblName.text = arrLastEmp.object(at: indexPath.row) as? String
        
        tablecell.btnRemove.tag = indexPath.row
        
        tablecell.btnRemove .addTarget(self, action: #selector(removeEmpExp(sender:)), for: .touchUpInside)
        
      //  tablecell.backgroundColor = UIColor.green
        
        return tablecell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    
    }


    
    
    // MARK: - Class Method
    
    
    
    func alrtAddEmployer() {
        
        let alert = UIAlertController(title: "Add Employer", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Your Last Employer"
            
            alert.addAction(UIAlertAction(title: "ADD", style: .default, handler: { [weak alert] (_) in
                
                if(textField.text?.characters.count != 0)
                {
                    self.lblLastEmployers.isHidden = false
                
                    self.arrLastEmp.adding((textField.text! as Any))
                    
                    self.arrNonLastEmp = ((self.arrLastEmp as NSArray).mutableCopy()) as! NSMutableArray
                    
                    self.arrNonLastEmp.add(textField.text!)
                    
                    self.arrLastEmp = self.arrNonLastEmp
                    
                    self.setUpTableView()
                }
            }))
            
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setUpTableView()
    {
        if(self.arrLastEmp.count == 0)
        {
            self.constrainHe3ightTblLastEmp.constant = 0
            lblLastEmployers.isHidden = true
        }
        else
        {
            self.constrainHe3ightTblLastEmp.constant = CGFloat(arrLastEmp.count * 35)
            //h
            lblLastEmployers.isHidden = false

        }
        
        if arrLastEmp.count == 3 {
            bynLastEmployer.isEnabled = false
            bynLastEmployer.isHidden = true
        }
        else
        {
            bynLastEmployer.isEnabled = true
            bynLastEmployer.isHidden = false
        }
        
        tblLastEmploter.delegate = self
        tblLastEmploter.dataSource = self
        tblLastEmploter.reloadData()
    }
    
    @IBAction func removeEmpExp(sender :UIButton)
    {
        let buttonrow = sender.tag
        
        var tempArray = NSMutableArray()
        tempArray = arrLastEmp.mutableCopy() as! NSMutableArray
        
        tempArray.removeObject(at: buttonrow)
        
        arrLastEmp = tempArray.mutableCopy() as! NSMutableArray
        
        
        if arrLastEmp.count == 3 {
            bynLastEmployer.isEnabled = false
            bynLastEmployer.isHidden = true
        }
        else
        {
            bynLastEmployer.isEnabled = true
            bynLastEmployer.isHidden = false

        }
        
        
        setUpTableView()
        
        
    }

    
    
    
    func labelBlankSetup()
    {
        lblValidateEmail.text = ""
        lblValidatePassword.text = ""
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
        lblValidateBusiness.text = ""
        lblValideSubCategory.text = ""
        lblValideexperiance.text = ""
        lblValideRate.text = ""


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
        txtExperiance.underlined()
        txtRate.underlined()
        txtPassword.underlined()
        
    }
    
    //  TextField Email Validation Method
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func userHasChosen(image: UIImage){
        
        if image.isEqual(nil){
            print("Choose An Image!")
        }
        else{
            btnProfilePic.setImage(image, for: .normal)
            ImgJobSeekerProfilepic = image
        }
    }

    func UpdateCategorySel(notification: NSNotification)
    {
       // print(notification.userInfo!)
    
        let dict = notification.object as! NSDictionary
        let receivedNameofCat = dict["catName"]
        let receivedCatId = dict["catId"]
        let receivedSubCatArray = dict["subCatArray"]
        let receivedSubCatName = dict["subCatName"] as! NSMutableArray

        print(receivedNameofCat as! String)
        print(receivedCatId as! String)
        
        nameCategory = receivedNameofCat as! String
         IdCategory = receivedCatId as! String
        arrnameSubCategory = receivedSubCatArray as! NSMutableArray
        
        lblSubcategory.text = receivedSubCatName.componentsJoined(by: ",")
        lblBussiness.text = nameCategory
        print("category nameCategory is",nameCategory)
        print("category id is",IdCategory)
        print("category arrnameSubCategory is",arrnameSubCategory)
     }
    
 

    // MARK: - Api Call
    
    func getUserDetailsApi()
    {
        SwiftLoader.show(animated: true)
        
        /*
         "userId": "77",
         "language": "en",
         "methodName": "userDetails"
         
         */
        
        
        
        let param =  [WebServicesClass.METHOD_NAME: "userDetails",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
                      "language":"en"] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            if error != nil {

                print("ErrorGetUserInfo:",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                print("ResponseGetUserInfo",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                   // self.view.makeToast("Details", duration: 3.0, position: .bottom)

                    if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary
                    {
                        
                        print("dataDict is",dataDict)
                        
                        self.IdCategory = "\(dataDict.object(forKey: "category_id")!)"
                        
                        let subcategoryId = "\(dataDict.object(forKey: "sub_category_id")!)"
                        let array = subcategoryId.components(separatedBy: ",") as NSArray

                        self.arrnameSubCategory = array.mutableCopy() as! NSMutableArray
                        self.txtName.text = "\(dataDict.object(forKey: "first_name")!)"
                        self.txtZipCode.text = "\(dataDict.object(forKey: "zipcode")!)"
                        self.txtSurname.text = "\(dataDict.object(forKey: "last_name")!)"
                        self.txtPhoneNo.text = "\(dataDict.object(forKey: "phone")!)"
                        self.txtCountry.text = "\(dataDict.object(forKey: "country")!)"
                        
                        self.txtNumber.text = "\(dataDict.object(forKey: "number")!)"
                        self.txtState.text = "\(dataDict.object(forKey: "state")!)"
                        self.txtEmail.text = "\(dataDict.object(forKey: "email")!)"
                        
                        
                        self.lat = "\(dataDict.object(forKey: "lat")!)"
                        self.lng = "\(dataDict.object(forKey: "lng")!)"

                        
                        self.txtRate.placeholder = "Rate"
                        
                        self.txtRate.textColor = UIColor.lightGray
                        
                        self.txtRate.text = "\(dataDict.object(forKey: "hourly_compensation")!)"
                        
                        self.txtCity.text = "\(dataDict.object(forKey: "city")!)"
                        
                        
                        self.lblBussiness.text = "\(dataDict.object(forKey: "category_name")!)"
                        
                         self.lblSubcategory.text = "\(dataDict.object(forKey: "sub_category_name")!)"
                       
                        self.txtComplement.text = "\(dataDict.object(forKey: "complement")!)"
                        
                        self.txtExperiance.placeholder = "Experience"
                        self.txtExperiance.text = "\(dataDict.object(forKey: "exp_years")!)"
                        self.txtExperiance.textColor = UIColor.lightGray

                        
                        self.txtStreetName.text = "\(dataDict.object(forKey: "streetName")!)"
                        
                        self.txtCountryCode.text = "\(dataDict.object(forKey: "country_code")!)"
                        
                        self.tfDescribeYourProfile.text = "\(dataDict.object(forKey: "profile_description")!)"
                        
                        if self.tfDescribeYourProfile.text.characters.count > 0
                        {
                            let count = 500 - self.tfDescribeYourProfile.text.characters.count
                            self.lblMaxNumber.text = "\(count)"
                        }
                        
                        self.arrLastEmp = (dataDict.object(forKey: "last_employer")! as! NSArray)
                        
                        if self.arrLastEmp.count > 0
                        {
                            self.setUpTableView()

                        }
                    }
                }
                else
                {
                    self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
        }
        
    }
    
    
    func updateUserDetails()
    {
        SwiftLoader.show(animated: true)
        
        /*
         "categoryId": "108",
         "city": "Ahmedabad",
         "complement": "Near sola",
         "country": "India",
         "country_code": "+1",
         "description": "description text",
         "email": "johnsmith@gmail.com",
         "experience": "2.00",
         "firstName": "John",
         "lastEmployer": [
         "last employer"
         ],
         "lastName": "Smith",
         "lat": 23.0498393,
         "lng": 72.51730529999999,
         "number": "25",
         "password": "",
         "phone": "12 3456-7890",
         "profile_pic": "",
         "rate": "28.00",
         "state": "Gujarat",
         "streetName": "Sarkhej - Gandhinagar Highway",
         "subCategoryId": "102,100,104,88",
         "userId": "77",
         "zipcode": "380054",
         "language": "en",
         "methodName": "updateUserDetails"
          */
        
        
        
        let strArrSubCatId = self.arrnameSubCategory.componentsJoined(by: ",")
        
        
        let param =  [WebServicesClass.METHOD_NAME: "updateUserDetails",
            "categoryId":IdCategory,
            "city":"\(txtCity.text!)",
            "complement":"\(txtComplement.text!)",
            "country":"\(txtCountry.text!)",
            "country_code":"\(txtCountryCode.text!)",
            "description": "\(tfDescribeYourProfile.text!)",
            "email": "\(txtEmail.text!)",
            "experience": "\(txtExperiance.text!)",
            "firstName": "\(txtName.text!)",
            "lastEmployer": arrLastEmp,
            "lastName": "\(txtSurname.text!)",
            "lat": self.lat,
            "lng": self.lng,
            "number": "\(txtNumber.text!)",
            "password": "\(txtPassword.text!)",
            "phone": "\(txtPhoneNo.text!)",
            "profile_pic": "",
            "rate": "\(txtRate.text!)",
            "state": "\(txtState.text!)",
            "streetName": "\(txtStreetName.text!)",
            "subCategoryId": strArrSubCatId,
            "userId": "\(appdel.loginUserDict.object(forKey: "userId")!)",
            "zipcode": "\(txtZipCode.text!)",
            "language": "en"
            ] as [String : Any]
        
        print("param",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
        
            SwiftLoader.hide()
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
    
                let userID = "\(appdel.loginUserDict.object(forKey: "userId")!)"
       
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
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
                        }
                        
                        UserDefaults.standard.removeObject(forKey: kUserLoginDict)
                        
                        UserDefaults.standard.set(loginDict, forKey: kUserLoginDict)
                        appdel.loginUserDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
                        
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                        let JobDashVC = storyBoard.instantiateViewController(withIdentifier: "JobDash") as! JobDash

                        JobDashVC.SettingDetailUPdated = true
                        self.navigationController?.pushViewController(JobDashVC, animated: true)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeImage"), object: nil)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeImageFromSetting"), object: nil)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateProfileDetail"), object: nil)
                        
                        
                        if self.imageIsNull(imageName: ImgJobSeekerProfilepic ){
                        }else{
                            self.UploadImage(image: self.btnProfilePic.image(for: .normal)!, userID: userID,isEmployer:false)
                        }
                       
                    }
                }
                else
                {
                    self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
                
            }
        }
        
    }

    
    
    func placeApi()
    {
        
        SwiftLoader.show(animated: true)
        //print("Load pois")
        
        let uri = apiURL + "?address=\(txtAddress.text)&key=\(apiKey)"
        
        let url = URL(string: uri)
        let session = URLSession(configuration: URLSessionConfiguration.default)
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
    
    
    
    @IBAction func clickBAck(_ sender: Any) {
        
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)

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
