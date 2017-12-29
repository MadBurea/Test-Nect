//
//  CustomChatScene.swift
//  PeopleNect
//
//  Created by BAPS on 11/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

// MARK: - Receive Cell -
class receiveCell:UITableViewCell {
    
    @IBOutlet weak var receiveTimeLbl: UILabel!
    @IBOutlet weak var receiveMessageLbl: UILabel!
    @IBOutlet weak var receiveView: UIView!
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
}
// MARK: - Send Cell -
class sendCell:UITableViewCell {

    @IBOutlet weak var animateImg: UIImageView!
    @IBOutlet weak var sendViewWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var sendMessageLbl: UILabel!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var sendTimeLbl: UILabel!
}
class CustomChatScene: UIViewController,UITableViewDataSource,UITableViewDelegate{

     // MARK: - Outlets -
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextTv: UITextView!
    @IBOutlet weak var textViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    // MARK: - Variables -

    var keyBoardHeightObj:CGFloat = 0
    var fromNotify = false
    var chat_message_id = ""
    var userID = ""
    var userType = ""
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    var receiveMessage = false
    var timer = Timer()
    var latest_msg_id = "0"
    var receiver_id = ""
    var receiver_Name = ""
    var messagesArray = NSMutableArray()
    var messageWidth = CGFloat()
    var animatedSent = NSMutableArray()

    var userName = ""
    var userCategory = ""
    var userprofilePic = ""

    var isReceiveCall = false
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.setUpView()
        
        messageWidth = (UIScreen.main.bounds.size.width * 250) / 375
        if fromNotify {
        }
        
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
        
        receiverMessage(flag: "0", latest_msg_id: "0")
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.repeatReceiveMessage), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UI Action -
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        

        if (messageTextTv.text?.isBlank)! {
           
        }else{
            if self.messageTextTv.isUserInteractionEnabled {
                let messageDic = NSMutableDictionary()
                messageDic.setValue(messageTextTv.text, forKey: "Message")
                messageDic.setValue(self.userID, forKey: "SenderId")
                messageDic.setValue(self.latest_msg_id, forKey: "id")
                
                messageDic.setValue(currentTime().currentUTCTimeZoneTime, forKey: "Time")
                
                self.messagesArray.add(messageDic)
                
                //            self.animatedSent.add("0")
                //            let index = self.animatedSent.count-1
                
                self.messageTableView.reloadData()
                let indexPath = NSIndexPath(item: self.messagesArray.count-1, section: 0)
                self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                
                // self.sendMessage(message: messageTextTv.text,index: index)
                self.sendMessage(message: messageTextTv.text)
                
                //self.messageTextTv.resignFirstResponder()
                self.messageTextTv.text = ""
            }
        }
    }
    
    // MARK: - Table View Delegate/Datasource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageDic = messagesArray.object(at: indexPath.row) as! NSDictionary
        
        let SenderId = "\(messageDic.value(forKey: "SenderId")!)"
        let message = "\(messageDic.value(forKey: "Message")!)"

        var time = "\(messageDic.value(forKey: "Time")!)"
        time = time[0..<5]
        
        
        //        UTCToLocal

        
        // let  time = (self.chatArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Time") as! String?
        //cell.chatTime.text =  time?[0..<5]
        
        
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = "HH:mm"
//        let UTCStartTime = dateFormat.date(from: StartTime)
//        let UTCEndTime = dateFormat.date(from: EndTime)
//        
//        
//        myCurrentDict.setValue(UTCStartTime!.currentUTCTimeZoneTime, forKey: "start_time")
//        myCurrentDict.setValue(UTCEndTime!.currentUTCTimeZoneTime, forKey: "end_time")
//        myCurrentDict.setValue(currentDay, forKey: "day")
        
        
        if SenderId == userID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as! sendCell
            cell.sendMessageLbl.text = message
            
            cell.sendTimeLbl.text = self.UTCToLocal(date: time)
            
//            if self.animatedSent.object(at: indexPath.row) as! String == "1" {
//                cell.animateImg.image = UIImage(named: "tickBlue")
//            }else{
//                cell.animateImg.loadGif(name: "sendRoll")
//            }
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "receiveCell", for: indexPath) as! receiveCell
            cell.receiveMessageLbl.text = message
            cell.receiveTimeLbl.text = self.UTCToLocal(date: time)

            return cell
        }
       
    }
    
    // MARK: - Keyboard methods -

    func keyboardShown(notification: NSNotification)
    {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyBoardHeightObj = keyboardFrame.size.height
        //self.textViewBottomConstraints.constant = keyBoardHeightObj
        //self.view.layoutIfNeeded()
    }
    
    func keyboardWillHide(_ notification: NSNotification)
    {
        keyBoardHeightObj = 0
        //self.textViewBottomConstraints.constant = keyBoardHeightObj
        //self.view.layoutIfNeeded()
    }
    
    func keyboardDidChangeFrame(_ notification: NSNotification)
    {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        keyBoardHeightObj = keyboardFrame.size.height
        
        //self.textViewBottomConstraints.constant = keyBoardHeightObj
       // self.view.layoutIfNeeded()
    }
   
    // MARK: - General methods -
    
    func setUpView()  {
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        self.messageTableView.rowHeight = UITableViewAutomaticDimension
        self.messageTableView.estimatedRowHeight = 70
        
        self.profileImg.layer.cornerRadius = 20
        self.profileImg.layer.masksToBounds = true
        
        // keyboard Notification
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // user Data
        self.userNameLbl.text = userName
        if userCategory == "nil"  {
            self.categoryLbl.text = ""
        }else{
            self.categoryLbl.text = self.userCategory
        }
        if  (self.userprofilePic.characters.count) > 0 {
            let url = URL(string: self.userprofilePic)
            let placeHolderImage = "male-user"
            let placeimage = UIImage(named: placeHolderImage)
            profileImg.sd_setImage(with: url, placeholderImage: placeimage)
        }else{
            let placeHolderImage = "male-user"
            profileImg.image = UIImage(named: placeHolderImage)
        }
    }
    
    func repeatReceiveMessage()  {
        
        if isReceiveCall == false
        {
            receiverMessage(flag: "1", latest_msg_id: latest_msg_id)
        }
    }
    // MARK: - API -

    func sendMessage(message:String)  {
        
        isReceiveCall = true
        
        let param =  [WebServicesClass.METHOD_NAME: "sendMessage","userType":userType,"receiver_id": receiver_id,"sender_id": userID,"msg": message,"language":appdel.userLanguage,"token":""] as [String : Any]
        
        print("param of sent message",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            self.isReceiveCall = false

            if error != nil {
                
            }else{
                
                let dictResponse = Response as! NSDictionary
                let status = dictResponse.object(forKey: "status") as! Int
                
                if status == 1 {
                    
                    let id = ((dictResponse.object(forKey: "data")) as! NSDictionary).value(forKey: "id") as! NSNumber
                    self.receiveMessage = true
                    self.latest_msg_id = id.stringValue
                    print("self.latest_msg_id",self.latest_msg_id)
                    
//                    self.animatedSent.replaceObject(at: index, with: "1")
//                    self.messageTableView.reloadData()
//                    let indexPath = NSIndexPath(item: self.messagesArray.count-1, section: 0)
//                    self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                    
                }
                print("response of sent message",Response)
            }
        }
    }
   
    func receiverMessage(flag:String,latest_msg_id:String)  {
        
        isReceiveCall = true
        let param =  [WebServicesClass.METHOD_NAME: "receiverMessage","flag":flag,"latest_msg_id": latest_msg_id,"receiver_id": receiver_id,"sender_id": userID,"language":appdel.userLanguage,"userType":userType] as [String : Any]
        
        
        print("param for receive message is",param)
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            let dictResponse = Response as! NSDictionary
            
            let status = dictResponse.object(forKey: "status") as! Int
            
            if status == 1
            {
                
                if let dataDict = (dictResponse.object(forKey: "data")) as? [Any]
                {
                    print("response is",dataDict)

                    if dataDict.count > 0{
                        
                        let message = dataDict as NSArray
                        let sortedArray = message.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as! [[String:AnyObject]]
                        
                         //id = 298;
                        
                        if flag == "0" {
                            self.messagesArray.removeAllObjects()
                            self.receiveMessage = true
                            self.messagesArray.addObjects(from: sortedArray)
                            
                        let isChatEnable = dictResponse.object(forKey: "isChatEnable") as! Int
                            
                            if isChatEnable == 1 {
                                self.messageTextTv.text = ""
                                self.messageTextTv.isUserInteractionEnabled = true
                            }else{
                                self.messageTextTv.text = "You cannot send message"
                                self.messageTextTv.isUserInteractionEnabled = false
                            }
                            
                            self.latest_msg_id = "\((self.messagesArray.object(at: self.messagesArray.count-1) as! NSDictionary).value(forKey: "id")!)"
                            
                            for (index,element) in self.messagesArray.enumerated() {
                                self.animatedSent.add("1")
                            }
                            
                            self.messageTableView.reloadData()
                            let indexPath = NSIndexPath(item: self.messagesArray.count-1, section: 0)
                            self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                        }
                        else {
                            
                            let array = NSMutableArray()
                            array.add(sortedArray)
                            
                            if array.count > 0{
                                let arry = array.object(at: 0) as! NSArray
                                let messageDic = arry.object(at: 0) as! NSDictionary
                                let latestID = "\(messageDic.value(forKey: "id")!)"
                                
                                
                                if latestID != self.latest_msg_id {
                                    
                                    self.messagesArray.addObjects(from: sortedArray)
                                    
                                    self.animatedSent.add("1")

                                    
                                    self.messageTableView.reloadData()
                                    let indexPath = NSIndexPath(item: self.messagesArray.count-1, section: 0)
                                    self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                                    
                                    self.latest_msg_id = "\((self.messagesArray.object(at: self.messagesArray.count-1) as! NSDictionary).value(forKey: "id")!)"
                                }
                            }
                        }
                        
                    }
                }
                
                self.isReceiveCall = false
                
            }
            else
            
            {
                self.isReceiveCall = false
            }
        }
    }


    
}
