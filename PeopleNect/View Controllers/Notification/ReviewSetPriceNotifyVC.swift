//
//  ReviewSetPriceNotifyVC.swift
//  PeopleNect
//
//  Created by BAPS on 11/9/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit
import Cosmos
import Toast_Swift

class ReviewSetPriceNotifyVC: UIViewController,UITextFieldDelegate {

    // MARK: - OUTLETS -
    @IBOutlet weak var totalPriceTF: UITextField!
    @IBOutlet weak var totalHourTF: UITextField!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var ratingStatusLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    
    // MARK: - VARIABLES -
    var totalHour = ""
    var totalPrice = ""
    var jobTitle = ""
    var userName = ""
    var rating:Double = 0
    var ratingText = ""
    var ratingStatus = ""
    let _acceptableCharacters = "0123456789."

    var profileImage = UIImage()
    var fromRatingScreen = false
    // MARK: - VIEW LIFE CYCLE -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let corner = (UIScreen.main.bounds.size.height / 667) * 70
        userProfileImg.layer.cornerRadius = corner/2
        userProfileImg.layer.masksToBounds = true
        
        totalPrice = totalPrice.replacingOccurrences(of: "$", with: "")
        totalHourTF.text = totalHour
        totalPriceTF.text = totalPrice
        userNameLbl.text = userName
        jobTitleLbl.text = jobTitle
        ratingStatusLbl.text = ratingStatus
        userProfileImg.image = profileImage
        ratingView.rating = rating
        ratingView.text = ratingText

        totalHourTF.delegate = self
        totalPriceTF.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIACTION -
    @IBAction func ClickOnAdjust(_ sender: Any) {
        
        if (totalHourTF.text?.isBlank)! {
              self.view.makeToast("Total Hour Should not be blank", duration: 1.0, position: .bottom)
        }
        else if (totalPriceTF.text?.isBlank)! {
            self.view.makeToast("Total Price Should not be blank", duration: 1.0, position: .bottom)
        }
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Employee", bundle:nil)
            let reviewJobVC = storyBoard.instantiateViewController(withIdentifier: "ReviewJobNotifierVC") as! ReviewJobNotifierVC
            reviewJobVC.totalHour = totalHourTF.text!
            reviewJobVC.totalPrice = totalPriceTF.text!
            reviewJobVC.fromSetPrice = true
            reviewJobVC.userName = userName
            reviewJobVC.ratingStatus = ratingStatus
            reviewJobVC.rating = rating
            reviewJobVC.profileImage = profileImage
            reviewJobVC.jobTitle = jobTitle
            reviewJobVC.fromRatingScreen = fromRatingScreen
            reviewJobVC.ratingText = ratingText
            self.navigationController?.pushViewController(reviewJobVC, animated: true)
        }
    }
    
    // MARK: - TEXTFIELD DELEGATES -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let inverseSet = CharacterSet(charactersIn:".0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        if (textField.text?.contains("."))!, string.contains(".") {
            return false
        }
        return string == filtered
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if totalHourTF == textField
        {
            totalHourTF.resignFirstResponder()
            totalPriceTF.becomeFirstResponder()
        }
        if totalPriceTF == textField
        {
            totalPriceTF.resignFirstResponder()
        }
        return true
    }
}
