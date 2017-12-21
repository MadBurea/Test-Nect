//
//  JobSelectProfilrPicVC.swift
//  PeopleNect
//
//  Created by Apple on 13/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

protocol UserChosePhoto {
    func userHasChosen(image: UIImage)
}


class JobSelectProfilrPicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var lblChoosePicture: UILabel!
    @IBOutlet var btnCamara: UIButton!
    @IBOutlet var btnMyPhotos: UIButton!
    @IBOutlet var btnFacebook: UIButton!
    
    var dataValue = Data()
    var delegate: UserChosePhoto?
    
    let tapGesture = UITapGestureRecognizer()


    
    var imagePickerControllerObj:UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnCamara.layer.cornerRadius = btnCamara.bounds.size.width/2
        btnCamara.clipsToBounds = true
        //btnCamara.layer.borderWidth = 1
        btnCamara.layer.borderColor = ColorProfilePicBorder.cgColor
        
        btnMyPhotos.layer.cornerRadius = btnCamara.bounds.size.width/2
        btnMyPhotos.clipsToBounds = true
        //btnMyPhotos.layer.borderWidth = 1
        btnMyPhotos.layer.borderColor = ColorProfilePicBorder.cgColor

        
        btnFacebook.layer.cornerRadius = btnCamara.bounds.size.width/2
        btnFacebook.clipsToBounds = true
        //btnFacebook.layer.borderWidth = 1
        btnFacebook.layer.borderColor = ColorProfilePicBorder.cgColor

        tapGesture.addTarget(self, action: #selector(self.dismissView))
        
        self.view.addGestureRecognizer(tapGesture)
        

        

        // Do any additional setup after loading the view.
    }
    
    
    func dismissView()
    {
        
        if appdel.isFromRegister {
            self.navigationController?.popViewController(animated: true)
        }else{
        self.dismiss(animated: false, completion: nil)
        }
        
//            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: false, completion: nil)
        
    }

    
    @IBAction func btnTakePhotoClicked(_ sender: AnyObject) {
        
        
        if imagePickerControllerObj == nil
        {
            imagePickerControllerObj = UIImagePickerController()
            imagePickerControllerObj.delegate = self
            
            //            imagePickerControllerObj.delegate = self
            
            imagePickerControllerObj.allowsEditing = false
        }
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePickerControllerObj.sourceType = .camera
            present(imagePickerControllerObj, animated: true, completion: nil)
        }
        else
        {
         //   globalMethodObj.ShowAlertDisplay(titleObj: "", messageObj: "Camera not avalilable", viewcontrolelr: self)
            
            print("Permison Error:")
        }
        
        
    }
    
    @IBAction func btnChooesfromLibraryClicked(_ sender: AnyObject) {
        
        
        
        if imagePickerControllerObj == nil
        {
            imagePickerControllerObj = UIImagePickerController()
            imagePickerControllerObj.delegate = self
            imagePickerControllerObj.allowsEditing = false
        }
        
        imagePickerControllerObj.sourceType = .photoLibrary
        
        present(imagePickerControllerObj, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    // MARK: - Method FaceBook JobSignUpVC
    
   @IBAction func btnFBProfilePic(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { LoginResult in
            switch LoginResult {
                
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                self.getUserrInfo(completion: { (userInfo, error) in
                    if error != nil
                    {
                        print("error")
                    }
                    print("userInfo",userInfo)
                    
                })
                
            }
            //  print("Logged in!")
        }
        
    }
    
    
    
    
    func getUserrInfo(completion: @escaping (_: [String: Any]?, _ : Error?) -> Void){
        
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture"])
        
        req.start {response , result in
            switch result{
            case .failed(let error):
                completion(nil, error)
            case .success(let graphResponse):
                completion(graphResponse.dictionaryValue, nil)
                
                print(graphResponse)
                print("graphResponse.dictionaryValue",graphResponse.dictionaryValue)
                let DictImg = graphResponse.dictionaryValue! as NSDictionary
                print("DictImg",DictImg)
                
                let dictImgUrl = DictImg.object(forKey: "picture") as! NSDictionary
                
                print("dictImgUrl",dictImgUrl)
                
                let url = dictImgUrl.object(forKey: "data") as! NSDictionary
                
                print(url)
                
                
                let urlD = URL(string: (url.object(forKey: "url") as! String))
                print(urlD)
                let dataD = try? Data(contentsOf: urlD!)
                print(dataD)

                let DataPic = UIImage(data: dataD!)
                print(DataPic)
                
       //         let img:UIImage = UIImage(data: NSData(contentsURL: url)!)

                
                
                
                //                print(graphResponse)
//                print("graphResponse.dictionaryValue",graphResponse.dictionaryValue)
//                let DictImg = graphResponse.dictionaryValue! as NSDictionary
//                print("DictImg",DictImg)
//                
//                let dictImgUrl = DictImg.object(forKey: "picture") as! NSDictionary
//                
//                print("dictImgUrl",dictImgUrl)
//                
//                let url = dictImgUrl.object(forKey: "data") as! NSDictionary
//                
//                print(url)
//                
//                let imgURL = NSURL(string: url.object(forKey: "url") as! String)!
//                
//                print(imgURL)
//                
//                var imageData = NSData(contentsOf: imgURL as URL)
//                
//                //  var imageData = NSData(contentsOfURL: (imgURL! as URL))
                
                self.delegate?.userHasChosen(image: DataPic!)

                
                self.dismiss(animated: false, completion: nil)
                
                self.navigationController?.popViewController(animated: true)

                
            }
        }
        
    }
    
    
    //MARK: Image PickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //if (delegate != nil) {
        
        let imageName = info[UIImagePickerControllerOriginalImage] as! UIImage
       
        ImgJobSeekerProfilepic = imageName
        
        ImgEmployerProfilepic = imageName
        
        // }
        //self.selAddPhoto(btnAddPhoto)
        //let imageName = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let data = UIImageJPEGRepresentation(imageName, 1.0)! as Data
        
        //        let data = UIImagePNGRepresentation(imageName)! as Data
        // self.UploadPhotoWebservice(imageData: data)

       // self.navigationController?.popViewController(animated: true)
        
        
        imagePickerControllerObj.dismiss(animated: true, completion: nil)

        if appdel.isFromRegister {
            self.delegate?.userHasChosen(image: imageName)

            self.navigationController?.popViewController(animated: true)
        }else{
            imagePickerControllerObj.dismiss(animated: true, completion: nil)
            self.dismiss(animated: false, completion: nil)

            self.delegate?.userHasChosen(image: imageName)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeImage"), object: nil)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        imagePickerControllerObj.dismiss(animated: true, completion: nil)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
