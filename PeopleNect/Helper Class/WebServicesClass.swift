//
//  WebServicesClass.swift
//  PeopleNect
//
//  Created by InexTure on 11/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration
import JVFloatLabeledTextField

class WebServicesClass: NSObject {
  
    //  THIS IS TEST URL
   static let WEB_SERVICE_URL  = "http://peoplenect.inexture.com/webservice"
    
    //  THIS IS LIVE URL
      // static let WEB_SERVICE_URL  = "http://mobileapp.peoplenect.com/webservice"
    
    static let METHOD_NAME = "methodName"
    static var deviceToken = ""
    var request: Alamofire.Request?


    func callWebService(parameter: AnyObject!,  completionHandler:@escaping (AnyObject, NSError?)->()) ->()
    {
        if currentReachabilityStatus != .notReachable
        {
            
            request = Alamofire.request(WebServicesClass.WEB_SERVICE_URL, method: .post, parameters: parameter as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                if self.currentReachabilityStatus != .notReachable
                {
                    if response.result.value == nil
                    {
                        let JSONError = response.result.error
                        let JSON = response.result.value
                        
                        completionHandler(JSON as AnyObject, JSONError as NSError?)
                    }
                    else
                    {
                        let JSON = response.result.value! as! NSDictionary
                        let JSONError = response.result.error
                        
                        completionHandler(JSON as AnyObject, JSONError as NSError?)
                    }
                }
                else
                {
                    self.alertNoInternetConnection()
                }
            }
            
            
        }
        else
        {
            self.alertNoInternetConnection()
        }
    }
    
    
    func alertNoInternetConnection()
    {
        let topController = UIApplication.topViewController()
        self.ShowAlertDisplay(titleObj: Localization(string:"Internet Connection"), messageObj: Localization(string:"No Internet Connection"), viewcontrolelr: topController!)
    }
    
    //MARK: AlertView Display
    
    func ShowAlertDisplay(titleObj:String, messageObj:String, viewcontrolelr:UIViewController)
    {
        let AlertObj = UIAlertController.init(title:titleObj, message: messageObj, preferredStyle: UIAlertControllerStyle.alert)
        
        AlertObj.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        viewcontrolelr.navigationController?.present(AlertObj, animated: true, completion: nil)
    }


    
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

protocol Utilities {
}

extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
}


extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = self.trimmingCharacters(in: NSCharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


extension JVFloatLabeledTextField {
    
    func underlined(){
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(colorLiteralRed: 19.0/255.0, green: 65.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
        // border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
}


