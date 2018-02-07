//
//  LeftViewController.swift
//  PeopleNect
//
//  Created by Apple on 17/02/17.
//  Copyright © 2017 Sagar Trivedi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import SwiftLoader


let keymenu = "Menu"
let keyImage = "Mimage"

class Menu_Cell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
}

class Menu_CellExitEmp: UITableViewCell {
    @IBOutlet weak var imgViewExit: UIImageView!
    @IBOutlet weak var lblTitleExit: UILabel!
}

class LeftMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UserChosePhoto {
    
    @IBOutlet var profileimage1: UIImageView!
   
    @IBOutlet weak var lblUser: UILabel!

    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblSearchProfessional: UILabel!
    
    @IBOutlet weak var lblPostNewJob: UILabel!
    @IBOutlet weak var lblSelectionProgress: UILabel!
    @IBOutlet weak var table:UITableView!
    
    @IBOutlet weak var viewTop: UIView!
  
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var viewRating: CosmosView!
    var arrayMenu = [NSDictionary]()
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnProfilePic: UIButton!
    
    @IBOutlet weak var notifyBadgeViewRed: UIView!
     var global = WebServicesClass()

    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ser rating
        self.viewRating.text = "(0)"
        self.viewRating.rating = 0
        
        arrayMenu.append([keymenu:strBalance,keyImage:"map_sel"])
        arrayMenu.append([keymenu:strJobinprogress,keyImage:"menu-search"])
        arrayMenu.append([keymenu:strJobHistory,keyImage:"menu-fagent"])
        
        arrayMenu.append([keymenu:strSettings,keyImage:"menu-search"])
        arrayMenu.append([keymenu:strInviteFrnd,keyImage:"menu-favorite"])
        arrayMenu.append([keymenu:strLogout,keyImage:"menu-favorite"])
    
       // NotificationCenter.default.addObserver(self, selector: #selector(self.updateProfileDetail), name: NSNotification.Name(rawValue: "UpdateProfileDetail"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeImage), name: NSNotification.Name(rawValue: "EmpchangeImageFromEmpSetting"), object: nil)
        
        
        table.tableFooterView = UIView()
        
        
        
        
        // Do any additional setup after loading the view.
        
        
    /*
        // Do not change rating when touched
        // Use if you need just to show the stars without getting user's input
        viewRating.settings.updateOnTouch = false
        
        // Show only fully filled stars
        viewRating.settings.fillMode = .full
        // Other fill modes: .half, .precise
        
        // Change the size of the stars
        viewRating.settings.starSize = 5
        
        // Set the distance between stars
        viewRating.settings.starMargin = 5
        */
        setUpLeftView()
    
        // Badge Notification
        self.notifyBadgeViewRed.isHidden = true
        if appdel.showRedBadge{
            self.notifyBadgeViewRed.layer.cornerRadius = 7.5
            self.notifyBadgeViewRed.layer.masksToBounds = true
            self.notifyBadgeViewRed.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if imageIsNull(imageName: ImgEmployerProfilepic )
        {
            self.setEmployerImage(btnProfilePic:btnProfilePic)
        }
        else
        {
            btnProfilePic.setImage(ImgEmployerProfilepic, for: .normal)
        }
        btnProfilePic.layer.cornerRadius = btnProfilePic.frame.size.height/2
        btnProfilePic.clipsToBounds = true
        btnProfilePic.contentMode = .scaleAspectFit
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //print("view Will Appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayMenu.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if arrayMenu[indexPath.row][keymenu] as? String == strExit{
            
            let Menu_CellExitEmp = tableView.dequeueReusableCell(withIdentifier: "Menu_CellExitEmp", for: indexPath) as! Menu_CellExitEmp
            
            Menu_CellExitEmp.imgViewExit.image = #imageLiteral(resourceName: "exit")
            Menu_CellExitEmp.lblTitleExit.text = strLogOut
            
            return Menu_CellExitEmp
            
        }
            
        else{
            
            let tablecell = tableView.dequeueReusableCell(withIdentifier: "Table_Cell", for: indexPath) as! Menu_Cell

            
            tablecell.lblTitle?.text = arrayMenu[indexPath.row][keymenu] as? String
            
            return tablecell
            
            
        }
    
    }


    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            
            let empBalanceVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpBalanceVC") as! EmpBalanceVC
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: empBalanceVC, withSlideOutAnimation: false, andCompletion: nil)
            
            
            /*let empBalanceVC = self.storyboard?.instantiateViewController(withIdentifier: "RateEmployee") as! RateEmployee
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: empBalanceVC, withSlideOutAnimation: false, andCompletion: nil)*/
            break
            
        case 1:
            let empJobProgressVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpJobProgressVC") as! EmpJobProgressVC
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: empJobProgressVC, withSlideOutAnimation: false, andCompletion: nil)
            break
            
        case 2:
            let EmpHistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpHistoryVC") as! EmpHistoryVC
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: EmpHistoryVC, withSlideOutAnimation: false, andCompletion: nil)
            break

        case 3:
            let empSettingsVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpSettingsVC") as! EmpSettingsVC
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: empSettingsVC, withSlideOutAnimation: false, andCompletion: nil)
            break
            
        case 4:
           
            shareAppExtension()
            break

        case 5:
            self.LogoutAction()
            break
            
        default:
            SlideNavigationController.sharedInstance().toggleLeftMenu()
        }
        
        table.reloadData()
    }
    
    // MARK: - UIView Actions -
    @IBAction func searchProfessionalSel(_ sender: Any) {
        print("searchProfessionalSel")
        
        let empDashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: empDashboardVC, withSlideOutAnimation: false, andCompletion: nil)
    }
    
    @IBAction func postNewJobSel(_ sender: Any) {
        print("postNewJobSel")
        
        let empPostNewJobVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpPostNewJobVC") as! EmpPostNewJobVC
        empPostNewJobVC.profileImage = btnProfilePic.image(for: .normal)!
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: empPostNewJobVC, withSlideOutAnimation: false, andCompletion: nil)
    }
    
    @IBAction func selectionProgressSel(_ sender: Any) {
        print("selectionProgressSel")
        
        let empSelectionProgressVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpSelectionProgressVC") as! EmpSelectionProgressVC
        
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: empSelectionProgressVC, withSlideOutAnimation: false, andCompletion: nil)
    }
    
    
    @IBAction func clickBack(_ sender: Any) {
        
        
        SlideNavigationController.sharedInstance().closeMenu(completion: nil)
      /*  let EmpDashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: EmpDashboardVC, withSlideOutAnimation: false, andCompletion: nil)
 */
    }
    
    
    @IBAction func clickProfile(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let jobSelectProfilrPicVC = storyBoard.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        appdel.isFromRegister = false

        jobSelectProfilrPicVC.delegate = self
        
       //appdel.window?.rootViewController?.present(jobSelectProfilrPicVC, animated: true, completion: nil)

        SlideNavigationController.sharedInstance().present(jobSelectProfilrPicVC, animated: true, completion: nil)

        
        //self.present(jobSelectProfilrPicVC, animated: true, completion: nil)
        
    }
    
    
    func LogoutAction()
    {
        
        let alert = UIAlertController(title: Localization(string: "Log out"), message: Localization(string: "Are you sure you want to log out?"), preferredStyle: .alert)
        
        
        alert.addAction((UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            self.logoutApi()
            //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        })))
        
        alert.addAction(UIAlertAction(title: Localization(string: "Cancel"), style: .cancel, handler: nil))
      
        //appdel.window?.rootViewController?.present(alert, animated: true, completion: nil)
        SlideNavigationController.sharedInstance().present(alert, animated: true, completion: nil)

    }
    
    // MARK: - UIView Methods -
    func setUpLeftView()
    {
        lblSearchProfessional.text = strSearchProfessionals
        lblPostNewJob.text = strPostnewJob
        lblSelectionProgress.text = strSelectioninProgresss
        
        viewTop.backgroundColor = LightBlueTopLeftMenuColor
        viewBottom.backgroundColor = DarkBlueBottomLeftMenuColor
        btnProfilePic.backgroundColor = ImgBackLeftMenuColor
        
       
        lblUser.text = appdel.loginUserDict.object(forKey: "companyName") as? String
       
        // call user Rating api and set outlet of Cosmos View
        self.getUserRating(userId: "\(appdel.loginUserDict.object(forKey: "employerId")!)", userType: "1")
    }
    
    func EmpchangeImageFromSetting() {
        btnProfilePic.setImage(ImgEmployerProfilepic, for: .normal)
    }
    
    func changeImage()
    {
        btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
    }
    
    
    func userHasChosen(image: UIImage){
        
        if image.isEqual(nil){
            print("Choose An Image!")
        }
        else{
            
            self.dismiss(animated: true, completion: nil)
            btnProfilePic.setImage(image, for: .normal)
            ImgEmployerProfilepic = image
            
            self.view.makeToast(Localization(string:"Profile updated!"), duration: 3.0, position: .bottom)

            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeImageEmployer"), object: nil)

            let userID = "\(appdel.loginUserDict.object(forKey: "employerId")!)"
            
            self.UploadImage(image: image, userID: userID,isEmployer:true)
        }
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
                      "userId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
            "userType":"1","deviceType":"2","deviceID":UIDevice.current.identifierForVendor!.uuidString] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {                SwiftLoader.hide()

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
                    
                    UserDefaults.standard.removeObject(forKey: kEmpLoginDict)
                    UserDefaults.standard.removeObject(forKey: kUserLoginDict)
                    ImgEmployerProfilepic = UIImage()
                    ImgJobSeekerProfilepic = UIImage()
                    
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
        
        print("param is",param)
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
                
                SwiftLoader.hide()
                
                if status == 1
                {
                    self.viewRating.text = "(\(dictResponse.object(forKey: "ratingCount")!))"
                    
                    if dictResponse.object(forKey: "rating")! is NSNumber {
                        print("it's number")
                        self.viewRating.rating = Double((dictResponse.object(forKey: "rating")!) as! NSNumber)
                    }else{
                        self.viewRating.rating = Double((dictResponse.object(forKey: "rating")!) as! String)!
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
