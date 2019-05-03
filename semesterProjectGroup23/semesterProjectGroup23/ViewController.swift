//
//  ViewController.swift
//  semesterProjectGroup23
//
//  Created by Oliver Bentham on 4/20/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var cbClient: CoinbaseClient
    
    required init?(coder aDecoder: NSCoder) {
        self.cbClient = CoinbaseClient()
        
        super.init(coder: aDecoder)
    }
    
    
	@IBOutlet weak var SearchButtonOutlet: UIButton!
	@IBAction func SearchButtonAction(_ sender: UIButton) {
		// segue to SearchController
	}
    
    
	@IBOutlet weak var TableViewOutlet: UITableView!
	
	// need to implement TableView functions
	
	// each TableViewCell has a stack view containing the
	// corresponding labels (name, value, and change in value)
	
	// each TableViewCell also has a button that should take
	// the user to that stock's StockController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		SearchButtonOutlet.layer.cornerRadius = 10
		TableViewOutlet.layer.cornerRadius = 5
        
        // Test Script
        
        //cbClient.connectToStream()
        cbClient.getProducts()
        //fetchCryptoData()
	}

    
    
    
    
}

