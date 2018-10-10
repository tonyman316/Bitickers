//
//  MoreTableViewController.swift
//  BitTicker
//
//  Created by Tony Man on 7/30/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    
    var tableItems = ["Settings", "About", "Contact Us / Feedback"]
    var identities = ["settings", "about", "contact"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.black
//        navigationController?.navigationBar.barTintColor = UIColor.black
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tableView.delegate = self
        tableView.dataSource = self

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
        return tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath)

        let itemLabel = cell.viewWithTag(1000) as! UILabel

        switch indexPath.row {
        case 0:
            itemLabel.text = tableItems[indexPath.row]
        case 1:
            itemLabel.text = tableItems[indexPath.row]
        case 2:
            itemLabel.text = tableItems[indexPath.row]
        default:
            itemLabel.text = ""
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcName = identities[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    

}
