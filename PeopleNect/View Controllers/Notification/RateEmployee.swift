//
//  RateEmployee.swift
//  PeopleNect
//
//  Created by BAPS on 11/8/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import Cosmos
import SwiftLoader


class RateEmployee: UIViewController {

    @IBOutlet weak var imgStarMain: UIImageView!
    @IBOutlet weak var lblRateYourLastJob: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewRate: CosmosView!
    
    @IBOutlet weak var lblReguler: UILabel!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lblLast: UILabel!
    
    var userId = String()
    var employerId = String()
    var jobId = String()
    var companyName = String()
    var jobTitle = String()
    var fromNotification = false

    var userDic = [String: Any]()
    var global = WebServicesClass()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewRate.rating = 0
        
        if fromNotification {
            self.viewRate.update()
            self.lblName.text = companyName
            self.lblJobTitle.text = jobTitle
            self.lblLast.text = ""
        }else{
            self.userId = "\(userDic["jobseeker_id"]!)"
            self.employerId = "\(userDic["employer_id"]!)"
            self.jobId = "\(userDic["job_id"]!)"
            self.viewRate.update()
            
            self.lblName.text = "\(userDic["company_name"]!)"
            self.lblJobTitle.text = "\(userDic["job_title"]!)"
            self.lblLast.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickRateEmployee(_ sender: Any) {
        self.rateEmployerApi()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Api Call
    
    func rateEmployerApi()
    {
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "rateEmployer",
                      "userId":userId,
                        "employerId":employerId,
                        "jobId":jobId,
                        "rating":viewRate.rating] as [String : Any]
        
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
                
                print(dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else
                {
                }
                
            }
        }
        
    }

 

}
