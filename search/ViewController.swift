//
//  ViewController.swift
//  SearchApp
//  Created by Yasmin Abdi on 5/1/19.
//  Copyright © 2019 Yasmin Abdi. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data = ["Bitcoin", "Bitcoin Cash", "Ethereum", "Ethereum Classic", "Litecoin", "0x"]
    
    var filteredData = [String]()
    
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredData.count
        }

        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DataCell {
        
            let text: String!
            
            if inSearchMode {
                
                text = filteredData[indexPath.row]
                
            } else {
                
                text = data[indexPath.row]
            }
            
            cell.congigureCell(text: text)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            
            view.endEditing(true)
            
            tableView.reloadData()
            
        } else {
            
            inSearchMode = true
            
            filteredData = data.filter({$0 == searchBar.text})
            
            tableView.reloadData()
        }
    }
}

