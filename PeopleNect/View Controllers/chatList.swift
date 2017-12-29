//
//  chatList.swift
//  PeopleNect
//
//  Created by BAPS on 10/13/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class chatListCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDesc: UILabel!
    @IBOutlet weak var chatTime: UILabel!
    @IBOutlet weak var checkedImg: UIImageView!
    
    @IBOutlet weak var borderLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
        profilePic.layer.masksToBounds = true
    }
}

class chatList: UIViewController , UITableViewDelegate,UITableViewDataSource { 

    @IBOutlet weak var chatListTableView: UITableView!
    var chatArray  = NSMutableArray()
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    
    @IBOutlet weak var noChatLbl: UILabel!
    // userType Employer  = 1 , JOb Seeker 0
    // Receiver ID means here UserID
    var userType = ""
    var recieverId = ""

    
    var refreshControl = UIRefreshControl()
    var isForRefresh = false

    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        noChatLbl.isHidden = true
        
        
        self.refreshContoller()
        
        chatListTableView.rowHeight = UITableViewAutomaticDimension
        chatListTableView.estimatedRowHeight = 80
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Job Seeker 0
        if let val = appdel.loginUserDict.object(forKey: "userId") {
            print("val is",val)
            userType = "0"
        }
        
        // Employer 1
        if let val = appdel.loginUserDict.object(forKey: "employerId") {
            print("val is",val)
            userType = "1"
        }
        chatArray  = NSMutableArray()
        hideNavigationBar()
        getUserChatList()
    }
    
    
    // MARK: - backClicked
    
    @IBAction func backClicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - tableView Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListCell", for: indexPath) as! chatListCell
       
        
        cell.userName.text = (self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "SenderName") as! String?
        
        cell.userDesc.text = (self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Message") as! String?
        
        let newDate = (self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Date") as! String?

        cell.chatTime.text =  convertDateFormater(newDate!)
        cell.checkedImg.isHidden = true

        let Status = (self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Status") as! String?

        let senderId = (self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "originalSenderId") as! String?
        
    
        
        if senderId == recieverId {
            print("Equal equal equal")
            cell.checkedImg.isHidden = true
        }else {
            if Status == "0" {
                cell.checkedImg.isHidden = false
            }else{
                cell.checkedImg.isHidden = true
            }
        }
        
        
        let imagUrlString = (self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "SenderPic") as! String?
        
        if  (imagUrlString?.count)! > 0 {
            let url = URL(string: imagUrlString!)
            let placeHolderImage = "plceholder"
            let placeimage = UIImage(named: placeHolderImage)
            
            cell.profilePic.sd_setImage(with: url, placeholderImage: placeimage)
        }
        
        cell.borderLbl.isHidden = false
        if indexPath.row == self.chatArray.count - 1 {
            cell.borderLbl.isHidden = true
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("cell selected")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
        let ChatScene = storyBoard.instantiateViewController(withIdentifier: "CustomChatScene") as! CustomChatScene
        var userDataDic = NSDictionary()
        userDataDic = self.chatArray.object(at: indexPath.row) as! NSDictionary
        
        ChatScene.userName = ((self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "SenderName") as! String?)!
        ChatScene.userprofilePic = ((self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "SenderPic") as! String?)!
        
       
        if userDataDic["categoryName"] != nil  {
            ChatScene.userCategory = userDataDic["categoryName"] as! String
        }else{
            ChatScene.userCategory = ""
        }
        
       // ChatScene.userCategory = "\(((self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_name")))"
        
        ChatScene.userID = ((self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "ReceiverId") as! String?)!

        ChatScene.receiver_id = ((self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "SenderId") as! String?)!

        ChatScene.userType = userType
       
        ChatScene.receiver_Name = ((self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "SenderName") as! String?)!
        
        self.navigationController?.pushViewController(ChatScene, animated: true)
        
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        
        //2017-10-18
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM"
        
        return dateFormatter.string(from: dt!)
        
    }
    
    
    //MARK:- Refresh Controller methods -
    func refreshContoller()  {
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        refreshControl.tintColor = blueThemeColor
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        if #available(iOS 10.0, *) {
            self.chatListTableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    func refreshTable(refreshControl: UIRefreshControl) {
        
        isForRefresh = true
        self.getUserChatList()
    }
    
    
    
    // MARK: - getUserChatList

    func getUserChatList()  {
       
        if  isForRefresh == false {
            SwiftLoader.show(animated: true)
        }
        self.chatArray = NSMutableArray()
        let param =  [WebServicesClass.METHOD_NAME: "chatHistory","userType":userType,"recieverId": recieverId,"language":appdel.userLanguage] as [String : Any]
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()
            let dictResponse = Response as! NSDictionary
            
            let status = dictResponse.object(forKey: "status") as! Int
            
            if status == 1
            {
                if let dataDict = (dictResponse.object(forKey: "data")) as? [Any]
                {
                self.chatArray.addObjects(from: dataDict)
                self.chatListTableView.delegate = self
                self.chatListTableView.dataSource = self
                    
                self.chatListTableView.reloadData()
                    
                    if self.isForRefresh {
                        self.refreshControl.endRefreshing()
                        self.isForRefresh = false
                    }
                }
            }else{
                
                
                self.noChatLbl.isHidden = false
                self.chatListTableView.isHidden = true

            }
   }
 }
}
