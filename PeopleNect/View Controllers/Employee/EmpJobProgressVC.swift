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
            
            
            
            expandcell.lblProfessionalHired.isHidden = false
            expandcell.lblProfessionalHired.text = "No professional hired."
            
            
            expandcell.lbCompanyAddress.text = "\(tempDict.object(forKey: "street_name")!), \(tempDict.object(forKey: "address")!), \(tempDict.object(forKey: "address1")!), \(tempDict.object(forKey: "city")!), \(tempDict.object(forKey: "state")!)"
            
            
            
            
            let perDay = tempDict.object(forKey: "payment_type") as! String
            
            if perDay == "1"
            {
                expandcell.lblPerHour.text = "/hour"
            }
            else if perDay == "2"
            {
                expandcell.lblPerHour.text = "/job"
            } else{
                expandcell.lblPerHour.text = "/month"
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
                expandcell.lblFromEndDate.text =  "From \n \(self.convertDateFormaterUTC(UTCStartDate)) \n to \n \(endDate) \n | \n From \n \(self.UTCToLocal(date: tempDict.object(forKey: "startHour")! as! String))h \n to \n No End Time"
            }else{
                expandcell.lblFromEndDate.text =  "From \n \(self.convertDateFormaterUTC(UTCStartDate)) \n to \n \(endDate) \n | \n From \n \(self.UTCToLocal(date: tempDict.object(forKey: "startHour")! as! String))h \n to \n \(self.UTCToLocal(date:tempDict.object(forKey: "endTime")! as! String))h"
            }
            
            
            
            
            let workingDays = tempDict.object(forKey: "workingDay") as! String
            
            
            if workingDays == "0"
            {
                expandcell.lblOnlyDays.text = "Only business days"
            }
            else if perDay == "1"
            {
                expandcell.lblOnlyDays.text = "Includes non Business days"
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
                mainCell.lblPerHour.text = "/hour"
            }
            else if perDay == "2"
            {
                mainCell.lblPerHour.text = "/job"
            }
            else{
                mainCell.lblPerHour.text = "/month"
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
            "language":"en"] as [String : Any]
        
        
        print("paramclosedJobsApi",param)
        
        
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