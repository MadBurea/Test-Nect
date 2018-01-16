//
//  JobOnGoingJobsInnerCell.swift
//  PeopleNect
//
//  Created by Apple on 28/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class JobOnGoingJobsInnerCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var topBottomLblConstraints: NSLayoutConstraint!
    @IBOutlet weak var empratingBtnWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var empRatingBorderLbl: UILabel!
    @IBOutlet weak var empRatingBtn: UIButton!
    @IBOutlet weak var employerRatingLbl: UILabel!
    @IBOutlet var viewLeft: UIView!
    @IBOutlet var viewPayment: UIView!
    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblPerHour: UILabel!
    
    @IBOutlet var viewFromEndDate: UIView!
    @IBOutlet var lblFromEndDate: UILabel!
    @IBOutlet var imgFromEndDate: UIImageView!
    
    @IBOutlet var viewOnlyDays: UIView!
    @IBOutlet var lblOnlyDays: UILabel!
    
    @IBOutlet var lblJob: UILabel!
    @IBOutlet var lblRatings: UILabel!
    @IBOutlet var imgRating: UIImageView!
    
    @IBOutlet var imgUpDownArrow: UIImageView!
    
    @IBOutlet var lblMiddelCompany: UILabel!
    @IBOutlet var lblMiddelTrial: UILabel!
    
    @IBOutlet var objOnGoingJobsCollectionView: UICollectionView!
    
    @IBOutlet var lbCompanyAddress: UILabel!
    
    @IBOutlet var btnSeeDetails: UIButton!
    
    @IBOutlet var lblBottomBorder: UILabel!
    
    @IBOutlet var lblStartEndTime: UILabel!
    
    
    var arrSubCatData = NSMutableArray()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        objOnGoingJobsCollectionView.dataSource = self
        objOnGoingJobsCollectionView.delegate = self
        
        arrSubCatData = ["1","2"]

        // Initialization code
    }
    
    
    
// MARK: - UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSubCatData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobOnGoingJobsCollectionCell", for: indexPath) as! JobOnGoingJobsCollectionCell
        
        
        
        // var subCatagoryDict = NSDictionary()
        
        
        //cell.lblCollection.text = "\(arrSubCatData.object(at: indexPath.row))"
        
        
        
        
        cell.lblOnGOingJosCollection.text = "\(arrSubCatData[indexPath.row])"
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 1
        cell.layer.borderColor =  UIColor.gray.cgColor
        cell.backgroundColor = UIColor.white
        cell.clipsToBounds = true
        //   cell.imgClick.isHidden = true
        // cell.lblSelectExperienceScreen.preferredMaxLayoutWidth = 66
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        //  var subCatagoryDict = NSDictionary()
        
        //   subCatagoryDict = arrSubCatData.object(at: indexPath.row) as! NSDictionary
        
        
        
        let size: CGSize = ((arrSubCatData.object(at: indexPath.row)) as AnyObject).size(attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 17.0)!] )
        
        
        return CGSize(width: size.width + 20.0, height: 35)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    @IBAction func clickSeeDatails(_ sender: Any) {
        
//        let destination = JobOnGoingDetailsVC()
//        UINavigationController?.pushViewController(destination, animated: true)
//
//        let JobResetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "JobResetPasswordVC") as! jobDetai
//        
//        navigationController?.pushViewController(JobResetPasswordVC, animated: true)
//            
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
