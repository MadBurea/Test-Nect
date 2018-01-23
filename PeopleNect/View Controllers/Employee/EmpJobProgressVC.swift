//
//  EmpJobProgressVC.swift
//  PeopleNect
//
//  Created by Apple on 09/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader


class EmpJobProgressVC: UIViewController, UITableViewDelegate, UITableViewDataSource,SlideNavigationControllerDelegate {

    //@IBOutlet weak var lblNone : UILabel!
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet var lblJobHistory: UILabel!
    @IBOutlet var tblJobHistory: UITableView!
    
    @IBOutlet weak var lblNoHistory: UILabel!
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    
    
    var mainArray = ["abc","def"]
    var currentIndex = -1
    var previousIndex = -1
    
    var arrResponseJobs = NSMutableArray()
    
    var dictData = NSDictionary()

    var refreshControl = UIRefreshControl()
    var isForRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoHistory.isHidden = true
        
        
        
        self.tblJobHistory.rowHeight = UITableViewAutomaticDimension
        self.tblJobHistory.estimatedRowHeight = 80
        
        
        
        self.tblJobHistory.delegate = self
        self.tblJobHistory.dataSource = self
        
        
        self.intialSetupView()
        self.jobInProgressAPI()
    
        self.refreshContoller()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    func intialSetupView()
    {
        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrResponseJobs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == currentIndex
        {
           // let expandcell = tableView.dequeueReusableCell(withIdentifier: "EmpHistoryInnerCell", for: indexPath) as! EmpHistoryInnerCell
            
            
            let expandcell = tableView.dequeueReusableCell(withIdentifier: "EmpHistoryInnerCell", for: indexPath) as! EmpHistoryInnerCell

            expandcell.showHiredBtn.isHidden = false
            expandcell.rateCandidateBorderLbl.isHidden = true
            expandcell.RateCandidateBtn.isHidden = true
            expandcell.userRateTableView.isHidden = true
            expandcell.userRateTableheightConstraints.constant = 0
            expandcell.ProfessionalLblHeightConstant.constant = 0

            expandcell.professionalLblBottomConstraints.constant = 8
            expandcell.userTableTopConstraints.constant = 35

            
            

            expandcell.RateCandidateBtn.setTitle(Localization(string: "Rate Candidate"), for: .normal)
            expandcell.showHiredBtn.setTitle(Localization(string: "Show hired job seeker"), for: .normal)
            expandcell.rateCandidateWidthConstraints.constant = 125
            expandcell.showHiredBtn.tag = indexPath.row
            expandcell.showHiredBtn.addTarget(self, action: #selector(self.showHiredJobseeker), for: .touchUpInside)
            expandcell.RateCandidateBtn.tag = indexPath.row
            expandcell.RateCandidateBtn.addTarget(self, action: #selector(self.rateCandidateAction), for: .touchUpInside)
            
            expandcell.selectionStyle = .none
            previousIndex = currentIndex
            
            expandcell.viewLeft.backgroundColor = ColorJobSelected
            expandcell.viewPayment.backgroundColor = ColorJobSelected
            expandcell.viewOnlyDays.backgroundColor = ColorJobSelected
            expandcell.viewFromEndDate.backgroundColor = ColorJobSelected
            expandcell.lblBottomBorder.backgroundColor = ColorJobSelected
            expandcell.lblLineB.backgroundColor = ColorseperatorDarkGreen
            expandcell.lblLineA.backgroundColor = ColorseperatorDarkGreen
            
            
            
            var tempDict = NSDictionary()
            tempDict = arrResponseJobs.object(at: indexPath.row) as! NSDictionary
            let categoryList = tempDict.object(forKey: "subCategory") as! String
            
            
            
            //  For rating
            let jobseekerRating =  tempDict.object(forKey: "JobSeekerData") as! NSArray
            var showRating = false
            if jobseekerRating.count > 0 {
                expandcell.jobSeekerRating = jobseekerRating
                expandcell.userRateTableView.isHidden = false
            NotificationCenter.default.post(name:Notification.Name(rawValue:"reloadRatingTable"),object:nil)
                for i in jobseekerRating {
                    let userRating = i as! NSDictionary
                    let rating = userRating["rating"] as! NSString
                    if rating.length > 0 {
                        let intValue = rating.integerValue
                        if intValue == 0 {
                            showRating = true
                        }
                    }else{
                        showRating = true
                    }
                }
            }
            
            if let value = tempDict["is_rating_enable"]  {
                let is_rating_enable = value  as? NSNumber
                if tempDict.object(forKey: "is_rating_enable") is NSNull{
                }else{
                    if is_rating_enable == 1 {
                        showRating = true
                    }
                }
            }
                        
          
            if showRating {
                expandcell.rateCandidateBorderLbl.isHidden = false
                expandcell.RateCandidateBtn.isHidden = false
               expandcell.ProfessionalLblHeightConstant.constant = 20
                expandcell.professionalLblBottomConstraints.constant = 35
                expandcell.userTableTopConstraints.constant = 8
            }
            
            
            let categories = categoryList.characters.split{$0 == ","}.map(String.init)
            expandcell.arrSubCatData.removeAllObjects()
            
            if categories.count > 0
            {
                for i in 0...categories.count-1
                {
                    if i <= 2
                    {
                        expandcell.arrSubCatData.add(categories[i])
                        
                    }
                }
            }
            
            expandcell.objJobHistoryCollectionView.reloadData()
            expandcell.lblJob.text = (self.arrResponseJobs.object(at: indexPath.row) as! NSDictionary).value(forKey: "jobTitle") as! String?
            expandcell.lblFromEndDate.text =  "\(tempDict.object(forKey: "date")!)"
            expandcell.lblMiddelCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
            expandcell.lblMiddelTrial.text = "\(tempDict.object(forKey: "description")!)"
            
            
            
            
            let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
            var balanceRS = Int()
            balanceRS = balance.integerValue
            expandcell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
            expandcell.lblRatings.text =  "\(tempDict.object(forKey: "rating")!)"
            
            
            
            expandcell.lblProfessionalHired.isHidden = true
            expandcell.lblProfessionalHired.text = "No professional hired."
            
            expandcell.lbCompanyAddress.text = "\(tempDict.object(forKey: "street_name")!), \(tempDict.object(forKey: "address")!), \(tempDict.object(forKey: "address1")!), \(tempDict.object(forKey: "city")!), \(tempDict.object(forKey: "state")!)"
            
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
            
            
            let workingDays = tempDict.object(forKey: "workingDay") as! String
            if workingDays == "0"
            {
                expandcell.lblOnlyDays.text =  Localization(string: "Only business days")
            }
            else if perDay == "1"
            {
                expandcell.lblOnlyDays.text = Localization(string: "Includes non business days")
                
            }
            expandcell.contentView.layer.cornerRadius = 2.0
            
            expandcell.contentView.layer.shadowColor = UIColor.gray.cgColor
            expandcell.contentView.layer.shadowOpacity = 0.5
            expandcell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            expandcell.contentView.layer.shadowRadius = 2.0
            
            return expandcell
        }
        else
        {
            
            
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobPendingInvitationMainCell", for: indexPath) as! JobPendingInvitationMainCell
            
            mainCell.selectionStyle = .none
            
            var tempDict = NSDictionary()
            
            tempDict = arrResponseJobs.object(at: indexPath.row) as! NSDictionary
            
            
            mainCell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
            
            
            mainCell.lblLocation.isHidden = true
            mainCell.imgLocation.isHidden = true
            
            
            let StartTime = "\(tempDict.object(forKey: "startHour")!)"
            let StartDate = "\(tempDict.object(forKey: "startDate")!)"
            let UTCStartDate = self.convertDateFormater(StartDate, hour: StartTime)
            mainCell.lblDate.text = self.convertDateFormaterUTC(UTCStartDate)
            
            
            mainCell.lblCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
            mainCell.lblRating.text =  "\(tempDict.object(forKey: "rating")!)"
            
            
            
            let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
            var balanceRS = Int()
            balanceRS = balance.integerValue
            mainCell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
            
            
            //mainCell.lblPayment.text =  "$\(tempDict.object(forKey: "rate")!)"
            
            
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
            
            
            
            mainCell.contentView.layer.cornerRadius = 2.0
            
            mainCell.contentView.layer.shadowColor = UIColor.gray.cgColor
            mainCell.contentView.layer.shadowOpacity = 0.5
            mainCell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            mainCell.contentView.layer.shadowRadius = 2.0
            
            mainCell.viewLeft.isHidden = false
            
            return mainCell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == currentIndex
//        {
//            return 300
//        }
//        else
//        {
//            return UITableViewAutomaticDimension
//        }
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
        
        tblJobHistory.reloadData()
        
    }
    
   

    @IBAction func btnBackClick(sender : UIButton) {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)
    }
    
    
    //MARK:- Refresh Controller methods -
    
    func refreshContoller()  {
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        refreshControl.tintColor = blueThemeColor
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        if #available(iOS 10.0, *) {
            self.tblJobHistory.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    func refreshTable(refreshControl: UIRefreshControl) {
        
        isForRefresh = true
        self.jobInProgressAPI()
        
    }
    func showHiredJobseeker(sender:UIButton)  {
        var tempDict = NSDictionary()
        tempDict = arrResponseJobs.object(at: sender.tag) as! NSDictionary
        let jobseekerRating =  tempDict.object(forKey: "JobSeekerData") as! NSArray
        
        let jobDetail = self.storyboard?.instantiateViewController(withIdentifier: "EmpJobSeekerStatusVC") as! EmpJobSeekerStatusVC
        jobDetail.ArrayUserListing = jobseekerRating.mutableCopy() as! NSMutableArray
        jobDetail.currentIndex = 0
        jobDetail.fromJobRating = true
        jobDetail.fromDash = false
        self.navigationController?.pushViewController(jobDetail, animated: true)
    }
    func rateCandidateAction(sender:UIButton)  {
        
    }
    
    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    
    //MARK: - API call
    
    func jobInProgressAPI()
    {
        if  isForRefresh == false {
            SwiftLoader.show(animated: true)
        }
        /*
         "employerId": "37",
         "language": "en",
         "methodName": "jobInProgress"
         
         */
        
        let loginDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
        
        let param =  [WebServicesClass.METHOD_NAME: "jobInProgress",
                      "employerId":"\(loginDict.object(forKey: "employerId")!)",
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
                

                let status = dictResponse.object(forKey: "status") as! Int
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    
                    if let dataDict = (dictResponse.object(forKey: "data")) as? [Any]
                    {
                        
                        let tempArray = NSMutableArray()
                        tempArray.addObjects(from: dataDict)
                        
                        if self.arrResponseJobs.count == 0 {
                            self.arrResponseJobs.addObjects(from: dataDict)
                        }
                        if tempArray.count > self.arrResponseJobs.count {
                            self.arrResponseJobs.removeAllObjects()
                            self.arrResponseJobs = NSMutableArray()
                            self.arrResponseJobs.addObjects(from: dataDict)
                        }
                        if self.isForRefresh {
                            self.refreshControl.endRefreshing()
                            self.isForRefresh = false
                        }
                        
                        
                        if self.arrResponseJobs.count == 0
                        {
                            self.lblNoHistory.isHidden = false
                        }
                        
                    print("jobInProgress response is",self.arrResponseJobs)

                        self.tblJobHistory.delegate = self
                        self.tblJobHistory.dataSource = self
                        self.tblJobHistory.reloadData()
                    }
                }
                else
                {
                    
                    self.lblNoHistory.isHidden = false
                    
                }
                
                
            }
        }
    }

    
    
    
}
