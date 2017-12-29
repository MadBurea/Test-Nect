//
//  Extension.swift
//  PeopleNect
//
//  Created by BAPS on 10/11/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: range.lowerBound)
        let idx2 = index(startIndex, offsetBy: range.upperBound)
        return self[idx1..<idx2]
    }
    var count: Int { return characters.count }
}

extension Float {
    var clean: String {
        
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Date {
    
    var currentUTCTimeZoneDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    var currentUTCTimeZoneTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
extension Date {
    @nonobjc static var localFormatter: DateFormatter = {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateStyle = .medium
        dateStringFormatter.timeStyle = .medium
        return dateStringFormatter
    }()
    
    func localDateString() -> String
    {
        return Date.localFormatter.string(from: self)
    }
}

extension UIViewController {
    
    
    func getTimeZoneValue() -> Int {
        //var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        return TimeZone.current.secondsFromGMT() * 1000
    }

    
    
    //MARK:- DateFormatter
    
    func convertDateFormater(_ date: String,hour:String) -> String
    {
        let dateFormatter = DateFormatter()
        
        //2017-10-18
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeStr = "\(dateFormatter.string(from: dt!)) \(hour)"
        
        //return dateFormatter.string(from: dt!)
        
        return timeStr
    }
    
    
    func LocalToUTCDate(_ date: String,hour:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone.current

        print("date is",date)
        print("hour  is",hour)

        let timeStr = "\(date) \(hour)"
        
        let dt = dateFormatter.date(from: timeStr)
        print("dt is",dt)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: dt!)
    }
    
    
    func convertDateFormaterUTC(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        
        //2017-10-18
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM"
        
        return dateFormatter.string(from: dt!)
    }
    
    func currentTime() -> Date{
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        var countMinute:Int
        var countHour:Int

        countMinute = minutes/10
        countHour = hour/10

        var minute =  "\(minutes)"
        var hourAdded =  "\(hour)"

        if countMinute == 0{
            minute = "0\(minutes)"
        }
        if countHour == 0{
            hourAdded = "0\(hour)"
        }
        
       let time = "\(hourAdded):\(minute)"
        print("time is",time)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm"
        let UTCStartTime = dateFormat.date(from: time)
        return UTCStartTime!
    }
    
    
    func UTCToLocal(date:String) -> String {
        
        var date1 = String()
        
        date1 = date
        if date1 == "24:00" {
            date1 = "00:00"
        }
        print("date is",date1)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date1)
        print("date is dt",dt)

        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm"
        
        
        return dateFormatter.string(from: dt!)
    }
    
    func showNavigationBarView()  {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 32.0 / 255.0, green: 88.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setEmployerImageView(btnProfilePic:UIImageView)  {
        
        if UserDefaults.standard.object(forKey: kEmpLoginDict) != nil {
            
            let loginDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
            
            let imagUrlString = loginDict.object(forKey: "profilePic") as! String
            
            if  (imagUrlString.count) > 0 {
                let url = URL(string: imagUrlString)
                let placeHolderImage = "company_profile"
                let placeimage = UIImage(named: placeHolderImage)
                btnProfilePic.sd_setImage(with: url, placeholderImage: placeimage)
//                if imageIsNull(imageName:ImgEmployerProfilepic) {
//
//                }else{
//                    btnProfilePic.image = ImgEmployerProfilepic
//                }
            }
        }
        
    }
    
    func setEmployerImage(btnProfilePic:UIButton)  {
        
        if UserDefaults.standard.object(forKey: kEmpLoginDict) != nil {
            
            let loginDict = UserDefaults.standard.object(forKey: kEmpLoginDict) as! NSDictionary
            
            let imagUrlString = loginDict.object(forKey: "profilePic") as! String
            
            if  (imagUrlString.count) > 0 {
                let url = URL(string: imagUrlString)
                let placeHolderImage = "company_profile"
                let placeimage = UIImage(named: placeHolderImage)
                btnProfilePic.sd_setImage(with: url, for: .normal, placeholderImage: placeimage)
            }
        }

    }
    
    func setImageForJobSeeker(btnProfilePic:UIButton)  {
        
        if UserDefaults.standard.object(forKey: kUserLoginDict) != nil {
            
            let loginDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
            let imagUrlString = loginDict.object(forKey: "jobseeker_profile_pic") as! String
            
            print("imagUrlString is",imagUrlString)
            
            if  (imagUrlString.characters.count) > 0 {
                
                let url = URL(string: imagUrlString)
                let placeHolderImage = "male-user"
                let placeimage = UIImage(named: placeHolderImage)
                btnProfilePic.sd_setImage(with: url, for: .normal, placeholderImage: placeimage)

//                if imageIsNull(imageName:ImgJobSeekerProfilepic) {
//                }else{
//                    btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
//                }
            }
        }
        
        if   UserDefaults.standard.object(forKey: kUserLoginDict) != nil{
            
            let loginDict = UserDefaults.standard.object(forKey: kUserLoginDict) as! NSDictionary
            let imagUrlString = loginDict.object(forKey: "jobseeker_profile_pic") as! String
            
            if  (imagUrlString.characters.count) > 0 {
                let url = URL(string: imagUrlString)
                let placeHolderImage = "male-user"
                let placeimage = UIImage(named: placeHolderImage)
                if imageIsNull(imageName:ImgJobSeekerProfilepic) {
                    btnProfilePic.sd_setImage(with: url, for: .normal, placeholderImage: placeimage)
                }
                else{
                    btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)
                }
            }
            
        }
        
    }
    func imageIsNull(imageName : UIImage)-> Bool
    {
        
        let size = CGSize(width: 0, height: 0)
        if (imageName.size.width == size.width)
        {
            return true
        }
        else
        {
            return false
        }
    }
    func backButton() {
        
        let barButton = UIBarButtonItem(image: UIImage(named: "arrow_left"), style: .plain, target: self, action: #selector(UIViewController.gotoBack))
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = barButton
    }
    func gotoBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func hideNavigationBar()   {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func shareAppExtension() {
        let someText:String = "Look at this awesome PeopleNect App for aspiring Job!"
        let objectsToShare:URL = URL(string: "http://www.google.com")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
        
        SlideNavigationController.sharedInstance().present(activityViewController, animated: true, completion: nil)

       // appdel.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
   }
    
    func getImageFromURLString(URLStr:String) -> UIImage {
            let url = URL(string: URLStr)
            var image = UIImage()
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    image = UIImage(data: data!)!
                }
            }).resume()
        
        return image
        
    }
    
    func drawRouteAppleMap(directionsURL:String) {
       
        guard let url = URL(string: directionsURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func checkJobSeekerDetail() -> Bool  {

        var check = false
        // simple Login
        if JobSeekerUser.savedUser() != nil {
            check = true
        }
        //Social media login
        if JobSeekerSocialUser.savedUser() != nil {
           check = false
        }
        return check
    }
    func JobSeekerLoginDetail () -> JobSeekerData {
            var userData = [JobSeekerData]()
            userData = (JobSeekerUser.savedUser()?.data)!
        return userData[0]
    }
    func JobSeekerSocialMediaDetail () -> JobSeekerSocialData {
        var userData = [JobSeekerSocialData]()
        userData = (JobSeekerSocialUser.savedUser()?.data)!
        return userData[0]
    }
    
    func getJobSeekerAvailablity() -> String {
        var availability = ""
        if JobSeekerUser.savedUser() != nil {
            var userData = [JobSeekerData]()
            userData = (JobSeekerUser.savedUser()?.data)!
            if userData.count>0 {
                let obj = userData[0]
                availability = obj.availability
            }
        }
        if JobSeekerSocialUser.savedUser() != nil {
            var userData = [JobSeekerSocialData]()
            userData = (JobSeekerSocialUser.savedUser()?.data)!
            if userData.count>0 {
                let obj = userData[0]
                availability = obj.availability
            }
        }
        return availability
    }
   
}


extension String {
    
    func widthOfString() -> CGFloat {
        var font = UIFont()
        font =  UIFont(name: "Montserrat-Regular", size: 15.0)!
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
    }
}
