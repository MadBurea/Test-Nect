//
//  EmpHistoryVC.swift
//  PeopleNect
//
//  Created by InexTure on 12/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class EmpHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,SlideNavigationControllerDelegate{
  
    
    @IBOutlet var lblJobHistory: UILabel!
    @IBOutlet var tblJobHistory: UITableView!
    
    @IBOutlet weak var viewTop: UIView!
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
        self.closedJobsAPI()
        
        
        self.tblJobHistory.register(UINib(nibName: "JobDashBoardMainCell", bundle: Bundle.main), forCellReuseIdentifier: "JobDashBoardMainCell")
        
        
//        EmpHistoryInnerCell
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrResponseJobs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == currentIndex
        {
            let expandcell = tableView.dequeueReusableCell(withIdentifier: "EmpHistoryInnerCell", for: indexPath) as! EmpHistoryInnerCell
           
            expandcell.historyRateBtn.isHidden = true
            expandcell.userRateTableView.isHidden = true
            expandcell.userRateTableheightConstraints.constant = 40
            expandcell.userTableTopConstraints.constant = 45
            expandcell.historyRateBtnHeightConstraints.constant = 0
            
            expandcell.historyRateBtn.setTitle(Localization(string: "Rate Candidate"), for: .normal)
            expandcell.selectionStyle = .none
            previousIndex = currentIndex
            var tempDict = NSDictionary()
            tempDict = arrResponseJobs.object(at: indexPath.row) as! NSDictionary
            let categoryList = tempDict.object(forKey: "subCategory") as! String
            
            //  For rating
            let jobseekerRating =  tempDict.object(forKey: "jobseekerRating") as! NSArray
            var showRating = false
            if jobseekerRating.count > 0 {
                expandcell.jobSeekerRating = jobseekerRating
                expandcell.userRateTableView.isHidden = false
                expandcell.userTableTopConstraints.constant = 55
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
            if showRating {
                expandcell.historyRateBtnHeightConstraints.constant = 40
                expandcell.userTableTopConstraints.constant = 5
                expandcell.historyRateBtn.isHidden = false
                expandcell.historyRateBtn.tag = indexPath.row
                expandcell.historyRateBtn.addTarget(self, action: #selector(self.gotToJobseekerRating), for: .touchUpInside)
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
            expandcell.lblMiddelCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
            expandcell.lblMiddelTrial.text = "\(tempDict.object(forKey: "description")!)"
            
            

            let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
            var balanceRS = Int()
            balanceRS = balance.integerValue
            
            
            if appdel.deviceLanguage == "pt-BR"
            {
                let number = NSNumber(value: balance.floatValue)
                expandcell.lblPayment.text = ConvertToPortuegeCurrency(number: number)
            }
            else
            {
                expandcell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
            }
            
            expandcell.lblRatings.text =  "\(tempDict.object(forKey: "rating")!)"
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
                endDate = "No end Date"
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
                expandcell.lblFromEndDate.text =  "\(strFrom) \n \(self.convertDateFormaterUTC(UTCStartDate)) \n \(strTo) \n \(endDate) \n | \n \(strFrom) \n \(self.UTCToLocal(date: tempDict.object(forKey: "startHour")! as! String))h \n to \n \(strNoEndDate)"
            }else{
                expandcell.lblFromEndDate.text =  "\(strFrom) \n \(self.convertDateFormaterUTC(UTCStartDate)) \n \(strTo) \n \(endDate) \n | \n \(strFrom) \n \(self.UTCToLocal(date: tempDict.object(forKey: "startHour")! as! String))h \n to \n \(self.UTCToLocal(date:tempDict.object(forKey: "endTime")! as! String))h"
            }
            
            let workingDays = tempDict.object(forKey: "workingDay") as! String
            
            if workingDays == "0"
            {
                expandcell.lblOnlyDays.text = strOnlyBussDays
            }
            else if perDay == "1"
            {
                expandcell.lblOnlyDays.text = strIncludesNonBussDays
            }
            
            let jobCanceledByEmployer = "\(tempDict.object(forKey: "jobCanceledByEmployer")!)"
            
            if jobCanceledByEmployer == "1"
            {
                expandcell.viewLeft.backgroundColor = ColorJobRefused
                expandcell.viewPayment.backgroundColor = ColorJobRefused
                expandcell.viewOnlyDays.backgroundColor = ColorJobRefused
                expandcell.viewFromEndDate.backgroundColor = ColorJobRefused
                expandcell.lblBottomBorder.backgroundColor = ColorJobRefused
            
                expandcell.lblLineA.backgroundColor = ColorseperatorDarkRed
                expandcell.lblLineB.backgroundColor = ColorseperatorDarkRed
            }
            else
            {
                expandcell.viewLeft.backgroundColor = blueThemeColor
                expandcell.viewPayment.backgroundColor = blueThemeColor
                expandcell.viewOnlyDays.backgroundColor = blueThemeColor
                expandcell.viewFromEndDate.backgroundColor = blueThemeColor
                expandcell.lblBottomBorder.backgroundColor = blueThemeColor
                
                expandcell.lblLineA.backgroundColor = ColorseperatorDarkBlue
                expandcell.lblLineB.backgroundColor = ColorseperatorDarkBlue
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
            
            
            if appdel.deviceLanguage == "pt-BR"
            {
                let number = NSNumber(value: balance.floatValue)
                mainCell.lblPayment.text = ConvertToPortuegeCurrency(number: number)
            }
            else
            {
                mainCell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
            }
            
            
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
            
          
            let jobCanceledByEmployer = "\(tempDict.object(forKey: "jobCanceledByEmployer")!)"
            if jobCanceledByEmployer == "1" {
                mainCell.viewLeft.backgroundColor = ColorJobRefused
                mainCell.lblBottomBorder.backgroundColor = ColorJobRefused
            }
            else
            {
                mainCell.viewLeft.backgroundColor = blueThemeColor
                mainCell.lblBottomBorder.backgroundColor = blueThemeColor
            }
            
            mainCell.viewLeft.isHidden = false
            mainCell.contentView.layer.cornerRadius = 2.0
            
            mainCell.contentView.layer.shadowColor = UIColor.gray.cgColor
            mainCell.contentView.layer.shadowOpacity = 0.5
            mainCell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            mainCell.contentView.layer.shadowRadius = 2.0
            
            return mainCell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
      //  tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
        self.closedJobsAPI()
    }
    

    @IBAction func clickBack(_ sender: Any) {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)

    }
    func gotToJobseekerRating(sender:UIButton)  {
        var tempDict = NSDictionary()
        let loginDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
        tempDict = arrResponseJobs.object(at: sender.tag) as! NSDictionary
        let jobseekerRating =  tempDict.object(forKey: "jobseekerRating") as! NSArray
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let reviewJob = storyBoard.instantiateViewController(withIdentifier: "ReviewJobNotifierVC") as! ReviewJobNotifierVC
        reviewJob.employerId = "\(loginDict.object(forKey: "employerId")!)"
        reviewJob.job_id = "\(tempDict.object(forKey: "jobId")!)"
        reviewJob.JobseekerDataFromRating = jobseekerRating
        reviewJob.fromRatingScreen = true
        self.navigationController?.pushViewController(reviewJob, animated: true)
    }
    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    
    //MARK: - API call
    
    func closedJobsAPI()
    {
        if  isForRefresh == false {
            SwiftLoader.show(animated: true)
        }
        /*
         "employerId": "2",
         "language": "en",
         "methodName": "closedJobs"
         
         
         ["methodName": "closedJobs", "language": "en", "userId": "3"]
         */
        
        let loginDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
        
        let param =  [WebServicesClass.METHOD_NAME: "closedJobs",
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
                
                print("Employer History is",dictResponse)
                
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
                        
                        self.tblJobHistory.delegate = self
                        self.tblJobHistory.dataSource = self
                        self.tblJobHistory.reloadData()
                    }
                }
                else
                {
                    print(Error.self)
                    
                    self.lblNoHistory.isHidden = false
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
