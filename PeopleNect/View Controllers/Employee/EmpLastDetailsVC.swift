//
//  EmpLastDetailsVC.swift
//  PeopleNect
//
//  Created by InexTure on 21/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftLoader
import Toast_Swift
import Cosmos
import Alamofire

class EmpLastDetailsVC: UIViewController,PlaceSearchTextFieldDelegate, UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate{

    @IBOutlet weak var btnProfilePic: UIButton!
    
    @IBOutlet weak var lblLastDetails: UILabel!
    @IBOutlet weak var txtJobTitle: JVFloatLabeledTextField!
    @IBOutlet weak var lblValidJobTitle: UILabel!
    
    @IBOutlet weak var tfJobDescription: JVFloatLabeledTextView!
    @IBOutlet weak var lblValidJobDescription: UILabel!
    
    @IBOutlet weak var lblValidationEndTime: UILabel!
    @IBOutlet weak var lblValidationStartTime: UILabel!
    @IBOutlet weak var lblValidationEndDate: UILabel!
    @IBOutlet weak var lblValidationStartDate: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var viewNumberOfPos: UIView!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblLineMinus: UIView!
    @IBOutlet weak var lblPositionCount: UILabel!
    @IBOutlet weak var viewLinePlus: UIView!
    
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnNoEndDate: UIButton!
    @IBOutlet weak var lblNoEndDate: UILabel!
    
    @IBOutlet weak var lblPlaceHolderStartDate: UILabel!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnWeekendsInclude: UIButton!
    @IBOutlet weak var lblWeekendIncludes: UILabel!
    
    @IBOutlet weak var topLastDetailConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var inviteEmployeeLbl: UILabel!
    @IBOutlet weak var viewStartDate: UIView!
    @IBOutlet weak var txtStartHour: JVFloatLabeledTextField!
    @IBOutlet weak var txtEndHour: JVFloatLabeledTextField!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var employeeCategory_ExpLbl: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var viewPerDaysHours: UIView!
    @IBOutlet weak var txtPerHourPerDay: JVFloatLabeledTextField!
    @IBOutlet weak var txtRsPerHours: JVFloatLabeledTextField!
    @IBOutlet weak var lblValidateHoursPerDay: UILabel!
    @IBOutlet weak var lblValidateRsPerHour: UILabel!
    

    @IBOutlet weak var lblSelectPayment: UILabel!
    @IBOutlet weak var btnPaymentPerJob: UIButton!
    @IBOutlet weak var btnPaymentPerMonth: UIButton!
    
    @IBOutlet weak var lblTextSameAsCompanyAdd: UILabel!
    
    @IBOutlet weak var txtStartTypingAdd: MVPlaceSearchTextField!
    @IBOutlet weak var lblValidateStartTypingAdd: UILabel!
    
    @IBOutlet weak var txtStreetName: JVFloatLabeledTextField!
    @IBOutlet weak var lblValidateStreet: UILabel!
    
    
    @IBOutlet weak var txtNumber: JVFloatLabeledTextField!
    @IBOutlet weak var lblValidateNumber: UILabel!
    
    @IBOutlet weak var txtCompliment: JVFloatLabeledTextField!
    
    @IBOutlet weak var lblValidateCompliment: UILabel!
    
    @IBOutlet weak var txtCity: JVFloatLabeledTextField!
    
    @IBOutlet weak var lblValidateCity: UILabel!
    @IBOutlet weak var txtZipCode: JVFloatLabeledTextField!
    @IBOutlet weak var lblValidateZipCode: UILabel!
    
    @IBOutlet weak var txtState: JVFloatLabeledTextField!
    @IBOutlet weak var lblValidateState: UILabel!
    
    @IBOutlet weak var txtCountry: JVFloatLabeledTextField!
    @IBOutlet weak var lblValidateCountry: UILabel!
    
    @IBOutlet weak var btnPaymentPerHour: UIButton!
    
    @IBOutlet weak var btnSameAsCompanyDetail: UIButton!
    @IBOutlet weak var viewDiffAddress: UIView!
    @IBOutlet weak var constraintHeightDiffAddress: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewEstimatePayment: UIView!
    
    @IBOutlet weak var lblPaymentRs: UILabel!
    
    @IBOutlet weak var btnFInishPostJob: UIButton!
    
    @IBOutlet weak var viewStartTypingAddress: UIView!
    
    @IBOutlet weak var txtStartDate: JVFloatLabeledTextField!
    
    @IBOutlet weak var txtEndDate: JVFloatLabeledTextField!
    
    @IBOutlet weak var viewEndDate: UIView!
    
    @IBOutlet var imgCheckNoEndDate: UIImageView!
    @IBOutlet var imgCheckWeekend: UIImageView!
    
    @IBOutlet var imgCheckSameAdd: UIImageView!
    
    var totalAmountProject = ""
    var profileImage = UIImage()
    
    //for edit allow
    var FreshJob:Int = 1
    var loadFrmOtherCtr: Int = 0
    var inviteUser: Int = 0
    var selectUserDict = NSDictionary()
    var objEndDatePicker = UIDatePicker()
    var objStartDatePicker = UIDatePicker()
    var objStartHourPicker = UIDatePicker()
    var objEndHourPicker = UIDatePicker()
    
    var dateFormatter = DateFormatter()
    var hourFormatter = DateFormatter()

    var count = Int()
    var diff = Int()
    var hourDay = Int()
    
    var noEndDate = NSInteger()
    var workingDay = NSInteger()
    var sameLocation = NSInteger()
    
    var startDate = NSString()
    var endDate = NSString()
    var fordatePickerStart = NSString()
    var fordatePickerEnd = NSString()
    var totalHourMessage = NSString()
    
    var excludingWeekDay: Int = 0
    var includingWeekDay: Int = 0
    
    var totalhours = Float()
    var totalAmount = Float()
    
    var jobid = String()
    var categoryId = String()
    var subCategoryId = String()
    var alreadyWorked = String()

    var global = WebServicesClass()
    let apiURL = "https://maps.googleapis.com/maps/api/geocode/json"
    let apiKey = "AIzaSyAg5YUbdJukqM_BY7yu_ZN6UOf1MvLH3Zw"
    var alertMessage = AlertMessageVC()
    var totalBalance = NSString()
    var postJobPrice = NSString()
    var postFavBalance = NSString()

    var lat = ""
    var lng = ""
    var todayDate = ""

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let corner = (UIScreen.main.bounds.size.height / 568) * 90
        
        // Today Date 
        
        
         if appdel.loginUserDict["companyaddress"] != nil {
            
            lblTextSameAsCompanyAdd.text = "Same as company address \n \(appdel.loginUserDict.object(forKey: "companyaddress")!)"
            
            if appdel.loginUserDict["zip"] != nil{
                lblTextSameAsCompanyAdd.text = "Same as company address \n \(appdel.loginUserDict.object(forKey: "companyaddress")!) \(appdel.loginUserDict.object(forKey: "zip")!)"
            }
         }else{
             lblTextSameAsCompanyAdd.text = "Same as company address \n \(appdel.loginUserDict.object(forKey: "street_name")!)"
        }
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day,.hour,.minute], from: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        
        
        var countDay = day!/10
        countDay = abs(countDay)
        print("countDay is",countDay)
        
        if countDay == 0 {
            todayDate = "\(year!)-\(month!)-0\(day!)"

        }else{
            todayDate = "\(year!)-\(month!)-\(day!)"
        }
        
        btnProfilePic.layer.cornerRadius = 45
        btnProfilePic.layer.masksToBounds = true
        
        self.txtPerHourPerDay.isUserInteractionEnabled = false
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        self.btnFInishPostJob.setTitle("Finish job Post ✔︎", for: .normal)
        lblLastDetails.text = "Last details"
        if loadFrmOtherCtr == 1
        {
            self.jobDetailbyIdApi()

            if FreshJob == 0
            {
                self.txtAllowForRepost()
            }
            else
            {
                self.btnFInishPostJob.setTitle("Save", for: .normal)
                lblLastDetails.text = "Job details"
            }

        }else {
            self.btnPaymentPerHour.isSelected = true
        }
        
        if inviteUser == 1  && selectUserDict.count > 0{
            employeeName.isHidden = false
            ratingView.isHidden = false
            employeeCategory_ExpLbl.isHidden = false
            inviteEmployeeLbl.isHidden = false
             topLastDetailConstraints.constant = 150
            lblLastDetails.isHidden = true
            print("selectUserDict for invite job is",selectUserDict)
            
            employeeName.text = selectUserDict.value(forKey: "name") as! String?
            employeeCategory_ExpLbl.text = "\(selectUserDict.value(forKey: "categoryName")!)" + " -" + "\(selectUserDict.value(forKey: "exp_years")!)" + " years."
            inviteEmployeeLbl.text = "Invite " + "\(employeeName.text!)" + " to work"
            
            self.ratingView.text = ""
            self.ratingView.rating = Double(selectUserDict.value(forKey: "userRatingCount") as! String)!
            
            let imagUrlString = selectUserDict.object(forKey: "image_url") as! String
            let url = URL(string: imagUrlString)
            let placeHolderImage = "company_profile"
            let placeimage = UIImage(named: placeHolderImage)
            btnProfilePic.sd_setImage(with: url, for: .normal, placeholderImage: placeimage)
            alreadyWorked = "\(selectUserDict.value(forKey: "alreadyWorked")!)"
            
        }else{
            employeeName.isHidden = true
            ratingView.isHidden = true
            employeeCategory_ExpLbl.isHidden = true
            inviteEmployeeLbl.isHidden = true
            topLastDetailConstraints.constant = 25
            lblLastDetails.isHidden = false
            btnProfilePic.setImage(profileImage, for: .normal)
        }
        
        imgCheckSameAdd.isHidden = false
        imgCheckNoEndDate.isHidden = true
        imgCheckWeekend.isHidden = true
        
        self.setupView()
        
        self.constraintHeightDiffAddress.constant = 0
        
        self.viewNumberOfPos.layer.cornerRadius = 20
        
        noEndDate = 0
        
        workingDay = 0
        sameLocation = 1
        
        //self.unarchivingData()
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.dismissView))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        tfJobDescription.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtStartTypingAdd.autoCompleteRegularFontName =  "Montserrat-Bold"
        txtStartTypingAdd.autoCompleteBoldFontName = "Montserrat-Regular"
        txtStartTypingAdd.autoCompleteTableCornerRadius=0.0
        txtStartTypingAdd.autoCompleteRowHeight=35
        txtStartTypingAdd.autoCompleteFontSize=14
        txtStartTypingAdd.autoCompleteTableBorderWidth=1.0
        txtStartTypingAdd.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=true
        txtStartTypingAdd.autoCompleteShouldHideOnSelection=true
        txtStartTypingAdd.autoCompleteShouldHideClosingKeyboard=true
        txtStartTypingAdd.autoCompleteTableFrame = CGRect(x: 16 , y: viewStartTypingAddress.frame.origin.y + txtStartTypingAdd.frame.size.height, width: viewStartTypingAddress.frame.size.width, height: 200)
        
        txtStartTypingAdd.placeSearchDelegate = self
        txtStartTypingAdd.delegate = self
    }
    
    //MARK: - UIView Actoins -

    func dismissView()  {
       self.view.endEditing(true)
    }
    
    @IBAction func clickSameAsCompDetail(_ sender: Any) {
        
        if self.constraintHeightDiffAddress.constant == 0
        {
            self.imgCheckSameAdd.isHidden = true

            self.constraintHeightDiffAddress.constant = 505

        }
        else
        {
        self.constraintHeightDiffAddress.constant = 0
            
            self.imgCheckSameAdd.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickPosMinus(_ sender: Any) {
        if count > 1 {
            count -= 1
            self.lblPositionCount.text = "\(count)"
        }
    }
    
    @IBAction func clickPosPlus(_ sender: Any) {
        
        count += 1
        self.lblPositionCount.text = "\(count)"
    }
    
    @IBAction func clickNoEndDate(_ sender: Any) {
        
        self.btnNoEndDate.isSelected = !self.btnNoEndDate.isSelected
        if self.btnNoEndDate.isSelected
        {
            self.imgCheckNoEndDate.isHidden = false
            print("sel")
            noEndDate = 1
            viewEndDate.isHidden = true
            txtEndDate.isHidden = true
            txtEndDate.text = ""
            self.lblPaymentRs.text = "$0"
        }
        else
        {
            self.imgCheckNoEndDate.isHidden = true
            noEndDate = 0
            print("selNot")
            if (txtEndDate.text?.isEqual("Date"))!
            {
            }
            viewEndDate.isHidden = false
            txtEndDate.isHidden = false
            self.CalculatePrice()
        }
    }
    
    
    @IBAction func clickPaymentPerJob(_ sender: Any) {
        
        self.btnPaymentPerMonth.isSelected = false
        self.btnPaymentPerHour.isSelected = false
        self.btnPaymentPerJob.isSelected = true
        self.CalculatePrice()

    }
    
    @IBAction func clickPaymentPerHour(_ sender: Any) {
        
        self.btnPaymentPerJob.isSelected = false
        self.btnPaymentPerMonth.isSelected = false
        self.btnPaymentPerHour.isSelected = true
        self.CalculatePrice()
    }
    
    @IBAction func clickPaymentPerMonth(_ sender: Any) {
        
        /*
        var longterm = ""
        var payment_type = ""
        
     
        var sameLocationOfTheCompany = ""
        let totalAmount =  self.lblPaymentRs.text as! NSString
        totalAmount.replacingOccurrences(of: "$", with: "")
        var workingDay = ""
        var totalHour = 0
        let hourPerDay = self.txtPerHourPerDay.text as! NSString
        if btnWeekendsInclude.isSelected {
            workingDay = "1"
            totalHour = hourPerDay.integerValue * includingWeekDay
        }else{
            workingDay = "0"
            totalHour = hourPerDay.integerValue * excludingWeekDay
        }
        
        if self.txtEndDate.isHidden  {
            longterm = "1"
        }else{
            longterm = "0"
        }
        if btnPaymentPerJob.isSelected  {
            payment_type = "2"
        }
        if btnPaymentPerHour.isSelected  {
            payment_type = "1"
        }
        if btnPaymentPerMonth.isSelected  {
            payment_type = "3"
        }
        if btnSameAsCompanyDetail.isSelected  {
            sameLocationOfTheCompany = "1"
            
        }else{
            sameLocationOfTheCompany = "0"
        }
       */
        self.btnPaymentPerJob.isSelected = false
        self.btnPaymentPerHour.isSelected = false
        self.btnPaymentPerMonth.isSelected = true
       
        self.CalculatePrice()

    }
    
    
    @IBAction func clickFinishJobPost(_ sender: Any) {
        self.view.endEditing(true)

        var longterm = ""
        var payment_type = ""
        
        var latitude = "\(appdel.loginUserDict.object(forKey: "lat")!)"
        var  longitude = "\(appdel.loginUserDict.object(forKey: "lng")!)"

        var sameLocationOfTheCompany = ""
        
        //var totalAmount =  self.lblPaymentRs.text as! NSString
        
        var totalAmount =  totalAmountProject as NSString
        
        totalAmount =  totalAmount.replacingOccurrences(of: "$", with: "") as NSString
        var workingDay = ""
        var totalHour = 0
        let hourPerDay = self.txtPerHourPerDay.text as! NSString
        
        
        self.weekDaysFromCurrentDays()
        
        if  self.imgCheckWeekend.isHidden == false {
            workingDay = "1"
            totalHour = hourPerDay.integerValue * includingWeekDay
        }else{
            workingDay = "0"
            totalHour = hourPerDay.integerValue * excludingWeekDay
        }
        
        if self.txtEndDate.isHidden  {
            longterm = "1"
        }else{
            longterm = "0"
        }
        if btnPaymentPerJob.isSelected  {
            payment_type = "2"
        }
        if btnPaymentPerHour.isSelected  {
            payment_type = "1"
        }
        if btnPaymentPerMonth.isSelected  {
            payment_type = "3"
        }
        if  self.imgCheckSameAdd.isHidden == false  {
            latitude = "\(appdel.loginUserDict.object(forKey: "lat")!)"
            longitude = "\(appdel.loginUserDict.object(forKey: "lng")!)"
            sameLocationOfTheCompany = "1"
        }else{
            latitude = self.lat
            longitude = self.lng
            sameLocationOfTheCompany = "0"
        }
        
        if latitude == "" && longitude == "" {
            latitude = "\(appdel.loginUserDict.object(forKey: "lat")!)"
            longitude = "\(appdel.loginUserDict.object(forKey: "lng")!)"
        }
        
        
      let checkStartDate = txtStartDate.text
      let checkEndDate = txtEndDate.text
       
        var count = NSString()
        count = self.txtPerHourPerDay.text as! NSString
        let hourCount = count.integerValue
        
        print("hourCount is ",hourCount)
        
        var apiCall = false
        var startDateToast = false
        var startTimeToast = false
        apiCall = true
        
        lblValidJobDescription.text = ""
        startDate = txtStartHour.text as! NSString
        endDate = txtEndHour.text as! NSString
       
        if self.txtStartDate.text == self.txtEndDate.text{
            if startDate.compare(endDate as String) == .orderedSame {
                apiCall = false
                startTimeToast = true
            }
            if startDate.compare(endDate as String) == .orderedDescending {
                apiCall = false
                startTimeToast = true
            }
        }
        
        if (self.txtJobTitle.text?.isBlank)!
        {
            lblValidJobTitle.text = Localization(string: "Required field")

            apiCall = false
        }
       if ((self.tfJobDescription.text?.isBlank)!){
        lblValidJobDescription.text = Localization(string: "Required field")

            apiCall = false
        }
        if ((self.txtStartDate.text?.isBlank)!){
            lblValidationStartDate.text = Localization(string: "Required field")

            apiCall = false
        }
         if ((self.txtEndDate.text?.isBlank)!){
            if txtEndDate.isHidden == false{
                lblValidationEndDate.text = Localization(string: "Required field")

                apiCall = false
            }
        }
        if !(txtEndDate.isHidden){
            if checkStartDate?.compare(checkEndDate! as String) == .orderedDescending {
                startDateToast = true
                apiCall = false
            }
        }
         if ((self.txtStartHour.text?.isBlank)!){
            lblValidationStartTime.text = Localization(string: "Required field")

            apiCall = false
        }
         if ((self.txtEndHour.text?.isBlank)!){
            lblValidationEndTime.text = Localization(string: "Required field")

            apiCall = false

        }
         if ((self.txtPerHourPerDay.text?.isBlank)!){
            lblValidateHoursPerDay.text = Localization(string: "Required field")

            apiCall = false
        }
         if ((self.txtRsPerHours.text?.isBlank)!){
            lblValidateRsPerHour.text = Localization(string: "Required field")

            apiCall = false
        }
         if ((self.txtRsPerHours.text?.isBlank)!){
            lblValidateRsPerHour.text = Localization(string: "Required field")

            apiCall = false
        }
        if hourCount == 0 {
            startTimeToast = true
            apiCall = false
        }
        if hourCount < 1 {
            startTimeToast = true
            apiCall = false
        }
          if  FreshJob == 1 && apiCall == false {
             if ((self.txtStartTypingAdd.text?.isBlank)!) && apiCall == false{
                lblValidateStartTypingAdd.text = Localization(string: "Required field")

                apiCall = false
            }
             if ((self.txtStreetName.text?.isBlank)!) && apiCall == false{
                lblValidateStreet.text = Localization(string: "Required field")

                apiCall = false
            }
             if ((self.txtNumber.text?.isBlank)!) && apiCall == false{
                lblValidateNumber.text = Localization(string: "Required field")

                apiCall = false
            }
             if ((self.txtCompliment.text?.isBlank)!) && apiCall == false{
                lblValidateCompliment.text = Localization(string: "Required field")

                apiCall = false
            }
             if ((self.txtCompliment.text?.isBlank)!) && apiCall == false{
                lblValidateCompliment.text = Localization(string: "Required field")

                apiCall = false
            }
              if ((self.txtCity.text?.isBlank)!) && apiCall == false{
                lblValidateCity.text = Localization(string: "Required field")

                apiCall = false
            }
              if ((self.txtZipCode.text?.isBlank)!) && apiCall == false{
                lblValidateZipCode.text = Localization(string: "Required field")

                apiCall = false
            }
              if ((self.txtState.text?.isBlank)!) && apiCall == false{
                lblValidateState.text = Localization(string: "Required field")

                apiCall = false
            }
              if ((self.txtCountry.text?.isBlank)!) && apiCall == false{
                lblValidateCountry.text = Localization(string: "Required field")

                apiCall = false
             }
        }
        
        if  apiCall == false{
            
            if startDateToast{
                self.view.makeToast("End Date must be greater than start date", duration: 1.0, position: .bottom)
            }
            else if startTimeToast {
                self.txtPerHourPerDay.text = ""
                 self.view.makeToast("Please select appropriate hour", duration: 1.0, position: .bottom)
            }
            else{
                self.view.makeToast("All fields are required", duration: 1.0, position: .bottom)
            }
        }
        
        if apiCall && selectUserDict.count == 0 {
           
            if loadFrmOtherCtr == 1 && FreshJob == 1{

                let startUTCDate = self.LocalToLastUTCDate(txtStartDate.text!,hour:txtStartHour.text!)
                
                var endUTCDate = ""
                if !(txtEndDate.isHidden) {
                    endUTCDate = self.LocalToLastUTCDate(txtEndDate.text!,hour:txtEndHour.text!)
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                let startTimeLocal = formatter.date(from: txtStartHour.text!)
                let EndTimeLocal = formatter.date(from: txtEndHour.text!)

            let parameter = NSMutableDictionary()
                parameter.setObject("editJob", forKey: WebServicesClass.METHOD_NAME as NSCopying)
                parameter.setObject(self.tfJobDescription.text, forKey: "description" as NSCopying)
                parameter.setObject("\(appdel.loginUserDict.object(forKey: "employerId")!)", forKey: "employerId" as NSCopying)
               
               // parameter.setObject(objEndDatePicker.date.currentUTCTimeZoneDate, forKey: "endDate" as NSCopying)
                
                parameter.setObject(endUTCDate, forKey: "endDate" as NSCopying)

                
                //parameter.setObject(objEndHourPicker.date.currentUTCTimeZoneTime, forKey: "endHour" as NSCopying)
                
                parameter.setObject(EndTimeLocal?.currentUTCTimeZoneTime, forKey: "endHour" as NSCopying)

                
                parameter.setObject(self.txtPerHourPerDay.text!, forKey: "hoursPerDay" as NSCopying)
                parameter.setObject(self.jobid, forKey: "jobId" as NSCopying)
                parameter.setObject(self.txtJobTitle.text!, forKey: "jobTitle" as NSCopying)
                
                parameter.setObject(latitude, forKey: "lat" as NSCopying)
                parameter.setObject(longitude, forKey: "lng" as NSCopying)

                
                parameter.setObject(longterm, forKey: "long_term_job" as NSCopying)
                parameter.setObject(self.lblPositionCount.text!, forKey: "noOfPosition" as NSCopying)
                parameter.setObject(payment_type, forKey: "payment_type" as NSCopying)
                parameter.setObject(self.txtRsPerHours.text!, forKey: "rate" as NSCopying)
                parameter.setObject(sameLocationOfTheCompany, forKey: "sameLocationOfTheCompany" as NSCopying)
                
               // parameter.setObject(objStartDatePicker.date.currentUTCTimeZoneDate, forKey: "startDate" as NSCopying)
                
                
                parameter.setObject(startUTCDate, forKey: "startDate" as NSCopying)
                
              //  parameter.setObject(objStartHourPicker.date.currentUTCTimeZoneTime, forKey: "startHour" as NSCopying)
                
                parameter.setObject(startTimeLocal?.currentUTCTimeZoneTime, forKey: "startHour" as NSCopying)

                
                parameter.setObject(totalAmount, forKey: "totalAmount" as NSCopying)
                parameter.setObject("\(totalHour)", forKey: "totalHours" as NSCopying)
                parameter.setObject("\(workingDay)", forKey: "workingDay" as NSCopying)
                parameter.setObject(txtStreetName.text!, forKey: "streetName" as NSCopying)
                parameter.setObject(txtZipCode.text!, forKey: "zip" as NSCopying)
                parameter.setObject(txtState.text!, forKey: "state" as NSCopying)
                parameter.setObject(txtCity.text!, forKey: "city" as NSCopying)
                parameter.setObject(txtCountry.text!, forKey: "country" as NSCopying)
                parameter.setObject(txtNumber.text!, forKey: "address1" as NSCopying)
                parameter.setObject(txtCompliment.text!, forKey: "address2" as NSCopying)

                print("parameter for edit job",parameter)
                
                self.postJob(param: parameter,edit:1)
            
            }else {
                if apiCall {
                    
                    let startUTCDate = self.LocalToLastUTCDate(txtStartDate.text!,hour:txtStartHour.text!)
                   
                    var endUTCDate = ""
                    if !(txtEndDate.isHidden) {
                        endUTCDate = self.LocalToLastUTCDate(txtEndDate.text!,hour:txtEndHour.text!)
                    }
                    
                    let parameter = NSMutableDictionary()
                    parameter.setObject("postJob", forKey: WebServicesClass.METHOD_NAME as NSCopying)
                    parameter.setObject(txtNumber.text!, forKey: "address1" as NSCopying)
                    parameter.setObject(txtCompliment.text!, forKey: "address2" as NSCopying)
                    parameter.setObject(txtCity.text!, forKey: "city" as NSCopying)
                    parameter.setObject(categoryId, forKey: "categoryId" as NSCopying)
                    parameter.setObject(txtCountry.text!, forKey: "country" as NSCopying)
                    parameter.setObject(self.tfJobDescription.text, forKey: "description" as NSCopying)
                    parameter.setObject("\(appdel.loginUserDict.object(forKey: "employerId")!)", forKey: "employerId" as NSCopying)
                    parameter.setObject("en", forKey: "language" as NSCopying)
                    
                   // parameter.setObject(objEndDatePicker.date.currentUTCTimeZoneDate, forKey: "endDate" as NSCopying)
                    
                    parameter.setObject(endUTCDate, forKey: "endDate" as NSCopying)

                    parameter.setObject(objEndHourPicker.date.currentUTCTimeZoneTime, forKey: "endHour" as NSCopying)
                    
                    parameter.setObject(self.txtPerHourPerDay.text!, forKey: "hoursPerDay" as NSCopying)
                    parameter.setObject(self.txtJobTitle.text!, forKey: "jobTitle" as NSCopying)
                    parameter.setObject(latitude, forKey: "lat" as NSCopying)
                    parameter.setObject(longitude, forKey: "lng" as NSCopying)
                    parameter.setObject(longterm, forKey: "long_term_job" as NSCopying)
                    parameter.setObject(self.lblPositionCount.text!, forKey: "noOfPosition" as NSCopying)
                    parameter.setObject(payment_type, forKey: "payment_type" as NSCopying)
                    parameter.setObject(self.txtRsPerHours.text!, forKey: "rate" as NSCopying)
                    parameter.setObject(sameLocationOfTheCompany, forKey: "sameLocationOfTheCompany" as NSCopying)
                    
                   // parameter.setObject(objStartDatePicker.date.currentUTCTimeZoneDate, forKey: "startDate" as NSCopying)
                    
                    parameter.setObject(startUTCDate, forKey: "startDate" as NSCopying)
                    
                    parameter.setObject(objStartHourPicker.date.currentUTCTimeZoneTime, forKey: "startHour" as NSCopying)
                    
                    parameter.setObject(txtState.text!, forKey: "state" as NSCopying)
                    parameter.setObject(txtStreetName.text!, forKey: "streetName" as NSCopying)
                    parameter.setObject(self.subCategoryId, forKey: "subCategoryId" as NSCopying)
                    parameter.setObject(totalAmount, forKey: "totalAmount" as NSCopying)
                    parameter.setObject("\(totalHour)", forKey: "totalHours" as NSCopying)
                    parameter.setObject("\(workingDay)", forKey: "workingDay" as NSCopying)
                    parameter.setObject(txtZipCode.text!, forKey: "zip" as NSCopying)
                    
                    
                    print("parameter for repost & post job",parameter)
                    
                    self.postJob(param: parameter,edit:2)

                }
            }
        }
        if selectUserDict.count > 0  {
            
            // Invite Employee
            
            if apiCall {
                let startUTCDate = self.LocalToLastUTCDate(txtStartDate.text!,hour:txtStartHour.text!)
                var endUTCDate = ""
                if !(txtEndDate.isHidden) {
                    endUTCDate = self.LocalToLastUTCDate(txtEndDate.text!,hour:txtEndHour.text!)
                }
                let parameter = NSMutableDictionary()
                parameter.setObject("postJobById", forKey: WebServicesClass.METHOD_NAME as NSCopying)
                parameter.setObject("\(appdel.loginUserDict.object(forKey: "employerId")!)", forKey: "employerId" as NSCopying)
                parameter.setObject("\(selectUserDict.value(forKey: "employeeId")!)", forKey: "assignJobseekerId" as NSCopying)
                parameter.setObject(categoryId, forKey: "categoryId" as NSCopying)
                parameter.setObject(self.tfJobDescription.text, forKey: "description" as NSCopying)
                parameter.setObject(txtNumber.text!, forKey: "address1" as NSCopying)
                parameter.setObject(txtCompliment.text!, forKey: "address2" as NSCopying)
                parameter.setObject(txtCity.text!, forKey: "city" as NSCopying)
                parameter.setObject(txtCountry.text!, forKey: "country" as NSCopying)
                parameter.setObject("en", forKey: "language" as NSCopying)
                
               // parameter.setObject(objEndDatePicker.date.currentUTCTimeZoneDate, forKey: "endDate" as NSCopying)
                
                parameter.setObject(endUTCDate, forKey: "endDate" as NSCopying)

                parameter.setObject(objEndHourPicker.date.currentUTCTimeZoneTime, forKey: "endHour" as NSCopying)
                
                parameter.setObject(self.txtPerHourPerDay.text!, forKey: "hoursPerDay" as NSCopying)
                parameter.setObject(self.txtJobTitle.text!, forKey: "jobTitle" as NSCopying)
                parameter.setObject(latitude, forKey: "lat" as NSCopying)
                parameter.setObject(longitude, forKey: "lng" as NSCopying)
                parameter.setObject(longterm, forKey: "long_term_job" as NSCopying)
                parameter.setObject(self.lblPositionCount.text!, forKey: "noOfPosition" as NSCopying)
                parameter.setObject(payment_type, forKey: "payment_type" as NSCopying)
                parameter.setObject(self.txtRsPerHours.text!, forKey: "rate" as NSCopying)
                parameter.setObject(sameLocationOfTheCompany, forKey: "sameLocationOfTheCompany" as NSCopying)
                
                parameter.setObject(startUTCDate, forKey: "startDate" as NSCopying)

                //parameter.setObject(objStartDatePicker.date.currentUTCTimeZoneDate, forKey: "startDate" as NSCopying)
                
                parameter.setObject(objStartHourPicker.date.currentUTCTimeZoneTime, forKey: "startHour" as NSCopying)
                
                
                parameter.setObject(txtState.text!, forKey: "state" as NSCopying)
                parameter.setObject(txtStreetName.text!, forKey: "streetName" as NSCopying)
                parameter.setObject(self.subCategoryId, forKey: "subCategoryId" as NSCopying)
                parameter.setObject(totalAmount, forKey: "totalAmount" as NSCopying)
                parameter.setObject("\(totalHour)", forKey: "totalHours" as NSCopying)
                parameter.setObject("\(workingDay)", forKey: "workingDay" as NSCopying)
                parameter.setObject(txtZipCode.text!, forKey: "zip" as NSCopying)
                
                
                print("parameter for postJobById ",parameter)

                self.jobPostingPriceAndBalance(parameter: parameter)
            }

        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func clickWeekendInclude(_ sender: Any) {
        
        btnWeekendsInclude.isSelected = !btnWeekendsInclude.isSelected
        if btnWeekendsInclude.isSelected {
            
            self.imgCheckWeekend.isHidden = false
            workingDay = 1
            if (txtStartDate.text?.count)! > 0 && (txtEndDate.text?.count)! > 0 && (txtPerHourPerDay.text?.count)! > 0 && (txtRsPerHours.text?.count)! > 0 {
                if noEndDate == 0 {
                    self.CalculatePrice()
                }
            }
        }
        else {
            
            workingDay = 0
            self.imgCheckWeekend.isHidden = true

            if (txtStartDate.text?.count)! > 0 && (txtEndDate.text?.count)! > 0 && (txtPerHourPerDay.text?.count)! > 0 && (txtRsPerHours.text?.count)! > 0 {
                if noEndDate == 0 {
                    self.CalculatePrice()
                }
            }
        }
    }
    
    
    
    // MARK: - TextField Delegate Method
    
    
    func containsOnlyLetters(input: String) -> Bool {
        for chr in input.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
     
        if (isBackSpace == -92) {
            return true
        }
        
    
        if textField == txtJobTitle
        {
            lblValidJobTitle.text = ""
        }
        
          if textField == txtCountry
        {
            lblValidateCountry.text = ""
        }
        
         if textField == txtPerHourPerDay
        {
            lblValidateHoursPerDay.text = ""
            if (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
              
                return false
            }
        }

        if textField == txtRsPerHours
        {
            lblValidateRsPerHour.text = ""
            
            
            
            
            
            if (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil){
                
                return false
            }
        }

 
         if textField == txtNumber {
                lblValidateNumber.text = ""
                if (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil) {
                    return false
                }
            }
        
         if textField == txtZipCode {
                lblValidateZipCode.text = ""
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

        if textField == txtJobTitle
        {
            if(txtJobTitle.text?.isBlank)!
            {
                lblValidJobTitle.text = Localization(string: "Required field")

            }
            else
            {
                lblValidJobTitle.text = ""
            }
            
        }
        if textField == txtStartDate
        {
            if(txtStartDate.text?.isBlank)!
            {
                lblValidationStartDate.text = Localization(string: "Required field")

            }
            else
            {
                lblValidationStartDate.text = ""
            }
        }
        if textField == txtEndDate
        {
            if(txtEndDate.text?.isBlank)!
            {
                lblValidationEndDate.text = Localization(string: "Required field")

            }
            else
            {
                lblValidationEndDate.text = ""
            }
        }
        if textField == txtStartHour
        {
            if(txtStartHour.text?.isBlank)!
            {
                lblValidationStartTime.text = Localization(string: "Required field")

            }
            else
            {
                lblValidationStartTime.text = ""
            }
        }
        if textField == txtEndHour
        {
            if txtEndDate.isHidden == false {
                if(txtEndHour.text?.isBlank)!
                {
                    lblValidationEndTime.text = Localization(string: "Required field")

                }
                else
                {
                    lblValidationEndTime.text = ""
                }
            }
        
        }
        if textField == txtPerHourPerDay
        {
            if(txtPerHourPerDay.text?.isBlank)!
            {
                lblValidateHoursPerDay.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateHoursPerDay.text = ""
                
                hourDay = hourDay * 3600
                if hourDay > diff {
                    self.view.makeToast("Please enter Valid Time", duration: 3.0, position: .bottom)
                }
            }
        }
        
        if btnWeekendsInclude.isSelected {
            workingDay = 1
            if (txtStartDate.text?.count)! > 0 && (txtEndDate.text?.count)! > 0 && (txtPerHourPerDay.text?.count)! > 0 && (txtRsPerHours.text?.count)! > 0 {
                if noEndDate == 0 {
                    self.CalculatePrice()
                }
                
            }
        }
        else {
            workingDay = 0
            if (txtStartDate.text?.count)! > 0 && (txtEndDate.text?.count)! > 0 && (txtPerHourPerDay.text?.count)! > 0 && (txtRsPerHours.text?.count)! > 0 {
                if noEndDate == 0 {
                    self.CalculatePrice()
                }
            }
        }
        
        if textField == txtEndHour {

        }
        
        if textField == txtRsPerHours
        {
            if(txtRsPerHours.text?.isBlank)!
            {
                lblValidateRsPerHour.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateRsPerHour.text = ""
            }
        }
        if textField == txtStartTypingAdd
        {
            if(txtStartTypingAdd.text?.isBlank)!
            {
                lblValidateStartTypingAdd.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateStartTypingAdd.text = ""
            }
        }
        if textField == txtStreetName
        {
            if(txtStreetName.text?.isBlank)!
            {
                lblValidateStreet.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateStreet.text = ""
            }
        }
        if textField == txtNumber
        {
            if(txtNumber.text?.isBlank)!
            {
                lblValidateNumber.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateNumber.text = ""
            }
            
        }
        if textField == txtCompliment
        {
            if(txtCompliment.text?.isBlank)!
            {
                lblValidateCompliment.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateCompliment.text = ""
            }
            
        }
        if textField == txtCity
        {
            if(txtCity.text?.isBlank)!
            {
                lblValidateCity.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateCity.text = ""
            }
            
        }
        if textField == txtZipCode
        {
            if(txtZipCode.text?.isBlank)!
            {
                lblValidateZipCode.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateZipCode.text = ""
            }
            
        }
        if textField == txtState
        {
            if(txtState.text?.isBlank)!
            {
                lblValidateState.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateState.text = ""
            }
            
        }
        if textField == txtCountry
        {
            if(txtCountry.text?.isBlank)!
            {
                lblValidateCountry.text = Localization(string: "Required field")

            }
            else
            {
                lblValidateCountry.text = ""
            }
            
        }
        
//        if (txtStartDate.text?.count)! > 0 && (txtEndDate.text?.count)! > 0 && (txtPerHourPerDay.text?.count)! > 0 && (txtRsPerHours.text?.count)! > 0 {
//            if noEndDate == 0 {
//                
//                print("-txtRsPerHours.text!",txtRsPerHours.text!)
//                calculateTimePrice(txtRsPerHours.text!)
//            }
//        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtJobTitle == textField
        {
            txtJobTitle.resignFirstResponder()
            tfJobDescription.becomeFirstResponder()
        }
        else if txtStartDate == textField
        {
            txtStartDate.resignFirstResponder()
            
            if txtEndDate.isHidden {
                txtStartHour.becomeFirstResponder()
            }else{
                txtEndDate.becomeFirstResponder()
            }
        }
        else if txtEndDate == textField
        {
            txtEndDate.resignFirstResponder()
            txtStartHour.becomeFirstResponder()
        }
        else if txtStartHour == textField
        {
            txtStartHour.resignFirstResponder()
            txtEndHour.becomeFirstResponder()
        }
        else if txtEndHour == textField
        {
            txtEndHour.resignFirstResponder()
            txtPerHourPerDay.becomeFirstResponder()
        }
        else if txtPerHourPerDay == textField
        {
            txtPerHourPerDay.resignFirstResponder()
            txtRsPerHours.becomeFirstResponder()
        }
        else if txtRsPerHours == textField
        {
            txtRsPerHours.resignFirstResponder()
             if self.imgCheckSameAdd.isHidden == true {
                txtStartTypingAdd.becomeFirstResponder()
            }
        }
        else if self.imgCheckSameAdd.isHidden == true {
            
            if txtStartTypingAdd == textField
            {
                txtStartTypingAdd.resignFirstResponder()
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
                txtCompliment.becomeFirstResponder()
            }
            else if txtCompliment == textField
            {
                txtCompliment.resignFirstResponder()
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
            else{
                textField.resignFirstResponder()
            }
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == tfJobDescription {
            if(textView.text?.isBlank)!
            {
                lblValidJobDescription.text = Localization(string: "Required field")

            }
            else
            {
                lblValidJobDescription.text = ""
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtStartDate {
            self.txtStartDate.inputView = objStartDatePicker
            //self.txtStartDate.inputAccessoryView = self.toolBar()
            
            objStartDatePicker.datePickerMode = .date
            objStartDatePicker.addTarget(self, action: #selector(self.datePickerDidChangeStartDate), for: .allEvents)
            
            self.txtStartDate.text = dateFormatter.string(from: objStartDatePicker.date)
        }
        
        if textField == self.txtEndDate {
            self.txtEndDate.inputView = objEndDatePicker
            //self.txtEndDate.inputAccessoryView = self.toolBar()
            objEndDatePicker.datePickerMode = .date
            objEndDatePicker.addTarget(self, action: #selector(self.datePickerDidChangeEndDate), for: .allEvents)
            
            self.txtEndDate.text = dateFormatter.string(from: objEndDatePicker.date)

            //UIControlEventValueChanged
        }
        
        if textField == self.txtStartHour {
            self.txtStartHour.inputView = objStartHourPicker
            //self.txtStartHour.inputAccessoryView = self.toolBar()
            objStartHourPicker.datePickerMode = .time
            objStartHourPicker.addTarget(self, action: #selector(self.datePickerDidChangeStartHour), for: .allEvents)
            
            self.txtStartHour.text = hourFormatter.string(from: objStartHourPicker.date)
        }
        
        if textField == self.txtEndHour {
            self.txtEndHour.inputView = objEndHourPicker
           // self.txtEndHour.inputAccessoryView = self.toolBar()
            objEndHourPicker.datePickerMode = .time
            objEndHourPicker.addTarget(self, action: #selector(self.datePickerDidChangeEndHour), for: .allEvents)
        }
        
        if textField == txtPerHourPerDay
        {
            
            if(txtPerHourPerDay.text?.isBlank)!
            {
               // lblValidateHoursPerDay.text = strRequiredFieldEmpty
            }
            else
            {
               // lblValidateHoursPerDay.text = ""
                
            }
        }
    }
    
    // MARK: - Gesture  Delegates -
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        print("called gestureRecognizer")
        
        for case _ as UITextField in self.view.subviews {
            print("called gestureRecognizer in textfield")

            return false
        }
        
        if (touch.view?.isDescendant(of: txtStartTypingAdd.autoCompleteTableView))! {
            print("called gestureRecognizer in autoCompleteTableView")
            return false
        }else{
            return true
        }
    }
    
    // MARK: - MVPlaceSearchTextField Delegate Methods
    
    public func placeSearch(_ textField: MVPlaceSearchTextField!, resultCell cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
        
    }
    
    public func placeSearchWillHideResult(_ textField: MVPlaceSearchTextField!) {
        
    }
    
    public func placeSearchWillShowResult(_ textField: MVPlaceSearchTextField!) {
        
    }
    
    public func placeSearch(_ textField: MVPlaceSearchTextField!, responseForSelectedPlace responseDict: GMSPlace!) {
        
        txtStartTypingAdd.text = responseDict.formattedAddress
        txtStreetName.text = ""
        txtZipCode.text = ""
        txtCity.text = ""
        txtState.text = ""
        txtCountry.text = ""

        self.lat = "\(responseDict.coordinate.latitude)"
        self.lng = "\(responseDict.coordinate.longitude)"
        
        for component in responseDict.addressComponents! {
           // print(component.type)
            
            if component.type == "sublocality_level_1" {
              //  print("Sub Locality : \(component.name)")
                txtStreetName.text = component.name
            }
            
            if component.type == "postal_code" {
           //   print("Postal Code : \(component.name)")
                txtZipCode.text = component.name
            }
            
            if component.type == "locality" {
                // print("Locality : \(component.name)")
            }
            
            if component.type == "administrative_area_level_2" {
               print("city : \(component.name)")
                txtCity.text = component.name
            }
            
            if component.type == "administrative_area_level_1" {
             print("State : \(component.name)")
                txtState.text = component.name
            }
            
            if component.type == "country" {
                 print("Country : \(component.name)")
                txtCountry.text = component.name
            }
        }
    }
    
    // MARK: - Class Method
    func validationShoW(status:Int,api:Bool,getFreshJob:Int)  {
        
        lblValidJobTitle.text = Localization(string: "Required field")

        lblValidJobDescription.text = Localization(string: "Required field")

        lblValidationStartDate.text = Localization(string: "Required field")

        lblValidationEndDate.text = Localization(string: "Required field")

        lblValidationStartTime.text = Localization(string: "Required field")

        lblValidationEndTime.text = Localization(string: "Required field")

        lblValidateHoursPerDay.text = Localization(string: "Required field")

        lblValidateRsPerHour.text = Localization(string: "Required field")

        lblValidateRsPerHour.text = Localization(string: "Required field")

         if  getFreshJob == 1 && api == false {
            lblValidateStartTypingAdd.text = Localization(string: "Required field")

            lblValidateStreet.text = Localization(string: "Required field")

            lblValidateNumber.text = Localization(string: "Required field")

            lblValidateCompliment.text = Localization(string: "Required field")

            lblValidateCompliment.text = Localization(string: "Required field")

            lblValidateCity.text = Localization(string: "Required field")

            lblValidateZipCode.text = Localization(string: "Required field")

            lblValidateState.text = Localization(string: "Required field")

            lblValidateCountry.text = Localization(string: "Required field")

        }
        if status == 1 {
            lblValidJobTitle.text = ""
        }else if status == 2 {
            lblValidJobDescription.text = ""
        }else if status == 3 {
            lblValidationStartDate.text = ""
        }
        else if status == 4 {
            lblValidationEndDate.text = ""
        }
        else if status == 5 {
            lblValidationStartTime.text = ""
        }
        else if status == 6 {
            lblValidationStartTime.text = ""
        }
        else if status == 7 {
            lblValidationEndTime.text = ""
        }
        else if status == 8 {
            lblValidateHoursPerDay.text = ""
        }
        else if status == 8 {
            lblValidateHoursPerDay.text = ""
        }
        
    }
    func setupView()
    {
        
        lblValidateCountry.text = ""
        lblValidateRsPerHour.text = ""
        lblValidateHoursPerDay.text = ""
        lblValidateState.text = ""
        lblValidateZipCode.text = ""
        lblValidateCity.text = ""
        lblValidateCompliment.text = ""
        lblValidateNumber.text = ""
        lblValidateStreet.text = ""
        lblValidJobTitle.text = ""
        lblValidateStartTypingAdd.text = ""
        lblValidJobDescription.text = ""
        lblValidationStartDate.text  = ""
        lblValidationStartTime.text  = ""
        lblValidationEndTime.text  = ""
        lblValidationEndDate.text  = ""

        objEndDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 253))
        objEndDatePicker.minimumDate = Date()
        
        objStartDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 253))
        objStartDatePicker.minimumDate = Date()

        objStartHourPicker = UIDatePicker(frame: objEndDatePicker.frame)
        objStartHourPicker.minuteInterval = 15
        objStartHourPicker.minimumDate = Date()
        
        // en_GB is used for 24 hour format it's English - Europe
        objStartHourPicker.locale = Locale(identifier: "en_GB")
        objStartHourPicker.datePickerMode = .time
        
        objEndHourPicker = UIDatePicker(frame: objEndDatePicker.frame)
        objEndHourPicker.minuteInterval = 15
        objEndHourPicker.datePickerMode = .time
        objEndHourPicker.locale = Locale(identifier: "en_GB")

        dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateFormatter.dateFormat = "dd-MM-yyyy"

        hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        count = 1
    }
    

    func toolBar() -> UIView {
        
        let objToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 45))
        objToolBar.barStyle = .default
        objToolBar.barTintColor = blueThemeColor
        
        let btnNext: UIBarButtonItem = UIBarButtonItem(title: "Set", style: .plain, target: self, action: #selector(self.nextAction))
        
        
        
        
        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: Localization(string: "Cancel"), style: .plain, target: self, action: #selector(self.cancelAction))

        
        btnNext.tintColor = UIColor.white
        cancelButton.tintColor = UIColor.white
        
        let spaceLeft: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        
        objToolBar.setItems(NSArray(objects: cancelButton,spaceLeft,btnNext) as! [UIBarButtonItem], animated: true)
        return objToolBar
    }
    
    func nextAction() {
        
        let start: Bool = self.txtStartDate.isFirstResponder
        let end: Bool = self.txtEndDate.isFirstResponder
        let endHour: Bool = self.txtEndHour.isFirstResponder
        let startHour: Bool = self.txtStartHour.isFirstResponder
        
        if start == true {
            
            print("start",dateFormatter.string(from: objStartDatePicker.date))
            txtStartDate.text = dateFormatter.string(from: objStartDatePicker.date)
            self.txtStartDate.resignFirstResponder()
            
            if txtEndDate.isHidden {
                txtStartHour.becomeFirstResponder()
            }else{
                txtEndDate.becomeFirstResponder()
            }
            
           // self.txtEndDate.becomeFirstResponder()
        }
        
        if end == true && txtEndDate.isHidden == false{
            fordatePickerStart = dateFormatter.string(from: objStartDatePicker.date) as NSString
            fordatePickerEnd = dateFormatter.string(from: objEndHourPicker.date) as NSString
            
            print("end",dateFormatter.string(from: objStartDatePicker.date))
            
            
            
                if fordatePickerStart.compare(fordatePickerEnd as String) == .orderedSame
                {
                    self.txtEndDate.text = dateFormatter.string(from: objEndDatePicker.date)
                }
                else
                {
                    self.txtEndDate.text = dateFormatter.string(from: objEndDatePicker.date)
                }
            self.txtEndDate.resignFirstResponder()
            self.txtStartHour.becomeFirstResponder()
        }

        
        
        if startHour == true {
            
            startDate = hourFormatter.string(from: objStartHourPicker.date) as NSString

            print("startHour",hourFormatter.string(from: objStartHourPicker.date))

            txtStartHour.text = hourFormatter.string(from: objStartHourPicker.date)
            self.txtStartHour.resignFirstResponder()
            self.txtEndHour.becomeFirstResponder()
        }
        
        if endHour == true {
            startDate = hourFormatter.string(from: objStartHourPicker.date) as NSString
            endDate = hourFormatter.string(from: objEndHourPicker.date) as NSString
            
            print("endHour",hourFormatter.string(from: objEndHourPicker.date))

            let interval = objEndHourPicker.date.timeIntervalSince(objStartHourPicker.date)
            // 15 Minute Gap
            let countValue = 15.0 * 60.0
            
            if interval >= countValue {
                txtEndHour.text = hourFormatter.string(from: objEndHourPicker.date)
                
               // diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)
                
                diff = Int(objStartDatePicker.date.timeIntervalSince(objStartHourPicker.date) - objEndDatePicker.date.timeIntervalSince(objEndHourPicker.date))

                
                totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                
                print("-totalHourMessage",totalHourMessage)
                
                self.txtPerHourPerDay.text = totalHourMessage as String
            }
            
             self.txtEndHour.resignFirstResponder()
            self.txtRsPerHours.becomeFirstResponder()
        }
    }
    
    
    func cancelAction() {
        
        if txtEndDate.isFirstResponder
        {
            txtEndDate.resignFirstResponder()
        }
        if txtEndHour.isFirstResponder
        {
            txtEndHour.resignFirstResponder()
        }
        if txtStartHour.isFirstResponder == true
        {
            txtStartHour.resignFirstResponder()
        }
        if txtStartDate.isFirstResponder
        {
            txtStartDate.resignFirstResponder()
        }
    }
    

    func CalculatePrice()  {
        
        if (txtRsPerHours.text?.count)!>0 && !(txtEndDate.isHidden)
        {
            self.weekDaysFromCurrentDays()

            if includingWeekDay == 0 {
                includingWeekDay = 1
            }
            if excludingWeekDay == 0 {
                excludingWeekDay = 1
            }
            
            let hours = (self.txtPerHourPerDay.text!) as NSString
            let intHours = hours.intValue
            
            let rs = (self.txtRsPerHours.text!) as NSString
            let intRs = rs.intValue
            let amount = Float(intHours) * Float(intRs)
            if btnPaymentPerJob.isSelected  {
                let rsValue = (self.txtRsPerHours.text!) as NSString
                let myNumber = NSNumber(value: rsValue.floatValue)

                totalAmountProject = "$\(self.txtRsPerHours.text!)"
                
                if appdel.deviceLanguage == "pt-BR"
                {
                    self.lblPaymentRs.text = ConvertToPortuegeCurrency(number: myNumber)
                }
                else
                {
                    self.lblPaymentRs.text = totalAmountProject
                }
                
            }
            if btnPaymentPerHour.isSelected  {
                if  self.imgCheckWeekend.isHidden == false {
                    let amountHour = Float(amount) * Float(includingWeekDay)
                    let number = NSNumber(value: amountHour)
                    
                    totalAmountProject = "$\(amountHour)"

                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.lblPaymentRs.text = ConvertToPortuegeCurrency(number: number)
                    }
                    else
                    {
                        self.lblPaymentRs.text = totalAmountProject
                    }
                }
                else{
                    let amountHour = Float(amount) * Float(excludingWeekDay)
                    
                    let number = NSNumber(value: amountHour)
                    
                    totalAmountProject = "$\(amountHour)"

                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.lblPaymentRs.text = ConvertToPortuegeCurrency(number: number)
                    }
                    else
                    {
                        self.lblPaymentRs.text = totalAmountProject
                    }
                    
                }
            }
            if btnPaymentPerMonth.isSelected  {
                let totalAmount = rs.floatValue
                let totalMonthprice = totalAmount/30

                
                if  self.imgCheckWeekend.isHidden == false {
                    let totalCost = Float(totalMonthprice) * Float(includingWeekDay)
                    let amountValue =  String(format: "%.2f", totalCost)
                    
                    let number = NSNumber(value: totalCost)
                    
                    totalAmountProject = "$\(amountValue)"

                    
                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.lblPaymentRs.text = ConvertToPortuegeCurrency(number: number)
                    }
                    else
                    {
                        self.lblPaymentRs.text = totalAmountProject
                    }
                    
                }else{
                    let totalCost = Float(totalMonthprice) * Float(excludingWeekDay)
                    let amountValue =  String(format: "%.2f", totalCost)
                    
                    let number = NSNumber(value: totalCost)
                    
                    totalAmountProject = "$\(amountValue)"

                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.lblPaymentRs.text = ConvertToPortuegeCurrency(number: number)
                    }
                    else
                    {
                        self.lblPaymentRs.text = totalAmountProject
                    }
                    
                }
            }
        }
    }
 
    func weekDaysFromCurrentDays() {
        excludingWeekDay = 0
        includingWeekDay = 0
        let sunday: Int = 1
        let saturday: Int = 7
        var oneDay = DateComponents()
        oneDay.day = 1
        let calendar = Calendar(identifier: .gregorian)
        
        if (txtStartDate.text?.count)!>0 &&  (txtEndDate.text?.count)!>0 {
            
            var currentDate = dateFormatter.date(from: txtStartDate.text!)
            let endDate = dateFormatter.date(from: txtEndDate.text!)
            while currentDate?.compare(dateFormatter.date(from: txtEndDate.text!)!) == .orderedAscending
            {
                let dateComponents: DateComponents? = calendar.dateComponents(in: .autoupdatingCurrent, from: currentDate!)
                if dateComponents?.weekday != saturday && dateComponents?.weekday != sunday {
                    excludingWeekDay += 1
                }
                includingWeekDay += 1
                currentDate = calendar.date(byAdding: oneDay, to: currentDate!)
            }
        }
    }

    func timeFormatted(_ totalSeconds: Double) -> String {

        print("Total Second is",totalSeconds)
        var hour:Double
        let totalSecond = Double(totalSeconds)/3600
        hour = Double(totalSecond)
        print("Total hour is",hour)
        
        var countInt:Int = Int(hour)
      
        print("Total hour actual  is",countInt)
        
        let getLastTwo = (hour * 100).truncatingRemainder(dividingBy: 100)
        let lastTwoInt:Int = Int(getLastTwo)
        
        if lastTwoInt >= 99 {
            countInt = countInt + 1
        }
        
       // self.txtPerHourPerDay.text = "\(countInt)"

        return "\(countInt)"
    }
    
    func txtAllowForRepost()
    {
        
        txtStartDate.isUserInteractionEnabled = true
        txtEndDate.isUserInteractionEnabled = true
        txtStartHour.isUserInteractionEnabled = true
        txtEndHour.isUserInteractionEnabled = true

        txtJobTitle.isUserInteractionEnabled = false
        tfJobDescription.isUserInteractionEnabled = false
        btnMinus.isUserInteractionEnabled = false
        btnPlus.isUserInteractionEnabled = false
        btnNoEndDate.isUserInteractionEnabled = false
        btnWeekendsInclude.isUserInteractionEnabled = false
        btnNoEndDate.isUserInteractionEnabled = false
        btnPaymentPerHour.isUserInteractionEnabled = false
        btnPaymentPerJob.isUserInteractionEnabled = false
        btnPaymentPerMonth.isUserInteractionEnabled = false
        btnSameAsCompanyDetail.isUserInteractionEnabled = false
        txtStreetName.isUserInteractionEnabled = false
        txtNumber.isUserInteractionEnabled = false
        txtCompliment.isUserInteractionEnabled = false
        txtCity.isUserInteractionEnabled = false
        txtZipCode.isUserInteractionEnabled = false
        txtState.isUserInteractionEnabled = false
        txtCountry.isUserInteractionEnabled = false
        txtRsPerHours.isUserInteractionEnabled = false
        txtPerHourPerDay.isUserInteractionEnabled = false
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        //2017-10-18
        dateFormatter.dateFormat = "yyyy-MM-dd:HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: dt!)
    }
    
  //  MARK: - datePickerDidChangeDate
    func datePickerDidChangeStartDate(sender: UIDatePicker) {
        self.txtStartDate.text = dateFormatter.string(from: sender.date)
        
        if self.txtStartDate.text! == todayDate {
            objStartHourPicker.minimumDate = Date()
        }
       else{
            objStartHourPicker = UIDatePicker()
             objStartHourPicker = UIDatePicker(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 253))
            objStartHourPicker.locale = Locale(identifier: "en_GB")
            objStartHourPicker.minuteInterval = 15
            objStartHourPicker.datePickerMode = .time
        }
        objEndDatePicker.minimumDate = sender.date
        startDate = hourFormatter.string(from: objStartHourPicker.date) as NSString
        endDate = hourFormatter.string(from: objEndHourPicker.date) as NSString
        
        if (txtStartDate.text?.count)!>0 && (txtEndDate.text?.count)!>0 && (txtStartHour.text?.count)!>0 && (txtEndHour.text?.count)! > 0 {
            
            let interval = objEndHourPicker.date.timeIntervalSince(objStartHourPicker.date)
            let countValue = 60.0 * 60.0
            
            if self.txtStartDate.text == self.txtEndDate.text{
                if startDate.compare(endDate as String) == .orderedAscending {
                    if interval >= countValue {
                       
                        diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)

                        totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                        self.txtPerHourPerDay.text = totalHourMessage as String
                        self.CalculatePrice()

                    }
                }
            }
            else
            {
                
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: objStartDatePicker.date)
                if startDate.compare(endDate as String) == .orderedAscending {
                    diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)
                    totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                    self.txtPerHourPerDay.text = totalHourMessage as String
                    
                }else{
                    diff = Int((tomorrow?.timeIntervalSince(objEndHourPicker.date))! - objStartDatePicker.date.timeIntervalSince(objStartHourPicker.date))
                    var hour:Double
                    let totalSecond = Double(diff)/3600
                    hour = Double(totalSecond)
                  //  hour = hour.rounded(.up)

                    if hour > 24 {
                        hour = hour - 24
                        hour = 24 - hour
                    }
                    var countInt:Int = Int(hour)
                    let getLastTwo = (hour * 100).truncatingRemainder(dividingBy: 100)
                    let lastTwoInt:Int = Int(getLastTwo)
                    
                    if lastTwoInt >= 99 {
                        countInt = countInt + 1
                    }
                    
                    self.txtPerHourPerDay.text = "\(countInt)"

                    self.CalculatePrice()
                }
            }
        }
    }
    
    func datePickerDidChangeEndDate(sender: UIDatePicker) {
        self.txtEndDate.text = dateFormatter.string(from: sender.date)
        
        startDate = hourFormatter.string(from: objStartHourPicker.date) as NSString
        endDate = hourFormatter.string(from: objEndHourPicker.date) as NSString

        if (txtStartDate.text?.count)!>0 && (txtEndDate.text?.count)!>0 && (txtStartHour.text?.count)!>0 && (txtEndHour.text?.count)! > 0 {

        let interval = objEndHourPicker.date.timeIntervalSince(objStartHourPicker.date)
        let countValue = 60.0 * 60.0

            if self.txtStartDate.text == self.txtEndDate.text{
                if startDate.compare(endDate as String) == .orderedAscending {
                    if interval >= countValue {
                        diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)
                        totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                        self.txtPerHourPerDay.text = totalHourMessage as String
                        self.CalculatePrice()
                    }
                }
            }
            else
            {
                
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: objStartDatePicker.date)
                if startDate.compare(endDate as String) == .orderedAscending {
                    diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)
                    totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                    self.txtPerHourPerDay.text = totalHourMessage as String
                    
                }else{
                    diff = Int((tomorrow?.timeIntervalSince(objEndHourPicker.date))! - objStartDatePicker.date.timeIntervalSince(objStartHourPicker.date))
                    
                    var hour:Double
                    let totalSecond = Double(diff)/3600
                    hour = Double(totalSecond)
                    //  hour = hour.rounded(.up)
                    
                    if hour > 24 {
                        hour = hour - 24
                        hour = 24 - hour
                    }
                   
                    var countInt:Int = Int(hour)
                    let getLastTwo = (hour * 100).truncatingRemainder(dividingBy: 100)
                    let lastTwoInt:Int = Int(getLastTwo)
                    
                    if lastTwoInt >= 99 {
                        countInt = countInt + 1
                    }
                    
                    self.txtPerHourPerDay.text = "\(countInt)"

                    
                    self.CalculatePrice()
                }
            }
        }
    }
    
    func datePickerDidChangeEndHour(sender: UIDatePicker)
    {
        startDate = hourFormatter.string(from: objStartHourPicker.date) as NSString
        endDate = hourFormatter.string(from: sender.date) as NSString
        
        let interval = objEndHourPicker.date.timeIntervalSince(objStartHourPicker.date)
        let countValue = 60.0 * 60.0

        if self.txtStartDate.text == self.txtEndDate.text{
            if startDate.compare(endDate as String) == .orderedAscending {
                if interval >= countValue {
           // diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)
                  
                    
                    diff = Int(sender.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)

                    print("diff Equal is ",diff)
                    
                    totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                    
                    print("totalHourMessage Equal is  ",totalHourMessage)

                    self.txtPerHourPerDay.text = totalHourMessage as String
                    self.txtEndHour.text = hourFormatter.string(from: sender.date)
                    self.CalculatePrice()
                }
            }
        }
        else
        {
            self.txtEndHour.text = hourFormatter.string(from: sender.date)
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: objStartDatePicker.date)

            if startDate.compare(endDate as String) == .orderedAscending {
               
              //  diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)
                
                diff = Int(sender.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)

                print("diff Equal is ",diff)

                totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                
                print("totalHourMessage Equal is  ",totalHourMessage)

                self.txtPerHourPerDay.text = totalHourMessage as String
                
            }else{
               
                //diff = Int((tomorrow?.timeIntervalSince(objEndHourPicker.date))! - objStartDatePicker.date.timeIntervalSince(objStartHourPicker.date))
                
                diff = Int((tomorrow?.timeIntervalSince(sender.date))! - objStartDatePicker.date.timeIntervalSince(objStartHourPicker.date))

                
                print("diff is",diff)

                var hour:Double
                let totalSecond = Double(diff)/3600
                hour = Double(totalSecond)
                //  hour = hour.rounded(.up)
                print("diff is hour",hour)

                if hour > 24 {
                    hour = hour - 24
                    hour = 24 - hour
                }

                var countInt:Int = Int(hour)
                print("diff is countInt",countInt)

                let getLastTwo = (hour * 100).truncatingRemainder(dividingBy: 100)
                print("diff is getLastTwo",getLastTwo)

                let lastTwoInt:Int = Int(getLastTwo)

                print("diff is lastTwoInt",lastTwoInt)

                if lastTwoInt >= 99 {
                    countInt = countInt + 1
                }
               
                print("diff is countInt actual ",countInt)

                self.txtPerHourPerDay.text = "\(countInt)"

                
                self.CalculatePrice()
            }
        }
    }
    func datePickerDidChangeStartHour(sender: UIDatePicker)
    {
        self.txtStartHour.text = hourFormatter.string(from: sender.date)
        
        startDate = hourFormatter.string(from: sender.date) as NSString
        endDate = hourFormatter.string(from: objEndHourPicker.date) as NSString
        
        if (txtStartDate.text?.count)!>0 && (txtEndDate.text?.count)!>0 && (txtStartHour.text?.count)!>0 && (txtEndHour.text?.count)! > 0 {
            
            let interval = objEndHourPicker.date.timeIntervalSince(objStartHourPicker.date)
            let countValue = 60.0 * 60.0
            
            if self.txtStartDate.text == self.txtEndDate.text{
                if startDate.compare(endDate as String) == .orderedAscending {
                    if interval >= countValue {
                      //  diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)
                        
                        diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - sender.date.timeIntervalSinceReferenceDate)

                        totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                        self.txtPerHourPerDay.text = totalHourMessage as String
                        self.CalculatePrice()
                    }
                }
            }
            else
            {
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: objStartDatePicker.date)
                if startDate.compare(endDate as String) == .orderedAscending {
                    //diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - objStartHourPicker.date.timeIntervalSinceReferenceDate)
                    
                    diff = Int(objEndHourPicker.date.timeIntervalSinceReferenceDate - sender.date.timeIntervalSinceReferenceDate)

                    totalHourMessage = self.timeFormatted(Double(diff)) as NSString
                    self.txtPerHourPerDay.text = totalHourMessage as String
                    
                }else{
                   // diff = Int((tomorrow?.timeIntervalSince(objEndHourPicker.date))! - objStartDatePicker.date.timeIntervalSince(objStartHourPicker.date))
                    
                    diff = Int((tomorrow?.timeIntervalSince(objEndHourPicker.date))! - objStartDatePicker.date.timeIntervalSince(sender.date))
                  
                    var hour:Double
                    let totalSecond = Double(diff)/3600
                    hour = Double(totalSecond)
                    //  hour = hour.rounded(.up)
                    
                    if hour > 24 {
                        hour = hour - 24
                        hour = 24 - hour
                    }
                    var countInt:Int = Int(hour)
                    let getLastTwo = (hour * 100).truncatingRemainder(dividingBy: 100)
                    let lastTwoInt:Int = Int(getLastTwo)
                    
                    if lastTwoInt >= 99 {
                        countInt = countInt + 1
                    }
                    
                    self.txtPerHourPerDay.text = "\(countInt)"

                    self.CalculatePrice()
                }
            }
        }
        
    }
    
    // MARK: - API Call

    func jobDetailbyIdApi()
    {
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "jobDetailbyId",
                      "jobId":self.jobid,
                      "userId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        print("paramjobDetailbyIdApi",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            print("jobDetailbyId response",param)

            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        
                        self.txtJobTitle.text = dataDict.value(forKey: "jobTitle") as? String
                        
                        self.tfJobDescription.text = dataDict.value(forKey: "jobDescription") as? String

                        self.lblPositionCount.text = dataDict.value(forKey: "position") as? String

                        self.categoryId = (dataDict.value(forKey: "categoryId") as? String)!
                        self.subCategoryId = (dataDict.value(forKey: "subCategoryId") as? String)!

                        
                        if self.endDate.length < 1
                        {
                            self.imgCheckNoEndDate.isHidden = true
                        }
                        else
                        {
                            self.imgCheckNoEndDate.isHidden = false

                        }
                        
                        
//                        dateFormat
                        
                        
                        self.txtNumber.text = "\(dataDict.value(forKey: "address1")!)"
                        self.txtCompliment.text = "\(dataDict.value(forKey: "address2")!)"
                        self.txtCity.text = "\(dataDict.value(forKey: "city")!)"
                        self.txtCountry.text = "\(dataDict.value(forKey: "country")!)"
                        self.txtState.text = "\(dataDict.value(forKey: "state")!)"
                        self.txtStreetName.text = "\(dataDict.value(forKey: "streetName")!)"
                        self.txtZipCode.text = "\(dataDict.value(forKey: "zip")!)"
                        self.txtStartTypingAdd.text = "\(dataDict.value(forKey: "country")!)"

                       let workingDay = dataDict.value(forKey: "working_day") as? String

                        
                        if workingDay == "0"
                        {
                            self.imgCheckWeekend.isHidden = true
                        }
                        else
                        {
                            self.imgCheckWeekend.isHidden = false
                        }
                        
                        if self.loadFrmOtherCtr == 1
                        {
                            if self.FreshJob == 0
                            {
                               
                                
                                self.txtJobTitle.textColor = UIColor.gray
                                self.tfJobDescription.textColor = UIColor.gray
                                self.lblPositionCount.textColor = UIColor.gray

                                self.txtNumber.textColor = UIColor.gray
                                self.txtCompliment.textColor = UIColor.gray
                                self.txtCity.textColor = UIColor.gray
                                self.txtCountry.textColor = UIColor.gray
                                self.txtState.textColor = UIColor.gray

                                self.txtStreetName.textColor = UIColor.gray
                                self.txtZipCode.textColor = UIColor.gray

                                self.txtStartTypingAdd.textColor = UIColor.gray

                                self.txtPerHourPerDay.textColor = UIColor.gray
                                self.txtRsPerHours.textColor = UIColor.gray

                            }else{
                                
                                
                                
                                let StartTime = "\(dataDict.object(forKey: "start_hour")!)"
                                
                                let Time = "\(dataDict.object(forKey: "start_date")!)" + ":" + "\(StartTime)"
                                
                                print("date Time expand is",Time)
                                
                                let newDate = self.convertDateFormater(Time)
                                
                                self.txtStartDate.text = newDate
                               
                                self.txtStartHour.text = "\(self.UTCToLocal(date: dataDict.object(forKey: "start_hour")! as! String))"

                                print("date newDate expand is",newDate)
                               
                                var endTime = "\(dataDict.object(forKey: "end_hour")!)"
                                
                                print("date endTime expand is",endTime)
                                
                                var endDate = dataDict.object(forKey: "end_date") as! String
                                
                                print("date endDate expand is",endDate)
                                
                                if endDate == "0000-00-00"
                                {
                                    endDate = "No end Date"
                                }
                                else
                                {
                                    let Time = "\(dataDict.object(forKey: "end_date")!)" + ":" + "\(dataDict.object(forKey: "end_hour")!)"
                                    
                                    print("date Time expand is",Time)
                                    endDate = self.convertDateFormater(Time)
                                    self.txtEndDate.text = endDate
                                }
                                
                                if endTime == "" {
                                    
                                    endTime = "00:00"
                                }else{
                                    
                                    self.txtEndHour.text = "\(self.UTCToLocal(date: dataDict.object(forKey: "end_hour")! as! String))"
                                }

                                if dataDict.value(forKey: "long_term_job") as? String == "0"
                                {
                                  //  self.txtEndDate.text = dataDict.value(forKey: "end_date") as? String
                                }
                            }
                        }
                        
                        let balance = "\(dataDict.object(forKey: "hoursPerDay")!)" as NSString
                        var balanceRS = Int()
                        balanceRS = balance.integerValue
                        
                       
                        
                        if appdel.deviceLanguage == "pt-BR"
                        {
                            let number = NSNumber(value: balance.floatValue)
                            self.txtPerHourPerDay.text = self.ConvertToPortuegeCurrency(number: number)
                        }
                        else
                        {
                            self.txtPerHourPerDay.text = "\(balanceRS.withCommas())" + ".00"
                        }
                        
                       // self.txtPerHourPerDay.text = dataDict.value(forKey: "hoursPerDay") as? String
                        
                        self.txtRsPerHours.text = dataDict.value(forKey: "hourlyRate") as? String
                        
                        
                        if dataDict.value(forKey: "long_term_job") as? String == "0"
                        {
                            
                            self.lblPaymentRs.text = "$\(dataDict.value(forKey: "TotalAmount") as! String)"
                        }
                        else
                        {
                            self.viewEndDate.isHidden = true
                            self.txtEndDate.isHidden = true
                            self.imgCheckNoEndDate.isHidden = false
                            self.lblPaymentRs.text = "$0"
                        }
                        
                        
                        let paymentType = dataDict.value(forKey: "payment_type") as? String
                        
                        if paymentType == "1"
                        {
                         self.btnPaymentPerHour.isSelected = true
                        }
                        else if paymentType == "2"
                        {
                            self.btnPaymentPerJob.isSelected = true

                        }
                        else if paymentType == "3"
                        {
                            self.btnPaymentPerMonth.isSelected = true

                        }
                        else
                        {
                            self.btnPaymentPerHour.isSelected = true

                        }

                        
                        let sameAsCompanyAdd = dataDict.value(forKey: "same_as_company_location") as? String
                        
                        if sameAsCompanyAdd == "1"
                        {
                            self.imgCheckSameAdd.isHidden = false
                            self.constraintHeightDiffAddress.constant = 0

                        }
                        else
                        {
                            
                            self.constraintHeightDiffAddress.constant = 505

                            self.imgCheckSameAdd.isHidden = true
                            
                        }
                        

 
                    }
                    
                }
                else
                {
                    
                }
                
                
            }
        }
    }
    
    
    func postJob(param:NSMutableDictionary,edit:Int)
    {
        SwiftLoader.show(animated: true)
        
        global.callWebService(parameter: param ) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print("diC Response is",dictResponse)
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1
                {
                  
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary {
                        
                        if edit == 1{
                            _ = self.navigationController?.popViewController(animated: true)
                        }else if edit == 2{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                            let postJob = storyBoard.instantiateViewController(withIdentifier: "EmpPostJob") as! EmpPostJob
                            postJob.jobId = "\(dataDict.object(forKey: "jobId")!)"
                            postJob.jobTitle = self.txtJobTitle.text!
                            self.navigationController?.pushViewController(postJob, animated: true)
                        }else{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                            let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
                            self.navigationController?.pushViewController(empdashboardVC, animated: true)
                        }
                    }
                    
                   
                }else{
                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.alertMessage.strMessage = "\(dictResponse.value(forKey: "pt_message")!)"
                    }
                    else
                    {
                        self.alertMessage.strMessage = "\(dictResponse.value(forKey: "message")!)"
                    }
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
                
            }
        }
    }
    
    func jobPostingPriceAndBalance(parameter:NSMutableDictionary)
    {
        SwiftLoader.show(animated: true)
        
        
        let param =  [WebServicesClass.METHOD_NAME: "jobPostingPriceAndBalance",
                      "employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
               
                print("dictResponse is",dictResponse)
                
                self.totalBalance = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "balance") as! NSString
                
                let remainingDays = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "remainingDays") as! NSString
                
                let totalDays = remainingDays.integerValue
                
                self.postJobPrice = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "jobInvitationPrice") as! NSString
                self.postFavBalance = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "jobInvitationFavouritePrice") as! NSString
                
                if totalDays > 0{
                    if self.alreadyWorked == "0"{
                        let alertController = UIAlertController(title: "", message: Localization(string: "per Professionals") + "$\(self.postJobPrice)" + Localization(string: "per Professionals") + "&" + "$\(self.postFavBalance)" + Localization(string: "per favorite professional."), preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        }
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            self.postJob(param: parameter, edit: 3)
                        }
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                         let alertController = UIAlertController(title: "", message: Localization(string: "per Professionals") + "$\(self.postJobPrice)" + Localization(string: "per Professionals") + "&" + "$\(self.postFavBalance)" + Localization(string: "per favorite professional."), preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        }
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            self.postJob(param: parameter, edit: 3)
                        }
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    if self.alreadyWorked == "0" {
                        if self.postJobPrice.intValue > self.totalBalance.intValue  {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                            let noBalance = storyBoard.instantiateViewController(withIdentifier: "EmpNoBalance") as! EmpNoBalance
                            self.navigationController?.pushViewController(noBalance, animated: true)
                        }else{
                            // self.postJob(param: postJobParam)
                            // open the View of alert
                            
                            let alertController = UIAlertController(title: "", message: Localization(string: "per Professionals") + "$\(self.postJobPrice)" + Localization(string: "per Professionals") + "&" + "$\(self.postFavBalance)" + Localization(string: "per favorite professional."), preferredStyle: UIAlertControllerStyle.alert)
                            
                            let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                            }
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                self.postJob(param: parameter, edit: 3)
                            }
                            alertController.addAction(cancelAction)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else{
                        if self.postJobPrice.intValue > self.totalBalance.intValue  {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                            let noBalance = storyBoard.instantiateViewController(withIdentifier: "EmpNoBalance") as! EmpNoBalance
                            self.navigationController?.pushViewController(noBalance, animated: true)
                        }else{
                            
                            // open the View of alert
                            
                          let alertController = UIAlertController(title: "", message: Localization(string: "per Professionals") + "$\(self.postJobPrice)" + Localization(string: "per Professionals") + "&" + "$\(self.postFavBalance)" + Localization(string: "per favorite professional."), preferredStyle: UIAlertControllerStyle.alert)
                            
                            let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                            }
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                self.postJob(param: parameter, edit: 3)
                            }
                            alertController.addAction(cancelAction)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
 
                }
            }
        }
    }
}


extension UIDatePicker {
    /// Returns the date that reflects the displayed date clamped to the `minuteInterval` of the picker.
    /// - note: Adapted from [ima747's](http://stackoverflow.com/users/463183/ima747) answer on [Stack Overflow](http://stackoverflow.com/questions/7504060/uidatepicker-with-15m-interval-but-always-exact-time-as-return-value/42263214#42263214})
    public var clampedDate: Date {
        let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}


