//
//  inviteViewController.swift
//  PeopleNect
//
//  Created by test on 10/17/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class listCell: UITableViewCell {
    @IBOutlet weak var avtarImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel1: UILabel!
    @IBOutlet weak var descLabel2: UILabel!
    @IBOutlet weak var addOutlet: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        avtarImage.layer.cornerRadius = avtarImage.frame.size.height / 2.0
        avtarImage.clipsToBounds = true
        avtarImage.backgroundColor = UIColor.white
        avtarImage?.contentMode = .scaleAspectFill
    }
}

class inviteViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate,UIGestureRecognizerDelegate
{
    /* Views */
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var allOutlet: UIButton!
    @IBOutlet weak var favoriteOutlet: UIButton!
    @IBOutlet weak var allImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var noProfLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var inviteViewConstraints: NSLayoutConstraint!
    
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    var jobId = String()
    var jobTitle = String()
    var allEmployeeArray = NSArray()
    var hotEmployeeArray = NSArray()
    var selectedAllId = NSMutableArray()
    var selectedFavId = NSMutableArray()

    var checkfavourite = false
    var allClicked = true
    var hotClicked = false
    
    var totalBalance = NSString()
    var postJobPrice = NSString()
    var postFavBalance = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noProfLabel.isHidden = true
        listTableView.isHidden = false
        
        titleLabel.text = jobTitle
        self.inviteViewConstraints.constant = 0
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(sender:)))
        leftGesture.direction = .left
        leftGesture.delegate = self

        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(sender:)))
        rightGesture.direction = .right
        rightGesture.delegate = self

        listTableView.addGestureRecognizer(leftGesture)
        listTableView.addGestureRecognizer(rightGesture)
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        self.allEmployeesList(all: true)
        
        // Do any additional setup after loading the view.
    }
    
    func handleSwipeGesture(sender:UISwipeGestureRecognizer)  {
        if sender.direction == .left{
            favoriteButt(favoriteOutlet)
        }
        else{
            allButt(allOutlet)
        }
    }
    //MARK: - UITABLEVIEW DATASOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if allClicked {
            return allEmployeeArray.count
        }else{
            return hotEmployeeArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! listCell
        
        var tempDict = NSDictionary()
        if allClicked {
            tempDict = allEmployeeArray.object(at: indexPath.row) as! NSDictionary
        }else{
            tempDict = hotEmployeeArray.object(at: indexPath.row) as! NSDictionary
        }
        
        cell.titleLabel.text = "\(tempDict.object(forKey: "first_name")!)" + " " + "\(tempDict.object(forKey: "last_name")!)"
        
        cell.descLabel1.text = "\(tempDict.object(forKey: "categoryName")!)"

       let InvitationStatus = "\(tempDict.object(forKey: "InvitationStatus")!)"
        
        if InvitationStatus == "1" {
            cell.addOutlet.isEnabled = false
            cell.addOutlet.setImage(UIImage(named: "check-square"), for: .normal)
        }else{
            cell.addOutlet.isEnabled = true
            cell.addOutlet.setImage(UIImage(named: "plus"), for: .normal)
        }
        
        let distance = tempDict.object(forKey: "distance") as! NSString
        var distanceStr = String()
        let distanceFloat: Float = distance.floatValue
        distanceStr = String(format: distanceFloat == floor(distanceFloat) ? "%.0f" : "%.2f", distanceFloat) + " km."
        
        let experience = tempDict.object(forKey: "exp_years") as! NSString
        var experienceStr = String()
        let experienceFloat: Float = experience.floatValue
        experienceStr = String(format: experienceFloat == floor(experienceFloat) ? "%.0f" : "%.2f", experienceFloat) + " years"
        
        experienceStr = "\(experience)  years"
        
        //cell.descLabel2.text = distanceStr + " /" + experienceStr
        
        cell.descLabel2.text = experienceStr + " / " + distanceStr


        if tempDict.object(forKey: "jobseeker_profile_pic") is NSNull
        {
            let placeHolderImage = "user"
            cell.avtarImage.image = UIImage(named: placeHolderImage)
        }
        else
        {
            let imagUrlString = tempDict.object(forKey: "jobseeker_profile_pic") as! String
            let url = URL(string: imagUrlString)
            let placeHolderImage = "user"
            let placeimage = UIImage(named: placeHolderImage)
            cell.avtarImage.sd_setImage(with: url, placeholderImage: placeimage)
        }
        cell.addOutlet.tag = indexPath.row
        cell.addOutlet.addTarget(self, action: #selector(self.addInviteUser), for: .touchUpInside)

        let jobseekerId = "\(tempDict.object(forKey: "jobseekerId")!)"
        cell.addOutlet.isSelected = false
        
        if allClicked {
            if selectedAllId.contains(jobseekerId) {
                cell.addOutlet.isSelected = true
            }
        }else{
            if selectedFavId.contains(jobseekerId) {
                cell.addOutlet.isSelected = true
            }
        }
        return cell
    }
    
    //MARK: - UIAction

    func addInviteUser(sender:UIButton)  {
        
        let index = sender.tag
        print("index is ",index)
        
        var tempDict = NSDictionary()
        if allClicked {
            tempDict = allEmployeeArray.object(at: index) as! NSDictionary
        }else{
            tempDict = hotEmployeeArray.object(at: index) as! NSDictionary
        }
        let jobseekerId = "\(tempDict.object(forKey: "jobseekerId")!)"
        print("jobseeker id is",jobseekerId)
        
        if sender.isSelected {
            sender.isSelected = false
            
            if allClicked {
                selectedAllId.remove(jobseekerId)
            }else{
                selectedFavId.remove(jobseekerId)
            }
            
        }else{
            sender.isSelected = true
            
            if allClicked {
                selectedAllId.add(jobseekerId)
            }else{
                selectedFavId.add(jobseekerId)
            }
        }
        
        if selectedAllId.count > 0 || selectedFavId.count > 0{
            inviteViewConstraints.constant = 80
        }
        if selectedAllId.count == 0 && selectedFavId.count == 0 {
            inviteViewConstraints.constant = 0
        }
        print("selcted all id is",selectedAllId)
        print("selcted fav id is",selectedFavId)
        
    }
    @IBAction func dismissButt(_ sender: Any) {
        self.back()
    }
    @IBAction func allButt(_ sender: UIButton) {
        allClicked = true
        hotClicked = false
        sender.setTitleColor(UIColor.black, for: .normal)
        favoriteImage.isHidden = true
        favoriteOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        allImage.isHidden = false
        self.availableLabel.text = "Available professionals"
        noProfLabel.isHidden = true
        if allEmployeeArray.count == 0 {
            noProfLabel.isHidden = false
        }
        
        self.listTableView.reloadData()
    }
    
    @IBAction func inviteUserClicked(_ sender: Any) {
        self.jobPostingPriceAndBalance()
    }
    @IBAction func favoriteButt(_ sender: UIButton) {
        hotClicked = true
        allClicked = false
        sender.setTitleColor(UIColor.black, for: .normal)
        allImage.isHidden = true
        allOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        favoriteImage.isHidden = false
        self.availableLabel.text = "Candidate who worked for you."
        noProfLabel.isHidden = true
        if hotEmployeeArray.count == 0 {
            noProfLabel.isHidden = false
        }
        self.listTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Gesture Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func back()  {
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            var checkVC = false
            for viewController in viewControllers {
                
                if viewController.isKind(of: selctionViewController.self) {
                    checkVC = true
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            if checkVC == false{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                let selection = storyBoard.instantiateViewController(withIdentifier: "selctionViewController") as! selctionViewController
                selection.jobId = self.jobId
                selection.jobTitle = self.jobTitle
                self.navigationController?.pushViewController(selection, animated: true)
        }
    }
}
    //MARK: - API
    
    func allEmployeesList(all:Bool)  {
        
        /*
         {
         "employerId": "2",
         "jobId": "243",
         "latitude": 0.0,
         "longitude": 0.0,
         "language": "en",
         "methodName": "allEmployeesList" 
         }
         */
        var param = [String : Any]()
        
        
        
        SwiftLoader.show(animated: true)
        
        
        if all {
             param =  [WebServicesClass.METHOD_NAME: "allEmployeesList","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":self.jobId,"latitude":appdel.userLocationLat,"longitude":appdel.userLocationLng] as [String : Any]
        }else{
             param =  [WebServicesClass.METHOD_NAME: "employeesHotList","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":self.jobId,"latitude":appdel.userLocationLat,"longitude":appdel.userLocationLng] as [String : Any]
        }
        
        print("param is",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            let dictResponse = Response as! NSDictionary
            
            let status = dictResponse.object(forKey: "status") as! Int
            
            if status == 1
            {
                    if !self.checkfavourite {
                        self.allEmployeesList(all: false)
                        self.checkfavourite = true
                        
                        self.allEmployeeArray = (dictResponse.object(forKey: "data")) as! NSArray
                        print("response of all employee",self.allEmployeeArray)
                        print("response of all employee count ",self.allEmployeeArray.count)
                        
                    }else{
                        self.hotEmployeeArray = (dictResponse.object(forKey: "data")) as! NSArray
                        print("response of hot employee",self.hotEmployeeArray)
                        print("response of hot employee count ",self.hotEmployeeArray.count)
                        self.listTableView.reloadData()
                }
                    //self.tableView.reloadData()
            }else{
                
            }
        }
    }

    
    func jobPostingPriceAndBalance()
    {
        SwiftLoader.show(animated: true)
        
        let param =  [WebServicesClass.METHOD_NAME: "jobPostingPriceAndBalance",
                      "employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            SwiftLoader.hide()
            
            if error != nil
            {
                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                self.totalBalance = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "balance") as! NSString
                
                self.postJobPrice = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "jobInvitationPrice") as! NSString
                self.postFavBalance = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "jobInvitationFavouritePrice") as! NSString
               
                let remainingDays = (dictResponse.object(forKey: "data") as! NSDictionary).value(forKey: "remainingDays") as! NSString
                
                let totalDays = remainingDays.integerValue
                if totalDays > 0{
                     let alertController = UIAlertController(title: "", message: Localization(string: "per Professionals") + "$\(self.postJobPrice)" + Localization(string: "per Professionals") + "&" + "$\(self.postFavBalance)" + Localization(string: "per favorite professional."), preferredStyle: UIAlertControllerStyle.alert)
                    
                    
                    
                    let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                    }
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        let allId = self.selectedAllId.componentsJoined(by: ",")
                        let favId = self.selectedFavId.componentsJoined(by: ",")
                        self.inviteEmployees(allIds: allId, favIds: favId)
                    }
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    if self.postJobPrice.intValue > self.totalBalance.intValue  {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
                        let noBalance = storyBoard.instantiateViewController(withIdentifier: "EmpNoBalance") as! EmpNoBalance
                        self.navigationController?.pushViewController(noBalance, animated: true)
                    }else{
                         let alertController = UIAlertController(title: "", message: Localization(string: "per Professionals") + "$\(self.postJobPrice)" + Localization(string: "per Professionals") + "&" + "$\(self.postFavBalance)" + Localization(string: "per favorite professional."), preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        }
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            let allId = self.selectedAllId.componentsJoined(by: ",")
                            let favId = self.selectedFavId.componentsJoined(by: ",")
                            self.inviteEmployees(allIds: allId, favIds: favId)
                        }
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    
    func inviteEmployees(allIds:String,favIds:String)  {
        
        /*
        {
         "allIds": "38,77",
         "employerId": "2",
         "favIds": "",
         "jobId": "243",
         "methodName": "inviteEmployees" 
         }
         */
        
        SwiftLoader.show(animated: true)
     
        let param =  [WebServicesClass.METHOD_NAME: "inviteEmployees","employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage,"jobId":self.jobId,"allIds":allIds,"favIds":favIds] as [String : Any]
        
        print("param is",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            
            if error != nil {
                print("error is",error?.localizedDescription)
            }else{
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                print("dictResponse is",dictResponse)
                if status == 1
                {
                    
                    self.view.makeToast(Localization(string:"Invited Successfully"), duration: 3.0, position: .bottom)

                    let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.back()
                    }
                    
                }else{
                    self.inviteViewConstraints.constant = 0
                    self.selectedAllId.removeAllObjects()
                    self.selectedFavId.removeAllObjects()
                    self.listTableView.reloadData()
                    
                    if status == 0 {
                        self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                    }
                    if status == 2{
                        self.alertMessage.strMessage = Localization(string:  "you have insufficient credit.")
                    }else{
                        
                        self.alertMessage.strMessage = Localization(string:  "Error while sending invitation, please try again")
                    }
                    
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)

                }
            }
        }
    }

}
