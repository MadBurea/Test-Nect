//
//  JobOnGoingDetailsVC.swift
//  PeopleNect
//
//  Created by Apple on 28/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class JobOnGoingDetailsVC: UIViewController {

    @IBOutlet var imgSelected: UIImageView!
    
    @IBOutlet weak var awareLbl: UILabel!
    @IBOutlet weak var confirmLbl: UILabel!
    @IBOutlet weak var forThisJobLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet var viewDate: UIView!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblEndDate: UILabel!
    
    @IBOutlet weak var viewHeightConstraints: NSLayoutConstraint!
    @IBOutlet var viewTime: UIView!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    
    @IBOutlet var viewPayment: UIView!
    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblPerHour: UILabel!
    
    @IBOutlet var viewJobRating: UIView!
    @IBOutlet var lblJob: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var imgRating: UIImageView!
    
    @IBOutlet var lblCompnyJob: UILabel!
    
    @IBOutlet var lblMiddelJob: UILabel!
    
    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var lblAddressCompany: UILabel!
    
    @IBOutlet var imgSeeInMap: UIImageView!
    @IBOutlet var btnSeeInMap: UIButton!
    
    @IBOutlet var btnAcknowledgement: UIButton!
    @IBOutlet var viewbtnScheduleGiveup: UIView!
    
    @IBOutlet var btnSchedule: UIButton!
    @IBOutlet var btnGiveUp: UIButton!
    var global = WebServicesClass()

    var JobLat = ""
    var JobLng = ""
    var jobId:String = ""
    var type:String = ""
    var hasAcknowledge:String = ""
    var userDic = [String: Any]()
    var alertMessage = AlertMessageVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblStartDate.text = ""
        self.lblEndDate.text = ""
        self.lblMiddelJob.text = ""
        self.lblEndTime.text = ""
        self.lblStartTime.text = ""
        self.lblEndTime.text = ""
        self.lblPerHour.text = ""
        self.lblPayment.text = ""
        self.lblJob.text = ""
        self.lblRating.text = ""
        self.lblCompnyJob.text = ""
        
        alertMessage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        
        if userDic.count > 0 && appdel.notificationStatus == 4 {
            self.jobId = "\(userDic["job_id"]!)"
            self.type = "\(userDic["job_type"]!)"
            hasAcknowledge = "0"
        }
        
        if userDic.count > 0 && appdel.notificationStatus == 9 {
            self.jobId = "\(userDic["jobId"]!)"
            self.type = "\(userDic["type"]!)"
            hasAcknowledge = "0"
        }
        
        self.JobDetailApiCall()
        
        if hasAcknowledge == "0" {
            self.viewbtnScheduleGiveup.isHidden = true
            
            awareLbl.isHidden = false
            confirmLbl.isHidden = false
            forThisJobLbl.text = "to this job."

        }else{
            forThisJobLbl.text = "for this job."
            awareLbl.isHidden = true
            confirmLbl.isHidden = true
            self.btnAcknowledgement.isHidden = true
            self.viewbtnScheduleGiveup.isHidden = false
        }
        
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topView.layer.shadowRadius = 2.0
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    
    // MARK: - Actions
    @IBAction func clickSeeInMap(_ sender: Any) {
        drawRouteAppleMap(directionsURL:"http://maps.apple.com/?saddr=\(appdel.userLocationLat),\(appdel.userLocationLng)&daddr=\(self.JobLat),\(self.JobLng)")
    }
    
    @IBAction func clickAcknowlegement(_ sender: Any) {
        self.acknowledge()
    }
    
    @IBAction func clickSchedule(_ sender: Any) {
        gotoAppleCalendar()
    }

    @IBAction func clickGievUp(_ sender: Any) {
        cancelJobByEmployee()
    }
    
    func gotoAppleCalendar() {
        let interval = Date.timeIntervalSinceReferenceDate
        let url = NSURL(string: "calshow:\(interval)")!
        UIApplication.shared.openURL(url as URL)
    }
    
    
   
    @IBAction func clickBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    // MARK: - Date Formate
//
//    func convertDateFormater(_ date: String) -> String
//    {
//        let dateFormatter = DateFormatter()
//        
//        //2017-10-18
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.date(from: date)
//        dateFormatter.dateFormat = "dd/MM"
//        return  dateFormatter.string(from: date!)
//    }
    


    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        
        //2017-10-18
        dateFormatter.dateFormat = "yyyy-MM-dd:HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM"
        
        return dateFormatter.string(from: dt!)
    }
    
    // MARK: - API Call

  
    func JobDetailApiCall()
    {
        SwiftLoader.show(animated: true)
        
        
       let param =  [WebServicesClass.METHOD_NAME: "jobDetailbyId",
                      "jobId":self.jobId,
                      "jobSeekerId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                SwiftLoader.hide()
                print("Error",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                print("response is",dictResponse)
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        self.JobLat = dataDict.value(forKey: "JobLat") as! String
                        self.JobLng = dataDict.value(forKey: "JobLng") as! String
                        
                        
                        let Time = "\(dataDict.object(forKey: "start_date")!)" + ":" + "\(dataDict.object(forKey: "start_hour")!)"
                        
                        let newDate = self.convertDateFormater(Time)
                        
                        self.lblStartDate.text = "\(newDate)" + " to"
                        
                        let TimeEnd = "\(dataDict.object(forKey: "end_date")!)" + ":" + "\(dataDict.object(forKey: "end_hour")!)"
                        
                        let end_date = dataDict.value(forKey: "end_date") as? String
                        
                        if end_date == "0000-00-00" {
                            self.lblEndDate.text = "No End Date"
                        }else{
                            self.lblEndDate.text = self.convertDateFormater(TimeEnd)
                        }
                        
                        self.lblMiddelJob.text = dataDict.value(forKey: "jobDescription") as? String
                        
                        
                        
                        var endTime = "\(dataDict.value(forKey: "start_hour")!)"
                        
                        if endTime == "" {
                            
                            endTime = "00:00"
                            self.lblEndTime.text = "To " + "No End Time"

                        }else{
                            
                            self.lblStartTime.text = "From " + "\(self.UTCToLocal(date: dataDict.value(forKey: "start_hour")! as! String))h "

                            
                            self.lblEndTime.text = "To " + "\(self.UTCToLocal(date: dataDict.value(forKey: "end_hour")! as! String))h "
                            
                        }
                        

                        //self.lblPayment.text =  "$" + (dataDict.value(forKey: "hourlyRate") as? String)!
                        
                        
//
                        
                        
                        
                        let perDay = dataDict.object(forKey: "payment_type") as! String
                        
                        if perDay == "1"
                        {
                            self.lblPerHour.text =    "/hour"
                        }
                        else if perDay == "2"
                        {
                            self.lblPerHour.text =    "/job"
                        }else{
                            self.lblPerHour.text =    "/month"
                        }

                        
                        
                        let balance = "\(dataDict.object(forKey: "hourlyRate")!)" as NSString
                        var balanceRS = Int()
                        balanceRS = balance.integerValue
                       
                       
                        
                        if appdel.deviceLanguage == "pt-BR"
                        {
                            let number = NSNumber(value: balance.floatValue)
                            self.lblPayment.text = self.ConvertToPortuegeCurrency(number: number)
                        }
                        else
                        {
                            self.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
                        }
                        
                        
                        self.lblJob.text = dataDict.value(forKey: "jobTitle") as? String
                        self.lblRating.text = dataDict.value(forKey: "rating") as? String
                        self.lblCompnyJob.text = dataDict.value(forKey: "company_name") as? String
                        
                        
                        let streetName =  "\(dataDict.value(forKey: "streetName")!)"
                        let address1 = "\(dataDict.value(forKey: "address1")!)"
                        let address2 = "\(dataDict.value(forKey: "address2")!)"
                        let city = "\(dataDict.value(forKey: "city")!)"
                        let state = "\(dataDict.value(forKey: "state")!)"
                        
                        let address = "\(streetName),\(address1), \(address2), \(city), \(state)"
                        
                        self.lblAddressCompany.text = address
                    }
                }
                else
                {
                    
                }
                
            }
        }
    }
    
    func acknowledge()
    {
        
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "acknowledge",
                      "jobId":self.jobId,"type":self.type,
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                SwiftLoader.hide()
                print("Error",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1
                {   self.btnAcknowledgement.isHidden = true
                    self.viewbtnScheduleGiveup.isHidden = false
                }else{
                    self.btnAcknowledgement.isHidden = true
                    self.viewbtnScheduleGiveup.isHidden = false
                }
            }
        }
    }
    
    func cancelJobByEmployee()
    {
        /*
         {"jobID":"236","jobSeekerID":"63","methodName":"cancelJobByEmployee","userType":"0"}
         */
        
        SwiftLoader.show(animated: true)
        

        let param =  [WebServicesClass.METHOD_NAME: "cancelJobByEmployee",
                      "jobID":self.jobId,"userType":self.type,
                      "jobSeekerID":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                SwiftLoader.hide()
                print("Error",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                print("response is",dictResponse)
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1
                {
                    self.view.makeToast(Localization(string:"You canceled job successfully"), duration: 3.0, position: .bottom)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }else{
               
                    if status == 2 {
                         self.alertMessage.strMessage = Localization(string:"Job in progress, you can't cancel it!")
                    }else{
                        self.alertMessage.strMessage = Localization(string:"Dang! Something went wrong. Try again!")
                    }
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }}
        }
    }
    
}
