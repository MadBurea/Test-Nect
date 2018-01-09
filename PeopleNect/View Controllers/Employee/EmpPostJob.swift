//
//  EmpPostJob.swift
//  PeopleNect
//
//  Created by BAPS on 10/27/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class EmpPostJob: UIViewController  {

    @IBOutlet weak var leftArrowImg: UIImageView!
    @IBOutlet weak var addBalanceView: UIView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    var totalBalance = NSString()
    var postJobPrice = NSString()
    var jobId  = String()
    var jobTitle  = String()
    var remainingDays  = false
    
    // MARK: - View LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblPrice.text  = "0"
        self.lblTotalPrice.text  = "$0"
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        // call jobPostingPriceAndBalance for checking post job price
        
        self.jobPostingPriceAndBalance()
        
        // add gesture for add balance
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.addBalanceClick))
         self.leftArrowImg.isUserInteractionEnabled = true
        self.leftArrowImg.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Click Action -
    @IBAction func inviteJobClick(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let invite = storyBoard.instantiateViewController(withIdentifier: "inviteViewController") as! inviteViewController
        invite.jobId = self.jobId
        invite.jobTitle = self.jobTitle
        self.navigationController?.pushViewController(invite, animated: true)
    }
    @IBAction func postJobClick(_ sender: Any) {
        
        if remainingDays {
            self.publishJob()
        }else{
            if jobId.count > 0 {
                if postJobPrice.intValue > totalBalance.intValue  {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                    let noBalance = storyBoard.instantiateViewController(withIdentifier: "EmpNoBalance") as! EmpNoBalance
                    self.navigationController?.pushViewController(noBalance, animated: true)
                }else{
                    self.publishJob()
                }
            }
        }
    }
    @IBAction func CloseBtnClick(_ sender: Any) {
        
        //self.dismiss(animated: true, completion: nil)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
        self.navigationController?.pushViewController(empdashboardVC, animated: true)
    }
    
    @IBAction func addBalanceClick(_ sender: Any) {
        print("Add Balance")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let addBalance = storyBoard.instantiateViewController(withIdentifier: "addBalance") as! addBalance
        self.navigationController?.pushViewController(addBalance, animated: true)
    }

    //MARK: - jobPostingPriceAndBalance
    
    func jobPostingPriceAndBalance()
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
                 self.lblPrice.text  = ((dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "jobPostingPrice") as! NSString) as String
                
                self.totalBalance = (((dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "balance") as! NSString) as String) as String as NSString

                let remainingDays = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "remainingDays") as! NSString
                let totalDays = remainingDays.integerValue
                if totalDays > 0{
                    self.remainingDays = true
                }
                
                self.postJobPrice = self.lblPrice.text! as NSString
                
                self.lblTotalPrice.text = self.totalBalance as String
            }
        }
    }
    
    func publishJob()  {
        /*
         {
         "employerId": "2",
         "jobId": "243",
         "methodName": "publishJob"
         }
         */
        SwiftLoader.show(animated: true)
        
        
        let param =  [WebServicesClass.METHOD_NAME: "publishJob","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":self.jobId] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            let dictResponse = Response as! NSDictionary
            print("dictResponse",dictResponse)
            let status = dictResponse.object(forKey: "status") as! Int
            if status == 1
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                let selection = storyBoard.instantiateViewController(withIdentifier: "selctionViewController") as! selctionViewController
                selection.jobId = self.jobId
                selection.isfromJobPubliush = true
                selection.jobTitle = self.jobTitle
                self.navigationController?.pushViewController(selection, animated: true)
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
