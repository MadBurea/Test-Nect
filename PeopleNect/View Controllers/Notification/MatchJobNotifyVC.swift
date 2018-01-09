//
//  MatchJobNotifyVC.swift
//  PeopleNect
//
//  Created by BAPS on 11/9/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class MatchJobNotifyVC: UIViewController, UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var matchJobTableView: UITableView!
    
    @IBOutlet weak var viewTop: UIView!
    var global = WebServicesClass()
    var jobDetailArry = NSMutableArray()
    var userDic = [String: Any]()
    var userId = ""
    var alertMessage = AlertMessageVC()

    // MARK: - View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        alertMessage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        self.matchJobTableView.rowHeight = UITableViewAutomaticDimension
        self.matchJobTableView.estimatedRowHeight = 300
        
        matchJobTableView.delegate = self
        matchJobTableView.dataSource = self
        
        self.matchJobTableView.register(UINib(nibName: "JobDashBoardInnerViewCell", bundle: Bundle.main), forCellReuseIdentifier: "JobDashBoardInnerViewCell")
        
        
        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0

        let employer_id = "\(userDic["employer_id"]!)"
        let job_id = "\(userDic["job_id"]!)"
        userId = "\(appdel.loginUserDict.object(forKey: "userId")!)"

        
        self.jobDetailbyId(employerId: employer_id, jobSeekerId: userId, jobId: job_id)
        
        
        //self.jobDetailbyId(employerId: "65", jobSeekerId: "178", jobId: "422")
        
        //            job_id=493,
        //                    employer_id=343,
        //                    message=RateEmployerforjob,
        //                    notification_status=13,
        //                    job_title=matchnotification,
        //                    jobseeker_id=249
        //        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI ACTION -

    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func applyStatus(sender: UIButton)
    {
        var tempDict = NSDictionary()
        tempDict = self.jobDetailArry.object(at: sender.tag) as! NSDictionary
        let jobId =  "\(tempDict.object(forKey: "jobId")!)"
        self.applyForJob(userId: userId, jobId: jobId)
    }
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
   
    // MARK: - TABLEVIEW DELEGATE / DATASOURCE -

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobDetailArry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let expandcell = tableView.dequeueReusableCell(withIdentifier: "JobDashBoardInnerViewCell", for: indexPath) as! JobDashBoardInnerViewCell
        
        expandcell.contentView.layer.cornerRadius = 2.0
        expandcell.contentView.layer.shadowColor = UIColor.gray.cgColor
        expandcell.contentView.layer.shadowOpacity = 0.5
        expandcell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        expandcell.contentView.layer.shadowRadius = 2.0
        
        
        var tempDict = NSDictionary()
        tempDict = self.jobDetailArry.object(at: indexPath.row) as! NSDictionary
        expandcell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
        
        
        let StartTime = "\(tempDict.object(forKey: "start_hour")!)"
        let Time = "\(tempDict.object(forKey: "start_date")!)" + ":" + "\(StartTime)"
        let newDate = convertDateFormater(Time)
        
        expandcell.lblDate.text = newDate
        
        
        expandcell.lblCompany.text =  "\(tempDict.object(forKey: "company_name")!)"
        
        expandcell.lblPayment.text =  "$\(tempDict.object(forKey: "TotalAmount")!)"
        
        expandcell.lblRatings.text =  "\(tempDict.object(forKey: "rating")!)"
        
        let distance = tempDict.object(forKey: "distance") as! NSNumber
        let distanceFloat: Float = distance.floatValue
        expandcell.lblLocation.text = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f", distanceFloat) + "Km"
        
        
        expandcell.lblDescription.text =  "\(tempDict.object(forKey: "jobDescription")!)"
        
        
        let perDay = tempDict.object(forKey: "payment_type") as! String
        if perDay == "1"
        {
            expandcell.lblPerHour.text = "/hour"
        }
        else if perDay == "2"
        {
            expandcell.lblPerHour.text = "/job"
        }else{
            expandcell.lblPerHour.text = "/month"
        }
        
        
        var endTime = "\(tempDict.object(forKey: "end_hour")!)"
        var endDate = tempDict.object(forKey: "end_date") as! String
        
        if endDate == "0000-00-00"
        {
            endDate = "No end Date"
        }
        else
        {
            let Time = "\(tempDict.object(forKey: "end_date")!)" + ":" + "\(tempDict.object(forKey: "end_hour")!)"
            endDate = convertDateFormater(Time)
        }
        
        if endTime == "" {
            
            endTime = "00:00"
            expandcell.lblFromEndDate.text =  "From \n \(newDate) \n to \n \(endDate) \n | \n From \n \(self.UTCToLocal(date: tempDict.object(forKey: "start_hour")! as! String))h \n to \n No End Time"
        }else{
            
            expandcell.lblFromEndDate.text =  "From \n \(newDate) \n to \n \(endDate) \n | \n From \n \(self.UTCToLocal(date: tempDict.object(forKey: "start_hour")! as! String))h \n to \n \(self.UTCToLocal(date:tempDict.object(forKey: "end_hour")! as! String))h"
        }
       
        
        let workingDays = tempDict.object(forKey: "working_day") as! String
        
        if workingDays == "0"
        {
            expandcell.lblOnlyDays.text = "Only business days"
        }
        else if workingDays == "1"
        {
            expandcell.lblOnlyDays.text = "Includes non Business days"
        }
        expandcell.btnApplyAlReadyInvited.tag = indexPath.row
        expandcell.btnApplyAlReadyInvited.addTarget(self, action: #selector(self.applyStatus(sender:)), for: .touchUpInside)
        expandcell.backgroundColor = UIColor.clear

        
        return expandcell
    }
    
    // MARK: - Api Call
    
    func jobDetailbyId(employerId:String,jobSeekerId:String,jobId:String)
    {
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "jobDetailbyId",
                      "employerId":employerId,
                      "jobSeekerId":jobSeekerId,
                      "jobId":jobId] as [String : Any]
        
        print("param",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                //  SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()

                if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary {
                    self.jobDetailArry.add(dataDict)
                    print("jobDetailArry ",self.jobDetailArry)
                    self.matchJobTableView.reloadData()
                }

                if status == 1
                {

                }
                else
                {
                    
                    print(Response.object(forKey: "message")!)
                }
                
                
            }
        }
        
    }
    
    
    func applyForJob(userId:String,jobId:String)
    {
        
        //  {"jobId":"290","userId":"178","methodName":"applyForJob"}

        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "applyForJob",
                      "userId":userId,
                      "jobId":jobId] as [String : Any]
        
        print("param",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                //  SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                    _ = self.navigationController?.popViewController(animated: true)
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
    
}
