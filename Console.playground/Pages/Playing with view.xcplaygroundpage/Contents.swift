import Foundation
import PlaygroundSupport
import UIKit

class MasterViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

let master = MasterViewController()

PlaygroundPage.current.liveView = master
