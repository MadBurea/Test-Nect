//
//  WebService.swift
//  PeopleNect
//
//  Created by BAPS on 10/11/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Alamofire
import SwiftLoader

extension UIViewController {
    func UploadImage(image:UIImage,userID:String,isEmployer:Bool)  {
        
        ImgJobSeekerProfilepic = image
        ImgEmployerProfilepic = image

        if imageIsNull(imageName: image) {
            print("image is nil")
            return
        }
        
        var parameters =
            [
                WebServicesClass.METHOD_NAME: "uploadProfilePic",
                "userId":userID
        ]
        
        if isEmployer {
            
             parameters =
                [
                    WebServicesClass.METHOD_NAME: "uploadProfilePicEmployer",
                    "employerId":userID
            ]
            
        }else {
            parameters =
                [
                    WebServicesClass.METHOD_NAME: "uploadProfilePic",
                    "userId":userID
            ]
        }
            
        
        print("parameters is",parameters)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "profile_pic", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:"http://peoplenect.inexture.com/webservice")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Progress is",progress)
                    
                })
                
                upload.responseJSON { response in
                    print("uploaded image response is",response)
                    print("response.result is",response.result)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeImage"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeImageFromSetting"), object: nil)
                }
                
            case .failure(let encodingError):
            print("encodingError.description",encodingError.localizedDescription)
                break
            }
        }
        
    }
    
    func JobSeekerUploadImage(image:UIImage,userId:String)  {
        
        //let imageData = UIImagePNGRepresentation(image) as Data?
        
        let imageData = UIImageJPEGRepresentation(image, 0.5) as Data?

        
        print("image data is ",imageData)
        let parameters =
            [
                WebServicesClass.METHOD_NAME: "uploadProfilePic",
                "userId":userId
        ]
        
        
        print("image data parameters ",parameters)

        Alamofire.upload(multipartFormData:
            { multipartFormData in
                if imageData != nil
                {
                    //multipartFormData.append(imageData, withName: "profile_pic")
                    
                    multipartFormData.append(imageData!, withName:"profile_pic", fileName: "file.png", mimeType: "image/png")
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: WebServicesClass.WEB_SERVICE_URL, method: .post, headers: ["Authorization": "auth_token"],
                    encodingCompletion: { encodingResult in
                        
                        print("encodingResult is ",encodingResult)
                        
                        
                        switch encodingResult
                        {
                        case .success(let upload, _, _):
                            upload.response
                                {
                                    [weak self] response in
                                   
                                    print("response data ",response)

                                    guard self != nil else
                                    {
                                        return
                                    }
                                    
                                    print("response data ",response)

                                    do{
                                        print("response data ",response)
                                        
                                        let dict = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                        
                                        print("dict of uploaded image",dict)
                                        
                                    }
                                    catch {
                                        print("error of uploaded image")
                                        let errorObj = error as NSError
                                        print("ERROR Code : ",errorObj.code)
                                        print("ERROR Code : ",errorObj.localizedDescription)
                                    }
                                    
                            }
                        case .failure(let encodingError):
                            print("failure of uploaded image")
                            print("error:\(encodingError)")
                        }
        })
        
    }
}

extension JobOnGoingDetailsVC {

    func jobDetailbyIdApi()
    {
        SwiftLoader.show(animated: true)
        
        
        
        let param =  [WebServicesClass.METHOD_NAME: "jobDetailbyId",
                      "jobId":self.jobId,
                      "userId":"\(appdel.loginUserDict.object(forKey: "userId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            if error != nil
            {     SwiftLoader.hide()
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
                    if let dataDict = (dictResponse.object(forKey: "data")) as? NSDictionary
                    {
                        
                        self.JobLat = dataDict.value(forKey: "JobLat") as! String
                        self.JobLng = dataDict.value(forKey: "JobLng") as! String
                        self.lblStartDate.text = dataDict.value(forKey: "start_date") as? String
                        self.lblEndDate.text = dataDict.value(forKey: "end_date") as? String
                        
                        self.lblStartTime.text = dataDict.value(forKey: "start_hour") as? String
                        self.lblEndTime.text = dataDict.value(forKey: "end_hour") as? String
                        self.lblPayment.text = dataDict.value(forKey: "hourlyRate") as? String
                        self.lblPerHour.text = dataDict.value(forKey: "TotalAmount") as? String
                        self.lblJob.text = dataDict.value(forKey: "jobTitle") as? String
                        self.lblRating.text = dataDict.value(forKey: "rating") as? String
                        self.lblCompnyJob.text = dataDict.value(forKey: "company_name") as? String
                        // self.lblMiddelJob.text = dataDict.value(forKey: "JobLng")as? String
                        
                        let address1 = dataDict.value(forKey: "address1") as? String
                        let address2 = dataDict.value(forKey: "address2") as? String
                        let city = dataDict.value(forKey: "city") as? String
                        let state = dataDict.value(forKey: "state") as? String
                        
                        let address = "\(address1!), \(address2!), \(city!), \(state!)"
                        self.lblAddressCompany.text = address
                    }
                    
                }
                else
                {
                    
                }
                
                
            }
        }
    }
}
extension JobLogInVC {
    func loginWithParameters (loginWith:String) {
        if checkInternet() == false {
            
        presentErrorToast(alertMessageVC:self.alertMessage,selfVC:self,errorMessage:popUpMessage.someWrong.rawValue)
            return
        }
        view.endEditing(true)
        
        // set the device token
        
        let param = [WebServicesClass.METHOD_NAME: "login","deviceId": UIDevice.current.identifierForVendor!.uuidString,"password":"\(self.txtPassword.text!)","email":"\(self.txtEmail.text!)"] as [String : Any]
        
        SwiftLoader.show(animated: true)

        print(param)
        Alamofire.request(WebServicesClass.WEB_SERVICE_URL, method: .post, parameters: param, encoding: URLEncoding.default).responseObject(completionHandler: { (response: DataResponse<JobSeekerUser>) in
            if let userData = response.result.value {
                if userData.status == "1" {
                    userData.save()
                    var arr = [JobSeekerData]()
                    arr = userData.data
                    
                    if  arr.count > 0 {
                        let obj = arr[0]
                        //appdel.JobSeekerUserID = obj.userId
                        if obj.exp_years.characters.count == 0
                        {
                            let JobSelectCatagoryVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectCatagoryVC") as! JobSelectCatagoryVC
                            self.navigationController?.pushViewController(JobSelectCatagoryVC, animated: true)
                        }
                        else
                        {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "JobSeeker", bundle:nil)
                            let empdashboardVC = storyBoard.instantiateViewController(withIdentifier: "JobDash") as! JobDash
                            let navigationController = SlideNavigationController(rootViewController: empdashboardVC)
                            let leftview = storyBoard.instantiateViewController(withIdentifier:"LeftMenuJobSeeker") as! LeftMenuJobSeeker
                            SlideNavigationController.sharedInstance().leftMenu = leftview
                            SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.50
                            navigationController.navigationBar.isHidden = true
                            self.present(navigationController, animated: true, completion: nil)
                        }
                    }
                    }
                else {
                    presentErrorToast(alertMessageVC:self.alertMessage,selfVC:self,errorMessage:userData.message)
                }
            }
            else {
                presentErrorToast(alertMessageVC:self.alertMessage,selfVC:self,errorMessage:popUpMessage.someWrong.rawValue)
            }
            SwiftLoader.hide()
        }).responseString { (response) in
            print(response.result.value ?? "nil")
        }
    }
   
}


