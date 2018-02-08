//
//  EmpHistoryInnerCell.swift
//  PeopleNect
//
//  Created by InexTure on 12/10/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class EmpHistoryInnerCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var professionalLblBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var ProfessionalLblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var userTableTopConstraints: NSLayoutConstraint!
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
    
    var jobSeekerRating = NSArray()

    override func awakeFromNib() {
        super.awakeFromNib()
        
       let notification = Notification.Name("reloadRatingTable")
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadRatingTable),name:notification,object:nil)
        
        let topVC = UIApplication.topViewController()
        if topVC is EmpJobProgressVC {
            self.rateCandidateBorderLbl.isHidden = true
            self.RateCandidateBtn.isHidden = true
            self.showHiredBtn.isHidden = true
            self.userRateTableheightConstraints.constant = 0
            self.userRateTableView.isHidden = true
            
            self.userRateTableView.register(UINib(nibName: "EmpHistoryRatingCell", bundle: Bundle.main), forCellReuseIdentifier: "EmpHistoryRatingCell")
            
            self.userRateTableView.rowHeight = UITableViewAutomaticDimension
            self.userRateTableView.estimatedRowHeight = 20
            
            self.userRateTableView.dataSource = self
            self.userRateTableView.delegate = self
        }
       else if topVC is EmpHistoryVC {
            self.userRateTableheightConstraints.constant = 0
            self.historyRateBtn.isHidden = true
            
            self.userRateTableView.register(UINib(nibName: "EmpHistoryRatingCell", bundle: Bundle.main), forCellReuseIdentifier: "EmpHistoryRatingCell")
            
            self.userRateTableView.rowHeight = UITableViewAutomaticDimension
            self.userRateTableView.estimatedRowHeight = 20
            
            self.userRateTableView.dataSource = self
            self.userRateTableView.delegate = self
        }
        else{
            self.lblProfessionalHired.isHidden = true
        }
        
     
        objJobHistoryCollectionView.dataSource = self
        objJobHistoryCollectionView.delegate = self
       
        self.lblLineA.backgroundColor = blueThemeColor
        self.lblLineB.backgroundColor = blueThemeColor
        arrSubCatData = ["1","2"]
    }
    // MARK: - Notification for reload Table
    func reloadRatingTable()  {
        
        if jobSeekerRating.count > 0 {
            self.userRateTableView.reloadData()
            self.userRateTableheightConstraints.constant = 1000
            let indexPath = NSIndexPath(row: jobSeekerRating.count-1, section: 0)
            self.userRateTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
            let startIndexPath = NSIndexPath(row: 0, section: 0)
            self.userRateTableView.scrollToRow(at: startIndexPath as IndexPath, at: .top, animated: false)
        }
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
    
    // MARK: - UITableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobSeekerRating.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratingCell = tableView.dequeueReusableCell(withIdentifier: "EmpHistoryRatingCell", for: indexPath)
            as! EmpHistoryRatingCell
        
        var tempDict = NSDictionary()
        tempDict = jobSeekerRating.object(at: indexPath.row) as! NSDictionary
        
        if let name = tempDict["JobseekerName"] {
            ratingCell.userNameLbl.text = name as? String
        }else{
            ratingCell.userNameLbl.text = tempDict["name"] as? String
        }
        let rating = tempDict["rating"] as! NSString
        
        if rating.length > 0 {
            let floatValue = rating.doubleValue
            ratingCell.userRatingView.rating = floatValue
        }else{
            ratingCell.userRatingView.rating = 0
        }
       
        if indexPath.row == jobSeekerRating.count - 1 {
            self.userRateTableheightConstraints.constant = self.userRateTableView.contentSize.height
        }
        
        return ratingCell
    }
}

