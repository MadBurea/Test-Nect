//
//  Modal.swift
//  PeopleNect
//
//  Created by BAPS on 10/12/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import Foundation

let kJobSeekerUserInfo = "JobSeekerUserInfo"
let kJobSeekerSocialMedia = "JobSeekerSocialMedia"

class JobSeekerUser : EVObject{
    
    var data = [JobSeekerData]()
    var message = ""
    var status = ""
    var pt_message = ""
    
    func save() {
        let defaults: UserDefaults = UserDefaults.standard
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: self) as Data
        defaults.set(data, forKey: kJobSeekerUserInfo)
        defaults.synchronize()
    }
    
    class func savedUser() -> JobSeekerUser? {
        let defaults: UserDefaults = UserDefaults.standard
        let data = defaults.object(forKey: kJobSeekerUserInfo) as? NSData
        if data != nil {
            if let userinfo = NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as? JobSeekerUser {
                return userinfo
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    class func clearUser() {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.removeObject(forKey: kJobSeekerUserInfo)
        defaults.synchronize()
    }
}
class JobSeekerData: EVObject {
    var availability = ""
    var category_id = ""
    var category_name = ""
    var country_code = ""
    var email = ""
    var exp_years = ""
    var first_name = ""
    var hourly_compensation = ""
    var is_loggedIn = ""
    var jobseeker_profile_pic = ""
    var last_name = ""
    var phone = ""
    var profile_description = ""
    var registerWith = ""
    var sub_category_name = ""
    var sub_category_id = ""
    var userId = ""
}
class JobSeekerSocialUser : EVObject{
    
    var data = [JobSeekerSocialData]()
    var message = ""
    var status = ""
    
    func save() {
        let defaults: UserDefaults = UserDefaults.standard
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: self) as Data
        defaults.set(data, forKey: kJobSeekerSocialMedia)
        defaults.synchronize()
    }
    
    class func savedUser() -> JobSeekerSocialUser? {
        let defaults: UserDefaults = UserDefaults.standard
        let data = defaults.object(forKey: kJobSeekerSocialMedia) as? NSData
        if data != nil {
            if let userinfo = NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as? JobSeekerSocialUser {
                return userinfo
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    class func clearUser() {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.removeObject(forKey: kJobSeekerSocialMedia)
        defaults.synchronize()
    }
}
class JobSeekerSocialData: EVObject {
    var availability = ""
    var city = ""
    var complement = ""
    var country = ""
    var country_code = ""
    var email = ""
    var exp_years = ""
    var first_name = ""
    var hourly_compensation = ""
    var is_loggedIn = ""
    var jobseeker_profile_pic = ""
    var last_name = ""
    var number = ""
    var phone = ""
    var profile_description = ""
    var registerWith = ""
    var state = ""
    var streetName = ""
    var userId = ""
    var zipcode = ""
    var category_id = ""
    var sub_category_id = ""
   var category_name = ""
   var sub_category_name = ""

}
