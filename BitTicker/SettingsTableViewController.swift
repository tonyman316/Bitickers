//
//  SettingsTableViewController.swift
//  BitTicker
//
//  Created by Tony Man on 7/30/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//
//  Pass by value? 0 checkmark issue, switch tab issue, fix refresh empty coin issue

import UIKit

//protocol SettingsTableViewControllerDelegate: class {
//    func SettingsTableViewController(_ controller: SettingsTableViewController, didSave item: DataModel)
//
//}

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var dataModel = (UIApplication.shared.delegate as! AppDelegate).dataModel
    var coinlistCopy = [CoinModel]()
    var checkmarkCounter = 0
    //let vc = HomeViewController()
    
    //weak var delegate: SettingsTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        printlist(listsName: "dataModel", lists: dataModel.lists)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        self.tableView.backgroundColor = UIColor.black
        self.saveButton.isEnabled = false
        let index = dataModel.indexOfSelectedChecklist
        print("Setting index: \(index)")
        // make a coinlist copy
        makeCoinlistCopy()
        countCheckmark()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if checkmarkCounter == 5 {
            dataModel.lists = coinlistCopy
            dataModel.savelists()
        }else{
            dataModel.savelists()
        }
        
        printlist(listsName: "dataModel.list", lists: dataModel.lists)
        printlist(listsName: "coinlistCopy", lists: coinlistCopy)

    }
    
    func setAllUnchecked() {
        for item in dataModel.lists {
            if item.checked {
                item.toggleChecked()
            }
        }
    }
    
    func makeCoinlistCopy() {
        coinlistCopy.removeAll()
        for item in dataModel.lists {
            coinlistCopy.append(item.copy() as! CoinModel)
        }
    }

    
    func countCheckmark() {
        checkmarkCounter = 0
        for item in coinlistCopy {
            if item.checked {
                checkmarkCounter += 1
            }
        }
        print("coinlistCopy checkmark: \(checkmarkCounter)")
    }
    
    func printlist(listsName: String ,lists: [CoinModel]) -> Void {
        for list in lists{
            print("Setting \(listsName) coinName: \(list.coinName)")
            print("Setting \(listsName) checked: \(list.checked)")
        }
        print("lists.count: \(lists.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        dataModel.savelists()
        //printlist(listsName: "dataModel", lists: dataModel.lists)
        if checkmarkCounter == 5 {
            _ = navigationController?.popViewController(animated: true)
        }else{
            showAlert()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)

        let itemLabel = cell.viewWithTag(2000) as! UILabel
        //let checked = false
        itemLabel.text = coinlistCopy[indexPath.row].coinName.uppercased()
        
        if coinlistCopy[indexPath.row].checked {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            self.saveButton.isEnabled = true
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                //dataModel.lists[indexPath.row].checked = false
                coinlistCopy[indexPath.row].checked = false

                checkmarkCounter -= 1
                print("checkmark: \(checkmarkCounter)")

            } else {
                cell.accessoryType = .checkmark
                //dataModel.lists[indexPath.row].checked = true
                coinlistCopy[indexPath.row].checked = true
                checkmarkCounter += 1
                print("checkmark: \(checkmarkCounter)")

            }
        }
        
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Reminder", message: "Please choose 5 items", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissView () {
        _ = navigationController?.popViewController(animated: true)

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if let cell = tableView.cellForRow(at: indexPath) {
//            let item = coinlist[indexPath.row]
//            item.toggleChecked()
//            //configureCheckmark(for: cell, with: item)
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    func configureCheckmark(for cell: UITableViewCell, with item: CoinModel) {
//        let label = cell.viewWithTag(1001) as! UILabel
//        
//        if item.checked {
//            label.text = "√"
//        } else {
//            label.text = ""
//        }
//    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
