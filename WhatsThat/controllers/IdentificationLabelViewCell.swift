//
//  IdentificationLabelViewCell.swift
//  
//
//  Created by Chetan Mahajan on 11/23/17.
//

import UIKit

class IdentificationLabelViewCell: UITableViewCell {
    
    @IBOutlet weak var identificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
