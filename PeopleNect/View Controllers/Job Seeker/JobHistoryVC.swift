//
//  JobHistoryVC.swift
//  PeopleNect
//
//  Created by Apple on 29/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

//
//class HeaderCell: UITableViewCell {
//    
//    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var toggleButton: UIButton!
//    
//}


class JobHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource,SlideNavigationControllerDelegate  {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet var lblJobHistory: UILabel!
    @IBOutlet var tblJobHistory: UITableView!
    
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()

    
    var mainArray = ["abc","def"]
    var currentIndex = -1
    var previousIndex = -1
    
    
    var arrjobHistory = NSMutableArray()
    var arrDeclinedJobs = NSMutableArray()
    var arrOtherJobs = NSMutableArray()

    
    let kHeaderSectionTag: Int = 6900;

    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    
     var thelblCount1 = UILabel()
     var thelblCount2 = UILabel()
     var thelblCount3 = UILabel()
   
    var refreshControl = UIRefreshControl()
    var isForRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        thelblCount1 = UILabel(frame: CGRect(x: 140, y: 10, width: 50, height: 20))
        thelblCount2 = UILabel(frame: CGRect(x: 140, y: 10, width: 50, height: 20))
        thelblCount3 = UILabel(frame: CGRect(x: 140, y: 10, width: 50, height: 20))
        

        self.tblJobHistory.delegate = self
        self.tblJobHistory.dataSource = self
        self.tblJobHistory.rowHeight = UITableViewAutomaticDimension
        self.tblJobHistory.estimatedRowHeight = 80
        self.tblJobHistory.backgroundColor = UIColor.clear

        sectionNames = [Localization(string: "Job history"), Localization(string: "Declined jobs"), Localization(string: "Other jobs")];
        

        self.tblJobHistory!.tableFooterView = UIView()
        self.tblJobHistory.backgroundColor = UIColor.white
        
        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0
        
        //Refresh Controller
        self.refreshContoller()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.jobHistoryAPI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arrjobHistory.removeAllObjects()
        self.arrOtherJobs.removeAllObjects()
        self.arrDeclinedJobs.removeAllObjects()
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
        self.jobHistoryAPI()
    }
   
    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    
    
    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tblJobHistory.backgroundView = nil
            return sectionNames.count
        } else {

        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count;
        }
        else {
            return 0;
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 20.0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let header = UIView()

        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView?.backgroundColor = UIColor.clear
        header.backgroundColor = UIColor.clear
        
        header.backgroundColor = UIColor(red:155.0/255.0, green:155.0/255.0 ,blue:155.0/255.0 , alpha:1.00)

        
        var mainLbl = UILabel()
        if appdel.deviceLanguage == "pt-BR"
        {
            // findJobLbl.text = Localization(string: "FIND A JOB")
            mainLbl = UILabel(frame: CGRect(x: 8, y: 10, width: 210, height: 20))
        }
        else
        {
            // findJobLbl.text =  "FIND \n A JOB"
            mainLbl = UILabel(frame: CGRect(x: 8, y: 10, width: 150, height: 20))
        }
        
        
        
        mainLbl.textColor = UIColor.white
        mainLbl.text = self.sectionNames[section] as? String
        header.addSubview(mainLbl)
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        
        
        var theImageView = UIImageView()
        var thelblCount = UILabel()

        if appdel.deviceLanguage == "pt-BR"
        {
            theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 80, y: 10, width: 20, height: 20))
            thelblCount = UILabel(frame: CGRect(x: 210, y: 10, width: 50, height: 20))
        }
        else
        {
             theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 80, y: 10, width: 20, height: 20))
            thelblCount = UILabel(frame: CGRect(x: 120, y: 10, width: 50, height: 20))
        }
        
        thelblCount.backgroundColor = UIColor.clear
        theImageView.contentMode = .scaleAspectFit
        thelblCount.textColor = UIColor.white
        
        theImageView.image = UIImage(named: "left_arrow")
        theImageView.tag = kHeaderSectionTag + section
        
        let button = UIButton(frame: CGRect(x: header.frame.origin.x, y: header.frame.origin.y, width: header.frame.size.width, height: header.frame.size.height))
        
        button.tag = section
        button.addTarget(self, action: #selector(self.expandSection(sender:)), for: .touchUpInside)
        
        header.addSubview(theImageView)
        header.addSubview(thelblCount)
        header.addSubview(button)
        
        
        if section == 0
        {
            thelblCount.text = ""
            thelblCount.text = "(\(arrjobHistory.count))"
        }
        
        
        if section == 1
        {
            thelblCount.text = ""
            thelblCount.text = "(\(arrDeclinedJobs.count))"
            
        }
        
        if section == 2
        {
            thelblCount.text = ""
            thelblCount.text = "(\(arrOtherJobs.count))"
        }
        
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
        
        return header
    }
    
    //////////
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView?.backgroundColor = UIColor.white
        
        footer.backgroundColor = UIColor(red:251.0/255.0, green:251.0/255.0 ,blue:251.0/255.0 , alpha:1.00)

        return footer
    }
    
    
    
    func expandSection(sender:UIButton)  {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if indexPath.row == currentIndex
        {

            let expandcell = tableView.dequeueReusableCell(withIdentifier: "JobHistoryInnerCell", for: indexPath) as! JobHistoryInnerCell
            
            expandcell.selectionStyle = .none
            expandcell.employerratingLbl.isHidden = true
            expandcell.rateEmployerBtn.isHidden = true
             expandcell.ratingBtnBorderLbl.isHidden = true
            previousIndex = currentIndex
            
            
          expandcell.rateEmployerBtn.setTitle(Localization(string: "Rate Employer"), for: .normal)

            if appdel.deviceLanguage == "pt-BR"
            {
               expandcell.RateBtnWidthConstraints.constant = 160

            }
            else
            {
                expandcell.RateBtnWidthConstraints.constant = 135
            }
            
            var tempDict = NSDictionary()
            
            if indexPath.section == 0
            {
                tempDict = arrjobHistory.object(at: indexPath.row) as! NSDictionary
                expandcell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                expandcell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
                
                expandcell.borderBottomLbl.backgroundColor = ColorseperatorDarkYellow
                expandcell.borderTopLbl.backgroundColor = ColorseperatorDarkYellow

                expandcell.viewPayment.backgroundColor = ColorJobAlRedyInvitedApplied
                expandcell.viewOnlyDays.backgroundColor = ColorJobAlRedyInvitedApplied
                expandcell.viewFromEndDate.backgroundColor = ColorJobAlRedyInvitedApplied
            }
            else if indexPath.section == 1
            {
                tempDict = arrDeclinedJobs.object(at: indexPath.row) as! NSDictionary
                expandcell.viewLeft.backgroundColor = ColorJobRefused
                expandcell.lblBottomBorder.backgroundColor = ColorJobRefused
                expandcell.viewPayment.backgroundColor = ColorJobRefused
                expandcell.viewOnlyDays.backgroundColor = ColorJobRefused
                expandcell.viewFromEndDate.backgroundColor = ColorJobRefused
                
                expandcell.borderBottomLbl.backgroundColor = ColorseperatorDarkRed
                expandcell.borderTopLbl.backgroundColor = ColorseperatorDarkRed
            }
            if indexPath.section == 2
            {
                tempDict = arrOtherJobs.object(at: indexPath.row) as! NSDictionary
                expandcell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                expandcell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
                expandcell.viewPayment.backgroundColor = ColorJobAlRedyInvitedApplied
                expandcell.viewOnlyDays.backgroundColor = ColorJobAlRedyInvitedApplied
                expandcell.viewFromEndDate.backgroundColor = ColorJobAlRedyInvitedApplied
                
                
                let cancel  = "\(tempDict.object(forKey: "jobCanceledByEmployer")!)"
                let tracking  = "\(tempDict.object(forKey: "jobTrackingStatus")!)"
                
                if cancel == "1" || tracking == "2" {
                    expandcell.viewLeft.backgroundColor = ColorJobRefused
                    expandcell.lblBottomBorder.backgroundColor = ColorJobRefused
                    expandcell.viewPayment.backgroundColor = ColorJobRefused
                    expandcell.viewOnlyDays.backgroundColor = ColorJobRefused
                    expandcell.viewFromEndDate.backgroundColor = ColorJobRefused
                    
                    expandcell.borderBottomLbl.backgroundColor = ColorseperatorDarkRed
                    expandcell.borderTopLbl.backgroundColor = ColorseperatorDarkRed
                    
                }else{
                    expandcell.borderBottomLbl.backgroundColor = ColorseperatorDarkYellow
                    expandcell.borderTopLbl.backgroundColor = ColorseperatorDarkYellow
                    expandcell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewPayment.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewOnlyDays.backgroundColor = ColorJobAlRedyInvitedApplied
                    expandcell.viewFromEndDate.backgroundColor = ColorJobAlRedyInvitedApplied
                }
            }
            
            
            
            if let value = tempDict["is_rating_enable"]  {
                let is_rating_enable = value  as? NSNumber
                if tempDict.object(forKey: "is_rating_enable") is NSNull{
                }else{
                    if is_rating_enable == 1 {
                        let rating = tempDict["rating"] as! NSString
                        if rating.length>0{
                            let intValue = rating.integerValue
                            if intValue == 0 {
                                expandcell.rateEmployerBtn.tag = indexPath.row
                                expandcell.rateEmployerBtn.accessibilityHint = "\(indexPath.section)"
                                expandcell.rateEmployerBtn.addTarget(self, action: #selector(gotoRateEmployer(sender:)), for: .touchUpInside)
                                expandcell.rateEmployerBtn.isHidden = false
                                expandcell.ratingBtnBorderLbl.isHidden = false
                            }else{
                                expandcell.employerratingLbl.isHidden = false
                                expandcell.employerratingLbl.text = "You have rated " + "\(rating)"
                            }
                           
                        }else{
                            expandcell.rateEmployerBtn.tag = indexPath.row
                            expandcell.rateEmployerBtn.accessibilityHint = "\(indexPath.section)"
                            expandcell.rateEmployerBtn.addTarget(self, action: #selector(gotoRateEmployer(sender:)), for: .touchUpInside)
                            expandcell.rateEmployerBtn.isHidden = false
                            expandcell.ratingBtnBorderLbl.isHidden = false
                        }
                    }
                }
            }
            
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
                    }
                }
            }
            
            expandcell.objJobHistoryCollectionView.reloadData()
            expandcell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
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
            
            // Start Date
            let StartTime = "\(tempDict.object(forKey: "startHour")!)"
            let StartDate = "\(tempDict.object(forKey: "startDate")!)"
            let UTCStartDate = self.convertDateFormater(StartDate, hour: StartTime)
            
            var endTime = "\(tempDict.object(forKey: "endTime")!)"
            var endDate = tempDict.object(forKey: "endDate") as! String
            
            if endDate == "0000-00-00 00:00:00"
            {
                endDate = Localization(string: "No end Date")
                // findJobLbl.text =

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
            
            expandcell.contentView.layer.cornerRadius = 5.0
            expandcell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
            expandcell.contentView.layer.shadowOpacity = 0.5
            expandcell.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
            expandcell.contentView.layer.shadowRadius = 2.0

            return expandcell
        }
        else
        {
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobHistoryMainCell", for: indexPath) as! JobHistoryMainCell

            mainCell.selectionStyle = .none
            var tempDict = NSDictionary()

            
            if indexPath.section == 0
            {
                tempDict = arrjobHistory.object(at: indexPath.row) as! NSDictionary
                mainCell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                mainCell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
            }
            else if indexPath.section == 1
            {
                tempDict = arrDeclinedJobs.object(at: indexPath.row) as! NSDictionary
                mainCell.viewLeft.backgroundColor = ColorJobRefused
                mainCell.lblBottomBorder.backgroundColor = ColorJobRefused
            }
            if indexPath.section == 2
            {
                tempDict = arrOtherJobs.object(at: indexPath.row) as! NSDictionary
                
                
                let cancel  = "\(tempDict.object(forKey: "jobCanceledByEmployer")!)"
                let tracking  = "\(tempDict.object(forKey: "jobTrackingStatus")!)"
                

                if cancel == "1"  || tracking == "2"{
                    mainCell.viewLeft.backgroundColor = ColorJobRefused
                    mainCell.lblBottomBorder.backgroundColor = ColorJobRefused

                }else{
                    mainCell.viewLeft.backgroundColor = ColorJobAlRedyInvitedApplied
                    mainCell.lblBottomBorder.backgroundColor = ColorJobAlRedyInvitedApplied
                }
                
            }
            
            mainCell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"
            
            
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
            
            mainCell.viewLeft.isHidden = false

            mainCell.contentView.layer.cornerRadius = 2.0
            mainCell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
            mainCell.contentView.layer.shadowOpacity = 0.5
            mainCell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            mainCell.contentView.layer.shadowRadius = 2.0
            
            return mainCell
        }

        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    

    // MARK: - Expand / Collapse Methods
    
    func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        
        
        let headerView = sender.view!
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView

        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section)
            {

                tableViewCollapeSection(section, imageView: eImageView!)
            }
            else {
                

                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            
            imageView.image = UIImage(named: "left_arrow")
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tblJobHistory!.beginUpdates()
            self.tblJobHistory!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tblJobHistory!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        

        let sectionData = self.sectionItems[section] as! NSArray
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            imageView.image = UIImage(named: "downarrow")
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tblJobHistory!.beginUpdates()
            self.tblJobHistory!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tblJobHistory!.endUpdates()
        }
    }
    
    @IBAction func gotoRateEmployer(sender :UIButton)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let rateEmp = storyBoard.instantiateViewController(withIdentifier: "RateEmployee") as! RateEmployee
        
        var tempDict = NSDictionary()
        if sender.accessibilityHint == "0"
        {
            tempDict = arrjobHistory.object(at: sender.tag) as! NSDictionary
        }
        else if sender.accessibilityHint == "1"
        {
            tempDict = arrDeclinedJobs.object(at: sender.tag) as! NSDictionary
        }
        else if sender.accessibilityHint == "2"
        {
            tempDict = arrOtherJobs.object(at: sender.tag) as! NSDictionary
        }
        
        rateEmp.userId = "\(appdel.loginUserDict.object(forKey: "userId")!)"
        rateEmp.employerId = "\(tempDict.object(forKey: "employerId")!)"
        rateEmp.jobId = "\(tempDict.object(forKey: "jobId")!)"
        rateEmp.companyName = "\(tempDict.object(forKey: "companyName")!)"
        rateEmp.jobTitle = "\(tempDict.object(forKey: "jobTitle")!)"
        rateEmp.fromNotification = true
        self.navigationController?.pushViewController(rateEmp, animated: true)
    }
    
    //MARK: - API call
    func jobHistoryAPI()
    {
        if  isForRefresh == false {
            SwiftLoader.show(animated: true)
        }
        
        
        let param =  [WebServicesClass.METHOD_NAME: "jobHistory",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            
            if error != nil
            {

            }
            else
            {
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                print("dictResponse of job history is",dictResponse)
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        
                        
        // Job History
      
                        let jobHistory = dataDict.object(forKey: "jobHistory") as! [Any]

                        let tempjobHistoryArray = NSMutableArray()
                        tempjobHistoryArray.addObjects(from: jobHistory)

                        if self.arrjobHistory.count == 0 {
                            self.arrjobHistory.addObjects(from: jobHistory)
                        }
                        if tempjobHistoryArray.count > self.arrjobHistory.count {
                            self.arrjobHistory.removeAllObjects()
                            self.arrjobHistory = NSMutableArray()
                            self.arrjobHistory.addObjects(from: jobHistory)
                        }
                        
                        
        //Declined Jobs
                        let otherInvitation = dataDict.object(forKey: "otherInvitation") as! [Any]
                        
                        let tempDeclineArray = NSMutableArray()
                        tempDeclineArray.addObjects(from: otherInvitation)
                        
                        if self.arrOtherJobs.count == 0 {
                            self.arrOtherJobs.addObjects(from: otherInvitation)
                        }
                        if tempDeclineArray.count > self.arrOtherJobs.count {
                            self.arrOtherJobs.removeAllObjects()
                            self.arrOtherJobs = NSMutableArray()
                            self.arrOtherJobs.addObjects(from: otherInvitation)
                        }
                        
                        
        //other Jobs
                        let rejectedInvitation = dataDict.object(forKey: "rejectedInvitation") as! [Any]

                        
                        let temprejectedArray = NSMutableArray()
                        temprejectedArray.addObjects(from: rejectedInvitation)
                        
                        if self.arrDeclinedJobs.count == 0 {
                            self.arrDeclinedJobs.addObjects(from: rejectedInvitation)
                        }
                        if tempDeclineArray.count > self.arrDeclinedJobs.count {
                            self.arrDeclinedJobs.removeAllObjects()
                            self.arrDeclinedJobs = NSMutableArray()
                            self.arrDeclinedJobs.addObjects(from: rejectedInvitation)
                        }
                        
                       
                        if self.isForRefresh {
                            self.refreshControl.endRefreshing()
                            self.isForRefresh = false
                        }
                        
                        self.sectionItems = [self.arrjobHistory,self.arrDeclinedJobs,self.arrOtherJobs];
                        self.tblJobHistory.reloadData()
                        
                    }
                }
                else
                {
                  
                }
                
                
            }
        }
    }


    @IBAction func clickBack(_ sender: Any) {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
