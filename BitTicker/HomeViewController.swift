//
//  HomeViewController.swift
//  BitTicker
//
//  Created by Tony Man on 7/26/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HomeViewController: UIViewController{
    
    fileprivate var tickerInfo: [String: Any]?
    fileprivate var midPrice: Double?
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func coinsSegment(_ sender: UISegmentedControl) {
        
    }
    @IBAction func refresh(_ sender: UIButton) {
        refreshPrice()
    }

    override func viewDidLoad() {
        refreshPrice()
    }
    
    func refreshPrice(){
        self.downloadBTCPrice { (tickerInfo) in
            self.tickerInfo = tickerInfo
            print(self.tickerInfo!)
            
            if let mPrice = (tickerInfo["mid"] as? NSString)?.doubleValue {
                self.midPrice = mPrice
                print("midPrice: \(self.midPrice!)")
                self.priceLabel.text = "$\(self.midPrice!)"
            }else{
                print("mPrice is nil")
            }
        }
    }
    
    
    func downloadBTCPrice(completion: @escaping ([String: Any]) -> Void){
        Alamofire.request(
            "https://api.bitfinex.com/v1/pubticker/btcusd"
            // "https://api.bitfinex.com/v1/pubticker/ethusd"

            )
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion([String: Any]())
                    return
                }
                guard let responseJSON = response.result.value as? [String: Any] else {
                    print("Invalid tag information received from the service")
                    completion([String: Any]())
                    return
                }
                

                //print(responseJSON)
                completion(responseJSON)
        }
    }
}
