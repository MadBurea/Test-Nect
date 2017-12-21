//
//  Constant.swift
//  PeopleNect
//
//  Created by BAPS on 10/12/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import Foundation

func jsonStringConvert(_ dict : Any) -> String {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
        return  String(data: jsonData, encoding: String.Encoding.utf8)! as String
        
    } catch {
        return ""
    }
}
enum popUpMessage : String {
    case someWrong          = "Something went wrong. Please try again later"
    case emptyString        = "Please fill all the fields"
    case emptyFirstName     = "First name should not be blank"
    case emptyLastName      = "Last name should not be blank"
    case emptyPassword      = "Please enter password"
    case PasswordValid      = "The password must be between 6 to 32 characters"
    case MobileValid        = "Please enter valid mobile number"
    case UserEmailValid     = "Please enter valid username or email"
    case emptyEmailId       = "Please enter email"
}
func checkInternet() -> Bool
{
    let status = ReachAvailable().connectionStatus()
    switch status {
    case .unknown, .offline:
        return false
    case .online(.wwan), .online(.wiFi):
        return true
    }
    
}
func presentErrorToast(alertMessageVC:AlertMessageVC,selfVC:UIViewController,errorMessage:String){
    alertMessageVC.strMessage =  errorMessage
    alertMessageVC.modalPresentationStyle = .overCurrentContext
    selfVC.present(alertMessageVC, animated: false, completion: nil)
}
