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
    var timer: Timer
    var productArray: [Product]
    var curProductIndex: Int
	
	var historicData: [Float]
	let calendar = Calendar.current
	let dateFormatter = DateFormatter()
    
    let sampleData: [Float] = [18.35, 16.33, 16.01, 12.55, 21.98, 28.61, 23.03, 21.52, 22.38, 17.92, 21.25, 13.95, 11.5, 28.87, 21.89, 12.87, 27.1, 28.65, 21.8, 22.26, 14.83, 26.05, 20.83, 21.19, 20.11, 29.12, 24.85, 23.37, 20.13, 16.29, 20.63, 16.98, 12.4, 13.58, 10.29, 10.27, 15.61, 19.99, 14.43, 13.67, 19.87, 23.68, 24.47, 22.25, 19.11, 18.95, 13.35, 26.24, 27.18, 18.28]
    
    
    
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var curPriceLabel: UILabel!
    @IBOutlet weak var dayOutlet: UIButton!
    @IBOutlet weak var weekOutlet: UIButton!
    @IBOutlet weak var monthOutlet: UIButton!
    @IBOutlet weak var yearOutlet: UIButton!
    
    @IBOutlet weak var graphViewOutlet: GraphView!
    
    required init?(coder aDecoder: NSCoder) {
        self.cbClient = CoinbaseClient()
        self.productArray = []
        self.curProductIndex = 0
        self.timer = Timer()
		self.historicData = []
        
        super.init(coder: aDecoder)
    }

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dateFormatter.dateFormat = "yyyy-MM-dd't'hh:mm:ss"
		
        cbClient.getProducts() { (list) in
            self.productArray = list
            self.productArray.sort(by: { $0.id < $1.id })
            
            self.refreshData()
			
			self.view.addSubview(self.graphViewOutlet)
			self.yearAction(self.yearOutlet)
        }
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveToNextItem(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveToNextItem(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
        dayOutlet.layer.cornerRadius = 15
        weekOutlet.layer.cornerRadius = 15
        monthOutlet.layer.cornerRadius = 15
        yearOutlet.layer.cornerRadius = 15
        
        /*
        cbClient.getHistoricRates(id: "BTC-USD", interval: "60") { (list) in
            print(list)
        }*/
        
        cbClient.get24hrStats(id: "BTC-USD") { (list) in
            print(list)
            
        }
        
        
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        cbClient.disconnectFromStream()
        print("disconnecting")
        
    }
    
    @objc func moveToNextItem(_ sender:UISwipeGestureRecognizer) {
        
        switch sender.direction{
        case .right:
            print("RIGHT")
            if curProductIndex > 0 {
                curProductIndex -= 1
                refreshData()
            }
        case .left:
            print("LEFT")
            if curProductIndex < productArray.count - 1 {
                curProductIndex += 1
                refreshData()
            }
        default:
            print("not left or right")
        }
        
    }
    
    
    @objc func refreshData () {
        if (cbClient.coinID != productArray[curProductIndex].id) {
            cbClient.disconnectFromStream()
            cbClient.connectToStream(coinID: productArray[curProductIndex].id)
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(self.refreshData), userInfo: nil, repeats: true)
            
            cbClient.get24hrStats(id: productArray[curProductIndex].id) { (list) in
                print(list)
                var openString = list["open"]!
                var lastString = list["last"]!
                
                openString.remove(at: openString.startIndex)
                lastString.remove(at: lastString.startIndex)
                
                let openDouble = Double(openString)!
                let lastDouble = Double(lastString)!
                
                let difference = lastDouble - openDouble
                let growthPercent = difference / openDouble * 100
                
                
                
                
                var changeLabelString = ""
                let upOrDown = difference >= 0 ? "up ": "down "
                let differenceFormated = String(format: "$%.02f", difference)
                let growthFormated = String(format: "%.02f", growthPercent)
                
                changeLabelString = upOrDown + differenceFormated + " " + growthFormated + "%"
              
                DispatchQueue.main.async {
                    if difference >= 0 {
                       self.changeLabel.textColor = UIColor.green
                    } else {
                        self.changeLabel.textColor = UIColor.red
                    }
                    
                    
                    
                    self.changeLabel.text = changeLabelString
                    
                    
                }
                
            }
        }
        
        
        
        DispatchQueue.main.async {
            self.coinNameLabel.text = self.productArray[self.curProductIndex].base_currency
            
            self.curPriceLabel.text = self.cbClient.getCurrentPrice()
            
        }
    }
    
	//GRAPHING
	
	@IBAction func dayAction(_ sender: Any) {
		historicData = []
		let currDate = Date()
		let startDate = dateFormatter.string(from: calendar.date(byAdding: .day, value: -1, to: currDate)!)
		
		print("self.curProductIndex")
		print(self.curProductIndex)
		print("self.productArray")
		print(self.productArray)
		print("self.productArray[self.curProductIndex].id")
		print(self.productArray[self.curProductIndex].id)
		
		cbClient.getHistoricRates(id: self.productArray[self.curProductIndex].id, startDate: startDate, interval: "900") { (list) in
			for time in list {
				self.historicData.append(Float(time.low))
			}
			self.graphViewOutlet.updateData(data: self.historicData, viewMode: .day)
			self.graphViewOutlet.setNeedsDisplay()
		}
		
		dayOutlet.backgroundColor = .white
		dayOutlet.setTitleColor(.black, for: .normal)
		weekOutlet.backgroundColor = .black
		weekOutlet.setTitleColor(.white, for: .normal)
		monthOutlet.backgroundColor = .black
		monthOutlet.setTitleColor(.white, for: .normal)
		yearOutlet.backgroundColor = .black
		yearOutlet.setTitleColor(.white, for: .normal)
	}
	
	@IBAction func weekAction(_ sender: Any) {
		historicData = []
		let currDate = Date()
		let startDate = dateFormatter.string(from: calendar.date(byAdding: .day, value: -7, to: currDate)!)
		
		print("self.curProductIndex")
		print(self.curProductIndex)
		print("self.productArray")
		print(self.productArray)
		print("self.productArray[self.curProductIndex].id")
		print(self.productArray[self.curProductIndex].id)
		
		cbClient.getHistoricRates(id: self.productArray[self.curProductIndex].id, startDate: startDate, interval: "21600") { (list) in
			for time in list {
				self.historicData.append(Float(time.low))
			}
			self.graphViewOutlet.updateData(data: self.historicData, viewMode: .week)
			self.graphViewOutlet.setNeedsDisplay()
		}
		
		dayOutlet.backgroundColor = .black
		dayOutlet.setTitleColor(.white, for: .normal)
		weekOutlet.backgroundColor = .white
		weekOutlet.setTitleColor(.black, for: .normal)
		monthOutlet.backgroundColor = .black
		monthOutlet.setTitleColor(.white, for: .normal)
		yearOutlet.backgroundColor = .black
		yearOutlet.setTitleColor(.white, for: .normal)
	}
	
	@IBAction func monthAction(_ sender: Any) {
		historicData = []
		let currDate = Date()
		let startDate = dateFormatter.string(from: calendar.date(byAdding: .month, value: -1, to: currDate)!)
		
		print("self.curProductIndex")
		print(self.curProductIndex)
		print("self.productArray")
		print(self.productArray)
		print("self.productArray[self.curProductIndex].id")
		print(self.productArray[self.curProductIndex].id)
		
		cbClient.getHistoricRates(id: self.productArray[self.curProductIndex].id, startDate: startDate, interval: "86400") { (list) in
			print(list)
			for time in list {
				self.historicData.append(Float(time.low))
			}
			self.graphViewOutlet.updateData(data: self.historicData, viewMode: .month)
			self.graphViewOutlet.setNeedsDisplay()
		}
		
		dayOutlet.backgroundColor = .black
		dayOutlet.setTitleColor(.white, for: .normal)
		weekOutlet.backgroundColor = .black
		weekOutlet.setTitleColor(.white, for: .normal)
		monthOutlet.backgroundColor = .white
		monthOutlet.setTitleColor(.black, for: .normal)
		yearOutlet.backgroundColor = .black
		yearOutlet.setTitleColor(.white, for: .normal)
	}
	
	@IBAction func yearAction(_ sender: Any) {
		historicData = []
		let currDate = Date()
		let startDate = dateFormatter.string(from: calendar.date(byAdding: .year, value: -1, to: currDate)!)
		
		print("this is the start date: " + startDate)
		
		print("self.curProductIndex")
		print(self.curProductIndex)
		print("self.productArray")
		print(self.productArray)
		print("self.productArray[self.curProductIndex].id")
		print(self.productArray[self.curProductIndex].id)
		
		cbClient.getHistoricRates(id: self.productArray[self.curProductIndex].id, startDate: startDate, interval: "86400") { (list) in
			for time in list {
				self.historicData.append(Float(time.low))
			}
			self.graphViewOutlet.updateData(data: self.historicData, viewMode: .year)
			self.graphViewOutlet.setNeedsDisplay()
		}
		
		dayOutlet.backgroundColor = .black
		dayOutlet.setTitleColor(.white, for: .normal)
		weekOutlet.backgroundColor = .black
		weekOutlet.setTitleColor(.white, for: .normal)
		monthOutlet.backgroundColor = .black
		monthOutlet.setTitleColor(.white, for: .normal)
		yearOutlet.backgroundColor = .white
		yearOutlet.setTitleColor(.black, for: .normal)
	}
	
}

enum viewMode: String {
	case day
	case week
	case month
	case year
}
