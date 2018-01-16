//
//  JobPendingAppVC.swift
//  PeopleNect
//
//  Created by Apple on 26/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class JobPendingAppVC: UIViewController, UITableViewDelegate, UITableViewDataSource,SlideNavigationControllerDelegate {

    @IBOutlet var lblPendingApplication: UILabel!
    @IBOutlet var tblPendingApplication: UITableView!
    
    
    @IBOutlet weak var viewTop: UIView!
    var global = WebServicesClass()
    
    var alertMessage = AlertMessageVC()
    
    var jobFollowUp = JobFolloewUpStatusVC()
    

    @IBOutlet var lblNoPendingApp: UILabel!
    
    var jobPendingCollection = JobPendinAppInnerCell()
    
     var currentIndex = -1
    var previousIndex = -1
    
    
    var arrAcceptedInvitation = NSMutableArray()
    
    var refreshControl = UIRefreshControl()
    var isForRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblPendingApplication.delegate = self
        self.tblPendingApplication.dataSource = self
        
        
        
        lblNoPendingApp.isHidden = true
        
        
        self.tblPendingApplication.register(UINib(nibName: "JobDashBoardMainCell", bundle: Bundle.main), forCellReuseIdentifier: "JobDashBoardMainCell")
        
        self.tblPendingApplication.register(UINib(nibName: "JobDashBoardInnerViewCell", bundle: Bundle.main), forCellReuseIdentifier: "JobDashBoardInnerViewCell")

        
        
        self.tblPendingApplication.rowHeight = UITableViewAutomaticDimension
        self.tblPendingApplication.estimatedRowHeight = 80
        
        self.getPendingApplication()
        
     //   alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0
        
        
        // refresh Controller
        self.refreshContoller()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrAcceptedInvitation.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //   let empTableItem = tableItems[indexPath.row]
        
        if indexPath.row == currentIndex
        {
            let expandcell = tableView.dequeueReusableCell(withIdentifier: "JobPendinAppInnerCell", for: indexPath) as! JobPendinAppInnerCell
            
            expandcell.selectionStyle = .none
            
            previousIndex = currentIndex
            
            
                        var tempDict = NSDictionary()
                        tempDict = arrAcceptedInvitation.object(at: indexPath.row) as! NSDictionary
            
                        let categoryList = tempDict.object(forKey: "subCategory") as! String
            
            
                        let categories = categoryList.characters.split{$0 == ","}.map(String.init)
            
                        expandcell.arrSubCatData.removeAllObjects()
            
                        if categories.count > 0
                        {
            
                            for i in 0...categories.count-1
                            {
                                if i <= 2
                                {
                                    expandcell.arrSubCatData.add(categories[i])
            
                                    print("mainCell.subCategoryArray",expandcell.arrSubCatData)
                                    
                                }
                            }
                        }
            
            
            
            expandcell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
            expandcell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
            
            expandcell.viewPayment.backgroundColor = ColorJobAlRedyInvitedApplied
            expandcell.viewOnlyDays.backgroundColor = ColorJobAlRedyInvitedApplied
            expandcell.viewFromEndDate.backgroundColor = ColorJobAlRedyInvitedApplied
            expandcell.btnApplyAlReadyInvited.backgroundColor = ColorJobAlRedyInvitedApplied

            
            expandcell.objCollectionView.reloadData()
            
            
            expandcell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
            
            expandcell.lblMiddelCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
            
            expandcell.lblMiddelTrial.text = "\(tempDict.object(forKey: "description")!)"
            expandcell.lbCompanyAddress.text = "\(tempDict.object(forKey: "street_name")!), \(tempDict.object(forKey: "address")!), \(tempDict.object(forKey: "address1")!), \(tempDict.object(forKey: "city")!), \(tempDict.object(forKey: "state")!)"
            
            
            
            let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
            var balanceRS = Int()
            balanceRS = balance.integerValue
            expandcell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
            expandcell.lblRatings.text =  "\(tempDict.object(forKey: "rating")!)"
            
            
            // Start Date
            let StartTime = "\(tempDict.object(forKey: "startHour")!)"
            let StartDate = "\(tempDict.object(forKey: "startDate")!)"
            let UTCStartDate = self.convertDateFormater(StartDate, hour: StartTime)
            
            var endTime = "\(tempDict.object(forKey: "endTime")!)"
            var endDate = tempDict.object(forKey: "endDate") as! String
            
            if endDate == "0000-00-00 00:00:00"
            {
                endDate = Localization(string: "No end Date")
            }
            else
            {
                endDate = tempDict.object(forKey: "endDate") as! String
                if  endTime == "" {
                    endTime = "00:00"
                }
                endDate = self.convertDateFormater(endDate, hour: endTime)
                endDate = self.convertDateFormaterUTC(endDate)
            }
            
            if endTime == "" {
                endTime = "00:00"
                expandcell.lblFromEndDate.text =  "From \n \(self.convertDateFormaterUTC(UTCStartDate)) \n to \n \(endDate) \n | \n From \n \(self.UTCToLocal(date: tempDict.object(forKey: "startHour")! as! String))h \n to \n No End Time"
            }else{
                expandcell.lblFromEndDate.text =  "From \n \(self.convertDateFormaterUTC(UTCStartDate)) \n to \n \(endDate) \n | \n From \n \(self.UTCToLocal(date: tempDict.object(forKey: "startHour")! as! String))h \n to \n \(self.UTCToLocal(date:tempDict.object(forKey: "endTime")! as! String))h"
            }
            

            
            
            let perDay = tempDict.object(forKey: "payment_type") as! String
            if perDay == "1"
            {
                expandcell.lblPerHour.text = "/" + "\(Localization(string: "hour"))"
            }
            else if perDay == "2"
            {
                expandcell.lblPerHour.text = "/" + "\(Localization(string: "job"))"
            }else{
                expandcell.lblPerHour.text = "/" + "\(Localization(string: "month"))"
            }

            
            let workingDays = tempDict.object(forKey: "workingDay") as! String
            if workingDays == "0"
            {
                expandcell.lblOnlyDays.text =  Localization(string: "Only business days")
            }
            else if perDay == "1"
            {
                expandcell.lblOnlyDays.text = Localization(string: "Includes non business days")
                
            }
            
            expandcell.btnApplyAlReadyInvited.tag = indexPath.row
            expandcell.btnApplyAlReadyInvited.addTarget(self, action: #selector(detail(sender:)), for: .touchUpInside)
            
            expandcell.btnApplyAlReadyInvited.setTitle("Follow Up", for: .normal)
            
            expandcell.contentView.layer.cornerRadius = 2.0
            expandcell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
            expandcell.contentView.layer.shadowOpacity = 0.5
            expandcell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            expandcell.contentView.layer.shadowRadius = 2.0

            
            return expandcell
            
        }
        else
        {
           // let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobDashBoardMainCell", for: indexPath) as! JobDashBoardMainCell
            
            
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobPendingInvitationMainCell", for: indexPath) as! JobPendingInvitationMainCell

            mainCell.selectionStyle = .none
            
                var tempDict = NSDictionary()
            tempDict = arrAcceptedInvitation.object(at: indexPath.row) as! NSDictionary

            mainCell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
            mainCell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
            mainCell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
                        
            let StartTime = "\(tempDict.object(forKey: "startHour")!)"
            let StartDate = "\(tempDict.object(forKey: "startDate")!)"
            let UTCStartDate = self.convertDateFormater(StartDate, hour: StartTime)
            
            mainCell.lblDate.text = self.convertDateFormaterUTC(UTCStartDate)
            
            
                let distance = tempDict.object(forKey: "distance") as! NSNumber
                print("distance is",distance)
                let distanceFloat: Float = distance.floatValue
                mainCell.lblLocation.text = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f", distanceFloat) + "Km"

                        mainCell.lblCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
                        mainCell.lblRating.text =  "\(tempDict.object(forKey: "rating")!)"
            
            let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
            var balanceRS = Int()
            balanceRS = balance.integerValue
            mainCell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"

            
            let perDay = tempDict.object(forKey: "payment_type") as! String
            if perDay == "1"
            {
                mainCell.lblPerHour.text = "/" + "\(Localization(string: "hour"))"
            }
            else if perDay == "2"
            {
                mainCell.lblPerHour.text = "/" + "\(Localization(string: "job"))"
            }else{
                mainCell.lblPerHour.text = "/" + "\(Localization(string: "month"))"
            }
            
            mainCell.viewLeft.isHidden = false
            mainCell.imgLocation.image = UIImage(named: "map_yellow")
           // map_yellow
            
            
            
            mainCell.contentView.layer.cornerRadius = 2.0
            mainCell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
            mainCell.contentView.layer.shadowOpacity = 0.5
            mainCell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            mainCell.contentView.layer.shadowRadius = 2.0
            
            return mainCell
            
        }
        
    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == currentIndex
//        {
//            return 330
//        }
//        else
//        {
//            return 90
//        }
//
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == currentIndex
        {
            currentIndex = -1
        }
        else
        {
            currentIndex = indexPath.row
        }
        
        tblPendingApplication.reloadData()
    }
    
    
    @IBAction func detail(sender :UIButton)
    {
        let buttonrow = sender.tag
        
        var tempDict = NSDictionary()
        tempDict = arrAcceptedInvitation.object(at: buttonrow) as! NSDictionary
        let jobId = tempDict.object(forKey: "jobId") as! String
        let type = tempDict.object(forKey: "type") as! NSNumber
        let jobTitle = tempDict.object(forKey: "jobTitle") as! String
        let companyName = tempDict.object(forKey: "companyName") as! String
       
        //let hasAcknowledge = tempDict.object(forKey: "companyName") as! String

        print("jobTitle is",jobTitle)
        print("type is",type)
        print("companyName is",companyName)

        if type ==  0{
            self.followUpAPI(jobId: jobId, METHOD_NAME: "followUpInvitations",companyName: companyName,jobTitle: jobTitle,type: type)
            
        }else{
            self.followUpAPI(jobId: jobId, METHOD_NAME: "followUp",companyName: companyName,jobTitle: jobTitle,type: type)
        }
    }

      // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    //MARK:- Refresh Controller methods -
    
    func refreshContoller()  {
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        refreshControl.tintColor = blueThemeColor
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        if #available(iOS 10.0, *) {
            self.tblPendingApplication.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    func refreshTable(refreshControl: UIRefreshControl) {
        
        isForRefresh = true
        self.getPendingApplication()
        
    }
    // MARK: - API call
    
    func getPendingApplication()
    {
        if  isForRefresh == false {
            SwiftLoader.show(animated: true)
        }
        /*
         {
         "isHired": 0, (0 - for pending application list, 1 - for ongoing job list)
         "userId": "77",
         "language": "en",
         "methodName": "getOnGoingJobs"
         }

         */
        
        //kJobLogInDict
        
       
        
        let param =  [WebServicesClass.METHOD_NAME: "getOnGoingJobs",
                      "isHired":"0",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
                      "language":appdel.userLanguage] as [String : Any]
        
        
        print("paramgetApplicationJobsApi",param)
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print("ResponseApplicationApi",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        let acceptedInvitation = dataDict.object(forKey: "acceptedInvitation") as! [Any]
                        
                        let tempArray = NSMutableArray()
                        tempArray.addObjects(from: acceptedInvitation)
                        
                        if self.arrAcceptedInvitation.count == 0 {
                            self.arrAcceptedInvitation.addObjects(from: acceptedInvitation)
                        }
                        if tempArray.count > self.arrAcceptedInvitation.count {
                            self.arrAcceptedInvitation.removeAllObjects()
                            self.arrAcceptedInvitation = NSMutableArray()
                            self.arrAcceptedInvitation.addObjects(from: acceptedInvitation)
                        }
                        if self.isForRefresh {
                            self.refreshControl.endRefreshing()
                            self.isForRefresh = false
                        }
                        
                        if self.arrAcceptedInvitation.count == 0
                        {
                            self.lblNoPendingApp.isHidden = false
                        }
                        self.tblPendingApplication.reloadData()
                    }
                    
                }
                else
                {
                    
//                    self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
//                    
//                    self.alertMessage.modalPresentationStyle = .overCurrentContext
//                    
//                    self.present(self.alertMessage, animated: false, completion: nil)
                    
                    self.lblNoPendingApp.isHidden = false

                   
                }
            }
        }
    }
    
    
    // MARK: - API call
    
    func followUpAPI(jobId:String,METHOD_NAME:String,companyName:String,jobTitle:String,type:NSNumber)
    {
        SwiftLoader.show(animated: true)
        
        /*
         "job_id": "240",
         "jobseeker_id": "77",
         "methodName": "followUp"
         */
    
        
        let param =  [WebServicesClass.METHOD_NAME: METHOD_NAME,
                      "jobseeker_id":"\(appdel.loginUserDict.object(forKey: "userId")!)",
                        "job_id":jobId] as [String : Any]
        
        
        print("ParamfollowUpAPI",param)
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print("ResponsefollowUpAPI",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                
                if status == 1
                {
                    let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                    
                    let jobFolloewUpStatusVC = storyBoard.instantiateViewController(withIdentifier: "JobApplyForJobVC") as! JobApplyForJobVC
                    jobFolloewUpStatusVC.companyName = companyName
                    jobFolloewUpStatusVC.jobTitle = jobTitle
                    jobFolloewUpStatusVC.employerStatus = dataDict?.value(forKey: "employerStatus") as! String
                    jobFolloewUpStatusVC.jobseekerStatus = dataDict?.value(forKey: "jobseekerStatus") as! String
                    jobFolloewUpStatusVC.type = type
                    jobFolloewUpStatusVC.jobId = jobId
                    jobFolloewUpStatusVC.hasAcknowledge = "0"

                    self.navigationController?.pushViewController(jobFolloewUpStatusVC, animated: true)
                }
                else
                {
                    print("Error","\(Response.object(forKey: "message")!)")
//                    self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
//                    
//                    self.alertMessage.modalPresentationStyle = .overCurrentContext
//                    
//                    self.present(self.alertMessage, animated: false, completion: nil)
                    
                    self.lblNoPendingApp.isHidden = false

                    
                }
                
                
            }
        }
    }

    
    @IBAction func clickBack(_ sender: Any) {
        
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
