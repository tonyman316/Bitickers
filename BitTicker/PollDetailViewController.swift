//
//  PollDetailViewController.swift
//  BitTicker
//
//  Created by Tony Man on 8/23/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import UIKit

class PollDetailViewController: UIViewController {

    // MARK: - Properties
    var detailItem: Poll!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option1CountLabel: UILabel!
    @IBOutlet weak var option2CountLabel: UILabel!
    
    override func viewDidLoad(){
    
        super.viewDidLoad()
        setUpLabels()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func option1Click(_ sender: UIButton) {
        
    }
    
    @IBAction func option2Click(_ sender: UIButton) {
        
    }
    
    func setUpLabels() {
        if detailItem?.title != nil {
            titleLabel.text = detailItem?.title
            option1Button.setTitle(detailItem?.option1, for: .normal)
            option2Button.setTitle(detailItem?.option2, for: .normal)
            option1CountLabel.text = detailItem?.option1Count.description
            option2CountLabel.text = detailItem?.option2Count.description

            
        }else {
            titleLabel.text = "Empty detailItem"
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
