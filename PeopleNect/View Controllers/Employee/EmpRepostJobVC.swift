//
//  EmpRepostJobVC.swift
//  PeopleNect
//
//  Created by BAPS on 10/27/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class RepostCell:UITableViewCell{
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var lblRepost: UILabel!
    @IBOutlet weak var Jobprice: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var repostTitle: UILabel!
    @IBOutlet weak var borderLbl: UILabel!
}
class EmpRepostJobVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var repostJobTbl: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    var repostJobArray = NSMutableArray()
    
    // MARK: - View  LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let corner = (UIScreen.main.bounds.size.height / 568) * 90
        profileView.layer.cornerRadius = corner/2
        profileView.layer.masksToBounds = true
        
        if imageIsNull(imageName: ImgEmployerProfilepic )
        {
            self.setEmployerImageView(btnProfilePic:profileImage)
        }
        else
        {
            profileImage.image = ImgEmployerProfilepic
        }
        
        repostJobTbl.delegate = self
        repostJobTbl.dataSource = self
        
        self.closedJobs()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - back Action
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - tableView Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repostJobArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepostCell", for: indexPath) as! RepostCell
        
        if indexPath.row == 0 {
            cell.jobTitle.isHidden = true
            cell.Jobprice.isHidden = true
            cell.nextBtn.isHidden = true
            cell.lblRepost.isHidden = true
            cell.repostTitle.isHidden = false
            cell.closeBtn.isHidden = false
            cell.borderLbl.isHidden = true
            
        }else{
            cell.jobTitle.isHidden = false
            cell.Jobprice.isHidden = false
            cell.nextBtn.isHidden = false
            cell.lblRepost.isHidden = false
            cell.repostTitle.isHidden = true
            cell.closeBtn.isHidden = true
            cell.borderLbl.isHidden = false
            
            var tempDict = NSDictionary()
            tempDict = repostJobArray.object(at: indexPath.row - 1) as! NSDictionary
            cell.jobTitle.text =  "\(tempDict.object(forKey: "jobTitle")!)"
            
            let perDay = tempDict.object(forKey: "payment_type") as! String
            
            var perDayStr = String()
            
            if perDay == "1"
            {
                perDayStr = "/hour"
            }
            else if perDay == "2"
            {
                perDayStr = "/job"
            }else{
                perDayStr = "/month"
            }
            
            
            
            let balance = "\(tempDict.object(forKey: "rate")!)" as NSString
            
            var balanceRS = Int()
            balanceRS = balance.integerValue
            
            cell.Jobprice.text = "$ \(balanceRS.withCommas())" + ".00" + perDayStr
            
            //cell.Jobprice.text =  "$" + "\(tempDict.object(forKey: "rate")!)" + perDayStr
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
           // here Category Subcategory
             let empPostNewJobVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpPostNewJobVC") as! EmpPostNewJobVC
            navigationController?.pushViewController(empPostNewJobVC, animated: true)
            
        }else{
           // last Details
            var tempDict = NSDictionary()
            tempDict = repostJobArray.object(at: indexPath.row - 1) as! NSDictionary
            let  jobId = "\(tempDict.object(forKey: "jobId")!)"
            print("Go to Last Details",jobId)
            let empLastDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpLastDetailsVC") as! EmpLastDetailsVC
            empLastDetailsVC.jobid = jobId
            empLastDetailsVC.FreshJob = 0
            empLastDetailsVC.loadFrmOtherCtr = 1
            navigationController?.pushViewController(empLastDetailsVC, animated: true)
        }
    }
    
    // MARK: - closedJobs API
    
    func closedJobs()  {
        
        SwiftLoader.show(animated: true)
      
        let param =  [WebServicesClass.METHOD_NAME: "closedJobs","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":"en"] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            let dictResponse = Response as! NSDictionary
            
            print("dictResponse",dictResponse)
            
            let status = dictResponse.object(forKey: "status") as! Int
            
            if status == 1
            {
                if let dataDict = (dictResponse.object(forKey: "data")) as? [Any]
                {
                    self.repostJobArray.addObjects(from: dataDict)
                    print(" self.repostJobArray ", self.repostJobArray)
                    self.repostJobTbl.reloadData()
                }
            }else{
                
            }
        }
    }
}
