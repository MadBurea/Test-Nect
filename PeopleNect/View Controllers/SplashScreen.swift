//
//  SplashScreen.swift
//  PeopleNect
//
//  Created by BAPS on 11/01/18.
//  Copyright © 2018 InexTure. All rights reserved.
//

import UIKit
class SplashScreen: UIViewController {

    var global = WebServicesClass()
   
    // MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* Check to which kind user */
        if UserDefaults.standard.object(forKey: kUserLoginDict) != nil
        {
            appdel.loginUserDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
            self.checkUserActive(user_id: "\(appdel.loginUserDict.object(forKey: "userId")!)", je_Type_Id: "J")
        }
        else if UserDefaults.standard.object(forKey: kEmpLoginDict) != nil
        {
            appdel.loginUserDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
            self.checkUserActive(user_id: "\(appdel.loginUserDict.object(forKey: "employerId")!)", je_Type_Id: "E")
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                let StartingVC = self.storyboard?.instantiateViewController(withIdentifier: "StartingVC") as! StartingVC
                self.navigationController?.pushViewController(StartingVC, animated: true)
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Go To Home Page -
    func GoToJobseeker()  {
        // Job Seeker Dashboard To Move
        let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
        let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "JobDash") as! JobDash
        let navigationController = SlideNavigationController(rootViewController: empdashboardVC)
        let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuJobSeeker") as! LeftMenuJobSeeker
        SlideNavigationController.sharedInstance().leftMenu = leftview
        SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
        navigationController.navigationBar.isHidden = true
        appdel.window!.rootViewController = navigationController
    }
    func GoToEmployerDashBoard()  {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
        let navigationController = SlideNavigationController(rootViewController: empdashboardVC)
        let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuViewController") as! LeftMenuViewController
        SlideNavigationController.sharedInstance().leftMenu = leftview
        SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
        navigationController.navigationBar.isHidden = true
        appdel.window!.rootViewController = navigationController
    }

    
    // MARK: - API Call -
    func checkUserActive(user_id: String, je_Type_Id: String)
    {
        /*
         methodName = "checkUserActive"
         je_id = 1
         je_Type_Id = jobseeker - "J" or Employer - "E"
         */
        
        let param =  [WebServicesClass.METHOD_NAME: "checkUserActive","je_id":user_id,"je_Type_Id":je_Type_Id,"language":appdel.userLanguage] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                print("checkUserActive resposne is",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                //let is_loggedIn = dictResponse.object(forKey: "is_loggedIn") as! Int
                let is_loggedIn = "\(dictResponse.object(forKey: "is_loggedIn")!)"

                print("checkUserActive is_loggedIn is",is_loggedIn)

                if is_loggedIn == "0" && status == 1 {
                    if je_Type_Id == "J" {
                        self.logoutApi(userType: "2", userId:user_id )
                    }else{
                        self.logoutApi(userType: "1", userId:user_id )
                    }
                }else{
                    if je_Type_Id == "J" {
                        self.GoToJobseeker()
                       // self.logoutApi(userType: "2", userId:user_id )

                    }else{
                        self.GoToEmployerDashBoard()
                      //  self.logoutApi(userType: "1", userId:user_id )
                        
                    }
                }
            }
        }
    }

    func logoutApi(userType: String, userId: String)  {
        
        
        /*
         "{
         ""deviceID"": ""3e209683c165da83"",
         ""deviceType"": ""1"",
         ""userId"": ""77"",
         ""userType"": ""2"",
         ""methodName"": ""logout""
         }"
         */
        
        
        let param =  [WebServicesClass.METHOD_NAME: "logout",
                      "userId":userId,
            "userType":userType,"deviceType":"2","deviceID":UIDevice.current.identifierForVendor!.uuidString] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
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
    
}
