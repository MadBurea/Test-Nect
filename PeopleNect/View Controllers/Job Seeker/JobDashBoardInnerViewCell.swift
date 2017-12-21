//
//  JobDashBoardInnerViewCell.swift
//  PeopleNect
//
//  Created by Apple on 20/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class JobDashBoardInnerViewCell: UITableViewCell,    UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var heightConstraintofCollectionView: NSLayoutConstraint!
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
    
    @IBOutlet var objCollectionView: UICollectionView!
    
    @IBOutlet var lblCompany: UILabel!
    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var btnApplyAlReadyInvited: UIButton!
    
    @IBOutlet var lblBottomBorder: UILabel!
    
    @IBOutlet var lblStartEndTime: UILabel!
    
    @IBOutlet var bottonLineA: UILabel!
    @IBOutlet var bottomLineB: UILabel!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var constrainHeightCollection: NSLayoutConstraint!
    var arrSubCatData = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  arrSubCatData = ["asdhbs","asdhbs","asdhbs","asdhbs","asdhbs"]
        //constrainHeightCollection.constant = 50
        objCollectionView.register(UINib(nibName: "InnerCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "InnerCollectionCell")
        objCollectionView.dataSource = self
        objCollectionView.delegate = self
        
        mainView.layer.cornerRadius = 2.0
        
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainView.layer.shadowRadius = 2.0


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSubCatData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCollectionCell", for: indexPath) as! InnerCollectionCell
        
        
        
         var subCatagoryDict = NSDictionary()
        
        
        cell.lblCollection.text = "\(arrSubCatData.object(at: indexPath.row))"
        
        // cell.labelObj.text = "\(tempArray[indexPath.row])"
        // cell.lblSelectExperienceScreen.textAlignment = .center
        cell.layer.cornerRadius = 20.0
        cell.layer.borderWidth = 1
        cell.layer.borderColor =  UIColor.gray.cgColor
        cell.backgroundColor = UIColor.white
        //   cell.lblSelectExperienceScreen.textColor = UIColor.black
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
        
        
//        if (size.width + 20.0) >= objCollectionView.bounds.width
//        {
//            constrainHeightCollection.constant = 100
//        }
        
        return CGSize(width: size.width + 20.0, height: 35)
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    
}
