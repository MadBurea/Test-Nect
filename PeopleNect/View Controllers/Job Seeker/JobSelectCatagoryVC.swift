//
//  JobSelectCatagoryVC.swift
//  PeopleNect
//
//  Created by Apple on 12/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader
import KTCenterFlowLayout

class JobSelectCatagoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UserChosePhoto {

    @IBOutlet var btnProfilePic: UIButton!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblPickProfilePic: UILabel!
    @IBOutlet var collectionCatagory: UICollectionView!
    
    @IBOutlet weak var lblNoData: UILabel!
    var arrData = NSMutableArray()
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    var userDic = NSMutableDictionary()
    
    var index = -1
    
    //varar index = Int()

    //MARK: - View life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionCatagory.delegate = self
        collectionCatagory.dataSource = self

        self.lblNoData.isHidden = true
      
        // self.lblPickProfilePic.text = "Pick what fits best"
        
        //let layout = KTCenterFlowLayout()
//        layout.minimumInteritemSpacing = 10.0
//        layout.minimumLineSpacing = 10.0
//        
//        UICollectionViewController(collectionViewLayout: layout)
        
        self.categoryListApi()
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        
        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        collectionCatagory.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.btnProfilePic.setImage(ImgJobSeekerProfilepic, for: .normal)

        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2
        btnProfilePic.clipsToBounds = true
        btnProfilePic.layer.borderWidth = 1
        btnProfilePic.layer.borderColor = ColorProfilePicBorder.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func clickBack(_ sender: Any) {
        
   //     _ = self.navigationController?.popViewController(animated: true)
        
        self.alertMessage.strMessage = Localization(string: "Please, complete your profile. You may edit it later.")

        self.alertMessage.modalPresentationStyle = .overCurrentContext
        
        self.present(self.alertMessage, animated: false, completion: nil)

    }

    
    
    // MARK: - UiCollectionview DataSource/ Delegate

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.arrData.count < 0
        {
            self.lblNoData.isHidden = false
            
        }
     return arrData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobSelectCategoryCell",
                                                      for: indexPath) as! JobSelectCategoryCell
        
        var CatagoryDict = NSDictionary()
        
        CatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
        
        if index == indexPath.row
        {
            cell.lblCollectionDetail.layer.borderColor = blueThemeColor.cgColor
            cell.lblCollectionDetail.layer.borderWidth = 1.5

        }
        else
        {
            cell.lblCollectionDetail.layer.borderWidth = 0
            cell.lblCollectionDetail.layer.borderColor = UIColor.clear.cgColor

        }
        
        cell.lblCollectionDetail.text = "\(CatagoryDict.object(forKey: "categoryName")!)"
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionCatagory.cellForItem(at: indexPath) as! JobSelectCategoryCell
        
        let jobSelectExpertisesVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectExpertisesVC") as! JobSelectExpertisesVC
        
        index = indexPath.row
        
        if cell.lblCollectionDetail.layer.borderWidth == 0{
            
            cell.lblCollectionDetail.layer.borderColor = blueThemeColor.cgColor
            cell.lblCollectionDetail.layer.borderWidth = 1.5
            
        }
        
        else{
            cell.lblCollectionDetail.layer.borderWidth = 0
            cell.lblCollectionDetail.layer.borderColor = UIColor.clear.cgColor
        }

        

       let CatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
        
        
        jobSelectExpertisesVC.categoryName = "\(CatagoryDict.object(forKey: "categoryName")!)"
        
        jobSelectExpertisesVC.categoryId = "\(CatagoryDict.object(forKey: "categoryId")!)"
        
        print("ccategoryId",jobSelectExpertisesVC.categoryId)

        
        if btnProfilePic.imageView?.image != nil{
            
            jobSelectExpertisesVC.imgCommonProfiePic = (btnProfilePic.imageView?.image)!
            
        }
        else{
            
           // cell.lblCollectionDetail.layer.borderWidth = 0

        }

        jobSelectExpertisesVC.userDic = userDic

          self.navigationController?.pushViewController(jobSelectExpertisesVC, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizeCatagoryDict = NSDictionary()
        
        sizeCatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
        
      //  var size: CGSize = ((sizeCatagoryDict.object(forKey: "categoryName")!) as AnyObject).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)] )
        
        
//        if (size.width > collectionCatagory.frame.size.width )
//        {
//            size.width = collectionCatagory.frame.size.width
//        }
        
        
        return CGSize(width: ((collectionCatagory.frame.size.width/2) - 6), height: 75)
    }


  
    // MARK: - class Methods

    @IBAction func clickSelProfilePic(_ sender: Any) {
        
        let jobSelectProfilrPicVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        
        jobSelectProfilrPicVC.delegate = self
        
        navigationController?.pushViewController(jobSelectProfilrPicVC, animated: true)
    }
    
    func userHasChosen(image: UIImage){
        
        if image.isEqual(nil){
            print("Choose An Image!")
        }
        else{
            
            //     btnprofilePic.setImage(image, for: .normal)
            
            btnProfilePic.setImage(image, for: .normal)
            
            ImgJobSeekerProfilepic = image
        }
    }

    
    
    
    // MARK: - Api Call
    
    func categoryListApi()
    {
        SwiftLoader.show(animated: true)
        
        /*
         {
         
         {
         "userId": "77",
         "language": "en",
         "methodName": "categoryList"
         }
         
         }
         
         */
        
        
      
        
       // let param =  [WebServicesClass.METHOD_NAME: "categoryList","userId":"64","language":"en"] as [String : Any]
        
        let param =  [WebServicesClass.METHOD_NAME: "categoryList","userId":"\(userDic.object(forKey: "userId")!)","language":appdel.userLanguage] as [String : Any]
  
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {                SwiftLoader.hide()

                print("Error",error?.description as String!)
            }
            else
            {
                //  SwiftLoader.hide()
                let dictResponse = Response as! NSDictionary
                
                print(dictResponse)
                
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {

                    if let catArray = dictResponse.object(forKey: "categoryList") as? [Any]
                    
                    {
                        self.arrData.addObjects(from: catArray)
                    }
                    
                    if self.arrData.count < 0
                    {
                        self.lblNoData.isHidden = false

                    }
                    print("arrData",self.arrData)
                   // }
                    
                    self.collectionCatagory.reloadData()

                }
                else
                {
                    
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
                    
                    self.lblNoData.isHidden = false

                    //print(Response.object(forKey: "message"))
                }
                
                
            }
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
