//
//  JobPendingInvitationVC.swift
//  PeopleNect
//
//  Created by Apple on 27/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class JobPendingInvitationVC: UIViewController, UITableViewDataSource , UITableViewDelegate,SlideNavigationControllerDelegate {
    
    @IBOutlet var lblPendingInvitation: UILabel!
    @IBOutlet var tblPendingInvitation: UITableView!
    @IBOutlet var lblNoPendingInvitations: UILabel!
    
    @IBOutlet weak var viewTop: UIView!
    var alertMessage = AlertMessageVC()

    var global = WebServicesClass()
    
    var currentIndex = -1
    var previousIndex = -1
    
    var arrJobPendingInvitation = NSMutableArray()
    

    var jobId = String()
    var refreshControl = UIRefreshControl()
    var isForRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.tblPendingInvitation.register(UINib(nibName: "JobDashBoardMainCell", bundle: Bundle.main), forCellReuseIdentifier: "JobDashBoardMainCell")

        
        self.tblPendingInvitation.rowHeight = UITableViewAutomaticDimension
        self.tblPendingInvitation.estimatedRowHeight = 80
        
        self.tblPendingInvitation.delegate = self
        self.tblPendingInvitation.dataSource = self
        

        lblNoPendingInvitations.isHidden = true
        
        
        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0
        
        if appdel.deviceLanguage == "pt-BR"
        {
            self.lblNoPendingInvitations.text = "Não há convite pendente"
        }
        
        
        // refresh Controller
       self.refreshContoller()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getPendingInvitationsAPI()
        self.navigationController?.navigationBar.isHidden = true
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrJobPendingInvitation.count == 0{
            return 0
        }else{
            return (arrJobPendingInvitation.object(at: 0) as! NSArray).count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //   let empTableItem = tableItems[indexPath.row]
        
        if indexPath.row == currentIndex
        {
            let expandcell = tableView.dequeueReusableCell(withIdentifier: "JObPendingInvitationInnerCellTableViewCell", for: indexPath) as! JObPendingInvitationInnerCellTableViewCell
            
            expandcell.selectionStyle = .none
            
            previousIndex = currentIndex
            
            var tempDict = NSDictionary()

            tempDict = (arrJobPendingInvitation.object(at: 0) as! NSArray).object(at: indexPath.row)  as! NSDictionary

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


            expandcell.viewLeft.backgroundColor = ColorJobSelected
            expandcell.lblBottomBorder.backgroundColor = ColorJobSelected

            expandcell.viewPayment.backgroundColor = ColorJobSelected
            expandcell.viewOnlyDays.backgroundColor = ColorJobSelected
            expandcell.viewFromEndDate.backgroundColor = ColorJobSelected
            expandcell.btnApplyAlReadyInvited.backgroundColor = ColorJobSelected

            expandcell.paymentViewBottomLbl.backgroundColor = ColorseperatorDarkGreen
            expandcell.dateBottomLbl.backgroundColor = ColorseperatorDarkGreen
            
            
            
            // Blue Color 
            expandcell.viewLeft.backgroundColor = blueThemeColor
            expandcell.lblBottomBorder.backgroundColor = blueThemeColor
            expandcell.viewPayment.backgroundColor = blueThemeColor
            expandcell.viewOnlyDays.backgroundColor = blueThemeColor
            expandcell.viewFromEndDate.backgroundColor = blueThemeColor
            expandcell.btnApplyAlReadyInvited.backgroundColor = blueThemeColor
            expandcell.paymentViewBottomLbl.backgroundColor = ColorseperatorDarkBlue
            expandcell.dateBottomLbl.backgroundColor = ColorseperatorDarkBlue
            
            
            expandcell.objCollectionView.reloadData()

            expandcell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"

            expandcell.lblFromEndDate.text =  "\(tempDict.object(forKey: "date")!)"

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
            //expandcell.lblPayment.text =  "$\(tempDict.object(forKey: "rate")!)"

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
            
            expandcell.btnApplyAlReadyInvited.tag = indexPath.row
            expandcell.btnApplyAlReadyInvited.addTarget(self, action: #selector(Accept(sender:)), for: .touchUpInside)
            
        
            expandcell.btnResuse.tag = indexPath.row
             expandcell.btnResuse.addTarget(self, action: #selector(Decline(sender:)), for: .touchUpInside)
            
            expandcell.contentView.layer.cornerRadius = 2.0
            expandcell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
            expandcell.contentView.layer.shadowOpacity = 0.5
            expandcell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            expandcell.contentView.layer.shadowRadius = 2.0
           
            return expandcell
            
        }
        else
        {
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobPendingInvitationMainCell", for: indexPath) as! JobPendingInvitationMainCell
            
            //let mainCell = tableView.dequeueReusableCell(withIdentifier: "JobDashBoardMainCell", for: indexPath) as! JobDashBoardMainCell

            mainCell.selectionStyle = .none
            
            var tempDict = NSDictionary()
          //  tempDict = arrJobPendingInvitation.object(at: indexPath.row) as! NSDictionary

            tempDict = (arrJobPendingInvitation.object(at: 0) as! NSArray).object(at: indexPath.row)  as! NSDictionary


            mainCell.lblJob.text = "\(tempDict.object(forKey: "jobTitle")!)"


            let StartTime = "\(tempDict.object(forKey: "startHour")!)"
            let StartDate = "\(tempDict.object(forKey: "startDate")!)"
            let UTCStartDate = self.convertDateFormater(StartDate, hour: StartTime)
            
            mainCell.lblDate.text = self.convertDateFormaterUTC(UTCStartDate)

            mainCell.lblCompany.text =  "\(tempDict.object(forKey: "companyName")!)"

            let distance = tempDict.object(forKey: "distance") as! NSString
            print("distance is",distance)
            let distanceFloat: Float = distance.floatValue
            mainCell.lblLocation.text = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f", distanceFloat) + "Km"
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
            
            mainCell.contentView.layer.cornerRadius = 2.0
            mainCell.contentView.layer.shadowColor = UIColor.darkGray.cgColor
            mainCell.contentView.layer.shadowOpacity = 0.5
            mainCell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
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
        
        tblPendingInvitation.reloadData()
    }
    
    //MARK:- Refresh Controller methods -

    func refreshContoller()  {
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        refreshControl.tintColor = blueThemeColor
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        if #available(iOS 10.0, *) {
            tblPendingInvitation.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    func refreshTable(refreshControl: UIRefreshControl) {
        
        isForRefresh = true
        self.getPendingInvitationsAPI()
       
    }
    
    //MARK:- API call
    
    
    func getPendingInvitationsAPI()
    {
        if  isForRefresh == false {
            SwiftLoader.show(animated: true)
        }
        
        /*
         "userId": "77",
         "language": "en",
         "methodName": "getPendingInvitations"
         */
        //kJobSignUpDict
        
       
        
        let param =  [WebServicesClass.METHOD_NAME: "getPendingInvitations",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
                      "language":appdel.userLanguage] as [String : Any]
        
        
        print("paramgetInvitationJobsApi",param)
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print("ResponsePendingInvitationJobsApi",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1
                {
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSArray
                    {

                        let tempArray = NSMutableArray()
                        tempArray.add(dataDict)

                        if self.arrJobPendingInvitation.count == 0 {
                            self.arrJobPendingInvitation.add(dataDict)
                        }
                        if tempArray.count > self.arrJobPendingInvitation.count {
                             self.arrJobPendingInvitation.removeAllObjects()
                            self.arrJobPendingInvitation = NSMutableArray()
                            self.arrJobPendingInvitation.add(dataDict)
                        }
                        if self.isForRefresh {
                            self.refreshControl.endRefreshing()
                            self.isForRefresh = false
                        }
                        
                        if self.arrJobPendingInvitation.count == 0 {
                            self.lblNoPendingInvitations.isHidden = false
                        }else{
                            self.lblNoPendingInvitations.isHidden = true
                        }
                        
                        self.tblPendingInvitation.reloadData()
                    }
                }
                else
                {
                    print(Response.object(forKey: "message")!)
                    self.lblNoPendingInvitations.isHidden = false
                }
            }
        }
    }
    
    func acceptJobInvitationAPI(accept: String, index: Int,jobID:String)
    {
        SwiftLoader.show(animated: true)
        
        
        let param =  [WebServicesClass.METHOD_NAME: "acceptJobInvitation",
                      "accept": accept,
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
                    "jobId": jobID,
                    "language":appdel.userLanguage] as [String : Any]
        
        
        print("ParamacceptJobInvitationAPI",param)
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            if error != nil
            {
                SwiftLoader.hide()

                print("ErrorInvAc",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                print("ResponseacceptJobInvitationAPI",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    
                    if accept == "1"
                    {
                        self.view.makeToast(Localization(string:"Invitation accepted!"), duration: 3.0, position: .bottom)
                        
                    }
                    else if accept == "0"
                    {
                        self.view.makeToast(Localization(string:"Invitation refused!"), duration: 3.0, position: .bottom)
                        
                    }
                    
                    var tempArray = NSMutableArray()
                    tempArray =  (self.arrJobPendingInvitation.object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                    tempArray.removeObject(at: index)
                    
                    self.arrJobPendingInvitation.removeAllObjects()

                    if tempArray.count > 0 {
                        self.arrJobPendingInvitation.add(tempArray)
                    }
                    
                    if self.arrJobPendingInvitation.count == 0 {
                        self.lblNoPendingInvitations.isHidden = false
                    }else{
                        self.lblNoPendingInvitations.isHidden = true
                    }
                    
                    self.tblPendingInvitation.reloadData()
                }
                else
                {
                    print(Response.object(forKey: "message")!)
                }
                
            }
        }
    }
    
    //MARK:- Reference  Methods
 
      @IBAction func clickBack(_ sender: Any) {
        
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)

    }
    
 
    //MARK:- Life cycle Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    
    //MARK:- Class Methods

    func Accept(sender: UIButton) {
        
        var tempDict = NSDictionary()
        tempDict = (arrJobPendingInvitation.object(at: 0) as! NSArray).object(at: sender.tag)  as! NSDictionary
        self.jobId = "\(tempDict.object(forKey: "jobId")!)"

        self.acceptJobInvitationAPI(accept: "1", index: sender.tag,jobID:self.jobId)
        
    }
    
    func Decline(sender: UIButton) {
        
        var tempDict = NSDictionary()
        tempDict = (arrJobPendingInvitation.object(at: 0) as! NSArray).object(at: sender.tag)  as! NSDictionary
        self.jobId = "\(tempDict.object(forKey: "jobId")!)"
        self.acceptJobInvitationAPI(accept: "0", index: sender.tag,jobID:self.jobId)
        
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
