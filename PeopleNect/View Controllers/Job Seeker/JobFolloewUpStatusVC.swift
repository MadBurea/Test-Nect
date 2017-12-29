//
//  JobFolloewUpStatusVC.swift
//  PeopleNect
//
//  Created by Apple on 05/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class JobFolloewUpStatusVC: UIViewController {

    @IBOutlet var lblJob: UILabel!
    @IBOutlet var lblCompany: UILabel!
    @IBOutlet var imgAccpted: UIImageView!
    @IBOutlet var imgHiringManagerKnow: UIImageView!
    @IBOutlet var imgWaitingFeedBack: UIImageView!
    
    var global = WebServicesClass()
    
    var alertMessage = AlertMessageVC()
    
    var jobID = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("jobID",jobID)
        
        //self.followUpAPI()
        
        self.jobDetailbyIdApi()
        
    
    }

    @IBAction func clickBAck(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    @IBOutlet var clickBAck: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // MARK: - API call
    
    func jobDetailbyIdApi()
    {
        SwiftLoader.show(animated: true)
        
        
        let param =  [WebServicesClass.METHOD_NAME: "jobDetailbyId",
                      "jobId":self.jobID,
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        print("paramjobDetailbyIdApi",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {                SwiftLoader.hide()

                print("Error",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                print("ResponsedictResponse",dictResponse)

                
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        
//                        self.JobLat = dataDict.value(forKey: "JobLat") as! String
//                        self.JobLng = dataDict.value(forKey: "JobLng") as! String
//                        self.lblStartDate.text = dataDict.value(forKey: "start_date") as? String
//                        self.lblEndDate.text = dataDict.value(forKey: "end_date") as? String
//                        
//                        self.lblStartTime.text = dataDict.value(forKey: "start_hour") as? String
//                        self.lblEndTime.text = dataDict.value(forKey: "end_hour") as? String
//                        self.lblPayment.text = dataDict.value(forKey: "hourlyRate") as? String
//                        self.lblPerHour.text = dataDict.value(forKey: "TotalAmount") as? String
//                        self.lblJob.text = dataDict.value(forKey: "jobTitle") as? String
//                        self.lblRating.text = dataDict.value(forKey: "rating") as? String
//                        self.lblCompnyJob.text = dataDict.value(forKey: "company_name") as? String
//                        // self.lblMiddelJob.text = dataDict.value(forKey: "JobLng")as? String
//                        
//                        let address1 = dataDict.value(forKey: "address1") as? String
//                        let address2 = dataDict.value(forKey: "address2") as? String
//                        let city = dataDict.value(forKey: "city") as? String
//                        let state = dataDict.value(forKey: "state") as? String
//                        
//                        let address = "\(address1!), \(address2!), \(city!), \(state!)"
//                        self.lblAddressCompany.text = address
                    }
                    
                }
                else
                {
                    
                }
                
                
            }
        }
    }
    
    
    
    
    
    
    
    func followUpAPI()
    {
        SwiftLoader.show(animated: true)
        
        /*
         "job_id": "240",
         "jobseeker_id": "77",
         "methodName": "followUp"
         */

        
        
        
        let param =  [WebServicesClass.METHOD_NAME: "followUp",
                      "jobseeker_id":"\(appdel.loginUserDict.object(forKey: "userId")!)",
                        "job_id":jobID] as [String : Any]
        
        
        print("ParamfollowUpAPI",param)
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {                SwiftLoader.hide()

                print("Error",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                print("ResponsefollowUpAPI",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                SwiftLoader.hide()
                
                if status == 1
                {
//                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
//                    {
//                        let acceptedInvitation = dataDict.object(forKey: "acceptedInvitation") as! [Any]
//                        
//                        self.view.makeToast("\(String(describing: Response.object(forKey: "message")))", duration: 3.0, position: .bottom)
//                        
//                        self.arrAcceptedInvitation.addObjects(from: acceptedInvitation)
//                        
//                        print("arrAcceptedInvitation",self.arrAcceptedInvitation)
//                        
//                        self.tblPendingApplication.reloadData()
//                    }
//                    
                }
                else
                {
                    print("Error","\(Response.object(forKey: "message")!)")
                    
//                    self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
//                    
//                    self.alertMessage.modalPresentationStyle = .overCurrentContext
//                    
//                    self.present(self.alertMessage, animated: false, completion: nil)
//                    
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
