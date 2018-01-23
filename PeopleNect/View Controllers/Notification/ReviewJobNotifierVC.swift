//
//  ReviewJobNotifierVC.swift
//  PeopleNect
//
//  Created by Apple on 08/11/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import Cosmos
import SwiftLoader

class ReviewJobNotifierVC: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet var imgProfrilePic: UIImageView!
    @IBOutlet var lblFullName: UILabel!
    @IBOutlet var lblJob: UILabel!
    @IBOutlet var viewRating: CosmosView!
    @IBOutlet var lblRateReview: UILabel!
    @IBOutlet var lblAmountPerHour: UILabel!
    @IBOutlet var lblTotalHours: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var btnEveluateFinish: UIButton!
    @IBOutlet var btnJobInProgressEvl: UIButton!
    
    // MARK: - VARIABLES -
    var fromSetPrice = false
    var totalHour = ""
    var totalPrice = ""
    var userDic = [String: Any]()
    var job_id = ""
    var assigned_jobseeker = ""
    var assigned_jobseekerData = NSArray()
    var amount_per_hour = ""
    var total_hours = ""
    var total_amount = ""
    var jobTitle = ""
    var userName = ""
    var employerId = ""

    var ratingStatus = ""
    var ratingText = ""
    var rating:Double = 0
    var profileImage = UIImage()
    var fromRatingScreen = false
    var JobseekerDataFromRating = NSArray()

    var global = WebServicesClass()

    // MARK: - VIEW LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let corner = (UIScreen.main.bounds.size.height / 667) * 70
        imgProfrilePic.layer.cornerRadius = corner/2
        imgProfrilePic.layer.masksToBounds = true

        if fromRatingScreen {
            // from Employer history and job in Progress this block will executed
            
        }else{
            // this block will be executed when notification arrive
            self.job_id = "\(userDic["job_id"]!)"
            self.employerId = "\(appdel.loginUserDict.object(forKey: "employerId")!)"
        }

        if  fromSetPrice {
            lblTotalHours.text = totalHour
            lblAmountPerHour.text =  "$" + "\(totalPrice)"
            lblJob.text = jobTitle
            self.lblFullName.text = userName
            self.lblRateReview.text = ratingStatus
            self.viewRating.rating = rating
            self.viewRating.text = ratingText
            imgProfrilePic.image = profileImage
        }else{
            self.lblFullName.text = ""
            self.lblJob.text = ""
            self.closeJobDetail()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        imgProfrilePic.layer.cornerRadius =  imgProfrilePic.frame.size.height/2
    }
    
    // MARK: - UIACTION -
    @IBAction func EvaluateFinish(_ sender: Any) {
        self.rateJobseeker()
    }

    @IBAction func JobInProgressEvl(_ sender: Any) {
        // got to home Page
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
        self.navigationController?.pushViewController(empdashboardVC, animated: true)
        
    }

    @IBAction func AdjustFinishAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let setPriceVC = storyBoard.instantiateViewController(withIdentifier: "ReviewSetPriceNotifyVC") as! ReviewSetPriceNotifyVC
       
        setPriceVC.totalHour = lblTotalHours.text!
        setPriceVC.totalPrice =  lblAmountPerHour.text!
        setPriceVC.profileImage = imgProfrilePic.image!
        
        setPriceVC.jobTitle = self.lblJob.text!
        setPriceVC.fromRatingScreen = fromRatingScreen

        setPriceVC.userName = self.lblFullName.text!
        setPriceVC.ratingStatus = self.lblRateReview.text!

        setPriceVC.rating = self.viewRating.rating
        setPriceVC.ratingText = self.viewRating.text!

        self.navigationController?.pushViewController(setPriceVC, animated: true)
    }
    
    func closeJobDetail()
    {
        SwiftLoader.show(animated: true)
        
        let  param =  [WebServicesClass.METHOD_NAME: "CloseJobDetail",
                              "employer_id":employerId,
                              "job_id":job_id] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                print("closeJobDetail is",dictResponse)
                
                self.assigned_jobseekerData = dictResponse.value(forKey: "assigned_jobseeker") as! NSArray
                
                if self.assigned_jobseekerData.count > 0{
                    
                    let assignedData = self.assigned_jobseekerData.object(at: 0) as! NSDictionary
                    self.assigned_jobseeker =  assignedData.value(forKey: "id") as! String
                    
                    let profilePic =  assignedData.value(forKey: "jobSeekerProfilePic") as! String
                    self.lblFullName.text = assignedData.value(forKey: "name") as? String
                    
                    let url = URL(string: profilePic)
                    let placeHolderImage = "plceholder"
                    let placeimage = UIImage(named: placeHolderImage)
                    self.imgProfrilePic.sd_setImage(with: url, placeholderImage: placeimage)
                    
                
                    
                    if assignedData.object(forKey: "rating")! is NSNumber {
                        self.viewRating.rating = Double((assignedData.object(forKey: "rating")!) as! NSNumber)
                    }else{
                        print("it's String")
                        let rating = assignedData.object(forKey: "rating") as! NSString
                        if rating.length > 0{
                            self.viewRating.rating = Double((assignedData.object(forKey: "rating")!) as! String)!
                            self.viewRating.text = "(\(assignedData.object(forKey: "rating")!))"
                        }else{
                            self.viewRating.rating = 0
                            self.viewRating.text = "0"
                        }
                    }
                }

                self.amount_per_hour = dictResponse.value(forKey: "total_amount") as! String
                self.total_amount = dictResponse.value(forKey: "amount_per_hour") as! String
                self.total_hours = dictResponse.value(forKey: "total_hours") as! String

                self.lblJob.text = dictResponse.value(forKey: "job_title") as? String
                self.lblAmountPerHour.text = "$" + "\(self.amount_per_hour)"
                self.lblTotalHours.text = self.total_hours
                self.lblTotalAmount.text = "$" + "\(self.total_amount)"
            }
        }
        
    }

    func rateJobseeker()
    {
        SwiftLoader.show(animated: true)
        
       let ratingArray  = NSMutableArray()
        
        let dic = NSMutableDictionary()
        dic.setValue(assigned_jobseeker, forKey: "user_id")
        dic.setValue("\(viewRating.rating)", forKey: "rating")
        dic.setValue(amount_per_hour, forKey: "amount_per_hour")
        dic.setValue(self.total_hours, forKey: "total_hour")
        
        ratingArray.add(dic)
        
        let paramDic = NSMutableDictionary()
        paramDic.setValue("rateJobseeker", forKey: WebServicesClass.METHOD_NAME)
        paramDic.setValue(employerId, forKey: "employerId")
        paramDic.setValue(job_id, forKey: "jobId")
        paramDic.setValue(ratingArray, forKey: "rating")

        
        print("param is",paramDic)
        
        global.callWebService(parameter: paramDic ) { (Response:AnyObject, error:NSError?) in
            
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
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                    let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
                    self.navigationController?.pushViewController(empdashboardVC, animated: true)
                }
               
            }
        }
        
    }

}
