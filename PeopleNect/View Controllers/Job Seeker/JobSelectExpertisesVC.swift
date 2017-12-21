//
//  JobSelectExpertisesVC.swift
//  PeopleNect
//
//  Created by Apple on 12/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader
import KTCenterFlowLayout

class JobSelectExpertisesVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UserChosePhoto {

    @IBOutlet var btnProfilePic: UIButton!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblSelectExpertises: UILabel!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var viewCollection: UICollectionView!
    
    @IBOutlet weak var lblNoData: UILabel!
    var selectedIndexPaths = IndexPath()
    var categoryId = String()
    var categoryName = String()

    var global = WebServicesClass()
    
    var arrSubCatData = NSMutableArray()
    
    var arrSelectedSubCatData = NSMutableArray()
    
    var arrSelectedSubCategory = NSMutableArray()
    
    var alertMessage = AlertMessageVC()
    
    var imgCommonProfiePic = UIImage()
    var userLoginDict = NSMutableDictionary()
    
    var userDic = NSMutableDictionary()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoData.isHidden = true
        
        self.lblNoData.text = "No expertise found for this business"
        
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        
        UICollectionViewController(collectionViewLayout: layout)
        
        viewCollection.dataSource = self
        viewCollection.delegate = self
        
        alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
        print("cnextcategoryId",categoryId)
        
        self.subCategoryListApi()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        

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
    
    
    // MARK: - UIView Actoins -
    
    @IBAction func clickProfilePic(_ sender: Any) {
        
        let jobSelectProfilrPicVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        
        jobSelectProfilrPicVC.delegate = self
        
        navigationController?.pushViewController(jobSelectProfilrPicVC, animated: true)
        
    }
    
    @IBAction func clickBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickNext(_ sender: Any) {
        
        let lastDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "LastDetailsVC") as! LastDetailsVC
        
       lastDetailVC.userInfoDict = userLoginDict
        
        print("arrSelectedSubCategory",arrSelectedSubCategory)
        
        lastDetailVC.arrSubCategoryId = arrSelectedSubCategory.mutableCopy() as! NSMutableArray
        
        lastDetailVC.categoryId = categoryId
        lastDetailVC.userDic = userDic

        if arrSelectedSubCategory.count <= 0{
            
            self.view.makeToast("Select at least one expertise, then continue", duration: 3.0, position: .bottom)

          //  print("Select any of SubCategory")
        }else{
            
            if btnProfilePic.imageView?.image != nil{
                
                lastDetailVC.imgCommonProfilePIC = (self.btnProfilePic.imageView?.image)!
                
            }

            navigationController?.pushViewController(lastDetailVC, animated: true)
            
        }
    }



    // MARK: - UICollectionView DataSource/Delegate Methods -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrSubCatData.count < 0
        {
            self.lblNoData.isHidden = false
            
            self.btnNext.isHidden = true
            
        }
        return arrSubCatData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectExperianceCell", for: indexPath) as! SelectExperianceCell
        

        
                var subCatagoryDict = NSDictionary()
        
                subCatagoryDict = arrSubCatData.object(at: indexPath.row) as! NSDictionary
        
                cell.lblSelectExperienceScreen.text = "\(subCatagoryDict.object(forKey: "subCategoryName")!)"
        

        
        cell.lblSelectExperienceScreen.textAlignment = .center
        cell.layer.cornerRadius = 25
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
        
        
        let size: CGSize = ((subCatagoryDict.object(forKey: "subCategoryName")!) as AnyObject).size(attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 16.0)!] )
        

        return CGSize(width: size.width + 66.0, height: 50)
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = viewCollection.cellForItem(at: indexPath) as! SelectExperianceCell
        
        var subCatagoryDict = NSDictionary()
        
        subCatagoryDict = arrSubCatData.object(at: indexPath.row) as! NSDictionary

        if   cell.imgClick.isHidden == true
        {
            cell.imgClick.isHidden = false
            
            cell.constrainY.constant = -8.5
            
            cell.backgroundColor = blueThemeColor
            
            cell.lblSelectExperienceScreen.textColor = UIColor.white

         //   print("arrSelectedSubCategory:-->",subCatagoryDict.object(forKey: "subCategoryId")!)
            
           arrSelectedSubCategory.add(subCatagoryDict.object(forKey: "subCategoryId")!)
            
           print(arrSelectedSubCategory)
            
        }
        else
        {
            cell.imgClick.isHidden = true
            
            cell.constrainY.constant = 0
            
            cell.backgroundColor = UIColor.white
            
            cell.lblSelectExperienceScreen.textColor = UIColor.black
            
            arrSelectedSubCategory.remove(subCatagoryDict.object(forKey: "subCategoryId")!)
            
        }
    }
    
    
    // MARK: - Class Methods -

    func userHasChosen(image: UIImage){
        
        if image.isEqual(nil){
            print("Choose An Image!")
        }
        else{
            
            btnProfilePic.setImage(image, for: .normal)
            
            ImgJobSeekerProfilepic = image

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
    
        
        let param =  [WebServicesClass.METHOD_NAME: "subCategoryList",
                      "categoryId":"\(categoryId)",
                       "userId":"\(userDic.object(forKey: "userId")!)",
                       "language":"en"] as [String : Any]
        
        
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
                    
                    if let subCatArray = dictResponse.object(forKey: "subCategoryList") as? [Any]
                    
                    {
                        self.arrSubCatData.addObjects(from: subCatArray)
                        
                        print("arrSubCatData",subCatArray)
                        
                        if self.arrSubCatData.count < 0
                        {
                            self.lblNoData.isHidden = false
                            
                            self.btnNext.isHidden = true

                        }
                        
                        self.viewCollection.reloadData()

                    }
                    
                else
                {

                    self.lblNoData.isHidden = false
                    self.btnNext.isHidden = true
                    
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
