//
//  EmpBalanceVC.swift
//  PeopleNect
//
//  Created by Apple on 09/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader
import Toast_Swift

extension String {
    
    func getDateFromString() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:self)
        
        return date!
    }

    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:self)
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var dateString = String()
        dateString = date!.getStringFromDate()
        let check = todayDate.getStringFromDate()

        if dateString == check {
            dateString = "Today"
        }else{
            dateString = date!.getStringFromDate()
        }
        
        return dateString
    }

}

extension Date {
    
    func getStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let dateString = dateFormatter.string(from:self)
        
        return dateString
    }
    
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}



class EmpBalanceCell : UITableViewCell {
    
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblBalance : UILabel!
    
    @IBOutlet weak var topLineView : UIView!
    @IBOutlet weak var bottomLineView : UIView!
    
    func configureCell(dictData : [String : String]) {
        self.lblDesc.text = dictData["comment"]
        
        self.lblDate.text = dictData["create_date"]!.getDateString()
        
        let action = dictData["action"]
        
        if action == "1" {
            self.lblBalance.text = "$\(dictData["amount"]!)"
            self.lblBalance.textColor = blueThemeColor
        }else{
            self.lblBalance.text = "-$\(dictData["amount"]!)"
            self.lblBalance.textColor = UIColor.red
        }
    }
    
}

class EmpBalanceVC: UIViewController,SlideNavigationControllerDelegate {

    @IBOutlet weak var lblBalance : UILabel!
    @IBOutlet weak var tblView : UITableView!
    
    @IBOutlet weak var viewTop: UIView!
    var alertMessage = AlertMessageVC()
    var global = WebServicesClass()
    
    var arrayData = NSArray()
                     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        
        alertMessage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        self.intialSetupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.transactionHistoryApi()

    }
    func intialSetupView()
    {
        viewTop.layer.shadowColor = UIColor.gray.cgColor
        viewTop.layer.shadowOpacity = 0.5
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTop.layer.shadowRadius = 2.0
    }
    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }

    // MARK: - Api Call
    
    func transactionHistoryApi()
    {
        SwiftLoader.show(animated: true)
        
        /*
         "userId": "77",
         "language": "en",
         "methodName": "userDetails"
         */
        
        
        let param =  [WebServicesClass.METHOD_NAME: "transactionHistory",
                      "employerId":"\(appdel.loginUserDict.object(forKey: "employerId")!)",
            "language":appdel.userLanguage] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            if error != nil {
                print("ErrorGetUserInfo:",error?.description as String!)
            }
            else {
                let dictResponse = Response as! NSDictionary
                print("ResponseGetUserInfo",dictResponse)
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                let balance = dictResponse.object(forKey: "balance") as! NSString
                
                var balanceRS = Int()
                balanceRS = balance.integerValue
                print("balance Rs is",balanceRS.withCommas())
                
                self.lblBalance.text = "$\(balanceRS.withCommas())" + ".00"
                
                if status == 1 {
                    
                    if let dataDict = dictResponse.object(forKey: "data") as? NSArray {
                        
                        
//                        if appdel.deviceLanguage == "pt-BR"
//                        {
//                            self.view.makeToast("\(Response.object(forKey: "pt_message")!)", duration: 3.0, position: .bottom)
//                        }
//                        else
//                        {
//                            self.view.makeToast("\(Response.object(forKey: "message")!)", duration: 3.0, position: .bottom)
//                        }
                        
                        self.arrayData = dataDict
                        self.tblView.reloadData()
                    }
                }
                else {
                    if appdel.deviceLanguage == "pt-BR"
                    {
                        self.alertMessage.strMessage = "\(Response.object(forKey: "pt_message")!)"
                    }
                    else
                    {
                        self.alertMessage.strMessage = "\(Response.object(forKey: "message")!)"
                    }
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func btnAddBalanceClick(sender : UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let ChatScene = storyBoard.instantiateViewController(withIdentifier: "addBalance") as! addBalance
        self.navigationController?.pushViewController(ChatScene, animated: true)
    }
    
    @IBAction func btnBackClick(sender : UIButton) {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)
    }
    
}

extension EmpBalanceVC : UITableViewDelegate {
    
}

extension EmpBalanceVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmpBalanceCell") as! EmpBalanceCell
        
        cell.configureCell(dictData: arrayData[indexPath.row] as! [String : String])
        
        if(indexPath.row == 0)
        {
            cell.topLineView.isHidden = true
        }
        else
        {
            cell.topLineView.isHidden = false
        }
        
        if(indexPath.row == arrayData.count - 1)
        {
            cell.bottomLineView.isHidden = true
        }
        else
        {
             cell.bottomLineView.isHidden = false
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
