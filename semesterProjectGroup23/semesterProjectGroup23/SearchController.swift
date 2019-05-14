
import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    

    
    @IBOutlet weak var tableView: UITableView!
    
    var cbClient: CoinbaseClient
    var productArray: [Product]
    var selectedID: String
    
    required init?(coder aDecoder: NSCoder) {
        self.cbClient = CoinbaseClient()
        self.productArray = []
        self.selectedID = ""
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 50.0
        
        
        //searchBar.delegate = self
        
        //searchBar.returnKeyType = UIReturnKeyType.done
        print("HI")
        cbClient.getProducts() { (list) in
            self.productArray = list
            print("GOT LIST")
            print(list)
            self.productArray.sort(by: { $0.id < $1.id })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SearchTableCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableCell  else {
            fatalError("The dequeued cell is not an instance of SearchTableCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let product = productArray[indexPath.row]
        
        cell.nameLabel.text = product.display_name
        cell.idLabel.text = product.id
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedID = productArray[indexPath.row].id
        self.performSegue(withIdentifier: "TableIDToStatsVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableIDToStatsVC" {
            let statsVC = segue.destination as! StatsController
            statsVC.selectedID = selectedID
        }
    }
    
}

