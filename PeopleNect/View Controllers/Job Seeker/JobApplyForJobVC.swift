//
//  JobApplyForJobVC.swift
//  PeopleNect
//
//  Created by InexTure on 22/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class JobApplyForJobVC: UIViewController {
    @IBOutlet weak var thirdImgHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdImgwidth: NSLayoutConstraint!

    @IBOutlet weak var secondImgHeight: NSLayoutConstraint!
    @IBOutlet weak var secondImgWidth: NSLayoutConstraint!
    @IBOutlet weak var firstImgHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var firstImgWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSeachAgain: UIButton!
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblFollowUpOn: UILabel!
    @IBOutlet weak var searchBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAt: UILabel!
    @IBOutlet weak var lblApplicationSent: UILabel!
    @IBOutlet weak var lblWaitingForHiringMngr: UILabel!
    @IBOutlet weak var lblWaitingFeedBack: UILabel!
    
    @IBOutlet weak var imgFirst: UIImageView!
    @IBOutlet weak var imgWaitingFor: UIImageView!
    @IBOutlet weak var imgWaitingFeedBack: UIImageView!

    var global = WebServicesClass()

    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var lblFour: UILabel!
    @IBOutlet weak var lblThree: UILabel!
    @IBOutlet weak var lblTwo: UILabel!
    
    var companyName = String()
    var jobTitle = String()
    var jobId = String()
    var jobseekerStatus = String()
    var employerStatus = String()
    var isFromMap = false
    var hasAcknowledge = String()

    
    var type = NSNumber() // if type is zero then it will be from invitation else followup Api

    // MARK: - View LifeCycle -

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        lblOne.Radius()
        lblTwo.Radius()
        lblThree.Radius()
        lblFour.Radius()
        
        lblJob.text = jobTitle
        lblCompany.text = companyName
        

        if isFromMap {
            btnSeachAgain.setTitle("Search again", for: .normal)
            //btnSeachAgain.setTitle("See details", for: .normal)
            searchBtnHeight.constant = 50
            btnSeachAgain.isHidden = false
        }else{
            if employerStatus == "4" {
                searchBtnHeight.constant = 50
                btnSeachAgain.setTitle("See details", for: .normal)
                btnSeachAgain.isHidden = false
            }else{
                searchBtnHeight.constant = 0
                btnSeachAgain.isHidden = true
                
                searchBtnHeight.constant = 50
                btnSeachAgain.isHidden = false
            }
        }
        
        if type == 0 {
            
            self.followUpInvitation()
            // here invitation
        }
        else if type == 1000 {
            lblOne.isHidden = true
            lblTwo.isHidden = true
            lblThree.isHidden = true
            lblFour.isHidden = true
            lblApplicationSent.isHidden = true
            lblWaitingForHiringMngr.isHidden = true
            lblWaitingFeedBack.isHidden = true
            imgFirst.isHidden = true
            imgWaitingFor.isHidden = true
            imgWaitingFeedBack.isHidden = true
        }
        else{
            //here followup

            self.followUp()
            //self.followUpInvitation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Click Action -

    
    @IBAction func clickOnSearchAgain(_ sender: Any) {
        
        if btnSeachAgain.title(for: .normal) == "Search again" {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
            let jobOnGoingDetailsVC = storyBoard.instantiateViewController(withIdentifier: "JobOnGoingDetailsVC") as! JobOnGoingDetailsVC
            jobOnGoingDetailsVC.hasAcknowledge = hasAcknowledge
            jobOnGoingDetailsVC.jobId = jobId
            jobOnGoingDetailsVC.type = "\(type)"
            self.navigationController?.pushViewController(jobOnGoingDetailsVC, animated: true)
        }
    }
    @IBAction func clickOnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)

    }
    
    // MARK: - Follow Up Method for setting UI -

    func followUpInvitation()  {
        if jobseekerStatus ==  "0" && employerStatus == "0"{
            
            lblApplicationSent.text = "You are  invited"
            lblWaitingForHiringMngr.text = "Waiting for hiring manager to check your application"
            lblWaitingFeedBack.text = "Waiting feedback"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "clock_new_")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "clock_new_")
            
            imgWaitingFeedBack.image = UIImage.init(named: "clock_new_")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "clock_new_")
            
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:45.0/255.0 , green: 88.0/255.0, blue: 124.0/255.0, alpha: 1.0))
            
        }else if jobseekerStatus ==  "1" && (employerStatus ==  "5" || employerStatus == "0" ){
            
            lblApplicationSent.text = "You accepted an invitation"
            lblWaitingForHiringMngr.text = "Hiring manager aware  of the application"
            lblWaitingFeedBack.text = "Waiting feedback"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "right_active")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "right_active")
            
            imgWaitingFeedBack.image = UIImage.init(named: "clock_new_")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "clock_new_")
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
        }else if employerStatus ==  "4" {
            
            if jobseekerStatus == "0" {
                lblApplicationSent.text = "You are  invited"
            }
            if jobseekerStatus == "1" {
                lblApplicationSent.text = "You accepted an invitation"
            }
            
            lblWaitingForHiringMngr.text = "Hiring manager aware  of the application"
            lblWaitingFeedBack.text = "You were  selected"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "right_active")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "right_active")
            
            imgWaitingFeedBack.image = UIImage.init(named: "right_active")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "right_active")
          
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
        }else if employerStatus ==  "2" || jobseekerStatus ==  "2" {
            

            if jobseekerStatus == "0" {
                lblApplicationSent.text = "You are  invited"
            }
            if jobseekerStatus == "1" {
                lblApplicationSent.text = "You accepted an invitation"
            }
            
            lblWaitingForHiringMngr.text = "Hiring manager aware  of the application"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "right_active")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "right_active")
            
            imgWaitingFeedBack.image = UIImage.init(named: "refuse_green")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "refuse_green")
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            if  employerStatus ==  "2"{
                lblWaitingFeedBack.text = "Employer gave up hiring you"
            }else{
                lblWaitingFeedBack.text = "You gave up this job"
            }
            
        }

        
    }
    func followUp()  {
       
        if jobseekerStatus ==  "0" && employerStatus == "0"{
            
            lblApplicationSent.text = "Application sent"
            lblWaitingForHiringMngr.text = "Waiting for hiring manager to check your application"
            lblWaitingFeedBack.text = "Waiting feedback"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "clock_new_")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "clock_new_")

            imgWaitingFeedBack.image = UIImage.init(named: "clock_new_")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "clock_new_")
            
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:45.0/255.0 , green: 88.0/255.0, blue: 124.0/255.0, alpha: 1.0))
            
        }else if employerStatus ==  "5" || employerStatus == "1" {
            
            lblApplicationSent.text = "Application sent"
            lblWaitingForHiringMngr.text = "Hiring manager received your application"
            lblWaitingFeedBack.text = "Waiting feedback"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "right_active")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "right_active")
            
            imgWaitingFeedBack.image = UIImage.init(named: "clock_new_")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "clock_new_")
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
        }else if employerStatus ==  "4" {
            
            lblApplicationSent.text = "Application sent"
            lblWaitingForHiringMngr.text = "Hiring manager received your application"
            lblWaitingFeedBack.text = "You were  selected"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "right_active")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "right_active")
            
            imgWaitingFeedBack.image = UIImage.init(named: "right_active")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "right_active")
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            if jobseekerStatus == "2" {
                lblWaitingFeedBack.text = "You gave up this job"
                imgWaitingFeedBack.image = UIImage.init(named: "refuse_green")
                setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "refuse_green")
            }
            
        }else if employerStatus ==  "2" || jobseekerStatus ==  "2" {
            
            lblApplicationSent.text = "Application sent"
            lblWaitingForHiringMngr.text = "Hiring manager received your application"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "right_active")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "right_active")
            
            imgWaitingFeedBack.image = UIImage.init(named: "refuse_green")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "refuse_green")
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            if  employerStatus ==  "2"{
                lblWaitingFeedBack.text = "Employer gave up hiring you"
            }else{
                lblWaitingFeedBack.text = "You gave up this job"
            }
            
        }else{
            lblApplicationSent.text = "Application sent"
            lblWaitingForHiringMngr.text = "Waiting for hiring manager to check your application"
            lblWaitingFeedBack.text = "Waiting feedback"
            
            imgFirst.image = UIImage.init(named: "right_active")
            setConstraints(width: firstImgWidth, height: firstImgHeight, imageName: "right_active")
            
            imgWaitingFor.image = UIImage.init(named: "clock_new_")
            setConstraints(width: secondImgWidth, height: secondImgHeight, imageName: "clock_new_")
            
            imgWaitingFeedBack.image = UIImage.init(named: "clock_new_")
            setConstraints(width: thirdImgwidth, height: thirdImgHeight, imageName: "clock_new_")
            
            
            lblOne.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 1.0))
            lblTwo.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.7))
            lblThree.changeColor(color: UIColor.init(colorLiteralRed:33.0/255.0 , green: 228.0/255.0, blue: 100.0/255.0, alpha: 0.4))
            
            lblFour.changeColor(color: UIColor.init(colorLiteralRed:45.0/255.0 , green: 88.0/255.0, blue: 124.0/255.0, alpha: 1.0))
        }
        
    }

    func setConstraints(width:NSLayoutConstraint,height:NSLayoutConstraint,imageName:String)  {
        
        if imageName == "right_active" {
            width.constant = 35
            height.constant = 30
        }else{
            width.constant = 40
            height.constant = 40
        }
    }
    
}

extension UILabel{
    func Radius()  {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }
    func changeColor(color:UIColor)  {
        self.backgroundColor = color
    }
}
