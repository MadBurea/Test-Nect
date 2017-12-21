//
//  JobDashBoardMainCell.swift
//  PeopleNect
//
//  Created by Apple on 20/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class JobDashBoardMainCell: UITableViewCell {

    
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
    
    @IBOutlet var viewMain: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
    
}
