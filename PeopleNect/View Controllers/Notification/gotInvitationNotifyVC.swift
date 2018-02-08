//
//  gotInvitationNotifyVC.swift
//  PeopleNect
//
//  Created by BAPS on 11/7/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class gotInvitationNotifyVC: UIViewController {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var distancelbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var priceHourLbl: UILabel!
    @IBOutlet weak var totalHourLbl: UILabel!
    @IBOutlet weak var topTitleLbl: UILabel!
    
    @IBOutlet weak var refuseDescriptionLbl: UILabel!
    @IBOutlet weak var decideBtn: UIButton!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    var userId = String()
    var employerId = String()
    var jobId = String()
    
    var userDic =  [String: Any]()
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
       // self.userId = "198"
        //self.jobId = "422"
//       print("user dic is ",userDic)
        
        
        //job_id,jobseeker_id,job_title, notification_status = 3
        
        self.userId =  "\(userDic["jobseeker_id"]!)"
        self.jobId =    "\(userDic["job_id"]!)"
        
        self.totalHourLbl.text = ""
        self.totalTimeLbl.text =  ""
        self.priceHourLbl.text = ""
        self.jobTitleLbl.text =  ""
        self.companyLbl.text =  ""
        self.ratingLbl.text =  ""
        self.descriptionLbl.text = ""
        self.lblAddress.text =  ""
        
        self.jobDetailbyIdApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func ClickonAccept(_ sender: Any) {
        self.acceptRefuseAPI(accept: "1")
    }

    @IBAction func ClickOnRefuse(_ sender: Any) {
        self.acceptRefuseAPI(accept: "2")
    }
    
    @IBAction func ClickOnDecideLater(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Api Call
    func acceptRefuseAPI(accept:String)  {
      
        
        SwiftLoader.show(animated: true)
        
        
        let param =  [WebServicesClass.METHOD_NAME: "acceptJobInvitation",
            "language":appdel.userLanguage,
            "jobId":jobId,
            "userId":userId,
            "accept":accept] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
           
            if error != nil {
                _ = self.navigationController?.popViewController(animated: true)

            }else{
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                if status == 1
                {
                    
                     self.view.makeToast(Localization(string:"Invitation accepted!"), duration: 3.0, position: .bottom)
                    
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }else{
                    print("error")
                    
                    
                    self.alertMessage.strMessage = Localization(string:"Invitation refused!")
                    
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
            
           
        }
    }

    
    func jobDetailbyIdApi()
    {
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "jobDetailbyId",
                      "jobId":self.jobId,
                      "userId":self.userId,
            "language":appdel.userLanguage] as [String : Any]
        
        print("paramjobDetailbyIdApi",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                
                print("dictResponse",dictResponse)

                let status = dictResponse.object(forKey: "status") as! Int
                
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        
                        self.totalTimeLbl.text = "$" + "\(dataDict.value(forKey: "TotalAmount")!)"
                        
                        let StartTime = "\(dataDict.object(forKey: "start_hour")!)"
                        let Time = "\(dataDict.object(forKey: "start_date")!)" + ":" + "\(StartTime)"
                        let newDate = self.convertDateFormater(Time)
                        let EndTime = "\(dataDict.object(forKey: "end_hour")!)"

                        
                        var endTime = "\(dataDict.object(forKey: "end_hour")!)"
                        var endDate = dataDict.object(forKey: "end_date") as! String
                        
                        if endDate == "0000-00-00"
                        {
                            endDate = "No end Date"
                            
                            self.totalHourLbl.text = "\(newDate) to \n \(endDate) "
                        }
                        else
                        {
                            let TimeEnd = "\(dataDict.object(forKey: "end_date")!)" + ":" + "\(EndTime)"
                            let EndDate = self.convertDateFormater(TimeEnd)
                            self.totalHourLbl.text = "\(newDate) to \n \(EndDate) "

                        }
                        
                        if endTime == "" {
                            
                            endTime = "00:00"
                            
                            self.priceHourLbl.text =  "\(strFrom) \n \(self.UTCToLocal(date: dataDict.object(forKey: "start_hour")! as! String))h \(strTo) \n No End Time"

                        }else{
                            self.priceHourLbl.text =  "\(strFrom) \n \(self.UTCToLocal(date: dataDict.object(forKey: "start_hour")! as! String)) h \(strTo) \n \(self.UTCToLocal(date:dataDict.object(forKey: "end_hour")! as! String))h"
                        }

                        self.jobTitleLbl.text =  "\(dataDict.value(forKey: "jobTitle")!)"
                        self.companyLbl.text =  "\(dataDict.value(forKey: "company_name")!)"
                        self.ratingLbl.text =  "\(dataDict.value(forKey: "rating")!)"

                        self.descriptionLbl.text = dataDict.value(forKey: "jobDescription") as? String
                        
                self.lblAddress.text =  "\(dataDict.value(forKey: "streetName")!)" + " " + "\(dataDict.value(forKey: "address1")!)" + " " + "\(dataDict.value(forKey: "address2")!)" + " " + "\(dataDict.value(forKey: "city")!)" + " " + "\(dataDict.value(forKey: "state")!)" + " " + "\(dataDict.value(forKey: "country")!)"

                }
                else
                {
                    
                }
                
                
            }
        }
    }
}

}
