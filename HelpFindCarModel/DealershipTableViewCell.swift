//
//  DealershipTableViewCell.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 06/01/2018.
//  Copyright © 2018 Tamir Hussain. All rights reserved.
//

import UIKit

class DealershipTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
