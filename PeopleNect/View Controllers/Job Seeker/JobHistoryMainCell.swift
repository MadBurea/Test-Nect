//
//  JobHistoryMainCell.swift
//  PeopleNect
//
//  Created by Apple on 29/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class JobHistoryMainCell: UITableViewCell {

    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblPerHour: UILabel!
    
    @IBOutlet var viewLeft: UIView!
    @IBOutlet var viewRight: UIView!
    @IBOutlet var lblJob: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var imgRating: UIImageView!
    @IBOutlet var imgArrowUpDown: UIImageView!
    
    @IBOutlet var lblCompany: UILabel!
    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var lblLocation: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblBottomBorder: UILabel!
    
    var arrSubCatData = NSMutableArray()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblLocation.isHidden = true
        self.imgLocation.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
