//
//  LeftMenuJobSeeker.swift
//  PeopleNect
//
//  Created by Apple on 17/02/17.
//  Copyright © 2017 Sagar Trivedi. All rights reserved.
//

import UIKit
import SwiftLoader
import Cosmos

class Menu_Cell1: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var notifyRedViewBadge: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notifyRedViewBadge.layer.cornerRadius = 5
        notifyRedViewBadge.layer.masksToBounds = true
    }
}

class Menu_CellExit: UITableViewCell {
    @IBOutlet weak var imgViewExit: UIImageView!
    @IBOutlet weak var lblTitleExit: UILabel!
}



class LeftMenuJobSeeker: UIViewController,UITableViewDataSource,UITableViewDelegate,UserChosePhoto {
    
    @IBOutlet var btnProfilePic: UIButton!
    @IBOutlet var profileimage1: UIImageView!
   
    @IBOutlet weak var lblUser: UILabel!

    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblSearchjobs: UILabel!
    
    @IBOutlet weak var lblHired: UILabel!
  
    @IBOutlet weak var lblExperties: UILabel!
   
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblYearofExp: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewTop: UIView!
  
    @IBOutlet weak var viewBottom: UIView!
    
    var arrayMenu = [NSDictionary]()
    
    var jobLogInVC = JobLogInVC()
    
    var global = WebServicesClass()
    
    

    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayMenu.append([keymenu:strPendingInvitations,keyImage:"map_sel"])
        arrayMenu.append([keymenu:strPendingApplication,keyImage:"menu-search"])
        arrayMenu.append([keymenu:strOngoingJob,keyImage:"menu-fagent"])
        
        arrayMenu.append([keymenu:strJobHistory,keyImage:"menu-search"])
        arrayMenu.append([keymenu:strSettings,keyImage:"menu-favorite"])
        arrayMenu.append([keymenu:strAvailibility,keyImage:"menu-favorite"])
        arrayMenu.append([keymenu:strInviteFrnd,keyImage:"menu-favorite"])
        arrayMenu.append([keymenu:strLogout,keyImage:"menu-logout"])

     //   arrayMenu.append([keymenu:strLogout,keyImage:"menu-favorite"])

    
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProfileDetail), name: NSNotification.Name(rawValue: "UpdateProfileDetail"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeImage), name: NSNotification.Name(rawValue: "changeImageFromSetting"), object: nil)

        
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.isScrollEnabled = true
        tblView.tableFooterView = UIView()
        
        
        ratingView.text = "(0)"
        ratingView.rating = 0
        
        // Do any additional setup after loading the view.
        
        
        lblSearchjobs.text = strSearchJobs
        
        viewTop.backgroundColor = DarkBlueBottomLeftMenuColor
        viewBottom.backgroundColor = LightBlueTopLeftMenuColor

        
        setUpLeftView()
        
        // Get User rating
        let loginDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
        self.getUserRating(userId: "\(loginDict.object(forKey: "userId")!)", userType: "2")

    }

    override func viewDidAppear(_ animated: Bool) {
        
//        profileimage1.layer.cornerRadius = profileimage1.frame.size.height/2
//        profileimage1.clipsToBounds = true
        
        if imageIsNull(imageName: ImgJobSeekerProfilepic ){
            print("image called")
            self.setImageForJobSeeker(btnProfilePic:btnProfilePic)
        }else{
            btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
        }
        
        
        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2
        btnProfilePic.clipsToBounds = true
        btnProfilePic.contentMode = .scaleAspectFit
        //btnProfilePic.layer.borderWidth = 1
        //btnProfilePic.layer.borderColor = ColorProfilePicBorder.cgColor
        

       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //print("view Will Appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UITableView Methods -
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayMenu.count;
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        if arrayMenu[indexPath.row][keymenu] as? String == strExit{
            
            let Menu_CellExit = tableView.dequeueReusableCell(withIdentifier: "Menu_CellExit", for: indexPath) as! Menu_CellExit
            
            Menu_CellExit.imgViewExit.image = #imageLiteral(resourceName: "exit")
            Menu_CellExit.lblTitleExit.text = strExit
            
            return Menu_CellExit

        }
        
        else{
            
            let tablecell = tableView.dequeueReusableCell(withIdentifier: "Table_Cell", for: indexPath) as! Menu_Cell1
        
            tablecell.lblTitle?.text = arrayMenu[indexPath.row][keymenu] as? String
            
            tablecell.notifyRedViewBadge.isHidden = true
            
            if indexPath.row == 0 {
                //        appdel.isGotInvitationNotification = true

                if  appdel.isGotInvitationNotification{
                    tablecell.notifyRedViewBadge.isHidden = false
                }

            }
            if indexPath.row == 2 {
                //        appdel.isSeeDetailNotification = true
                if  appdel.isSeeDetailNotification{
                    tablecell.notifyRedViewBadge.isHidden = false
                }
            }
            
            return tablecell


        }
        
       // tablecell.imgView?.image = UIImage(named: arrayMenu[indexPath.row][keyImage] as! String)
//        tablecell.lblTitle?.text = arrayMenu[indexPath.row][keymenu] as? String
//        
//        if tablecell.lblTitle?.text == strLogout{
//        
//            tablecell.imgView.image = #imageLiteral(resourceName: "exit")
//            
////            tablecell.lblTitle.alignmentRect(forFrame: CGRect(x: (tablecell.imgView.frame.origin.x)+(tablecell.imgView.frame.size.width)*2, y: 0, width: view.frame.size.width, height: tablecell.imgView.frame.size.height))
//            
//          //  tablecell.lblTitle.textAlignment = .center
//            
//        }
        

      //  return 0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    
        switch indexPath.row {
            
        case 0:
            let JobPendingInvitationVC = self.storyboard?.instantiateViewController(withIdentifier: "JobPendingInvitationVC") as! JobPendingInvitationVC
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: JobPendingInvitationVC, withSlideOutAnimation: false, andCompletion: nil)

            break
        case 1:
            
            let JobPendingAppVC = self.storyboard?.instantiateViewController(withIdentifier: "JobPendingAppVC") as! JobPendingAppVC
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: JobPendingAppVC, withSlideOutAnimation: false, andCompletion: nil)
            
            break
            
        case 2:
            
            let JobOnGoingJobsVC = self.storyboard?.instantiateViewController(withIdentifier: "JobOnGoingJobsVC") as! JobOnGoingJobsVC
            
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: JobOnGoingJobsVC, withSlideOutAnimation: false, andCompletion: nil)
            
            break

            
        case 3:
            
            let JobHistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "JobHistoryVC") as! JobHistoryVC
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: JobHistoryVC, withSlideOutAnimation: false, andCompletion: nil)
            
            break

            
        case 4:
            ////////////
            let JobSettingVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSettingVC") as! JobSettingVC
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: JobSettingVC, withSlideOutAnimation: false, andCompletion: nil)
            
            break
            
        case 5:
            let JobDashBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "JobDash") as! JobDash
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayAvailability"), object: nil)
            
            
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: JobDashBoardVC, withSlideOutAnimation: false, andCompletion: {
                //JobDashBoardVC.viewTurnYourAvailibiltyOn.isHidden = false
                JobDashBoardVC.viewTurnYourAvailibiltyOn.isHidden = true
                JobDashBoardVC.viewAvailibilityOnOff.isHidden = false
            })
            
            break
            
            
        case 6:
            
            shareAppExtension()
            
            break
            
            
        case 7:
            
            
           
             self.LooutAction()
            
            break

            
        default:
            SlideNavigationController.sharedInstance().toggleLeftMenu()
        }
        
      //  seletedtag = indexPath.row
        
        tblView.reloadData()
      
    }
    
    // MARK: - UIView Actions -
    @IBAction func searchJobSel(_ sender: Any)
    {
        let JobDashBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "JobDash") as! JobDash
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeAvailability"), object: nil)
        
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: JobDashBoardVC, withSlideOutAnimation: false, andCompletion: {
            JobDashBoardVC.viewTurnYourAvailibiltyOn.isHidden = true
            JobDashBoardVC.viewAvailibilityOnOff.isHidden = true
        })
    }
    
    @IBAction func clickUserProfilePic(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        appdel.isFromRegister = false
        
        let jobSelectProfilrPicVC = storyBoard.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        
        jobSelectProfilrPicVC.delegate = self
        
       // appdel.window?.rootViewController?.present(jobSelectProfilrPicVC, animated: true, completion: nil)
        
        SlideNavigationController.sharedInstance().present(jobSelectProfilrPicVC, animated: true, completion: nil)

    }
    
    @IBAction func clickBack(_ sender: Any) {
        
        //let JobDash = self.storyboard?.instantiateViewController(withIdentifier: "JobDash") as! JobDash
        
        
        SlideNavigationController.sharedInstance().closeMenu(completion: nil)
        
       // SlideNavigationController.sharedInstance().popToRootAndSwitch(to: JobDash, withSlideOutAnimation: false, andCompletion: nil)
        
    }
    
    
    func userHasChosen(image: UIImage){
        
        print("called")
        
        if image.isEqual(nil){
        }
        else{
            
            self.dismiss(animated: true, completion: nil)
            btnProfilePic.setImage(image, for: .normal)
            ImgJobSeekerProfilepic = image
            
           // let loginDict = UserDefaults.standard.object(forKey: kJobSignUpDict) as! NSDictionary
            
            self.view.makeToast("Profile updated!", duration: 3.0, position: .bottom)

            let userID = "\(appdel.loginUserDict.object(forKey: "userId")!)"
            self.UploadImage(image: image, userID: userID,isEmployer:false)
            
        }
    }

    
    // MARK: - UIView Methods -
    func setUpLeftView()
    {
        
            let loginDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
            
            print("leftloginDict",loginDict)
           
            
            let exp = loginDict.object(forKey: "exp_years") as? String
            
            print("exp",exp!)
            
            
//            let expNum = exp?.components(separatedBy: ".").first!
//            
//            print("expNum",expNum!)
        
        
        lblYearofExp.text = "\(exp!) \(Localization(string: "years of experience"))"
        
            
            lblUser.text = "\(loginDict.object(forKey: "first_name")!) \(loginDict.object(forKey: "last_name")!)"
            
        
           // print("category_name",loginDict.object(forKey: "category_name") as! String)
            
            lblExperties.text = "\(loginDict.object(forKey: "category_name")!)"
        
      }
    
    
    func updateProfileDetail()
    {
        self.setUpLeftView()
    }
    
    func changeImage()
    {
        btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
    }
    
    
    func LooutAction()
    {
        
        
        
        
        let alert = UIAlertController(title: Localization(string: "Log out"), message: Localization(string: "Are you sure you want to log out?"), preferredStyle: .alert)
        
        
        alert.addAction((UIAlertAction(title: "Ok", style: .default, handler: { action in
            
           // self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
             self.logoutApi()
            
        })))
        
        alert.addAction(UIAlertAction(title: Localization(string: "Cancel"), style: .cancel, handler: nil))
       
        SlideNavigationController.sharedInstance().present(alert, animated: true, completion: nil)
        //appdel.window?.rootViewController?.present(alert, animated: true, completion: nil)
     }
    // MARK: - Api Call -

    func logoutApi()  {
        
        SwiftLoader.show(animated: true)
        
        /*
         
         "{
         ""deviceID"": ""3e209683c165da83"",
         ""deviceType"": ""1"",
         ""userId"": ""77"",
         ""userType"": ""2"",
         ""methodName"": ""logout""
         }"
         
         */
        
        // need to put the device id
        
        let param =  [WebServicesClass.METHOD_NAME: "logout",
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "userType":"2","deviceType":"2","deviceID":UIDevice.current.identifierForVendor!.uuidString] as [String : Any]
        
        
        print("ParamfollowUpAPI",param)
        
        
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
                
                print("logout response",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                print("status in logout ",status)
                
                if status == 1
                {
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    ImgEmployerProfilepic = UIImage()
                    ImgJobSeekerProfilepic = UIImage()

                    
                    UserDefaults.standard.removeObject(forKey: kEmpLoginDict)
                    UserDefaults.standard.removeObject(forKey: kUserLoginDict)
                    
                    appdel.logoutToSetStartView()
                }
                else
                {
                    print("Error","\(Response.object(forKey: "message")!)")
                }
                
            }
        }
    }
    
    func getUserRating(userId:String,userType:String)
    {
        SwiftLoader.show(animated: true)
        let global = WebServicesClass()
        
        let param =  [WebServicesClass.METHOD_NAME: "getUserRating",
                      "userId":userId,
                      "userType":userType] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {                SwiftLoader.hide()

                print("Error",error?.description as String!)
            }
            else
            {
                SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                let status = dictResponse.object(forKey: "status") as! Int
                
                print("dictResponse rating is",dictResponse)
                SwiftLoader.hide()
                
                if status == 1
                {
                    
                     self.lblHired.text = "\(Localization(string: "Jobs")): \(dictResponse.object(forKey: "jobSeekerHire")!), \(Localization(string: "No show")): \(dictResponse.object(forKey: "jobSeekerNoShow")!)"
                    
                    self.ratingView.text = "(\(dictResponse.object(forKey: "ratingCount")!))"
                   
                    if dictResponse.object(forKey: "rating")! is NSNumber {
                        print("it's number")
                        self.ratingView.rating = Double((dictResponse.object(forKey: "rating")!) as! NSNumber)
                    }else{
                    self.ratingView.rating = Double((dictResponse.object(forKey: "rating")!) as! String)!
                    }
                }
                else
                {
                    print("Error","\(Response.object(forKey: "message")!)")
                }
                
            }
        }
    }
    

}




