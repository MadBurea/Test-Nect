//
//  EmpJobSeekerStatusVC.swift
//  PeopleNect
//
//  Created by BAPS on 11/3/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader
import KTCenterFlowLayout
import Cosmos
class availableCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var weekNameLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 5.0
        mainView.layer.masksToBounds = true
    }
}

class subCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var subCategoryLbl: UILabel!
    @IBOutlet weak var subCategoryView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subCategoryView.layer.cornerRadius = 5
        subCategoryView.layer.masksToBounds = true
    }
    
}

class EmpJobSeekerStatusVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{

    // MARK: - OUTLETS -
    @IBOutlet weak var objScrollView: UIScrollView!
    @IBOutlet weak var noShowBtn: UIButton!
    @IBOutlet weak var availableTableView: UITableView!
    @IBOutlet weak var postedJobBorderLbl: UILabel!
    @IBOutlet weak var noShowBtnWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var topTitleLbl: UILabel!
    @IBOutlet weak var chatImg: UIImageView!
    @IBOutlet weak var chatLbl: UILabel!
    @IBOutlet weak var clockImg: UIImageView!
    @IBOutlet weak var freeLbl: UILabel!
    @IBOutlet weak var backMenuImg: UIImageView!
    @IBOutlet weak var backLbl: UILabel!
    @IBOutlet weak var mapImg: UIImageView!
    @IBOutlet weak var mapLbl: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var noOfJobCountLbl: UILabel!
    @IBOutlet weak var btnPostedJob: UIButton!
    @IBOutlet weak var btnNewJob: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userCategoryLbl: UILabel!
    @IBOutlet weak var userExpLbl: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var lastEmployerView: UIView!
    @IBOutlet weak var subCategoryCollView: UICollectionView!
    @IBOutlet weak var firstEmployerLbl: UILabel!
    @IBOutlet weak var secondEmployerLbl: UILabel!
    @IBOutlet weak var thirdEmployerLbl: UILabel!
    @IBOutlet weak var subCategoryCollHeight: NSLayoutConstraint!
    @IBOutlet weak var userStatusImg: UIImageView!
    @IBOutlet weak var userStatusLbl: UILabel!
    
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    // MARK: - VARIABLES -
    var ArrayUserListing = NSMutableArray()
    var currentIndex = Int()
    var fromDash = false
    var chatWithUser = false
    var jobTitle = ""
    var jobID = ""
    var arrayCat = NSMutableArray()
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    var arrDaysName = NSMutableArray()
    var arrDaysFull = NSMutableArray()
    var showprofessionalDecline = false
    var fromJobRating = false

    // MARK: - View LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideNavigationBar()
        // Week Name
        arrDaysName = [ Localization(string: "Sun"),Localization(string: "Mon"),Localization(string: "Tue"),Localization(string: "Wed"),Localization(string: "Thu"),Localization(string: "Fri"),Localization(string: "Sat")]
        
        
        //  for Profile UIImageView
       
        self.noShowBtn.isHidden = true
        self.noShowBtn.setTitle(Localization(string: "NO SHOW"), for: .normal)
        if appdel.deviceLanguage == "pt-BR"
        {
            self.noShowBtnWidthConstraints.constant = 160
        }
        else
        {
            self.noShowBtnWidthConstraints.constant = 120
        }
        
        if  appdel.iPhone_X{
            userProfileImg.layer.cornerRadius = 45
        }else{
            let corner = (UIScreen.main.bounds.size.height / 667) * 90
            userProfileImg.layer.cornerRadius = corner/2
        }
        userProfileImg.layer.masksToBounds = true

       
    

        
        // flowlayout
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        self.subCategoryCollView.collectionViewLayout = layout
        
        // collection
        self.subCategoryCollView.delegate = self
        self.subCategoryCollView.dataSource = self
        
        
        print("ArrayUserListing ",ArrayUserListing)
        
        // if it's from DashBoard
        if  fromDash {
            topTitleLbl.isHidden = true
            backLbl.text = "Back"
            mapImg.isHidden = true
            mapLbl.isHidden = true
            userStatusLbl.isHidden = true
            userStatusImg.isHidden = true
        }else{
            btnNewJob.isHidden = true
            btnPostedJob.isHidden = true
            postedJobBorderLbl.isHidden = true
        }
        
        if showprofessionalDecline {
            userStatusLbl.text = "This candidate is hired"
            userStatusImg.isHidden = true
            btnNewJob.isHidden = false
            btnNewJob.setTitle("Professional decline", for: .normal)
        }
      
        // Hide the left and right Button for Scrolling when it's one Employee
        if ArrayUserListing.count == 1 {
            self.leftView.isHidden = true
            self.rightView.isHidden = true
        }
        
        // hide the availability View
        self.availabilityView.isHidden = true
        
        // Coming from Job in progress
        if fromJobRating{
            topTitleLbl.isHidden = true
            mapImg.isHidden = true
            mapLbl.isHidden = true
            userStatusLbl.isHidden = true
            userStatusImg.isHidden = true
        }
        
        self.setUpView()
        
        // alert
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        // add gesture for Scrolling
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.clickLeftSwipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.objScrollView.addGestureRecognizer(swipeRight)
        swipeRight.delegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.clickRightSwipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        swipeLeft.delegate = self
        self.objScrollView.addGestureRecognizer(swipeLeft)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userProfileImg.layer.cornerRadius = userProfileImg.frame.size.height/2
        
        hideNavigationBar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UIACTION -
    @IBAction func chatClicked(_ sender: Any) {
        if chatWithUser {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let ChatScene = storyBoard.instantiateViewController(withIdentifier: "CustomChatScene") as! CustomChatScene
            var userDataDic = NSDictionary()
            userDataDic = ArrayUserListing.object(at: currentIndex) as! NSDictionary
            ChatScene.userName = "\(userDataDic.object(forKey: "name")!)"
            if let val = userDataDic["image_url"] {
                if userDataDic.object(forKey: "image_url") is NSNull{}
                else{
                    ChatScene.userprofilePic = val as! String
                }
            }else{
                if userDataDic.object(forKey: "proifilePicUrl") is NSNull{}
                else{
                    ChatScene.userprofilePic = userDataDic.object(forKey: "proifilePicUrl") as! String
                }
            }
            
            if userDataDic["categoryName"]  is NSNull {
                ChatScene.userCategory = ""
            }else{
                ChatScene.userCategory = (userDataDic.object(forKey: "categoryName") as! String?)!
            }

        userDataDic = ArrayUserListing.object(at: currentIndex) as! NSDictionary
        ChatScene.userID = "\(appdel.loginUserDict.object(forKey: "employerId")!)"
        ChatScene.userType =  "0"
        ChatScene.receiver_Name = "\(userDataDic.object(forKey: "name")!)"
            
            if fromDash  || fromJobRating {
                ChatScene.receiver_id =  "\(userDataDic.object(forKey: "employeeId")!)"
            }else{
                ChatScene.receiver_id =  "\(userDataDic.object(forKey: "userId")!)"
            }
            
        self.navigationController?.pushViewController(ChatScene, animated: true)
        }
    }
    @IBAction func availabilityClicked(_ sender: Any) {
        self.availabilityView.isHidden = false
        self.checkAvailibilityApiCall()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ClickInviteForPostedJob(_ sender: Any) {
        var tempDict = NSDictionary()
        tempDict = ArrayUserListing.object(at: currentIndex) as! NSDictionary
        
        let invitedJobObj = self.storyboard?.instantiateViewController(withIdentifier: "EmpInvitePostedJobVC") as! EmpInvitePostedJobVC
        invitedJobObj.jobSeekerId = "\(tempDict.object(forKey: "employeeId")!)" as NSString
        invitedJobObj.jobSeekerName = "\(tempDict.object(forKey: "name")!)" as NSString
        self.navigationController?.pushViewController(invitedJobObj, animated: true)
    }
    
    @IBAction func clickInviteNewJob(_ sender: UIButton) {
        
        if sender.title(for: .normal) == "Professional decline" {
            
            let alertController = UIAlertController(title: "", message: Localization(string: "Are You sure, you want to decline this Professional"), preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                self.ProfessionalDecline()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let empSelectSkillsVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpSelectSkillsVC") as! EmpSelectSkillsVC
            let CatagoryDict = ArrayUserListing.object(at: currentIndex) as! NSDictionary
            empSelectSkillsVC.userDict = CatagoryDict
            empSelectSkillsVC.categoryName = "\(CatagoryDict.object(forKey: "categoryName")!)"
            empSelectSkillsVC.categoryId = "\(CatagoryDict.object(forKey: "categoryId")!)"
            self.navigationController?.pushViewController(empSelectSkillsVC, animated: true)
        }
    }
    
    @IBAction func clickRightSwipe(_ sender: Any) {
        print(currentIndex)
        print(ArrayUserListing.count)
        
        if currentIndex != ArrayUserListing.count-1
        {
             currentIndex = currentIndex + 1
            self.setUpView()
        }

    }
    
    @IBAction func clickLeftSwipe(_ sender: Any) {
        
        if currentIndex != 0
        {
            currentIndex = currentIndex - 1
            self.setUpView()
        }
    }
    
    @IBAction func clickCloseAvailability(_ sender: Any) {
        self.availabilityView.isHidden = true
    }

    @IBAction func noShowClicked(_ sender: Any) {
        
//        "You have successfully set Jobseeker as No Show for your job" = "You have successfully set Jobseeker as No Show for your job";
//        "Set this Professional as No Show?" = "Set this Professional as No Show?";
        
        let alertController = UIAlertController(title: "", message: Localization(string: "Set this Professional as No Show?"), preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: Localization(string: "NO"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.noShowApi()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func ClickOnMap(_ sender: Any) {
        if fromDash {
            // Nothing to do with
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
            let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
            self.navigationController?.pushViewController(empdashboardVC, animated: true)
        }
    }
    // MARK: - UICollectionView DataSource/Delegate Methods -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return arrayCat.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCell", for: indexPath) as! subCategoryCell
        cell.subCategoryLbl.text = arrayCat.object(at: indexPath.row) as? String
        if indexPath.row == arrayCat.count - 1 {
            self.subCategoryCollHeight.constant = self.subCategoryCollView.contentSize.height
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize = (arrayCat.object(at: indexPath.item) as AnyObject).size(attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Bold", size: 15.0)!] )
        
        return CGSize(width: size.width+10, height: 30)
    }
    
    // MARK: - UITABLEVIEW DataSource/Delegate Methods -

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrDaysName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "availableCell", for: indexPath) as! availableCell
        
        cell.weekNameLbl.text = arrDaysName.object(at: indexPath.row) as? String
        
        if indexPath.row == 0
        {
            let myCurrentDict = arrDaysFull.object(at: arrDaysFull.count-1) as! NSDictionary
            
            let start = myCurrentDict.object(forKey: "start_time") as! String
            let end = myCurrentDict.object(forKey: "end_time") as! String
            if start.isEmpty && end.isEmpty
            {
                cell.timeLbl.text = "Not Available"
                cell.timeLbl.textColor = UIColor.white
                cell.weekNameLbl.textColor = UIColor.white
                cell.mainView.backgroundColor = UIColor.clear
                cell.mainView.layer.borderColor = UIColor.white.cgColor
                cell.mainView.layer.borderWidth = 1.0
            }
            else
            {
                cell.mainView.layer.borderColor = UIColor.clear.cgColor
                cell.mainView.layer.borderWidth = 1.0
                cell.timeLbl.textColor = blueThemeColor
                cell.weekNameLbl.textColor = blueThemeColor
             //   cell.timeLbl.text = "\(start) - \(end)"
                
                
                cell.timeLbl.text = "\(self.UTCToLocal(date: start))" + "-" + "\(self.UTCToLocal(date: end))"

                
                cell.mainView.backgroundColor = UIColor.white
            }
        }
        else if indexPath.row == arrDaysFull.count-1
        {
            let myCurrentDict = arrDaysFull.object(at: 5) as! NSDictionary
            let start = myCurrentDict.object(forKey: "start_time") as! String
            let end = myCurrentDict.object(forKey: "end_time") as! String
            if start.isEmpty && end.isEmpty
            {
                cell.timeLbl.text = "Not Available"
                cell.timeLbl.textColor = UIColor.white
                cell.weekNameLbl.textColor = UIColor.white
                cell.mainView.backgroundColor = UIColor.clear
                cell.mainView.layer.borderColor = UIColor.white.cgColor
                cell.mainView.layer.borderWidth = 1.0
            }
            else
            {
                cell.mainView.layer.borderColor = UIColor.clear.cgColor
                cell.mainView.layer.borderWidth = 1.0
                cell.timeLbl.textColor = blueThemeColor
                cell.weekNameLbl.textColor = blueThemeColor
                //cell.timeLbl.text = "\(start) - \(end)"
                cell.timeLbl.text = "\(self.UTCToLocal(date: start))" + "-" + "\(self.UTCToLocal(date: end))"

                cell.mainView.backgroundColor = UIColor.white
            }
        } else{
            let myCurrentDict = arrDaysFull.object(at: indexPath.row-1) as! NSDictionary
            let start = myCurrentDict.object(forKey: "start_time") as! String
            let end = myCurrentDict.object(forKey: "end_time") as! String
            if start.isEmpty && end.isEmpty
            {
                cell.timeLbl.text = "Not Available"
                cell.timeLbl.textColor = UIColor.white
                cell.weekNameLbl.textColor = UIColor.white
                cell.mainView.backgroundColor = UIColor.clear
                cell.mainView.layer.borderColor = UIColor.white.cgColor
                cell.mainView.layer.borderWidth = 1.0
            }
            else
            {
                cell.mainView.layer.borderColor = UIColor.clear.cgColor
                cell.mainView.layer.borderWidth = 1.0
                cell.timeLbl.textColor = blueThemeColor
                cell.weekNameLbl.textColor = blueThemeColor
                //cell.timeLbl.text = "\(start) - \(end)"
                cell.timeLbl.text = "\(self.UTCToLocal(date: start))" + "-" + "\(self.UTCToLocal(date: end))"

                cell.mainView.backgroundColor = UIColor.white
            }
        }
        
        return cell
    }
    // MARK: - Gesture  Delegates -

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    // MARK: - General methods -

    func setUpView()  {
        
        print("ArrayUserListing is for profile pi",ArrayUserListing)
        self.noShowBtn.isHidden = true

        var userDataDic = NSDictionary()
        userDataDic = ArrayUserListing.object(at: currentIndex) as! NSDictionary
        
        
        print("ArrayUserListing is for profile pi",ArrayUserListing)
        // user profile Image from two Side
        if let val = userDataDic["image_url"] {
            if userDataDic.object(forKey: "image_url") is NSNull
            {
                let placeHolderImage = "male-user"
                userProfileImg.image = UIImage(named: placeHolderImage)
            }
            else
            {
              //  let imagUrlString = userDataDic.object(forKey: "image_url") as! String
                let url = URL(string: val as! String)
                let placeHolderImage = "male-user"
                let placeimage = UIImage(named: placeHolderImage)
                userProfileImg.sd_setImage(with: url, placeholderImage: placeimage)
            }
        }else{
            if userDataDic.object(forKey: "proifilePicUrl") is NSNull
            {
                let placeHolderImage = "male-user"
                userProfileImg.image = UIImage(named: placeHolderImage)
            }
            else
            {
                let imagUrlString = userDataDic.object(forKey: "proifilePicUrl") as! String
                let url = URL(string: imagUrlString)
                let placeHolderImage = "male-user"
                let placeimage = UIImage(named: placeHolderImage)
                userProfileImg.sd_setImage(with: url, placeholderImage: placeimage)
            }
        }
        
        // rating View
         if let rating = userDataDic["rating"] {
            ratingView.text =   "(\(rating))"
            if let totalRate = (userDataDic["userRatingCount"] as? NSString)?.doubleValue
            {
                ratingView.rating = totalRate
            }
         }else{
            ratingView.text =  "(\(userDataDic.object(forKey: "userRating")!))"
            if let totalRate = (userDataDic["userRatingCount"] as? NSString)?.doubleValue
            {
                ratingView.rating = totalRate
            }
        }
        
        // user Detail
        if let userName = userDataDic["name"] {
           userNameLbl.text = userName as? String
        }else{
            userNameLbl.text = userDataDic["userName"] as? String
        }
        
        noOfJobCountLbl.text = "Jobs: \(userDataDic.object(forKey: "jobSeekerHiredJob")!), No Show: \(userDataDic.object(forKey: "jobSeekerNoShowJob")!)"
        
        if userDataDic["categoryName"]  is NSNull {
            userCategoryLbl.text = ""
        }else{
            userCategoryLbl.text = userDataDic.object(forKey: "categoryName") as! String?
        }

        
        if userDataDic["exp_years"] != nil {
            
            let fullString = NSMutableAttributedString(string: "\(userDataDic.object(forKey: "exp_years")!) years / ")
            
            // create our NSTextAttachment
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: "map_white.png")
            let image1String = NSAttributedString(attachment: image1Attachment)
            
            fullString.append(image1String)
            if let userName = userDataDic["distance"] {
                fullString.append(NSAttributedString(string: " \(userDataDic.object(forKey: "distance")!) km "))
            }else{
                fullString.append(NSAttributedString(string: "0.00 km "))
            }
            
            userExpLbl.attributedText = fullString
        }else{
            
            let fullString = NSMutableAttributedString(string: "\(userDataDic.object(forKey: "experience")!) years / ")
            
            // create our NSTextAttachment
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: "map_white.png")
            let image1String = NSAttributedString(attachment: image1Attachment)
            
            fullString.append(image1String)
            if let userName = userDataDic["distance"] {
            fullString.append(NSAttributedString(string: " \(userDataDic.object(forKey: "distance")!) km "))
            }else{
                fullString.append(NSAttributedString(string: "0.00 km "))
            }
            userExpLbl.attributedText = fullString
            
        }
        
       
        if let des = userDataDic["description"] {
            print("exp is",des)
            userDescription.text = userDataDic.object(forKey: "description") as! String?
        }else{
            userDescription.text = userDataDic.object(forKey: "profileDescription") as! String?
        }
        
        // Last Employer'
        let lastEmployer = userDataDic.object(forKey: "last_employer") as! NSArray
        
        
        
        self.firstEmployerLbl.text = ""
        self.secondEmployerLbl.text = ""
        self.thirdEmployerLbl.text = ""
        if lastEmployer.count == 0 {
            self.lastEmployerView.isHidden = true
        }else{
            self.lastEmployerView.isHidden = false
            self.firstEmployerLbl.text =  "- \(lastEmployer.object(at: 0))"
            
            if lastEmployer.count == 2 {
                self.secondEmployerLbl.text = "- \(lastEmployer.object(at: 1))"
            }
            if lastEmployer.count == 3 {
                self.secondEmployerLbl.text = "- \(lastEmployer.object(at: 1))"
                self.thirdEmployerLbl.text = "- \(lastEmployer.object(at: 2))"
            }
        }
        
        // User Availability
        if userDataDic["availabilityStatus"] != nil
        {
            var image = UIImage(named: "busy_clock")
            let availabilityId = "\(userDataDic.object(forKey: "availabilityStatus")!)"
            
            if availabilityId == "0"
            {
                image = UIImage(named: "busy_clock")
                self.freeLbl.text = "Busy"
            }
            else
            {
                image = UIImage(named: "clock_new_")
                self.freeLbl.text = "Free"
            }
           clockImg.image = image
        }
       
        // From Selection View Availability
        if userDataDic["availability"] != nil
        {
            var image = UIImage(named: "busy_clock")
            let availabilityId = "\(userDataDic.object(forKey: "availability")!)"
            
            if availabilityId == "0"
            {
                image = UIImage(named: "busy_clock")
                self.freeLbl.text = "Busy"
            }
            else
            {
                image = UIImage(named: "clock_new_")
                self.freeLbl.text = "Free"
            }
            clockImg.image = image
        }
        
        // From Job in Progress Rating view
        if userDataDic["availabilityStatus"] != nil
        {
            var image = UIImage(named: "busy_clock")
            let availabilityId = "\(userDataDic.object(forKey: "availabilityStatus")!)"
            
            if availabilityId == "0"
            {
                image = UIImage(named: "busy_clock")
                self.freeLbl.text = "Busy"
            }
            else
            {
                image = UIImage(named: "clock_new_")
                self.freeLbl.text = "Free"
            }
            clockImg.image = image
        }
        
        // chatting With User if already Worked then chat allowed
        if userDataDic["alreadyWorked"] != nil
        {
            var image = UIImage(named: "chatGray")
            let alreadyWorked = "\(userDataDic.object(forKey: "alreadyWorked")!)"
            
            if alreadyWorked == "1"
            {
                image = UIImage(named: "chat_blue")
                chatWithUser = true
                chatLbl.textColor = freeLbl.textColor

            }
            else
            {
                image = UIImage(named: "chatGray")
                chatWithUser = false
                chatLbl.textColor = UIColor.lightGray
            }
            chatImg.image = image
        }
        
        // From Rating Job in Progress Chat
        
        if userDataDic["jobSeekerChatAvailable"] != nil
        {
            var image = UIImage(named: "chatGray")
            let alreadyWorked = "\(userDataDic.object(forKey: "jobSeekerChatAvailable")!)"
            
            if alreadyWorked == "1"
            {
                image = UIImage(named: "chat_blue")
                chatLbl.textColor = freeLbl.textColor
                chatWithUser = true
            }
            else
            {
                image = UIImage(named: "chatGray")
                chatWithUser = false
                chatLbl.textColor = UIColor.lightGray
            }
            chatImg.image = image
        }
        
        
        // No Show from rating
        
        if userDataDic["is_noshow"] != nil
        {
            let is_noshow = "\(userDataDic.object(forKey: "is_noshow")!)"
            self.noShowBtn.isHidden = false
           
            if is_noshow == "1"
            {
               
            }
            else
            {
                
            }
        }
        
        
        //  User Subcategory
        let categoryList = userDataDic.object(forKey: "subCategoryName") as! String
        let categories = categoryList.characters.split{$0 == ","}.map(String.init)
        arrayCat.removeAllObjects()
        
        if categories.count > 0
        {
            for i in 0...categories.count-1
            {
                if i <= 2
                {
                    arrayCat.add(categories[i])
                }
            }
        }
      
        self.subCategoryCollView.reloadData()
        
        // Collection Reload
        if arrayCat.count > 0 {
            
            self.subCategoryCollHeight.constant = 1000
            let indexPath = NSIndexPath(item: arrayCat.count-1, section: 0)
            self.subCategoryCollView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.bottom, animated: false)

            let indexPathStart = NSIndexPath(item: 0, section: 0)
            self.subCategoryCollView.scrollToItem(at: indexPathStart as IndexPath, at: UICollectionViewScrollPosition.top, animated: false)
        }else{
            self.subCategoryCollHeight.constant = 10
        }
        
        // user status -- Waiting
        if !fromDash {
            let attributes = NSAttributedString(string: "Professional pre-selected for ", attributes: [NSFontAttributeName : UIFont(name: "Montserrat-Regular", size: 15)!,NSForegroundColorAttributeName : UIColor(red: 68.0 / 255.0, green: 107.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0),NSTextEffectAttributeName : NSTextEffectLetterpressStyle])
            
            let boldJobTitle = NSAttributedString(string: jobTitle, attributes: [NSFontAttributeName : UIFont(name: "Montserrat-Bold", size: 15)!,NSForegroundColorAttributeName : UIColor(red: 68.0 / 255.0, green: 107.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0),NSTextEffectAttributeName : NSTextEffectLetterpressStyle])
            
            let combination = NSMutableAttributedString()
            combination.append(attributes)
            combination.append(boldJobTitle)
            
            self.topTitleLbl.attributedText = combination
            if userDataDic["jobseeker_status"] != nil && userDataDic["employer_status"] != nil
            {
                let JS =  "\(userDataDic.object(forKey: "jobseeker_status")!)"
                let ES =  "\(userDataDic.object(forKey: "employer_status")!)"
               
                if showprofessionalDecline {
                    
                }else{
                    self.setUpUserStatus(ES: ES, JS: JS)
                }
            }
        }
    }
    
    func setGetAvailibilityResponse()
    {
        print(self.arrDaysFull)
        var myTestArray = NSMutableArray()
        
        myTestArray = self.arrDaysFull.mutableCopy() as! NSMutableArray
        
        for i in 0 ..< self.arrDaysName.count
        {
            
            var strTag = String()
            
            strTag = String(i + 1)
            
            let predicate = NSPredicate(format: "day contains %@",strTag)
            
            var dupArray = NSArray()
            
            dupArray = arrDaysFull.filtered(using: predicate) as NSArray
            
            if(dupArray.count > 0)
            {
                
                
            }
            else
            {
                let myCurrentDict1 = NSMutableDictionary()
                
                myCurrentDict1.setValue("", forKey: "end_time")
                myCurrentDict1.setValue("", forKey: "start_time")
                myCurrentDict1.setValue(strTag, forKey: "day")
                
                myTestArray.add(myCurrentDict1)
            }
        }
        
        
        
        
        
        let sorted =  (myTestArray as NSArray).sorted(by: { (($0 as! NSDictionary).object(forKey: "day") as! NSString).floatValue < (($1 as! NSDictionary).object(forKey: "day") as! NSString).floatValue })
        myTestArray.removeAllObjects()
        myTestArray.addObjects(from: sorted)
        
        self.arrDaysFull = myTestArray.mutableCopy() as! NSMutableArray
        
        self.availableTableView.delegate = self
        self.availableTableView.dataSource = self
        self.availableTableView.reloadData()
    }
    func setUpUserStatus(ES:String,JS:String)  {
        self.userStatusLbl.text = ""
        if ES == "0" && JS == "0" {
            self.userStatusImg.image = UIImage(named: "clock")
            self.userStatusLbl.text = "Waiting"
        } else if ES == "0" || JS == "1"  {
//            cell.acceptBtn.isHidden = false
//            cell.waitingLabel.isHidden = true
//            cell.waitingImg.isHidden = true
//            cell.acceptBtn.setTitle("Accept/Hire", for: .normal)
//            cell.acceptBtn.accessibilityHint = "1"
//            cell.acceptBtn.tag = indexPath.row - 1
//            cell.acceptBtn.backgroundColor = UIColor.green
//            cell.acceptBtn.accessibilityValue = "\(indexPath.section)"
//            cell.acceptBtn.addTarget(self, action: #selector(self.acceptHire), for: .touchUpInside)
        }else if ES == "1" && JS == "0" {
//            cell.acceptBtn.isHidden = false
//            cell.waitingLabel.isHidden = true
//            cell.acceptBtn.setTitle("Hire", for: .normal)
//            cell.acceptBtn.accessibilityHint = "0"
//            cell.waitingImg.isHidden = true
//            cell.acceptBtn.tag = indexPath.row - 1
//            cell.acceptBtn.backgroundColor = UIColor.green
//            cell.acceptBtn.accessibilityValue = "\(indexPath.section)"
//            cell.acceptBtn.addTarget(self, action: #selector(self.acceptHire), for: .touchUpInside)
        }
    }
   
    // MARK: - Availability API Call -
    func checkAvailibilityApiCall()
    {
        var tempDict = NSDictionary()
        tempDict = ArrayUserListing.object(at: currentIndex) as! NSDictionary
        SwiftLoader.show(animated: true)
        print("tempDict is",tempDict)
        
        var param = [String : Any]()
        
        if fromDash  || fromJobRating {
             param =  [WebServicesClass.METHOD_NAME: "getUserAvailability",
                          "userId":"\(tempDict.object(forKey: "employeeId")!)"]as [String : Any]

        }else{
             param =  [WebServicesClass.METHOD_NAME: "getUserAvailability",
                          "userId":"\(tempDict.object(forKey: "userId")!)"]as [String : Any]

        }
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                print("ErrorgetUserAvailabilityApi",error?.description as String!)
                SwiftLoader.hide()
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                if status == 1
                {
                    if let arrResponsegetUserAvailabilityDict = (dictResponse as AnyObject).object(forKey: "data") as? NSArray
                    {
                        self.arrDaysFull = arrResponsegetUserAvailabilityDict.mutableCopy() as! NSMutableArray
                        self.setGetAvailibilityResponse()
                        // print(self.arrayAvl.count)
                    }
                }
            }
        }
    }
    
    
    // MARK: - Professional Decline -
    func ProfessionalDecline()
    {
        var tempDict = NSDictionary()
        tempDict = ArrayUserListing.object(at: currentIndex) as! NSDictionary
        SwiftLoader.show(animated: true)
        print("tempDict is",tempDict)
        
        
        let loginDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
        let param =  [WebServicesClass.METHOD_NAME: "prodeclinedEmployee",
                      "employerId":"\(loginDict.object(forKey: "employerId")!)",
                      "language":appdel.userLanguage,"userId":"\(tempDict.object(forKey: "userId")!)","jobId":self.jobID,"type":"\(tempDict.object(forKey: "type")!)"] as [String : Any]

        print("parameter for ProfessionalDecline is ",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                SwiftLoader.hide()
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                print("dictResponse ProfessionalDecline is ",dictResponse)
                let status = dictResponse.object(forKey: "status") as! Int
                if status == 1
                {
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.alertMessage.strMessage = "\(dictResponse.value(forKey: "pt_message")!)"
                    }
                    else
                    {
                        self.alertMessage.strMessage = "\(dictResponse.value(forKey: "message")!)"
                    }
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
        }
    }
    
    
    // MARK: - No Show  -
    func noShowApi()
    {
        var tempDict = NSDictionary()
        tempDict = ArrayUserListing.object(at: currentIndex) as! NSDictionary
        SwiftLoader.show(animated: true)
        
        let loginDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
        let param =  [WebServicesClass.METHOD_NAME: "noshowEmployee",
                      "employerId":"\(loginDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage,"userId":"\(tempDict.object(forKey: "userId")!)","jobId":self.jobID,"type":"\(tempDict.object(forKey: "usertype")!)"] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                SwiftLoader.hide()
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                print("dictResponse noshowEmployee ",dictResponse)
                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.alertMessage.strMessage = "\(dictResponse.value(forKey: "pt_message")!)"
                    }
                    else
                    {
                        self.alertMessage.strMessage = "\(dictResponse.value(forKey: "message")!)"
                    }
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
            }
        }
    }
    
}
