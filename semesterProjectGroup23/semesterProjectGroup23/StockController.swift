//
//  GraphController.swift
//  semesterProjectGroup23
//
//  Created by Oliver Bentham on 4/24/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import UIKit
//import CorePlot

// When the user clicks on a stock, either in the TableView in the ViewController,
// or in the TableView in the SearchController, the app will take them to that stock's
// StockController. The Stock Controller displays info about the stock and launches a
// GraphView to display visualized stock data.

class StockController: UIViewController {
	
	@IBOutlet weak var graphViewOutlet: GraphView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.addSubview(graphViewOutlet)
		graphViewOutlet.setNeedsDisplay()
	}

}
