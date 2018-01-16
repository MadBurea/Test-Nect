//
//  EmpHistoryInnerCell.swift
//  PeopleNect
//
//  Created by InexTure on 12/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class EmpHistoryInnerCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var historyRateBtnHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var historyUserTableHeight: NSLayoutConstraint!
    @IBOutlet weak var historyUserTableView: UITableView!
    @IBOutlet weak var historyRateBtn: UIButton!
    @IBOutlet weak var showHiredHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var rateCandidateWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var rateCandidateBorderLbl: UILabel!
    @IBOutlet weak var RateCandidateBtn: UIButton!
    @IBOutlet weak var showHiredBtn: UIButton!
    @IBOutlet weak var userRateTableheightConstraints: NSLayoutConstraint!
    @IBOutlet weak var userRateTableView: UITableView!
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
    
    @IBOutlet var objJobHistoryCollectionView: UICollectionView!
    
    @IBOutlet var lbCompanyAddress: UILabel!
    
    @IBOutlet var btnSeeDetails: UIButton!
    
    @IBOutlet var lblBottomBorder: UILabel!
    
    @IBOutlet var lblStartEndTime: UILabel!
    
    
    @IBOutlet var btnExpandCollaps: UIButton!
    @IBOutlet var lblLineA: UILabel!
    @IBOutlet var lblLineB: UILabel!
    @IBOutlet var lblProfessionalHired: UILabel!
    var arrSubCatData = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      //  btnSeeDetails.isHidden = true
        
        let topVC = UIApplication.topViewController()
        if topVC is EmpJobProgressVC {
            self.rateCandidateBorderLbl.isHidden = true
            self.RateCandidateBtn.isHidden = true
            self.showHiredBtn.isHidden = true
            self.userRateTableheightConstraints.constant = 0
            self.userRateTableView.isHidden = true
        }
        if topVC is EmpHistoryVC {
            self.rateCandidateBorderLbl.isHidden = true
            self.RateCandidateBtn.isHidden = true
            self.showHiredBtn.isHidden = true
            self.userRateTableheightConstraints.constant = 0
            self.userRateTableheightConstraints.constant = 0
            self.historyUserTableView.isHidden = true
            self.historyRateBtn.isHidden = true
        }
        
        
        
        self.lblProfessionalHired.isHidden = true
        objJobHistoryCollectionView.dataSource = self
        objJobHistoryCollectionView.delegate = self
        
     
       
        
        self.lblLineA.backgroundColor = blueThemeColor
        self.lblLineB.backgroundColor = blueThemeColor
        arrSubCatData = ["1","2"]

        // Initialization code
    }
    // MARK: - UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSubCatData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmpHistoryCollectionCell", for: indexPath) as! EmpHistoryCollectionCell
        
        cell.lblJobHistoryCollection.text = "\(arrSubCatData[indexPath.row])"
        
        cell.lblJobHistoryCollection.textAlignment = .center
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 1
        cell.layer.borderColor =  UIColor.gray.cgColor
        cell.backgroundColor = UIColor.white
        cell.clipsToBounds = true
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize = ((arrSubCatData.object(at: indexPath.row)) as AnyObject).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)] )
        
        return CGSize(width: size.width + 20.0, height: 35)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

