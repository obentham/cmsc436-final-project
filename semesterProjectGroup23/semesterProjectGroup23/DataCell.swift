//
//  DataCell.swift
//  semesterProjectGroup23
//
//  Created by Yasmin Abdi on 5/8/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import Foundation
import UIKit

class DataCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func congigureCell(text: String) {
        
        label.text = text
    }
}
