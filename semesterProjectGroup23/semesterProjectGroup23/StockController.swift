//
//  GraphController.swift
//  semesterProjectGroup23
//
//  Created by Oliver Bentham on 4/24/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import UIKit
import CorePlot

// When the user clicks on a stock, either in the TableView in the ViewController,
// or in the TableView in the SearchController, the app will take them to that stock's
// StockController. The Stock Controller displays info about the stock and launches a
// GraphView to display visualized stock data.

class StockController: UIViewController {
	
	let sampleData: [Float] = [18.35, 16.33, 16.01, 12.55, 21.98, 28.61, 23.03, 21.52, 22.38, 17.92, 21.25, 13.95, 11.5, 28.87, 21.89, 12.87, 27.1, 28.65, 21.8, 22.26, 14.83, 26.05, 20.83, 21.19, 20.11, 29.12, 24.85, 23.37, 20.13, 16.29, 20.63, 16.98, 12.4, 13.58, 10.29, 10.27, 15.61, 19.99, 14.43, 13.67, 19.87, 23.68, 24.47, 22.25, 19.11, 18.95, 13.35, 26.24, 27.18, 18.28]
	
	@IBOutlet weak var graphViewOutlet: GraphView!
	
	@IBOutlet weak var dayOutlet: UIButton!
	@IBOutlet weak var weekOutlet: UIButton!
	@IBOutlet weak var monthOutlet: UIButton!
	@IBOutlet weak var yearOutlet: UIButton!
	
	@IBAction func dayAction(_ sender: UIButton) {
		graphViewOutlet.updateData(data: sampleData, viewMode: .day)
		graphViewOutlet.setNeedsDisplay()
		
		dayOutlet.backgroundColor = .white
		dayOutlet.setTitleColor(.black, for: .normal)
		weekOutlet.backgroundColor = .black
		weekOutlet.setTitleColor(.white, for: .normal)
		monthOutlet.backgroundColor = .black
		monthOutlet.setTitleColor(.white, for: .normal)
		yearOutlet.backgroundColor = .black
		yearOutlet.setTitleColor(.white, for: .normal)
	}
	@IBAction func weekAction(_ sender: UIButton) {
		graphViewOutlet.updateData(data: sampleData, viewMode: .week)
		graphViewOutlet.setNeedsDisplay()
		
		dayOutlet.backgroundColor = .black
		dayOutlet.setTitleColor(.white, for: .normal)
		weekOutlet.backgroundColor = .white
		weekOutlet.setTitleColor(.black, for: .normal)
		monthOutlet.backgroundColor = .black
		monthOutlet.setTitleColor(.white, for: .normal)
		yearOutlet.backgroundColor = .black
		yearOutlet.setTitleColor(.white, for: .normal)
	}
	@IBAction func monthAction(_ sender: UIButton) {
		graphViewOutlet.updateData(data: sampleData, viewMode: .month)
		graphViewOutlet.setNeedsDisplay()
		
		dayOutlet.backgroundColor = .black
		dayOutlet.setTitleColor(.white, for: .normal)
		weekOutlet.backgroundColor = .black
		weekOutlet.setTitleColor(.white, for: .normal)
		monthOutlet.backgroundColor = .white
		monthOutlet.setTitleColor(.black, for: .normal)
		yearOutlet.backgroundColor = .black
		yearOutlet.setTitleColor(.white, for: .normal)
	}
	@IBAction func yearAction(_ sender: UIButton) {
		graphViewOutlet.updateData(data: sampleData, viewMode: .year)
		graphViewOutlet.setNeedsDisplay()
		
		dayOutlet.backgroundColor = .black
		dayOutlet.setTitleColor(.white, for: .normal)
		weekOutlet.backgroundColor = .black
		weekOutlet.setTitleColor(.white, for: .normal)
		monthOutlet.backgroundColor = .black
		monthOutlet.setTitleColor(.white, for: .normal)
		yearOutlet.backgroundColor = .white
		yearOutlet.setTitleColor(.black, for: .normal)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dayOutlet.layer.cornerRadius = 15
		weekOutlet.layer.cornerRadius = 15
		monthOutlet.layer.cornerRadius = 15
		yearOutlet.layer.cornerRadius = 15

		self.view.addSubview(graphViewOutlet)
		
		// default mode is year
		monthAction(yearOutlet)
	}

}

enum viewMode: String {
	case day
	case week
	case month
	case year
}
