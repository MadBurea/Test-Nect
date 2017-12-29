//
//  AppDelegate.swift
//  PeopleNect
//
//  Created by BAPS on 06/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import FacebookCore
import Google
import GooglePlacePicker
import GooglePlaces
import SwiftLoader
import UserNotifications
import Fabric
import Crashlytics
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate{
    
    var window: UIWindow?
    var config : SwiftLoader.Config = SwiftLoader.Config()
    var locationManager:CLLocationManager!
    var isFromRegister = false
    var deviceToken = ""
    var fcmToken = ""
    var userLanguage = ""
    
    // 1: portuguese, 2: English
    var userLanguageForPassword = ""

    var userLocationLat = ""
    var userLocationLng = ""
    var loginUserDict: NSDictionary!
    var deviceLanguage = ""

    var isNotificationCome = false
   
    /* Common Badge For Both Dash */
    var showRedBadge = false
    
    /* Badge Notification For Employer */
    var isHiredNotification  = false
    var isSelectedNotification  = false
    var isApplicantNotification  = false
    var isRejectedNotification  = false
    
    
    /* Badge Notification For Job Seeker */
    var isSeeDetailNotification  = false
    var isGotInvitationNotification  = false

    var notificationStatus = 200

    
    // MARK:- Appdelegate Life Cyle -

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //  UINavigationBar.appearance().barStyle = .blackOpaque
        UINavigationBar.appearance().barStyle = .blackTranslucent
        //UINavigationBar.appearance().barStyle = .black
        // UIApplication.shared.statusBarStyle = .lightContent
        // Override point for customization after application launch.
        
        config.size = 150
        config.spinnerColor = UIColor(colorLiteralRed: 19.0/255.0, green: 65.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        config.foregroundColor = .white
        config.foregroundAlpha = 0.5
        config.titleTextFont = UIFont(name: "Montserrat-Regular", size: 12.0)!
        config.backgroundColor = .white
        config.titleTextColor = .black
        config.spinnerLineWidth = 50.0
        
        
        GMSPlacesClient.provideAPIKey("AIzaSyDWBdQY8qpV-ynGVeszgkSRQzlFph3U_0w")
        
        GMSServices.provideAPIKey("AIzaSyDWBdQY8qpV-ynGVeszgkSRQzlFph3U_0w")
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "", PayPalEnvironmentSandbox: "AQ9YsiCP_QhToVAiOsQ96FZvZzlQfkhV85F4MtCTc4pOloURwbUBEyCoa3yzkSbnvh9w91CO9UL3T50B"])
        
        PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentSandbox)
        
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // For Push Notification check
        //        if #available(iOS 10.0, *) {
        //            let center = UNUserNotificationCenter.current()
        //            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        //
        //                UNUserNotificationCenter.current().delegate = self
        //
        //                // Enable or disable features based on authorization.
        //            }
        //        } else {
        //            // Fallback on earlier versions
        //            let settings = UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //            application.registerForRemoteNotifications()
        //        }
        //        application.registerForRemoteNotifications()
        
        // Fabric
        
        Fabric.with([Crashlytics.self])
        
        //Fabric.with([Crashlytics.self, STPAPI])
        
      
       // self.logUser()
        
        // Firebase
        
        FIRApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
      
        
        FIRMessaging.messaging().remoteMessageDelegate = self
        
       // FIRMessaging.messaging().shouldEstablishDirectChannel = true

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(self.tokenRefreshNotification(notification:)),
                                                        name: NSNotification.Name.firInstanceIDTokenRefresh,
                                                        object: nil)
//        FIRMessaging.remoteMessageDelegate = self
        
        
        
        
        
        /* Check to which kind user */
        if UserDefaults.standard.object(forKey: kUserLoginDict) != nil
        {
            appdel.loginUserDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
            
            
            // Job Seeker Dashboard To Move
            let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
            
            let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "JobDash") as! JobDash
            
            let navigationController = SlideNavigationController(rootViewController: empdashboardVC)
            
            let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuJobSeeker") as! LeftMenuJobSeeker
            
            SlideNavigationController.sharedInstance().leftMenu = leftview
            
            SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
            navigationController.navigationBar.isHidden = true
        
            self.window!.rootViewController = navigationController
            
        }
        else if UserDefaults.standard.object(forKey: kEmpLoginDict) != nil
        {
            // Employee Dashboard To Move
            
            appdel.loginUserDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
            
            let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "EmpDash") as! EmpDash
            
            
            let navigationController = SlideNavigationController(rootViewController: empdashboardVC)
            
            
            let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuViewController") as! LeftMenuViewController
            
            SlideNavigationController.sharedInstance().leftMenu = leftview
            
            SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
            
            navigationController.navigationBar.isHidden = true
         
            
            self.window!.rootViewController = navigationController
        }
        
        self.checkDevicelanguage()
        
        return true
    }
    // User Log Fabric
    
    func logUser() {
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("narendra.inexture@gmail.com")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
    }
    
    // firebase
    
//    func application(application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
    
    
    // receive message FCM
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme?.compare("fb296940694047526") == .orderedSame{
            if #available(iOS 9.0, *) {
                return SDKApplicationDelegate.shared.application(app, open: url, options: options)
            } else {
                // Fallback on earlier versions
            }
        }
        else{
            if #available(iOS 9.0, *) {
                return GIDSignIn.sharedInstance().handle(url,
                                                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                         annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            } else {
                // Fallback on earlier versions
            }
        }
        
        return false
    }
    
    func initLocation() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined{
            locationManager?.requestAlwaysAuthorization()
        }
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // Location manager
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        appdel.userLocationLat = "\(locValue.latitude)"
        appdel.userLocationLng = "\(locValue.longitude)"
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
    }
    
    
    
    // MARK:For Push Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceT = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        appdel.deviceToken = deviceT

        if let refreshedToken = FIRInstanceID.instanceID().token() {
            appdel.fcmToken = "\(refreshedToken)"
            print("InstanceID token:",appdel.fcmToken)
        }
     

        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)

        
//        let alert = UIAlertController(title: "", message: deviceT, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        
        print("device token is", deviceT)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK:- GIDSignInDelegate Method
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            
            let userId = user.userID // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            //   let password = user.profile
            print("UserID:",userId! + "Token",idToken! + "Full Name",fullName! + "givenName", givenName! + "Family Name",familyName! + "Email", email!)
            
            
            
        } else {
            print("\(error.localizedDescription)")
        }
        
        
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: Error!){
        // Perform any operations when the user disconnects from app here.
        if (error == nil) {
            
            let userId = user.userID // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print("UserID:",userId! + "Token",idToken! + "Full Name",fullName! + "givenName", givenName! + "Family Name",familyName! + "Email", email!)
            
            
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("Error:","\(error.localizedDescription)")
        }
        
        // ...
    }
    
    // MARK:- Push Notification -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("willPresent notification method called")
        
        if let aps = notification.request.content.userInfo["aps"] as? NSDictionary
        {
            print("aps is",aps)
            if let data = aps["data"] as? NSDictionary
            {
                print("data inside willPresent notification",data)
                let status = data["notification_status"] as! Int
                print("notification status is",status)
                //self.PresentVC(status: status,data: data)
            }
        }
        
        //completionHandler([.sound])
        
        let topVC = UIApplication.topViewController()
        if topVC is CustomChatScene {
            completionHandler([.sound])
        }else{
            completionHandler([.alert, .sound])
        }
        
       // completionHandler([.sound])

    }
    
    @available(iOS 10.0, *)
    private func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        //let aps = response.notification.request.content.userInfo["aps"] as? NSDictionary
        
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
        switch response.actionIdentifier {
            
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    // MARK:- FCM Receive Data Message -
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        print("didReceiveRemoteNotification without completion")
        
            let alert = UIAlertController(title: "", message: "didReceiveRemoteNotification without completion", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                    alert.dismiss(animated: true, completion: nil)
               }))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)

        if let messageData = userInfo["gcm.notification.data"] {
            let dict = convertToDictionary(text: messageData as! String)
            let status = dict?["notification_status"] as! Int
            print("notification status is",status)
            print("dict is",dict!)
            self.PresentVC(status: status,data: dict!)
        }
        print("userinfo inside didReceiveRemoteNotification is",userInfo)
        
    }
    
    
    // it called after App terminated
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("didReceiveRemoteNotification having  completion block")

       
        if let messageData = userInfo["gcm.notification.data"] {
            
            let dict = convertToDictionary(text: messageData as! String)
            let status = dict?["notification_status"] as! Int
            print("dict is",dict!)

            self.PresentVC(status: status,data: dict!)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }

    
    // MARK:- Present VC -
    func PresentVC(status:Int,data:[String: Any])  {
        
        appdel.showRedBadge = true
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        
        // 0 means Chat notification
        if status == 0 {
            let status = data["userStatus"] as! String
            print("notification status is",status)
            if status == "2" {
                let topVC = UIApplication.topViewController()
                if topVC is CustomChatScene {
                    
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        // your code here
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatNotificationJOB"), object: data)
                        self.isNotificationCome = false
                    }
                    isNotificationCome = true
                }
            }
            else{
                let topVC = UIApplication.topViewController()
                if topVC is CustomChatScene {
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        // your code here
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatNotification"), object: data)
                        self.isNotificationCome = false
                    }
                    isNotificationCome = true
                }
            }
        }
            
            // 1 means Review Employer
        else if status == 1 {
            // EmploYer Side Notification -- Job rating with Cost
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "jobSeekerRating"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 2 means Review JobSeeker
        else if status == 2 {
            
            // Present in Job Seeker side -- Rate Employer Screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RateEmployer"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
            
        }
            
            // 3 means Invitation -- Got Invitation
        else if status == 3 {
           
            // here job seeker got the invitation so w have to present got initation screen from jobDash

            appdel.isGotInvitationNotification = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotInvitation"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 4 means Select Notification
        else if status == 4 {
            //  See detail screen OnGoingDetail  Job Seeker Side
            
            appdel.isSeeDetailNotification = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectedJob"), object: data)
                
                self.notificationStatus = 4
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 5 Lapsed job -- Edit Job
        else if status == 5 {
            
            // it's edit job so present EditJob Notify Screen from EmpDash
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editjobNotify"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 6 Apply job
        else if status == 6 {
            // Job seeker applied job so present selection screen from Employer Dash
            
            appdel.isApplicantNotification = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selection"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 7 Accept invitation
        else if status == 7 {
            // Job seeker Accepted job so present selection screen from Employer Dash
            
            appdel.isSelectedNotification = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selection"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 8 Reject invitation
        else if status == 8 {
            // Job seeker Rejected job so present selection screen from Employer Dash
            
            appdel.isRejectedNotification = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selection"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 9 Edit job re-acnowladgement
        else if status == 9 {
            //  See detail screen OnGoingDetail  Job Seeker Side
            appdel.isSeeDetailNotification = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectedJob"), object: data)
                
                self.notificationStatus = 9
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 10 Cancel job by employer
        else if status == 10 {
            // Home Screen -- Done
        }
            
            // 11 Auto reject
        else if status == 11 {
            // Home Screen -- Done  here Follow Up Screen you have to add
        }
            
            // 12 Acknowledgement
        else if status == 12 {
            // Job seeker Rejected job so present selection screen from Employer Dash
            
            appdel.isHiredNotification = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selection"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 13 Match Job Notification
        else if status == 13 {
            // Match job  Job Seeker it's job Seeker Side Expand Blue color and Apply -- back
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MatchJobNotify"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            // 14 GIve up by job seeker
        else if status == 14 {
            // Job seeker Rejected job so present selection screen from Employer Dash
            
            appdel.isRejectedNotification = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selection"), object: data)
                self.isNotificationCome = false
            }
            isNotificationCome = true
        }
            
            // 15 Decline by employer
        else if status == 15 {
            // Home Screen -- Done
        }
            
            // 16 Job Re open
        else if status == 16 {
            // Home Screen -- Done
            
        }
            
            // 17 Job Re open
        else if status == 17 {
            // Home Screen -- Done
        }
    }
    
    // MARK:- FCM Delegate -

    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
      
        //self.PresentVC(status: 0, data: remoteMessage.appData as! [String : Any])
        print(" remote message ", remoteMessage.appData)
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = FIRInstanceID.instanceID().token()
        
        if refreshedToken != nil {
            appdel.fcmToken = "\(refreshedToken!)"
            print("fcm token is ",appdel.fcmToken)
        }
        print("InstanceID token: \(refreshedToken)")
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    
    
    func logoutToSetStartView()
    {
        SlideNavigationController.removeSharedInstance()
        
        let StartController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartingVC") as! StartingVC
        
        let nav = UINavigationController(rootViewController: StartController)
        self.window!.rootViewController = nav
        
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK:- Check Device Language -
    func checkDevicelanguage()  {
        appdel.deviceLanguage = NSLocale.preferredLanguages[0]
        print("language is",deviceLanguage)

        if appdel.deviceLanguage == "pt-BR"
        {
            self.setUserDefault(ObjectToSave: kFR as AnyObject?, KeyToSave: kLanguage)
            _ = SetLanguage(language: Localisator.sharedInstance.availableLanguagesArray[1])
            appdel.userLanguage = "pt"
            appdel.userLanguageForPassword = "1"
        }
        else
        {
            self.setUserDefault(ObjectToSave: kEN as AnyObject?, KeyToSave: kLanguage)
            _ = SetLanguage(language: Localisator.sharedInstance.availableLanguagesArray[0])
            appdel.userLanguage = "en"
            appdel.userLanguageForPassword = "2"

        }
    }
    func setUserDefault(ObjectToSave : AnyObject?  , KeyToSave : String)
    {
        let defaults = UserDefaults.standard
        
        if (ObjectToSave != nil)
        {
            defaults.set(ObjectToSave!, forKey: KeyToSave)
        }
        
        UserDefaults.standard.synchronize()
    }
}
