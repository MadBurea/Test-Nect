//
//  EmpPostNewJobVC.swift
//  PeopleNect
//
//  Created by Apple on 09/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import SwiftLoader

class EmpPostNewJobCell : UICollectionViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!
    
//    override func prepareForReuse() {
//        lblTitle.text = ""
//    }
    
}

class EmpPostNewJobVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SlideNavigationControllerDelegate {

    
    @IBOutlet weak var objCollectionView : UICollectionView!
    @IBOutlet var btnProfilePic: UIButton!
    
    @IBOutlet weak var lblNoData: UILabel!
    var arrData = NSMutableArray()
    var global = WebServicesClass()
    var alertMessage = AlertMessageVC()
    
    var profileImage = UIImage()
    
    var index = -1


    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblNoData.isHidden = true
        objCollectionView.delegate = self
        objCollectionView.dataSource = self
        
        btnProfilePic.isUserInteractionEnabled = false
        //btnProfilePic.setImage(ImgEmployerProfilepic, for: .normal)

        self.categoryListApi()
        
        //alertMessage = self.storyboard?.instantiateViewController(withIdentifier: "AlertMessageVC") as! AlertMessageVC
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.btnProfilePic.setImage(profileImage, for: .normal)
        ImgEmployerProfilepic = profileImage
        btnProfilePic.layer.cornerRadius = btnProfilePic.bounds.size.width/2
        btnProfilePic.clipsToBounds = true
        btnProfilePic.layer.borderWidth = 1
        btnProfilePic.layer.borderColor = ColorProfilePicBorder.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
            objCollectionView.reloadData()


    }

    @IBAction func btnBackClick(sender : UIButton) {
        SlideNavigationController.sharedInstance().leftMenuSelected(sender)
    }





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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmpPostNewJobCell",for: indexPath) as! EmpPostNewJobCell
    
    var CatagoryDict = NSDictionary()
    
    CatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
    
    if index == indexPath.row
    {
        cell.lblTitle.layer.borderColor = blueThemeColor.cgColor
        cell.lblTitle.layer.borderWidth = 1.5
        
    }
    else
    {
        cell.lblTitle.layer.borderWidth = 0
        cell.lblTitle.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    cell.lblTitle.text = "\(CatagoryDict.object(forKey: "categoryName")!)"
    
    return cell
}


func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let cell = objCollectionView.cellForItem(at: indexPath) as! EmpPostNewJobCell
    
    let empSelectSkillsVC = self.storyboard?.instantiateViewController(withIdentifier: "EmpSelectSkillsVC") as! EmpSelectSkillsVC
    
    cell.lblTitle.layer.borderWidth = 0
    
    index = indexPath.row

    if cell.lblTitle.layer.borderWidth == 0{
        
        cell.lblTitle.layer.borderColor = blueThemeColor.cgColor
        cell.lblTitle.layer.borderWidth = 2.0
        
    }
    else{
        
        cell.lblTitle.layer.borderWidth = 0
        
    }
    
    
    
    
    let CatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
    
    
    empSelectSkillsVC.categoryName = "\(CatagoryDict.object(forKey: "categoryName")!)"
    
    empSelectSkillsVC.categoryId = "\(CatagoryDict.object(forKey: "categoryId")!)"
    
    
    if btnProfilePic.imageView?.image != nil{
        
        
        //empSelectSkillsVC.imgCommonProfiePic = (btnProfilePic.imageView?.image)!
        
    }
    else{
        
        cell.lblTitle.layer.borderWidth = 0
        
    }
    
    empSelectSkillsVC.profileImage = profileImage


        self.navigationController?.pushViewController(empSelectSkillsVC, animated: true)
    
}


func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    
    var sizeCatagoryDict = NSDictionary()
    
    sizeCatagoryDict = arrData.object(at: indexPath.row) as! NSDictionary
    
    
    
   // let size: CGSize = ((sizeCatagoryDict.object(forKey: "categoryName")!) as AnyObject).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)] )
    
    
    return CGSize(width: ((objCollectionView.frame.size.width/2) - 6), height: 65)
    
}
    // MARK: - Slide Navigation Delegates -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }


// MARK: - class Methods

@IBAction func clickSelProfilePic(_ sender: Any) {
    
    let jobSelectProfilrPicVC = self.storyboard?.instantiateViewController(withIdentifier: "JobSelectProfilrPicVC") as! JobSelectProfilrPicVC
    
  //  jobSelectProfilrPicVC.delegate = self
    
    navigationController?.pushViewController(jobSelectProfilrPicVC, animated: true)
}

//func userHasChosen(image: UIImage){
//    
//    if image.isEqual(nil){
//        print("Choose An Image!")
//    }
//    else{
//        
//       // btnProfilePic.setImage(image, for: .normal)
//        
//        btnProfilePic.setImage(image, for: .normal)
//        
//        ImgEmployerProfilepic = image
//    }
//}




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
    
    let param =  [WebServicesClass.METHOD_NAME: "categoryList","userId":"\(appdel.loginUserDict.object(forKey: "employerId")!)","language":appdel.userLanguage] as [String : Any]
    
    
    global.callWebService(parameter: param as AnyObject!) { (Response:AnyObject, error:NSError?) in
        
        SwiftLoader.hide()
        if error != nil
        {
            print("Error",error?.description as String!)
        }
        else
        {
            
            let dictResponse = Response as! NSDictionary
            
            let status = dictResponse.object(forKey: "status") as! Int
            
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
                self.objCollectionView.reloadData()
                
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
    
    //extension EmpPostNewJobVC : UICollectionViewDataSource {
    //
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return 5
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "empPostNewJobCell", for: indexPath) as! EmpPostNewJobCell
    //
    ////        cell.lblTitle.text = ""
    //
    //        return cell
    //    }
    //    
    //}


//extension EmpPostNewJobVC : UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected item :- ",indexPath.item)
//    }
//
//}
//
//extension EmpPostNewJobVC : UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 130, height: 70)
//    }
//    
}
