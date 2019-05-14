//
//  StatsController.swift
//  semesterProjectGroup23
//
//  Created by Terry Kim on 5/14/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import UIKit

class StatsController: UIViewController {
    var selectedID:String
    var cbClient: CoinbaseClient
    var stats: [String:String]
    var timer: Timer
    
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var vol30Label: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        self.cbClient = CoinbaseClient()
        self.selectedID = ""
        self.stats = [:]
        self.timer = Timer()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cbClient.connectToStream(coinID: selectedID)
        
        cbClient.get24hrStats(id: selectedID) { (list) in
            self.stats = list
            
            
            DispatchQueue.main.async {
                self.lowLabel.text = self.stats["low"]
                self.highLabel.text = self.stats["high"]
                self.openLabel.text = self.stats["open"]
                self.closeLabel.text = self.stats["last"]
                self.volumeLabel.text = self.stats["volume"]
                self.vol30Label.text = self.stats["volume_30day"]
                
                self.idLabel.text = self.selectedID
                
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(self.refreshData), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        cbClient.disconnectFromStream()
        print("disconnecting")
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        //TableIDToStatsVC
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func refreshData () {

        DispatchQueue.main.async {
            self.priceLabel.text = self.cbClient.getCurrentPrice()
            
        }
    }
    
}

