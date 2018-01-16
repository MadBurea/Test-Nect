//
//  JobOnGoingJobsVC.swift
//  PeopleNect
//
//  Created by Apple on 28/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class JobOnGoingJobsVC: UIViewController, UITableViewDataSource , UITableViewDelegate,SlideNavigationControllerDelegate {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet var lblOnGoingJobs: UILabel!
    @IBOutlet var tblOnGoingJobs: UITableView!
    @IBOutlet var lblNoOnGoingJobs: UILabel!
    
    var global = WebServicesClass()
    
    var alertMessage = AlertMessageVC()
    
    var arrOnGoingJobs = NSMutableArray()
    
    var currentIndex = -1
    var previousIndex = -1
    
    var refreshControl = UIRefreshControl()
    var isForRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblOnGoingJobs.rowHeight = UITableViewAutomaticDimension
        self.tblOnGoingJobs.estimatedRowHeight = 80
        
        self.lblNoOnGoingJobs.isHidden = true

        self.refreshContoller()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentIndex = -1
        previousIndex = -1
        arrOnGoingJobs.removeAllObjects()
        arrOnGoingJobs = NSMutableArray()
       
        self.getOnGoingJobAPI()
        
        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0
        
        
        // refresh Controller
        self.refreshContoller()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOnGoingJobs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //   let empTableItem = tableItems[indexPath.row]
        
        if indexPath.row == currentIndex
        {
            let expandcell = tableView.dequeueReusableCell(withIdentifier: "JobOnGoingJobsInnerCell", for: indexPath) as! JobOnGoingJobsInnerCell
            expandcell.selectionStyle = .none
            previousIndex = currentIndex
            
            expandcell.topBottomLblConstraints.constant = 0
            expandcell.empRatingBorderLbl.isHidden = true
            expandcell.empRatingBtn.isHidden = true
            expandcell.employerRatingLbl.isHidden = true
            

            expandcell.empRatingBtn.setTitle(Localization(string: "Rate Employer"), for: .normal)
            
            if appdel.deviceLanguage == "pt-BR"
            {
                expandcell.empratingBtnWidthConstraints.constant = 160
            }
            else
            {
                expandcell.empratingBtnWidthConstraints.constant = 135
            }
            
            
            var tempDict = NSDictionary()
            tempDict = arrOnGoingJobs.object(at: indexPath.row) as! NSDictionary
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
            
            
            
            expandcell.viewLeft.backgroundColor = ColorJobSelected
            expandcell.lblBottomBorder.backgroundColor = ColorJobSelected
            
            expandcell.viewPayment.backgroundColor = ColorJobSelected
            expandcell.viewOnlyDays.backgroundColor = ColorJobSelected
            expandcell.viewFromEndDate.backgroundColor = ColorJobSelected
            expandcell.btnSeeDetails.backgroundColor = ColorJobSelected
            
            
            
            expandcell.objOnGoingJobsCollectionView.reloadData()
            
            expandcell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
            
            
            expandcell.lblMiddelCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
            
            expandcell.lblMiddelTrial.text = "\(tempDict.object(forKey: "description")!)"
            
            
            let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
            var balanceRS = Int()
            balanceRS = balance.integerValue
            expandcell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
            
            expandcell.lblRatings.text =  "\(tempDict.object(forKey: "rating")!)"
            
            expandcell.lbCompanyAddress.text = "\(tempDict.object(forKey: "street_name")!), \(tempDict.object(forKey: "address")!), \(tempDict.object(forKey: "address1")!), \(tempDict.object(forKey: "city")!), \(tempDict.object(forKey: "state")!)"
            
            
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
            
            expandcell.btnSeeDetails.tag = indexPath.row
            expandcell.btnSeeDetails.setTitle("See details", for: .normal)
            expandcell.btnSeeDetails.addTarget(self, action: #selector(detail(sender:)), for: .touchUpInside)
            expandcell.contentView.layer.cornerRadius = 2.0
            expandcell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
            expandcell.contentView.layer.shadowOpacity = 0.5
            expandcell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            expandcell.contentView.layer.shadowRadius = 2.0
            
            
            if let value = tempDict["is_rating_enable"]  {
                let is_rating_enable = value  as? NSNumber
                if tempDict.object(forKey: "is_rating_enable") is NSNull{
                }else{
                    if is_rating_enable == 1 {
                        let rating = tempDict["rating"] as! NSString
                        expandcell.topBottomLblConstraints.constant = 40
                        if rating.length>0{
                            let intValue = rating.integerValue
                        if intValue == 0 {
                            expandcell.empRatingBtn.tag = indexPath.row
                            expandcell.empRatingBtn.accessibilityHint = "\(indexPath.section)"
                            expandcell.empRatingBtn.addTarget(self, action: #selector(gotoRateEmployer(sender:)), for: .touchUpInside)
                            expandcell.empRatingBtn.isHidden = false
                            expandcell.empRatingBorderLbl.isHidden = false
                        }else{
                            expandcell.employerRatingLbl.isHidden = false
                            expandcell.employerRatingLbl.text = "You have rated " + "\(rating)"
                            }
                        }else{
                            expandcell.empRatingBtn.tag = indexPath.row
                            expandcell.empRatingBtn.accessibilityHint = "\(indexPath.section)"
                            expandcell.empRatingBtn.addTarget(self, action: #selector(gotoRateEmployer(sender:)), for: .touchUpInside)
                            expandcell.empRatingBtn.isHidden = false
                            expandcell.empRatingBorderLbl.isHidden = false
                        }
                    }
                }
            }
            
            return expandcell
            
        }
        else
        {
            //let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobOnGoingJobsMainCell", for: indexPath) as! JobOnGoingJobsMainCell
            
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobPendingInvitationMainCell", for: indexPath) as! JobPendingInvitationMainCell

            
            mainCell.selectionStyle = .none
            var tempDict = NSDictionary()
            tempDict = arrOnGoingJobs.object(at: indexPath.row) as! NSDictionary
            
            mainCell.viewLeft.backgroundColor = ColorJobSelected
            mainCell.lblBottomBorder.backgroundColor = ColorJobSelected
            
            
            mainCell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
            
            let StartTime = "\(tempDict.object(forKey: "startHour")!)"
            let StartDate = "\(tempDict.object(forKey: "startDate")!)"
            let UTCStartDate = self.convertDateFormater(StartDate, hour: StartTime)
            mainCell.lblDate.text = self.convertDateFormaterUTC(UTCStartDate)
            
            
            mainCell.lblCompany.text =  "\(tempDict.object(forKey: "companyName")!)"
            let distance = tempDict.object(forKey: "distance") as! NSNumber
            print("distance is",distance)
            let distanceFloat: Float = distance.floatValue
            mainCell.lblLocation.text = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f", distanceFloat) + "Km"
            mainCell.lblRating.text =  "\(tempDict.object(forKey: "rating")!)"
            
            

            let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
            var balanceRS = Int()
            balanceRS = balance.integerValue
            mainCell.lblPayment.text = "$\(balanceRS.withCommas())" + ".00"
            
           // mainCell.lblPayment.text =  "$\(tempDict.object(forKey: "rate")!)"
            
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
            
            tblOnGoingJobs.tableFooterView = UIView()
            
            mainCell.contentView.layer.cornerRadius = 5.0
            mainCell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
            mainCell.contentView.layer.shadowOpacity = 0.5
            mainCell.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
            mainCell.contentView.layer.shadowRadius = 2.0

            
            return mainCell
            
        }
        
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
        
        tblOnGoingJobs.reloadData()
        
    }
   
    
    @IBAction func detail(sender :UIButton)
    {
        let buttonrow = sender.tag
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let jobOnGoingDetailsVC = storyBoard.instantiateViewController(withIdentifier: "JobOnGoingDetailsVC") as! JobOnGoingDetailsVC
        var tempDict = NSDictionary()
        tempDict = arrOnGoingJobs.object(at: buttonrow) as! NSDictionary
        print("tempdict is ",tempDict)
        jobOnGoingDetailsVC.hasAcknowledge = "\(tempDict.object(forKey: "has_acknowledge")!)"
        jobOnGoingDetailsVC.jobId = "\(tempDict.object(forKey: "jobId")!)"
        jobOnGoingDetailsVC.type = "\(tempDict.object(forKey: "type")!)"
        self.navigationController?.pushViewController(jobOnGoingDetailsVC, animated: true)
    }
    
    @IBAction func gotoRateEmployer(sender :UIButton)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let rateEmp = storyBoard.instantiateViewController(withIdentifier: "RateEmployee") as! RateEmployee
        
        var tempDict = NSDictionary()
        tempDict = arrOnGoingJobs.object(at: sender.tag) as! NSDictionary
        
        rateEmp.userId = "\(appdel.loginUserDict.object(forKey: "userId")!)"
        rateEmp.employerId = "\(tempDict.object(forKey: "employerId")!)"
        rateEmp.jobId = "\(tempDict.object(forKey: "jobId")!)"
        rateEmp.companyName = "\(tempDict.object(forKey: "companyName")!)"
        rateEmp.jobTitle = "\(tempDict.object(forKey: "jobTitle")!)"
        rateEmp.fromNotification = true
        self.navigationController?.pushViewController(rateEmp, animated: true)
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
            self.tblOnGoingJobs.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    func refreshTable(refreshControl: UIRefreshControl) {
        
        isForRefresh = true
        self.getOnGoingJobAPI()
        
    }
    
    // MARK: - API call
    
    func getOnGoingJobAPI()
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
        
        
        let param =  [WebServicesClass.METHOD_NAME: "getOnGoingJobs",
                      "isHired":"1",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                print("ResponseApplicationApi ongoing",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        let onGoingJobs = dataDict.object(forKey: "nextJobCollection") as! [Any]
                        
                        
                        let tempArray = NSMutableArray()
                        tempArray.addObjects(from: onGoingJobs)
                        
                        if self.arrOnGoingJobs.count == 0 {
                            self.arrOnGoingJobs.addObjects(from: onGoingJobs)
                        }
                        if tempArray.count > self.arrOnGoingJobs.count {
                            self.arrOnGoingJobs.removeAllObjects()
                            self.arrOnGoingJobs = NSMutableArray()
                            self.arrOnGoingJobs.addObjects(from: onGoingJobs)
                        }
                        if self.isForRefresh {
                            self.refreshControl.endRefreshing()
                            self.isForRefresh = false
                        }
                        
                        if self.arrOnGoingJobs.count == 0
                        {
                        self.lblNoOnGoingJobs.isHidden = false
                        }
                        
                        
                        self.tblOnGoingJobs.delegate = self
                        self.tblOnGoingJobs.dataSource = self
                        self.tblOnGoingJobs.reloadData()
                    }
                    
                }
                else
                {
                    
//                    self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
//                    
//                    self.alertMessage.modalPresentationStyle = .overCurrentContext
//                    
//                    self.present(self.alertMessage, animated: false, completion: nil)
                    
                   // self.lblOnGoingJobs.isHidden = false
                    
                    self.lblNoOnGoingJobs.isHidden = false

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
