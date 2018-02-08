//
//  EmpSelectionProgressVC.swift
//  PeopleNect
//
//  Created by Apple on 09/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class EmptyCell: UITableViewCell
{
    @IBOutlet weak var lblEmpty: UILabel!
}

class EmpSelectionProgressVC: UIViewController, UITableViewDelegate, UITableViewDataSource,SlideNavigationControllerDelegate {

    @IBOutlet var tblJobHistory: UITableView!
    
    @IBOutlet weak var viewTop: UIView!
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    

    var currentIndex = -1

    var currentSection = -1

    
    var arrResponseJobs = NSMutableArray()
    var arrResSelInProgress = NSMutableArray()

    
    var refreshControl = UIRefreshControl()
    var isForRefresh = false
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblJobHistory.rowHeight = UITableViewAutomaticDimension
        self.tblJobHistory.estimatedRowHeight = 80
        
        
        self.tblJobHistory.delegate = self
        self.tblJobHistory.dataSource = self
        

        
        self.intialSetupView()
        
        self.openJobsAPI()
        
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
    
    //MARK: - API Call
    
    func openJobsAPI()
    {
        if  isForRefresh == false {
            SwiftLoader.show(animated: true)
        }
        /*
         ""employerId"": ""2"",
         ""language"": ""en"",
         ""methodName"": ""openJobs""
         */
        
        let loginDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
        
        let param =  [WebServicesClass.METHOD_NAME: "openJobs",
                      "employerId":"\(loginDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        
        print("paramopenJobsAPI",param)
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print("ResponseclosedJobsApi",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        
                        
                        if let hired = dataDict.object(forKey: "jobsForGuest") as? NSArray
                        {
                            if hired.count > 0
                            {
                                let tempArray = NSMutableArray()
                                tempArray.addObjects(from: hired as! [Any])

                                if self.arrResponseJobs.count == 0 {
                                    self.arrResponseJobs.addObjects(from: hired as! [Any])
                                }
                                if tempArray.count > self.arrResponseJobs.count {
                                    self.arrResponseJobs.removeAllObjects()
                                    self.arrResponseJobs = NSMutableArray()
                                    self.arrResponseJobs.addObjects(from: hired as! [Any])
                                }
                            }
                        }
                    
                        if let selInProgress = dataDict.object(forKey: "currentJobs") as? NSArray
                        {
                            if selInProgress.count > 0
                            {
                                
                                let tempArray = NSMutableArray()
                                tempArray.addObjects(from: selInProgress as! [Any])
                                
                                if self.arrResSelInProgress.count == 0 {
                                    self.arrResSelInProgress.addObjects(from: selInProgress as! [Any])
                                }
                                if tempArray.count > self.arrResSelInProgress.count {
                                    self.arrResSelInProgress.removeAllObjects()
                                    self.arrResSelInProgress = NSMutableArray()
                                    self.arrResSelInProgress.addObjects(from: selInProgress as! [Any])
                                }
                            }
                        }
                       
                        if self.isForRefresh {
                            self.refreshControl.endRefreshing()
                            self.isForRefresh = false
                        }
                        
                        self.tblJobHistory.delegate = self
                        self.tblJobHistory.dataSource = self
                        self.tblJobHistory.reloadData()
                    }
                    
                }
                else
                {
                    print("ERROR--",Error.self)
                }
                
                
            }
        }
    }
    // MARK: - UITableView Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        
        let headerImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        let lblSection = UILabel(frame: CGRect(x: 50, y: 5, width: headerView.frame.size.width, height: 30))
        
        lblSection.backgroundColor = UIColor.clear
        lblSection.textAlignment = .left
        lblSection.textColor = UIColor.darkGray

        if appdel.deviceLanguage == "pt-BR"
        {
            lblSection.font = UIFont(name: "Montserrat-Bold", size: 15.0)
        }
        else
        {
            lblSection.font = UIFont(name: "Montserrat-Bold", size: 20.0)
        }
        var image = UIImage()
        
        if(section == 0)
        {
            image = UIImage(named: "current_user")!
            
            
            if appdel.deviceLanguage == "pt-BR"
            {
                lblSection.text = "Processo seletivo em andamento"
            }
            else
            {
                lblSection.text = "Selection in progress"
            }
            
        }
        else
        {
            image = UIImage(named: "userSelection")!
            
            if appdel.deviceLanguage == "pt-BR"
            {
                lblSection.text = "Vagas só para convidados"
            }
            else
            {
                lblSection.text = "Invitation only jobs"
            }
        }
        
        headerImageView.image = image
        headerView.addSubview(headerImageView)
        headerView.addSubview(lblSection)
        
        return headerView
            
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount = Int()
        
        if section == 0
        {
            rowCount = arrResSelInProgress.count
        }
        else
        {
            rowCount = arrResponseJobs.count
        }
        
        if rowCount == 0
        {
            rowCount = 1
        }
        
        return rowCount
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var tempDict = NSDictionary()
        
        if indexPath.section == 0
        {
            if(arrResSelInProgress.count != 0)
            {
                 tempDict = arrResSelInProgress.object(at: indexPath.row) as! NSDictionary
            }
           
        }
        else
        {
            if(arrResponseJobs.count != 0)
            {
                tempDict = arrResponseJobs.object(at: indexPath.row) as! NSDictionary
            }
        }
        
        if tempDict.object(forKey: "jobTitle") == nil
        {
             let emptyCellObj = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            
            emptyCellObj.lblEmpty.text = strNone
            
            return emptyCellObj
        }
        else
        {
        
            if indexPath.row == currentIndex && indexPath.section == currentSection
            {
                let expandcell = tableView.dequeueReusableCell(withIdentifier: "EmpHistoryInnerCell", for: indexPath) as! EmpHistoryInnerCell
            
                expandcell.selectionStyle = .none
                
                expandcell.viewLeft.backgroundColor = ColorJobSelected
                expandcell.viewPayment.backgroundColor = ColorJobSelected
                expandcell.viewOnlyDays.backgroundColor = ColorJobSelected
                expandcell.viewFromEndDate.backgroundColor = ColorJobSelected
                expandcell.lblBottomBorder.backgroundColor = ColorJobSelected
            
                expandcell.lblLineB.backgroundColor = ColorseperatorDarkGreen
                expandcell.lblLineA.backgroundColor = ColorseperatorDarkGreen
        
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
            
                expandcell.lblProfessionalHired.isHidden = true
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
                    expandcell.lblFromEndDate.text =  "\(strFrom) \n \(self.convertDateFormaterUTC(UTCStartDate)) \n to \n \(endDate) \n | \n \(strFrom) \n \(self.UTCToLocal(date: tempDict.object(forKey: "startHour")! as! String))h \n \(strTo) \n \(self.UTCToLocal(date:tempDict.object(forKey: "endTime")! as! String))h"
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
            
                expandcell.btnExpandCollaps.tag = indexPath.row
                expandcell.btnExpandCollaps.addTarget(self, action: #selector(Accept(sender:)), for: .touchUpInside)
                
                
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
            
                mainCell.viewLeft.isHidden = false
 
                mainCell.btnMainExpandCollaps.tag = indexPath.row
            
                mainCell.btnMainExpandCollaps.addTarget(self, action: #selector(Accept(sender:)), for: .touchUpInside)

            
                mainCell.contentView.layer.cornerRadius = 2.0
                
                mainCell.contentView.layer.shadowColor = UIColor.gray.cgColor
                mainCell.contentView.layer.shadowOpacity = 0.5
                mainCell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
                mainCell.contentView.layer.shadowRadius = 2.0
                
                return mainCell
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var rowHight = Int()
        
        if indexPath.row == currentIndex && indexPath.section == currentSection
        {
          //  rowHight =  330
            rowHight =  Int(UITableViewAutomaticDimension)
        }
        else
        {
            rowHight =  Int(UITableViewAutomaticDimension)
            
            if(indexPath.section == 0)
            {
                if(arrResSelInProgress.count == 0)
                {
                    rowHight = 40
                }
            }
            else
            {
                if(arrResponseJobs.count == 0)
                {
                    rowHight = 40
                }

            }
        }
        
        return CGFloat(rowHight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var tempDict = NSDictionary()
        
        if indexPath.section == 0
        {
            if(arrResSelInProgress.count != 0)
            {
                tempDict = arrResSelInProgress.object(at: indexPath.row) as! NSDictionary
            }
            
        }
        else
        {
            if(arrResponseJobs.count != 0)
            {
                tempDict = arrResponseJobs.object(at: indexPath.row) as! NSDictionary
            }
        }
        
        if tempDict.object(forKey: "jobTitle") != nil
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
            let selection = storyBoard.instantiateViewController(withIdentifier: "selctionViewController") as! selctionViewController
            selection.jobId = "\(tempDict.object(forKey: "jobId")!)"
            selection.jobTitle = "\(tempDict.object(forKey: "jobTitle")!)"
            
            self.navigationController?.pushViewController(selection, animated: true)
        }
        
        
        
     }
    
    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    
    // MARK: - UIView Action
    
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
        self.openJobsAPI()
    }
    

   
    func Accept(sender: UIButton) {
     
        if sender.tag == currentIndex
        {
            currentIndex = -1
        }
        else
        {
            currentIndex = (sender.tag)
        }

        if let cell = sender.superview?.superview?.superview as? JobPendingInvitationMainCell {
            
            let indexPath = tblJobHistory.indexPath(for: cell)
            
            currentSection = (indexPath?.section)!
            
            print(currentSection)
   
        }
        
        if let cell = sender.superview?.superview?.superview?.superview as? EmpHistoryInnerCell {
            
            let indexPath = tblJobHistory.indexPath(for: cell)
            
            currentSection = -1
            
            print(currentSection)
        }
        tblJobHistory.reloadData()
    }

}
