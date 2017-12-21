//
//  JobAvailibilityOnOffCell.swift
//  PeopleNect
//
//  Created by Apple on 21/09/17.
//  Copyright © 2017 InexTure. All rights reserved.
//

import UIKit

class JobAvailibilityOnOffCell: UITableViewCell {

    @IBOutlet var lblDay: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var viewTblCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewTblCell.layer.cornerRadius = 5
        viewTblCell.layer.borderWidth = 1
        viewTblCell.layer.borderColor = UIColor.white.cgColor

    }

    @IBAction func clickCancel(_ sender: Any) {
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
