//
//  EmpDashboardMainCell.swift
//  PeopleNect
//
//  Created by Apple on 20/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class EmpDashboardMainCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var imgStar: UIImageView!

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var heightContraintOfCollectionView: NSLayoutConstraint!
    @IBOutlet var lblRatingCount: UILabel!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblfloat: UILabel!
    @IBOutlet var lblMore: UILabel!
    @IBOutlet var innerCollectionView: UICollectionView!
    @IBOutlet var lblYears: UILabel!
    @IBOutlet var imgProfilePic: UIImageView!
    var subCategoryArray = NSMutableArray()
    
    @IBOutlet weak var MoreBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var moreLblHeightConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*EmpDashInnerCollectionViewCell
         lblSubCategoryName*/
        // Initialization code
        
        innerCollectionView.register(UINib(nibName: "EmpDashInnerCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "EmpDashInnerCollectionViewCell")
        
//        var nib=UINib(nibName: "MenuCell", bundle:nil)
//        collectionView.registerNib(nib, forCellWithReuseIdentifier: "menuCell")
        
        innerCollectionView.delegate = self
        innerCollectionView.dataSource = self
        
        heightContraintOfCollectionView.constant = innerCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        //  heightContraintofCollectionview.constant = innerCollectionViewObj.contentSize.height
        
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.size.height / 2
        imgProfilePic.layer.masksToBounds = true
        
//        imgProfilePic.layer.borderColor = UIColor.red.cgColor
//        imgProfilePic.layer.borderWidth = 2.0


        viewMain.layer.cornerRadius = 2.0
        viewMain.layer.shadowColor = UIColor.gray.cgColor
        viewMain.layer.shadowOpacity = 0.5
        viewMain.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewMain.layer.shadowRadius = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return subCategoryArray.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmpDashInnerCollectionViewCell", for: indexPath) as! EmpDashInnerCollectionViewCell
        
        cell.lblSubCategoryName.text = "\(subCategoryArray.object(at: indexPath.row))"
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize = ((subCategoryArray.object(at: indexPath.row)) as AnyObject).size(attributes: [NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 12.0)!] )
        //print("size",size)
        
        return CGSize(width: size.width + 20.0, height: 30)
        
    }
    

}
