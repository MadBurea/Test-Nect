//
//  EmpDashboradMainCell.swift
//  PeopleNect
//
//  Created by Apple on 13/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class EmpDashboradMainCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet var innerCollectionViewObj: UICollectionView!
    @IBOutlet var heightContraintofCollectionview: NSLayoutConstraint!
    @IBOutlet var lblMore: UILabel!
   
    @IBOutlet var lblFloat: UILabel!
    @IBOutlet var lblFavourite: UILabel!
    @IBOutlet var lblYearsKm: UILabel!
    @IBOutlet var imgStar: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfilePic: UIImageView!
    var subCategoryArray = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        innerCollectionViewObj.delegate = self
        innerCollectionViewObj.dataSource = self
        
        heightContraintofCollectionview.constant = innerCollectionViewObj.collectionViewLayout.collectionViewContentSize.height

      //  heightContraintofCollectionview.constant = innerCollectionViewObj.contentSize.height

        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.size.width / 2
        imgProfilePic.clipsToBounds = true
        
     //   innerCollectionViewObj.reloadData()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
      //  innerCollectionViewObj.reloadData()

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return subCategoryArray.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectcell", for: indexPath) as! EmpDashInnerCollectionViewCell
    
        cell.lblSubCategoryName.text = "\(subCategoryArray.object(at: indexPath.row))"
        cell.layer.cornerRadius = 25.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize = ((subCategoryArray.object(at: indexPath.row)) as AnyObject).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)] )
        print("size",size)
        
        
        return CGSize(width: size.width + 20.0, height: 40)
        
        
    }
    
}
