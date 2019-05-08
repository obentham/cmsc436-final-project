//
//  DataCell.swift
//  SearchApp
//
//  Created by Yasmin Abdi on 5/1/19.
//  Copyright © 2019 Yasmin Abdi. All rights reserved.
//

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
