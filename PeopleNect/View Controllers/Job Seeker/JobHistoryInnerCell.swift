//
//  JobHistoryInnerCell.swift
//  PeopleNect
//
//  Created by Apple on 29/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class JobHistoryInnerCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var viewLeft: UIView!
    @IBOutlet var viewPayment: UIView!
    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblPerHour: UILabel!
    
    @IBOutlet weak var borderBottomLbl: UILabel!
    @IBOutlet weak var borderTopLbl: UILabel!
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
    
    @IBOutlet var objJobHistoryCollectionView: UICollectionView!
    
    @IBOutlet var lbCompanyAddress: UILabel!
    
    @IBOutlet var btnSeeDetails: UIButton!
    
    @IBOutlet var lblBottomBorder: UILabel!
    
    @IBOutlet var lblStartEndTime: UILabel!
    
    
    var arrSubCatData = NSMutableArray()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnSeeDetails.isHidden = true
        
        objJobHistoryCollectionView.dataSource = self
        objJobHistoryCollectionView.delegate = self
        
        arrSubCatData = ["1","2"]

    }
    
    // MARK: - UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSubCatData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobHistoryCollectionCell", for: indexPath) as! JobHistoryCollectionCell
        
        
        
        // var subCatagoryDict = NSDictionary()
        
        
        //cell.lblCollection.text = "\(arrSubCatData.object(at: indexPath.row))"
        
        
        
        
        cell.lblJobHistoryCollection.text = "\(arrSubCatData[indexPath.row])"

        cell.lblJobHistoryCollection.textAlignment = .center
        cell.layer.cornerRadius = 15
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
        
        
        return CGSize(width: size.width + 20.0, height: 35)
        
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
