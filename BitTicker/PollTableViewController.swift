//
//  PollTableViewController.swift
//  BitTicker
//
//  Created by Tony Man on 8/23/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import UIKit

class PollTableViewController: UITableViewController {
    
    var cloudModel = CloudModel.sharedInstance
    var detailViewController: PollDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.black

        cloudModel.delegate = self
        cloudModel.refresh()
        
        // Set up a refresh control.
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(cloudModel, action: #selector(cloudModel.refresh), for: .valueChanged)
        refreshControl?.tintColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cloudModel.refresh()
        //printItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cloudModel.items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath)

        var items = cloudModel.items
        let itemLabel = cell.viewWithTag(3000) as! UILabel
        
        if !items.isEmpty {
            itemLabel.text = items[indexPath.row].title
        }else{
            itemLabel.text = "Empty"
        }

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPollDetail" {
            let selectedRows = tableView.indexPathsForSelectedRows!
            let selectedIndexPath = selectedRows.last!
            let detailedVC = segue.destination as! PollDetailViewController
            detailedVC.detailItem = cloudModel.items[selectedIndexPath.row]
        }
    }
    
    func printItems(){
        for item in cloudModel.items {
            print("item: \(item.title), \(item.option1), \(item.option2)")
        }
    }
    
}

// MARK: - ModelDelegate
extension PollTableViewController: ModelDelegate {
    
    func modelUpdated() {
        refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    func errorUpdating(_ error: NSError) {
        let message: String
        if error.code == 1 {
            message = "Log into iCloud on your device and make sure the iCloud drive is turned on for this app."
        } else {
            message = error.localizedDescription
        }
        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

