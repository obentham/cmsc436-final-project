//
//  SearchTableCell.swift
//  semesterProjectGroup23
//
//  Created by Terry Kim on 5/14/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
