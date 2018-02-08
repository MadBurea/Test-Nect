//
//  JobSettingSelectCategoryVC.swift
//  PeopleNect
//
//  Created by Apple on 04/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class JobSettingSelectCategoryVC: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet var lblWhatFitsBest: UILabel!
    @IBOutlet var collectionCatagory: UICollectionView!
    
    @IBOutlet weak var lblNoData: UILabel!
    var arrData = NSMutableArray()
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    
    var categoryId = String()
    var nameCategory = String()
    var nameSubCategoryId = NSMutableArray()
    var IdCategory = String()


    @IBOutlet weak var topView: UIView!


    
    //MARK: - View life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblNoData.isHidden = true
        
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topView.layer.shadowRadius = 2.0
        
        self.categoryListApi()
        
     //   alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Actions
    @IBAction func clickBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobSettingSelectCategoryCollectionCell",for: indexPath) as! JobSettingSelectCategoryCollectionCell
        
        var CatagoryDict = NSDictionary()
        
        CatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
        
        
        cell.lblCollectionDetail.text = "\(CatagoryDict.object(forKey: "categoryName")!)"
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionCatagory.cellForItem(at: indexPath) as!JobSettingSelectCategoryCollectionCell
        
        let jobSelectExpertisesVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSettingSelectExperticesBVC") as! JobSettingSelectExperticesBVC
        
        cell.lblCollectionDetail.layer.borderWidth = 0
        
        if cell.lblCollectionDetail.layer.borderWidth == 0{
            
            cell.lblCollectionDetail.layer.borderColor = blueThemeColor.cgColor
            cell.lblCollectionDetail.layer.borderWidth = 1.5
            
        }
        else{
            cell.lblCollectionDetail.layer.borderWidth = 0
            
        }
        
        let CatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
        
        jobSelectExpertisesVC.categoryId = "\(CatagoryDict.object(forKey: "categoryId")!)"
        
        jobSelectExpertisesVC.nameCategory = "\(CatagoryDict.object(forKey: "categoryName")!)"
        
            cell.lblCollectionDetail.layer.borderWidth = 0
        
        self.navigationController?.pushViewController(jobSelectExpertisesVC, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizeCatagoryDict = NSDictionary()
        
        
        
        sizeCatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
        
        
        
        // let size: CGSize = ((sizeCatagoryDict.object(forKey: "categoryName")!) as AnyObject).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)] )
        
        
        return CGSize(width: ((collectionCatagory.frame.size.width/2) - 6), height: 65)
        
        
        
        
//        
//        sizeCatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
//        
//        
//        
//        let size: CGSize = ((arrData.object(at: indexPath.row)) as AnyObject).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)] )
//        
//        
//        return CGSize(width: size.width + 20.0, height: 35)
        
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
       
        
        
        let param =  [WebServicesClass.METHOD_NAME: "categoryList","userId":"\(appdel.loginUserDict.object(forKey: "userId")!)","language":appdel.userLanguage] as [String : Any]
        
        
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
                    self.collectionCatagory.reloadData()
                    
                }
                else
                {
                    self.alertMessage.strMessage = Localization(string:  "No business segment available")
                    self.alertMessage.modalPresentationStyle = .overCurrentContext
                    self.present(self.alertMessage, animated: false, completion: nil)

                    self.lblNoData.isHidden = false
                }
                
                
            }
        }
        
    }


    @IBAction func clickBAck(_ sender: Any) {
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
