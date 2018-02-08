//
//  selctionViewController.swift
//  PeopleNect
//
//  Created by test on 10/17/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader


class expandedCell: UITableViewCell {
    
    @IBOutlet weak var notifyRedBadge: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notifyRedBadge.layer.cornerRadius = 5
        notifyRedBadge.layer.masksToBounds = true
    }
}

class noProfCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class subCell: UITableViewCell {
    
    @IBOutlet weak var avtarImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel1: UILabel!
    @IBOutlet weak var descLabel2: UILabel!
    @IBOutlet weak var waitingLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var waitingImg: UIImageView!
    
    @IBOutlet weak var jobAcceptedLbl: UILabel!
    @IBOutlet weak var jobAcceptedLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var applicantAcceptLbl: UILabel!
    @IBOutlet weak var applicantRefuseLbl: UILabel!
    @IBOutlet weak var applicantRefuseBtn: UIButton!
    @IBOutlet weak var applicantAcceptBtn: UIButton!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var starImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avtarImage.layer.cornerRadius = avtarImage.frame.size.height / 2.0
        avtarImage.clipsToBounds = true
        avtarImage.backgroundColor = UIColor.white
        
        jobAcceptedLbl.layer.cornerRadius = 10
        jobAcceptedLbl.layer.masksToBounds = true
    }
}

class selctionViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate
{

    /* views */
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var btnPostJob: UIButton!
    @IBOutlet weak var postJobHeightConstraints: NSLayoutConstraint!
    
    /* Variables */
    var expandedSections: NSMutableIndexSet?
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    var hiredUserArray = NSMutableArray()
    var selectedUserArray = NSMutableArray()
    var applicantsUserArray = NSMutableArray()
    var rejectedUserArray = NSMutableArray()
    var jobId = String()
    var jobTitle = String()
    var totalBalance = NSString()
    var postJobPrice = NSString()
    var userDic =  [String: Any]()

    
        /* to show toast of published job */
    
    var isfromJobPubliush : Bool = false
    var refreshControl = UIRefreshControl()
    
    //MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postJobHeightConstraints.constant = 0
        animateView.layer.cornerRadius = 2.0
        animateView.layer.shadowColor = UIColor.gray.cgColor
        animateView.layer.shadowOpacity = 0.5
        animateView.layer.shadowOffset = CGSize(width: 0, height: 2)
        animateView.layer.shadowRadius = 2.0
        animateView.isHidden = true
        
        
        if (expandedSections == nil) {
            expandedSections = NSMutableIndexSet()
        }
        
        if userDic.count > 0 {
            jobId = "\(userDic["jobId"]!)"
            jobTitle = "\(userDic["job_title"]!)"
        }
     
        //                'jobseeker_id' =>$userId,
        //                'jobId' =>$jobId,
        //                'employer_id' =>$employerDetail -> employer_id,
        //                'jobseeker_name' =>$user -> first_name. " ".$user->last_name,
        //                'job_title' =>$employerDetail -> job_title,
        //                'payment_type' =>$employerDetail -> payment_type,
        //                'total_amount' =>$employerDetail -> total_amount,
        //                'hourly_rate' =>$employerDetail -> hourly_rate
        
        
        self.titleLabel.text = jobTitle

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        if isfromJobPubliush == true
        {
            self.view.makeToast(Localization(string: "Job published!"), duration: 3.0, position: .bottom)
        }
        // Do any additional setup after loading the view.
        
        
       
        // refresh Controller
        self.refreshContoller()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.jobUsersList()
    }
    
    //MARK: - TABLEVIEW DATASOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (expandedSections?.contains(section))! {
                
                if section == 0 {
                    if hiredUserArray.count == 0 {
                        return 2
                    }  else{
                        return (hiredUserArray.object(at: 0) as! NSArray).count + 1
                        
                    }
                }else if section == 1 {
                    
                    if selectedUserArray.count == 0 {
                        return 2
                    }  else{
                        return (selectedUserArray.object(at: 0) as! NSArray).count + 1
                    }
                    
                }else if section == 2 {
                    
                    if applicantsUserArray.count == 0 {
                        return 2
                    }  else{
                        return (applicantsUserArray.object(at: 0) as! NSArray).count + 1
                        
                    }
                    
                }else{
                    if rejectedUserArray.count == 0 {
                        return 2
                    }  else{
                        return (rejectedUserArray.object(at: 0) as! NSArray).count + 1
                    }
                }
                // return rows when expanded
            }
            return 1
            // only top row showing
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == 0 {
                return 50
            }
            else {
                return 64
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "expandedCell", for: indexPath) as! expandedCell
                
                cell.notifyRedBadge.isHidden = true

                if indexPath.section == 0 {
                    
                    if hiredUserArray.count ==  0 {
                        cell.titleLabel.text = "Hired (0)"
                    }else{
                        cell.titleLabel.text = "Hired (\((hiredUserArray.object(at: 0) as! NSArray).count))"
                    }
                    
                    if appdel.isHiredNotification {
                        cell.notifyRedBadge.isHidden = false
                    }
                }
                else if indexPath.section == 1 {
                    
                    
                    if selectedUserArray.count ==  0 {
                        cell.titleLabel.text = "Selected (0)"
                    }else{
                        cell.titleLabel.text = "Selected (\((selectedUserArray.object(at: 0) as! NSArray).count))"
                    }

                    
                    if appdel.isSelectedNotification {
                        cell.notifyRedBadge.isHidden = false
                    }
                }
                else if indexPath.section == 2 {
                    
                    if applicantsUserArray.count ==  0 {
                        cell.titleLabel.text = "Applicants (0)"
                    }else{
                        cell.titleLabel.text = "Applicants (\((applicantsUserArray.object(at: 0) as! NSArray).count))"
                    }
                    
                    if appdel.isApplicantNotification {
                        cell.notifyRedBadge.isHidden = false
                    }
                }else {
                    
                    if rejectedUserArray.count ==  0 {
                        cell.titleLabel.text = "Refuse (0)"
                    }else{
                        cell.titleLabel.text = "Refuse (\((rejectedUserArray.object(at: 0) as! NSArray).count))"
                    }

                    if appdel.isRejectedNotification {
                        cell.notifyRedBadge.isHidden = false
                    }
                }
 
                // only top row showing
                if (expandedSections?.contains(indexPath.section))! {
                   // cell.accessoryImage.image = #imageLiteral(resourceName: "arrow_down_white")
                    cell.accessoryImage.image = #imageLiteral(resourceName: "arrow_Down")
                }
                else {
                    cell.accessoryImage.image = #imageLiteral(resourceName: "arrow_right")
                }
                return cell
            }
            else {
                if  indexPath.section == 0  {
                    
                    if  hiredUserArray.count == 0{
                        let noProfessional = tableView.dequeueReusableCell(withIdentifier: "noProfCell", for: indexPath) as! noProfCell
                        return noProfessional
                    }else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! subCell
                       
                        var tempDict = NSDictionary()
                        
                        tempDict = (hiredUserArray.object(at: 0) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary

                        
                        cell.jobAcceptedLbl.isHidden = true
                        cell.titleLabel.text = "\(tempDict.object(forKey: "userName")!)"
                        cell.descLabel1.text = "\(tempDict.object(forKey: "categoryName")!)"

                        let distance = tempDict.object(forKey: "distance") as! NSString
                        var distanceStr = String()
                        let distanceFloat: Float = distance.floatValue
                        distanceStr = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f" , distanceFloat) + " km "
                        
                        let experience = tempDict.object(forKey: "experience") as! NSString
                        var experienceStr = String()
                        let experienceFloat: Float = experience.floatValue
                        experienceStr = String(format: experienceFloat == floor(experienceFloat) ? "%.0f" : "%.2f", experienceFloat) + " years / "
                        
                        
                        let has_acknowledge = tempDict.object(forKey: "has_acknowledge") as! NSString
                        let userName = "\(tempDict.object(forKey: "userName")!)"

                        if has_acknowledge == "1" {
                            cell.jobAcceptedLeadingConstraints.constant = userName.widthOfString()
                            cell.jobAcceptedLbl.isHidden = false
                        }
                        
                        // create an NSMutableAttributedString that we'll append everything to
                        let fullString = NSMutableAttributedString(string: experienceStr)
                        
                        
                        // create our NSTextAttachment
                        let image1Attachment = NSTextAttachment()
                        image1Attachment.image = UIImage(named: "map_white.png")
                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: image1Attachment)
                        
                        // add the NSTextAttachment wrapper to our full string, then add some more text.
                        fullString.append(image1String)
                        fullString.append(NSAttributedString(string: distanceStr))
                        
                        // draw the result in a label
                        cell.descLabel2.attributedText = fullString

                        cell.waitingImg.isHidden = true
                        cell.waitingLabel.isHidden = true
                        cell.acceptBtn.isHidden = true
                        cell.rateLbl.isHidden = false
                        cell.starImg.isHidden = false
                        cell.applicantAcceptBtn.isHidden = true
                        cell.applicantAcceptLbl.isHidden = true
                        cell.applicantRefuseBtn.isHidden = true
                        cell.applicantRefuseLbl.isHidden = true
                       // 209 180 63
                        cell.rateLbl.text = "\(tempDict.object(forKey: "userRating")!)"
                        cell.rateLbl.textColor = UIColor.init(colorLiteralRed: 209.0/255.0, green: 180.0/255.0, blue: 63.0/255.0, alpha: 1.0)

                        if tempDict.object(forKey: "proifilePicUrl") is NSNull
                        {
                            let placeHolderImage = "user"
                            cell.avtarImage.image = UIImage(named: placeHolderImage)
                        }
                        else
                        {
                            let imagUrlString = tempDict.object(forKey: "proifilePicUrl") as! String
                            let url = URL(string: imagUrlString)
                            let placeHolderImage = "user"
                            let placeimage = UIImage(named: placeHolderImage)
                            cell.avtarImage.sd_setImage(with: url, placeholderImage: placeimage)
                        }
                        
                        return cell
                    }
                } else if indexPath.section == 1 {
                    
                    if  selectedUserArray.count == 0{
                        let noProfessional = tableView.dequeueReusableCell(withIdentifier: "noProfCell", for: indexPath) as! noProfCell
                        return noProfessional
                    }else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! subCell
                 
                        var tempDict = NSDictionary()
                        tempDict = (selectedUserArray.object(at: 0) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary
                        
                        cell.titleLabel.text = "\(tempDict.object(forKey: "userName")!)"
                        cell.descLabel1.text = "\(tempDict.object(forKey: "categoryName")!)"
                        cell.jobAcceptedLbl.isHidden = true

                        
                        let distance = tempDict.object(forKey: "distance") as! NSString
                        var distanceStr = String()
                        let distanceFloat: Float = distance.floatValue
                        distanceStr = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f" , distanceFloat) + " km "
                        
                        let experience = tempDict.object(forKey: "experience") as! NSString
                        var experienceStr = String()
                        let experienceFloat: Float = experience.floatValue
                        experienceStr = String(format: experienceFloat == floor(experienceFloat) ? "%.0f" : "%.2f", experienceFloat) + " years / "
                        
                        // create an NSMutableAttributedString that we'll append everything to
                        let fullString = NSMutableAttributedString(string: experienceStr)
                        
                        
                        // create our NSTextAttachment
                        let image1Attachment = NSTextAttachment()
                        image1Attachment.image = UIImage(named: "map_white.png")
                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: image1Attachment)
                        
                        // add the NSTextAttachment wrapper to our full string, then add some more text.
                        fullString.append(image1String)
                        fullString.append(NSAttributedString(string: distanceStr))

                        cell.descLabel2.attributedText = fullString
                        
                        let ES = tempDict.object(forKey: "employer_status") as! NSString
                        let JS = tempDict.object(forKey: "jobseeker_status") as! NSString

                        if ES == "0" && JS == "0" {
                            cell.acceptBtn.isHidden = true
                            cell.waitingLabel.isHidden = false
                            cell.waitingImg.isHidden = false
                            cell.waitingImg.image = UIImage(named: "clock")
                            cell.waitingLabel.text = "Waiting"
                        } else if ES == "0" || JS == "1"  {
                            cell.acceptBtn.isHidden = false
                            cell.waitingLabel.isHidden = true
                            cell.waitingImg.isHidden = true
                            cell.acceptBtn.setTitle("Accept/Hire", for: .normal)
                            cell.acceptBtn.accessibilityHint = "1"
                            cell.acceptBtn.tag = indexPath.row - 1
                            cell.acceptBtn.backgroundColor = UIColor.clear
                            cell.acceptBtn.accessibilityValue = "\(indexPath.section)"
                            cell.acceptBtn.addTarget(self, action: #selector(self.acceptHire), for: .touchUpInside)
                        }else if ES == "1" && JS == "0" {
                            cell.acceptBtn.isHidden = false
                            cell.waitingLabel.isHidden = true
                            cell.acceptBtn.setTitle("Hire", for: .normal)
                           cell.acceptBtn.accessibilityHint = "0"
                            cell.waitingImg.isHidden = true
                            cell.acceptBtn.tag = indexPath.row - 1
                            cell.acceptBtn.backgroundColor = UIColor.clear
                            cell.acceptBtn.accessibilityValue = "\(indexPath.section)"
                            cell.acceptBtn.addTarget(self, action: #selector(self.acceptHire), for: .touchUpInside)
                        }
                        
                        cell.applicantAcceptBtn.isHidden = true
                        cell.applicantAcceptLbl.isHidden = true
                        cell.applicantRefuseBtn.isHidden = true
                        cell.applicantRefuseLbl.isHidden = true
                        cell.starImg.isHidden = true
                        cell.rateLbl.isHidden = true
                        
                        if tempDict.object(forKey: "proifilePicUrl") is NSNull
                        {
                            let placeHolderImage = "user"
                            cell.avtarImage.image = UIImage(named: placeHolderImage)
                        }
                        else
                        {
                            let imagUrlString = tempDict.object(forKey: "proifilePicUrl") as! String
                            let url = URL(string: imagUrlString)
                            let placeHolderImage = "user"
                            let placeimage = UIImage(named: placeHolderImage)
                            cell.avtarImage.sd_setImage(with: url, placeholderImage: placeimage)
                        }
                        
                        return cell
                    }
                }else if indexPath.section == 2 {
                    
                    if  applicantsUserArray.count == 0{
                        let noProfessional = tableView.dequeueReusableCell(withIdentifier: "noProfCell", for: indexPath) as! noProfCell
                        return noProfessional
                    }else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! subCell
                       
                        var tempDict = NSDictionary()
                        
                        tempDict = (applicantsUserArray.object(at: 0) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary

                        
                        cell.titleLabel.text = "\(tempDict.object(forKey: "userName")!)"
                        cell.descLabel1.text = "\(tempDict.object(forKey: "categoryName")!)"
                        cell.jobAcceptedLbl.isHidden = true

                        let distance = tempDict.object(forKey: "distance") as! NSString
                        var distanceStr = String()
                        let distanceFloat: Float = distance.floatValue
                        distanceStr = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f" , distanceFloat) + " km "
                        
                        let experience = tempDict.object(forKey: "experience") as! NSString
                        var experienceStr = String()
                        let experienceFloat: Float = experience.floatValue
                        experienceStr = String(format: experienceFloat == floor(experienceFloat) ? "%.0f" : "%.2f", experienceFloat) + " years / "
                        
                        // create an NSMutableAttributedString that we'll append everything to
                        let fullString = NSMutableAttributedString(string: experienceStr)
                        
                        
                        // create our NSTextAttachment
                        let image1Attachment = NSTextAttachment()
                        image1Attachment.image = UIImage(named: "map_white.png")
                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: image1Attachment)
                        
                        // add the NSTextAttachment wrapper to our full string, then add some more text.
                        fullString.append(image1String)
                        fullString.append(NSAttributedString(string: distanceStr))

                        cell.descLabel2.attributedText = fullString

                        cell.waitingImg.isHidden = true
                        cell.waitingLabel.isHidden = true
                        cell.acceptBtn.isHidden = true
                        
                        cell.applicantAcceptBtn.isHidden = true
                        cell.applicantAcceptLbl.isHidden = true
                        cell.applicantRefuseBtn.isHidden = true
                        cell.applicantRefuseLbl.isHidden = true
                        cell.starImg.isHidden = true
                        cell.rateLbl.isHidden = true
                        
                        
                        let ES = tempDict.object(forKey: "employer_status") as! NSString
                        let JS = tempDict.object(forKey: "jobseeker_status") as! NSString
                        
                        if ES == "0" || JS == "0"  {
                            cell.applicantAcceptBtn.isHidden = false
                            cell.applicantAcceptLbl.isHidden = false
                            cell.applicantRefuseBtn.isHidden = false
                            cell.applicantRefuseLbl.isHidden = false
                            
                            cell.applicantAcceptBtn.tag = indexPath.row - 1
                            cell.applicantAcceptBtn.accessibilityValue = "\(indexPath.section)"
                            cell.applicantAcceptBtn.addTarget(self, action: #selector(self.applicantAccept), for: .touchUpInside)

                            cell.applicantRefuseBtn.tag = indexPath.row - 1
                            cell.applicantRefuseBtn.accessibilityValue = "\(indexPath.section)"
                            cell.applicantRefuseBtn.addTarget(self, action: #selector(self.applicantRefuse), for: .touchUpInside)
                        }
                        
                        
                        if tempDict.object(forKey: "proifilePicUrl") is NSNull
                        {
                            let placeHolderImage = "user"
                            cell.avtarImage.image = UIImage(named: placeHolderImage)
                        }
                        else
                        {
                            let imagUrlString = tempDict.object(forKey: "proifilePicUrl") as! String
                            let url = URL(string: imagUrlString)
                            let placeHolderImage = "user"
                            let placeimage = UIImage(named: placeHolderImage)
                            cell.avtarImage.sd_setImage(with: url, placeholderImage: placeimage)
                        }
                        
                        return cell
                    }
                }
                else {
                    
                    if  rejectedUserArray.count == 0{
                        let noProfessional = tableView.dequeueReusableCell(withIdentifier: "noProfCell", for: indexPath) as! noProfCell
                        return noProfessional
                    }else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! subCell
                      
                        var tempDict = NSDictionary()
                        
                        tempDict = (rejectedUserArray.object(at: 0) as! NSArray).object(at: indexPath.row - 1) as! NSDictionary

                        cell.titleLabel.text = "\(tempDict.object(forKey: "userName")!)"
                        cell.descLabel1.text = "\(tempDict.object(forKey: "categoryName")!)"
                        cell.jobAcceptedLbl.isHidden = true

                        let distance = tempDict.object(forKey: "distance") as! NSString
                        var distanceStr = String()
                        let distanceFloat: Float = distance.floatValue
                        distanceStr = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f" , distanceFloat) + " km "
                        
                        let experience = tempDict.object(forKey: "experience") as! NSString
                        var experienceStr = String()
                        let experienceFloat: Float = experience.floatValue
                        experienceStr = String(format: experienceFloat == floor(experienceFloat) ? "%.0f" : "%.2f", experienceFloat) + " years / "
                        
                        // create an NSMutableAttributedString that we'll append everything to
                        let fullString = NSMutableAttributedString(string: experienceStr)
                        
                        
                        // create our NSTextAttachment
                        let image1Attachment = NSTextAttachment()
                        image1Attachment.image = UIImage(named: "map_white.png")
                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: image1Attachment)
                        
                        // add the NSTextAttachment wrapper to our full string, then add some more text.
                        fullString.append(image1String)
                        fullString.append(NSAttributedString(string: distanceStr))

                        cell.descLabel2.attributedText = fullString

                        cell.waitingImg.isHidden = true
                        cell.waitingLabel.isHidden = true
                        cell.acceptBtn.isHidden = true
                        cell.applicantAcceptBtn.isHidden = true
                        cell.applicantAcceptLbl.isHidden = true
                        cell.applicantRefuseBtn.isHidden = true
                        cell.applicantRefuseLbl.isHidden = true
                        cell.starImg.isHidden = true
                        cell.rateLbl.isHidden = true
                        
                        let ES = tempDict.object(forKey: "employer_status") as! NSString
                        if ES == "2" {
                            cell.rateLbl.isHidden = false
                            cell.rateLbl.text = "X Rejected"
                            cell.rateLbl.textColor = UIColor.white
                        }
                        
                        if tempDict.object(forKey: "proifilePicUrl") is NSNull
                        {
                            let placeHolderImage = "user"
                            cell.avtarImage.image = UIImage(named: placeHolderImage)
                        }
                        else
                        {
                            let imagUrlString = tempDict.object(forKey: "proifilePicUrl") as! String
                            let url = URL(string: imagUrlString)
                            let placeHolderImage = "user"
                            let placeimage = UIImage(named: placeHolderImage)
                            cell.avtarImage.sd_setImage(with: url, placeholderImage: placeimage)
                        }
                        return cell
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
                // only first row toggles exapand/collapse
                tableView.deselectRow(at: indexPath, animated: true)
                
                let section: Int = indexPath.section
                let currentlyExpanded: Bool = expandedSections!.contains(section)
                if currentlyExpanded {
                    expandedSections?.remove(section)
                }
                else {
                    expandedSections?.removeAllIndexes()
                    expandedSections?.add(section)
                }
                let cell = tableView.cellForRow(at: indexPath) as! expandedCell
                if currentlyExpanded {
                   // cell.accessoryImage.image = #imageLiteral(resourceName: "arrow_right_white")
                    cell.accessoryImage.image = #imageLiteral(resourceName: "arrow_Down")
                }
                else {
//cell.accessoryImage.image = #imageLiteral(resourceName: "arrow_down_white")
                    
                     cell.accessoryImage.image = #imageLiteral(resourceName: "arrow_right")
                }
                tableView.reloadData()
            }
        else{
                let jobDetail = self.storyboard?.instantiateViewController(withIdentifier: "EmpJobSeekerStatusVC") as! EmpJobSeekerStatusVC
                jobDetail.jobTitle = jobTitle
                if indexPath.section == 0 {
                    if hiredUserArray.count > 0 {
                        jobDetail.ArrayUserListing = (hiredUserArray.object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                        jobDetail.currentIndex = indexPath.row - 1
                        jobDetail.showprofessionalDecline = true
                        jobDetail.jobID = self.jobId
                        self.navigationController?.pushViewController(jobDetail, animated: true)
                    }
                }else if indexPath.section == 1 {
                    if selectedUserArray.count > 0 {
                        jobDetail.ArrayUserListing = (selectedUserArray.object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                        jobDetail.currentIndex = indexPath.row - 1
                        self.navigationController?.pushViewController(jobDetail, animated: true)
                    }
                }else if indexPath.section == 2 {
                    if  applicantsUserArray.count > 0 {
                        jobDetail.ArrayUserListing = (applicantsUserArray.object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                        jobDetail.currentIndex = indexPath.row - 1
                        self.navigationController?.pushViewController(jobDetail, animated: true)
                    }
                }
                else {
                    if  rejectedUserArray.count > 0 {
                        jobDetail.ArrayUserListing = (rejectedUserArray.object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                        jobDetail.currentIndex = indexPath.row - 1
                        self.navigationController?.pushViewController(jobDetail, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewObj = UIView()
        viewObj.backgroundColor = UIColor.clear
        return viewObj
    }
    
    //MARK: - UIAction
    func removeAnimateView()  {
        self.animateView.isHidden = true
    }
    func acceptHire(sender:UIButton)  {
        
        let index = sender.tag
        let section = sender.accessibilityValue
        print("index is",index)
        print("section is",section!)

        var tempDict = NSDictionary()
        
        tempDict = (selectedUserArray.object(at: 0) as! NSArray).object(at: index) as! NSDictionary
        let type = "1"
        let userId = "\(tempDict.object(forKey: "userId")!)"
        
        if  sender.accessibilityHint == "1" {
        print("Accept/Hire")
            self.acceptHireEmployee(userId: userId, type: type)
        }
        if  sender.accessibilityHint == "0" {
            print("Hire")
            self.acceptHireEmployee(userId: userId, type: type)
        }
    }
    
    func applicantAccept(sender:UIButton)  {
        
        let index = sender.tag
        let section = sender.accessibilityValue
        print("index is",index)
        print("section is",section!)
        
        var tempDict = NSDictionary()
        tempDict = (applicantsUserArray.object(at: 0) as! NSArray).object(at: index) as! NSDictionary

        print("tempDict is",tempDict)

        let type = "1"
        let userId = "\(tempDict.object(forKey: "userId")!)"
        self.acceptRefuseAPI(userId: userId, type: type, accept: "1")
    }
    
    func applicantRefuse(sender:UIButton)  {
        let index = sender.tag
        let section = sender.accessibilityValue
        print("index is",index)
        print("section is",section!)
        
        var tempDict = NSDictionary()
        
        tempDict = (applicantsUserArray.object(at: 0) as! NSArray).object(at: index) as! NSDictionary

        let type = "1"
        let userId = "\(tempDict.object(forKey: "userId")!)"
        self.acceptRefuseAPI(userId: userId, type: type, accept: "2")
        
    }
    @IBAction func settingsButt(_ sender: Any) {
        
        if self.animateView.isHidden == true {
            self.animateView.frame =  CGRect(x: self.view.center.x, y: -10, width: self.animateView.frame.size.width, height: self.animateView.frame.size.height)
            self.animateView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                
                self.animateView.frame =  CGRect(x: self.view.center.x, y: 0, width: self.animateView.frame.size.width, height: self.animateView.frame.size.height)
                
            }) { (Bool) in
                
            }
        }else{
            self.animateView.isHidden = true
        }
    }
    
    @IBAction func dismissButt(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let selection = storyBoard.instantiateViewController(withIdentifier: "EmpSelectionProgressVC") as! EmpSelectionProgressVC
        self.navigationController?.pushViewController(selection, animated: true)
    }
    
    @IBAction func professionalButt(_ sender: Any) {
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        print("cancel Clicked")
        
        
        
        let alertController = UIAlertController(title: "", message: Localization(string: "Want to cancel this job?"), preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            self.animateView.isHidden = true
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.animateView.isHidden = true
            self.cancelJob()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func editClicked(_ sender: Any) {
         self.animateView.isHidden = true
        let empLastDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpLastDetailsVC") as! EmpLastDetailsVC
        empLastDetailsVC.jobid = self.jobId
        empLastDetailsVC.FreshJob = 1
        empLastDetailsVC.loadFrmOtherCtr = 1
        navigationController?.pushViewController(empLastDetailsVC, animated: true)
    }
    @IBAction func postJobClicked(_ sender: Any) {
        self.jobPostingPriceAndBalance()
    }
    @IBAction func inviteButt(_ sender: Any) {
        // self.jobId
        // self.jobTitle

        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let invite = storyBoard.instantiateViewController(withIdentifier: "inviteViewController") as! inviteViewController
        invite.jobId =  self.jobId
        invite.jobTitle =  self.jobTitle
        self.navigationController?.pushViewController(invite, animated: true)
    }
    
    
    //MARK:- Refresh Controller methods -
    
    func refreshContoller()  {
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        refreshControl.tintColor = blueThemeColor
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    func refreshTable(refreshControl: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        self.jobUsersList()
    }
    
    
    //MARK: - API
    
    func jobUsersList()  {
        
        /*
         {
         "employerId": "2",
         "jobId": "243",
         "language": "en",
         "methodName": "jobUsersList"
         }
         */
        SwiftLoader.show(animated: true)
       
        self.hiredUserArray.removeAllObjects()
        self.selectedUserArray.removeAllObjects()
        self.applicantsUserArray.removeAllObjects()
        self.rejectedUserArray.removeAllObjects()
        
        let param =  [WebServicesClass.METHOD_NAME: "jobUsersList","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":self.jobId] as [String : Any]
        
       // let param =  [WebServicesClass.METHOD_NAME: "jobUsersList","employerId":"65","language":"en","jobId":"422"] as [String : Any]

        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            let dictResponse = Response as! NSDictionary
            
            print("dictResponse",dictResponse)
            
            let status = dictResponse.object(forKey: "status") as! Int
            
            if status == 1
            {
                if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                {
                    let publish_status = "\(dictResponse.object(forKey: "publish_status")!)"

                    if publish_status == "0" {
                        self.postJobHeightConstraints.constant = 80
                    }else {
                        self.postJobHeightConstraints.constant = 0
                    }
                   
                    let perDay = (dictResponse.object(forKey: "payment_type"))  as! String
                    
                    var perHour = String()
                    
                    if perDay == "1"
                    {
                        perHour = "/hour"
                    }
                    else if perDay == "2"
                    {
                        perHour = "/job"
                    }
                    else{
                        perHour = "/month"
                    }
                    
                    let balance = "\(dictResponse.object(forKey: "hourly_rate")!)" as NSString
                    var balanceRS = Int()
                    balanceRS = balance.integerValue
                    
                   
                    if appdel.deviceLanguage == "pt-BR"
                    {
                        let number = NSNumber(value: balance.floatValue)
                        self.amountLabel.text = self.ConvertToPortuegeCurrency(number: number)
                    }
                    else
                    {
                        self.amountLabel.text = "$\(balanceRS.withCommas())" + ".00 \(perHour)"
                    }
                    
                    
                   // self.amountLabel.text = "\(dictResponse.object(forKey: "hourly_rate")!)" + perHour
                    
                    let hired = dataDict.object(forKey: "hired") as! NSArray
                    if hired.count > 0 {
                        self.hiredUserArray.add(hired)
                    }
                 
                    
                    let selected = dataDict.object(forKey: "selected") as! NSArray
                    if selected.count > 0 {
                        self.selectedUserArray.add(selected)
                    }
                 

                    let applicants = dataDict.object(forKey: "applicants") as! NSArray
                    if applicants.count > 0 {
                        self.applicantsUserArray.add(applicants)
                    }
                    
                    let rejected = dataDict.object(forKey: "rejected") as! NSArray
                    if rejected.count > 0 {
                        self.rejectedUserArray.add(rejected)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }else{
                
            }
        }
    }
    
    func jobPostingPriceAndBalance()
    {
        SwiftLoader.show(animated: true)
        
        
        
        let param =  [WebServicesClass.METHOD_NAME: "jobPostingPriceAndBalance",
                      "employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
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
                
                self.totalBalance = (((dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "balance") as! NSString) as String) as String as NSString
                self.postJobPrice = (((dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "jobPostingPrice") as! NSString) as String) as String as NSString
                
                let remainingDays = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "remainingDays") as! NSString
                
                let totalDays = remainingDays.integerValue
                if totalDays > 0{
                    self.publishJob()
                }else{
                    if self.postJobPrice.intValue > self.totalBalance.intValue  {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                        let noBalance = storyBoard.instantiateViewController(withIdentifier: "EmpNoBalance") as! EmpNoBalance
                        self.navigationController?.pushViewController(noBalance, animated: true)
                    }else{
                        self.publishJob()
                    }
                }
            }
        }
    }
    
    
    func publishJob()  {
        /*
        {
            "employerId": "2",
            "jobId": "243",
            "methodName": "publishJob"
        }
*/
        SwiftLoader.show(animated: true)
        
       
        
        let param =  [WebServicesClass.METHOD_NAME: "publishJob","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":self.jobId] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            let dictResponse = Response as! NSDictionary
            print("dictResponse",dictResponse)
            let status = dictResponse.object(forKey: "status") as! Int
            if status == 1
            {
                self.postJobHeightConstraints.constant = 0
                self.alertMessage.strMessage = Localization(string:  "Job published!")
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                self.present(self.alertMessage, animated: false, completion: nil)
                
            }else{
                if status == 2{
                    self.alertMessage.strMessage = Localization(string:  "you have insufficient credit.")
                }else{
                    self.alertMessage.strMessage = Localization(string:  "Error while sending invitation, please try again")
                }
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                self.present(self.alertMessage, animated: false, completion: nil)
            }
        }
    }
    
    func cancelJob()  {
        /*
         {"jobId":"253","methodName":"cancelJob"}
         */
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "cancelJob","language":appdel.userLanguage,"jobId":self.jobId] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
           
            if error != nil {
                
            }
            else{
                let dictResponse = Response as! NSDictionary
                print("dictResponse",dictResponse)
                let status = dictResponse.object(forKey: "status") as! Int
                if status == 1
                {
                    //self.dismiss(animated: true, completion: nil)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                    let selection = storyBoard.instantiateViewController(withIdentifier: "EmpSelectionProgressVC") as! EmpSelectionProgressVC
                    self.navigationController?.pushViewController(selection, animated: true)
                    
                    self.view.makeToast(Localization(string:"job has been closed"), duration: 3.0, position: .bottom)

                }else{
                    self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
            
        }
    }
    
    func acceptRefuseAPI(userId:String,type:String,accept:String)  {
        /*
         {"accept":"2","employerId":"41","jobId":"255","type":"1","userId":"163","methodName":"acceptEmployee"}
         accept 2 -- Refuse
         accept 1 -- Accept
         */
        
        SwiftLoader.show(animated: true)
        
        
        let param =  [WebServicesClass.METHOD_NAME: "acceptEmployee","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":self.jobId,"userId":userId,"type":type,"accept":accept] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            let dictResponse = Response as! NSDictionary
            print("dictResponse of accept refuse",dictResponse)
            let status = dictResponse.object(forKey: "status") as! Int
            if status == 1
            {
                self.view.makeToast(Localization(string:"Invitation Accepted! or Invitation refused!"), duration: 3.0, position: .bottom)
                self.jobUsersList()
            }else{
                self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                self.present(self.alertMessage, animated: false, completion: nil)
            }
        }
    }
    
    
    func acceptHireEmployee(userId:String,type:String)  {
        /*
         {"employerId":"41","jobId":"253","type":"1","userId":"163","methodName":"hireEmployee"}
         */
        
        SwiftLoader.show(animated: true)
        
      
        let param =  [WebServicesClass.METHOD_NAME: "hireEmployee","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":self.jobId,"userId":userId,"type":type] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            let dictResponse = Response as! NSDictionary
            print("dictResponse of accept refuse",dictResponse)
            let status = dictResponse.object(forKey: "status") as! Int
            if status == 1
            {
                self.jobUsersList()
                
                self.view.makeToast(Localization(string:"Job offer sent"), duration: 3.0, position: .bottom)

            }else{
                self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                self.alertMessage.modalPresentationStyle = .overCurrentContext
                self.present(self.alertMessage, animated: false, completion: nil)
            }
        }
    }

    
}
