//
//  EmpHistoryRatingCell.swift
//  PeopleNect
//
//  Created by BAPS on 17/01/18.
//  Copyright © 2018 InexTure. All rights reserved.
//

import UIKit
import Cosmos

class EmpHistoryRatingCell: UITableViewCell {

    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var userNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
