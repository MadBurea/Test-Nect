//
//  EmpSelectSkillsVC.swift
//  PeopleNect
//
//  Created by InexTure on 17/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader
import KTCenterFlowLayout

class EmpSelectSkillsVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UserChosePhoto {
    
    @IBOutlet var btnProfilePic: UIButton!
    @IBOutlet var lblSelectSkills: UILabel!
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
    
    var userDict = NSDictionary()
    
    var imgCommonProfiePic = UIImage()
    
    var profileImage = UIImage()

     var CellCount = CGFloat()
     var CellSpacing = CGFloat()
     var collectionViewWidth = CGFloat()
     var CellWidth = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoData.isHidden = true
        
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        
        UICollectionViewController(collectionViewLayout: layout)
        
        viewCollection.bounces = false
        
        viewCollection.dataSource = self
        viewCollection.delegate = self
        
        btnProfilePic.isUserInteractionEnabled = false
       // btnProfilePic.setImage(ImgEmployerProfilepic, for: .normal)
        lblNoData.text = "No expertise found for this business"

        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        alertMessage = storyBoard.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC

        
        self.subCategoryListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.btnProfilePic.setImage(profileImage, for: .normal)
        
        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2
        btnProfilePic.clipsToBounds = true
        btnProfilePic.layer.borderWidth = 1
        btnProfilePic.layer.borderColor = ColorProfilePicBorder.cgColor
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func clickProfilePic(_ sender: Any) {
        
        let jobSelectProfilrPicVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
        
        jobSelectProfilrPicVC.delegate = self
        
        navigationController?.pushViewController(jobSelectProfilrPicVC, animated: true)
        
    }
    
    @IBAction func clickBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickNext(_ sender: Any) {
        
        let empLastDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpLastDetailsVC") as! EmpLastDetailsVC
        empLastDetailsVC.selectUserDict = userDict
        empLastDetailsVC.inviteUser = 1
        empLastDetailsVC.categoryId = categoryId
        empLastDetailsVC.subCategoryId = arrSelectedSubCategory.componentsJoined(by: ",")
        empLastDetailsVC.profileImage = self.profileImage
        

        print("categoryId is",categoryId)
        
        if arrSelectedSubCategory.count == 0{
            self.alertMessage.strMessage = Localization(string:"Select at least one expertise, then continue")
            self.alertMessage.modalPresentationStyle = .overCurrentContext
            self.present(self.alertMessage, animated: false, completion: nil)
        }else{
            
            navigationController?.pushViewController(empLastDetailsVC, animated: true)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectExperianceCell", for: indexPath) as! SelectExperianceCell
        
        
        
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
        
        
        var size: CGSize = ((subCatagoryDict.object(forKey: "subCategoryName")!) as AnyObject).size(attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 17.0)!] )
        
        
        if (size.width > viewCollection.frame.size.width )
        {
            size.width = viewCollection.frame.size.width
        }

        return CGSize(width: size.width + 60.0, height: 50)
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = viewCollection.cellForItem(at: indexPath) as! SelectExperianceCell
        
        var subCatagoryDict = NSDictionary()
        
        subCatagoryDict = arrSubCatData.object(at: indexPath.row) as! NSDictionary
        

        if cell.imgClick.isHidden == true
        {
            
            if arrSelectedSubCategory.count > 0
            {
                self.view.makeToast(Localization(string:"Select only 1 speciality"), duration: 1.0, position: .bottom)
                
             cell.isUserInteractionEnabled = false

            }
            else{
                
            cell.isUserInteractionEnabled = true

            cell.imgClick.isHidden = false
            
            cell.constrainY.constant = -8.5
            
            cell.backgroundColor = blueThemeColor
            
            cell.lblSelectExperienceScreen.textColor = UIColor.white

            arrSelectedSubCategory.add(subCatagoryDict.object(forKey: "subCategoryId")!)
            
            }

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
        
        print("categoryName",categoryName)
        
      
        
        print("categoryId",categoryId)
        print("userId",(appdel.loginUserDict.object(forKey: "employerId")!))


        let param = [WebServicesClass.METHOD_NAME: "subCategoryList","categoryId":"\(categoryId)","userId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage] as [String : Any]
        
        
        global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
            
            SwiftLoader.hide()

            if error != nil
            {
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
