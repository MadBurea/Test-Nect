//
//  JobSettingSelectExperticesBVC.swift
//  PeopleNect
//
//  Created by Apple on 04/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader
import KTCenterFlowLayout

class JobSettingSelectExperticesBVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet var btnProfilePic: UIButton!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblSelectExpertises: UILabel!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var viewCollection: UICollectionView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    var selectedIndexPaths = IndexPath()
    var categoryId = String()
    var global = WebServicesClass()
    
    var arrSubCatData = NSMutableArray()
    var arrSelectedSubCatData = NSMutableArray()
    var arrSelectedSubCategory = NSMutableArray()
    var arrSelectedSubCategoryName = NSMutableArray()

    var IdCategory = String()


    var nameCategory = String()
    var nameSubCategoryId = NSMutableArray()


    
    var alertMessage = AlertMessageVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoData.isHidden = true
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        
        
        
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topView.layer.shadowRadius = 2.0
        
        UICollectionViewController(collectionViewLayout: layout)
        
        viewCollection.dataSource = self
        viewCollection.delegate = self
        
      //  alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        
        self.subCategoryListApi()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func clickBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickNext(_ sender: Any) {
        
       // let jobSettingVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSettingVC") as! JobSettingVC
        
        //  lastDetailVC.subCategoryId = "\(subCatagoryDict.object(forKey: "subCategoryId")!)"
        
        print("arrSelectedSubCategory",arrSelectedSubCategory)
        
//        jobSettingVC.arrSubCategoryId = arrSelectedSubCategory.mutableCopy() as! NSMutableArray
        
        if arrSelectedSubCategory.count <= 0{
            
            self.view.makeToast(Localization(string:"Select at least one expertise, then continue"), duration: 3.0, position: .bottom)
            
        }else{
            
            let myDict = [ "catName": nameCategory, "catId":categoryId, "subCatArray":arrSelectedSubCategory, "subCatName":arrSelectedSubCategoryName] as [String : Any]
            
            print(myDict)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateCategorySel"), object: myDict)
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
    
    
    
    // MARK: - UICollectionView DataSource/Delegate Methods -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrSubCatData.count < 0
        {
            self.lblNoData.isHidden = false
            
        }
        return arrSubCatData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobSettingSelectExperiticesCollectionCell", for: indexPath) as! JobSettingSelectExperiticesCollectionCell
        
        
        
        var subCatagoryDict = NSDictionary()
        
        subCatagoryDict = arrSubCatData.object(at: indexPath.row) as! NSDictionary
        
        cell.lblSelectExperienceScreen.text = "\(subCatagoryDict.object(forKey: "subCategoryName")!)"
        
        
        
        cell.lblSelectExperienceScreen.textAlignment = .center
        cell.layer.cornerRadius = 20
        cell.backgroundColor = UIColor.white
        cell.lblSelectExperienceScreen.textColor = UIColor.black
        cell.clipsToBounds = true
        cell.imgClick.isHidden = true
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var subCatagoryDict = NSDictionary()
        
        subCatagoryDict = arrSubCatData.object(at: indexPath.row) as! NSDictionary
        
        
        let size: CGSize = ((subCatagoryDict.object(forKey: "subCategoryName")!) as AnyObject).size(attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 17.0)!] )
        
        
        return CGSize(width: size.width + 66.0, height: 50)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = viewCollection.cellForItem(at: indexPath) as! JobSettingSelectExperiticesCollectionCell
        
        var subCatagoryDict = NSDictionary()
        
        subCatagoryDict = arrSubCatData.object(at: indexPath.row) as! NSDictionary
        
        if   cell.imgClick.isHidden == true
        {
            cell.imgClick.isHidden = false
            
            cell.constrainY.constant = -8.5
            
            cell.backgroundColor = blueThemeColor
            
            cell.lblSelectExperienceScreen.textColor = UIColor.white
            
            arrSelectedSubCategory.add(subCatagoryDict.object(forKey: "subCategoryId")!)
            arrSelectedSubCategoryName.add(subCatagoryDict.object(forKey: "subCategoryName")!)

            print(arrSelectedSubCategory)
            
        }
        else
        {
            cell.imgClick.isHidden = true
            
            cell.constrainY.constant = 0
            
            cell.backgroundColor = UIColor.white
            
            cell.lblSelectExperienceScreen.textColor = UIColor.black
            
            arrSelectedSubCategory.remove(subCatagoryDict.object(forKey: "subCategoryId")!)
            arrSelectedSubCategoryName.remove(subCatagoryDict.object(forKey: "subCategoryName")!)

            
        }
    }
    
    
    // MARK: - Api Call
    
    func subCategoryListApi()
    {
        SwiftLoader.show(animated: true)
        
        /*
         "categoryId": "108",
         "userId": "77",
         "language": "en",
         "methodName": "subCategoryList"
         */
        
       
        
        let param =  [WebServicesClass.METHOD_NAME: "subCategoryList","categoryId":"\(categoryId)","userId":"\(appdel.loginUserDict.object(forKey: "userId")!)","language":appdel.userLanguage] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            
            if error != nil
            {                SwiftLoader.hide()

                print("Error",error?.description as String!)
            }
            else
            {
                let dictResponse = Response as! NSDictionary
                
                print(dictResponse)
                
                
                
                let status = dictResponse.object(forKey: "status") as! Int
                SwiftLoader.hide()
                
                if status == 1
                {
                    
                    if let subCatArray = dictResponse.object(forKey: "subCategoryList") as? [Any]
                        
                    {
                        self.arrSubCatData.addObjects(from: subCatArray)
                        
                        print("arrSubCatData",subCatArray)
                        
                        if self.arrSubCatData.count < 0
                        {
                            self.lblNoData.isHidden = false

                        }
                        
                        self.viewCollection.reloadData()
                        
                    }
                        
                    else
                    {
                        self.alertMessage.strMessage = Localization(string:  "Dang! Something went wrong. Try again!")
                        self.alertMessage.modalPresentationStyle = .overCurrentContext
                        self.present(self.alertMessage, animated: false, completion: nil)
                        
                          print(Response.object(forKey: "message")!)
                        self.lblNoData.isHidden = false
                    }
                    
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
