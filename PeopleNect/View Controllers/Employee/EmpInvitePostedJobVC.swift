//
//  EmpInvitePostedJobVC.swift
//  PeopleNect
//
//  Created by InexTure on 30/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class EmpInvitePostCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
   
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var lblinvited: UILabel!
}


class EmpInvitePostedJobVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var alertMessage = AlertMessageVC()
    var global = WebServicesClass()
    
    @IBOutlet weak var lblInvited: UILabel!
    
    @IBOutlet weak var lblFor: UILabel!

    @IBOutlet weak var tblInvited: UITableView!
    
    var arrayInvitedPost = NSMutableArray()
    
    @IBOutlet weak var viewEmpInvite: UIView!
    
    @IBOutlet weak var viewEmpInviteInner: UIView!
    
    @IBOutlet weak var lblInviteAmount: UILabel!
    
    @IBOutlet weak var btnCancle: UIButton!
    
    @IBOutlet weak var btnOk: UIButton!
    
    var jobSeekerId = NSString()
    
    var jobSeekerName = NSString()
    var totalBalance = NSString()
    var postJobPrice = NSString()
    var postFavBalance = NSString()
     // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialSetupView()
        
        // Alert View Initialize
          alertMessage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        // Api Call
            self.getInvitedPostedJobApi()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetupView()
    {
        viewEmpInviteInner.layer.cornerRadius = 5
        viewEmpInvite.isHidden = true
        lblInvited.text = "\(strInvite) \(jobSeekerName)"
        lblFor.text = strFor
        tblInvited.backgroundColor = UIColor.clear
        btnOk.setTitle(strOK, for: .normal)
        btnCancle.setTitle(strCancel, for: .normal)
    }
    
    // MARK: - UIView Action
    @IBAction func btnCloseSel(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnCancelClick(_ sender: Any)
    {
        viewEmpInvite.isHidden = true
    }
    @IBAction func btnOKClick(_ sender: Any) {
    }
    // MARK: - UITableView Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayInvitedPost.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let tablecell = tableView.dequeueReusableCell(withIdentifier: "EmpInvitePostCell1", for: indexPath) as! EmpInvitePostCell
        
        
        var tempDict = NSDictionary()
        tempDict = arrayInvitedPost.object(at: indexPath.row) as! NSDictionary
        
      //  print(tempDict)
        
        tablecell.lblName.text = "\(tempDict.object(forKey: "jobTitle")!)"
    
        let perDay = tempDict.object(forKey: "payment_type") as! String
        
        var afterRateString = NSString()
        
        if perDay == "1"
        {
            afterRateString = strHour as NSString
        }
        else if perDay == "2"
        {
            afterRateString = strJob as NSString
        }
        else
        {
            afterRateString = strDay as NSString
        }
        
        
        let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
        var balanceRS = Int()
        balanceRS = balance.integerValue
        
        if appdel.deviceLanguage == "pt-BR"
        {
            let number = NSNumber(value: balance.floatValue)
            tablecell.lblPrice.text = "\(ConvertToPortuegeCurrency(number: number))" + "\(afterRateString)"
        }
        else
        {
            tablecell.lblPrice.text = "$ \(balanceRS.withCommas())" + ".00" + "\(afterRateString)"
        }
        
         //tablecell.lblPrice.text = "$\(tempDict.object(forKey: "rate")!)/\(afterRateString)"
        
        tablecell.lblinvited.text = strInvite
        
        tablecell.backgroundColor = UIColor.clear
        
        tablecell.inviteBtn.tag = indexPath.row
        tablecell.inviteBtn.addTarget(self, action: #selector(self.clickTableCell), for: .touchUpInside)
        
        return tablecell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK: - Web Services Call
    func getInvitedPostedJobApi()
    {
        print(jobSeekerId)
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "openJobs","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","jobSeekerId":jobSeekerId] as [String : Any]
        
        print(param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            if error != nil
            {
                self.alertMessage.strMessage = error?.description as String!
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                self.present(self.alertMessage, animated: false, completion: nil)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
            
                let status = dictResponse.object(forKey: "status") as! Int
                if status == 1
                {
                    if let dataDict = (dictResponse as AnyObject).object(forKey: "data") as? NSDictionary
                    {
                        
                        if let arrjobsForGuest = (dataDict as AnyObject).object(forKey: "jobsForGuest") as? NSArray
                        {
                            
                            if arrjobsForGuest.count > 0 {
                                self.arrayInvitedPost.add(arrjobsForGuest.object(at: 0))
                            }
                            
                        }
                        
                        if let arrjobsCurrentJob = (dataDict as AnyObject).object(forKey: "currentJobs") as? NSArray
                        {
                            
                            print("arrjobsCurrentJob is",arrjobsCurrentJob)
                            
                            if arrjobsCurrentJob.count > 0 {
                                self.arrayInvitedPost.add(arrjobsCurrentJob.object(at: 0))
                            }
                        }
                        
                        self.tblInvited.reloadData()
                    }
                }
                else
                {
                    self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    
                    self.present(self.alertMessage, animated: false, completion: nil)
                    
                }
            }
        }
    }
    
    // MARK: - Class Method
    
    func clickTableCell(_sender : UIButton)
    {
        var tempDict = NSDictionary()
        tempDict = arrayInvitedPost.object(at: _sender.tag) as! NSDictionary
        let jobID = "\(tempDict.object(forKey: "jobId")!)"
        self.jobPostingPriceAndBalance(jobId:jobID)
    }
    
    
    func jobPostingPriceAndBalance(jobId:String)
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
                
                self.totalBalance = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "balance") as! NSString
                
                self.postJobPrice = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "jobInvitationPrice") as! NSString
                self.postFavBalance = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "jobInvitationFavouritePrice") as! NSString
                
                let remainingDays = "\((dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "remainingDays")!)"
                let totalDays = (remainingDays as NSString).integerValue
                
                if totalDays > 0{
                    
                    
                    let alertController = UIAlertController(title: "", message: Localization(string: "per Professionals") + " $ \(self.postJobPrice) " + Localization(string: "per Professionals") + "&" + " $ \(self.postFavBalance) " + Localization(string: "per favorite professional."), preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                    }
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        self.inviteEmployees(jobID: jobId)
                    }
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)

                }else{
                    if self.postJobPrice.intValue > self.totalBalance.intValue  {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                        let noBalance = storyBoard.instantiateViewController(withIdentifier: "EmpNoBalance") as! EmpNoBalance
                        self.navigationController?.pushViewController(noBalance, animated: true)
                    }else{
                       let alertController = UIAlertController(title: "", message: Localization(string: "per Professionals") + " $ \(self.postJobPrice) " + Localization(string: "per Professionals") + "&" + " $ \(self.postFavBalance) " + Localization(string: "per favorite professional."), preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        }
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            self.inviteEmployees(jobID: jobId)
                        }
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func inviteEmployees(jobID:String)  {
        
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "inviteEmployees","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":jobID,"allIds":jobSeekerId,"favIds":""] as [String : Any]
        
        print("param is",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            
            if error != nil {
                self.view.makeToast(Localization(string:"Dang! Something went wrong. Try again!"), duration: 3.0, position: .bottom)
            }else{
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                print("dictResponse is",dictResponse)
                if status == 1
                {
                    
                    self.view.makeToast(Localization(string:"Invited Successfully"), duration: 3.0, position: .bottom)

                    _ = self.navigationController?.popViewController(animated: true)
                    
                }else{
                   
                    if status == 0 {
                        self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    }
                    if status == 2{
                        self.alertMessage.strMessage = Localization(string:  "you have insufficient credit.")
                    }else{
                        
                        self.alertMessage.strMessage = Localization(string:  "Error while sending invitation, please try again")
                    }
                    
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
        }
    }
    
}
