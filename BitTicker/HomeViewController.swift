//
//  HomeViewController.swift
//  BitTicker
//
//  Created by Tony Man on 7/26/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//
// ToDo:

import Foundation
import UIKit
import Alamofire

class HomeViewController: UIViewController{
    var coinlistChecked = [CoinModel]()
    var tickerInfoDict = [String : [String:Any]?]()
    var dataModel = (UIApplication.shared.delegate as! AppDelegate).dataModel
    var tickerInfoV2 = [Any]()
    var tickerInfoDictV2 = [String : [String:Any]?]()
    var dljson = DLJSON()
    var requestIsFinished = Bool()
    
    //fileprivate var tickerInfo: [String: Any]?
    fileprivate var midPrice: Double?
    fileprivate var highPrice: Double?
    fileprivate var lowPrice: Double?
    fileprivate var volume: Double?
    fileprivate var percentChanged: Double?

    var count: Int = 0
    var counting: Bool = false
    var timer: Timer = Timer()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var highLowLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        //let cname = coinlistChecked[segmentedControl.selectedSegmentIndex].coinName
        let index = segmentedControl.selectedSegmentIndex
        let segTitle = segmentedControl.titleForSegment(at: index)

        switch index {
        case 0:
            setLabels(coinName: segTitle!.lowercased())
            print(segTitle!)
        case 1:
            setLabels(coinName: segTitle!.lowercased())
            print(segTitle!)
        case 2:
            setLabels(coinName: segTitle!.lowercased())
            print(segTitle!)
        case 3:
            setLabels(coinName: segTitle!.lowercased())
            print(segTitle!)
        case 4:
            setLabels(coinName: segTitle!.lowercased())
            print(segTitle!)

        default:
            print("None")
        }
    }

    @IBAction func refresh(_ sender: UIButton) {
        refreshAllPrice()
        let currentName = coinlistChecked[segmentedControl.selectedSegmentIndex].coinName
        if  currentName == "" {
            print("Empty coin name")
        }else{
            refreshOnePrice(coinType: currentName) // for initail pull
        }
    }

    // Mark: View func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if(dataModel.countCheckmark() == 5) {
            print("Checked item: \(dataModel.countCheckmark())")
            refreshEverything()
            print("refreshed Everything!!!")
        }else{
            print("0 Checked item: \(dataModel.countCheckmark())")
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let currentName = coinlistChecked[segmentedControl.selectedSegmentIndex].coinName
        if  currentName == "" {
            print("Empty coin name")
        }else{
            refreshOnePrice(coinType: currentName) // for initail pull
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test stuff
        //testNewStuff()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataModel.savelists()
    }
    
    // Mark: Data Manager
    
/*
    func setDefaultData() {
        dataModel.lists.removeAll()
        let coinName = dataModel.coinName
        let coinChecked = dataModel.coinChecked
        
        for (name, check) in zip(coinName,coinChecked) {
            let coin = CoinModel(coinName: name, checked: check)
            dataModel.lists.append(coin)
        }
        dataModel.savelists()
    }
*/
    
    func refreshEverything(){
        //isRefreshing = true
        refreshButton.isEnabled = false
        populateSettingData()
        setSegmentControlTitle()
        refreshAllPrice()
    }
    
    // 1
    func populateSettingData() -> Void {
        coinlistChecked.removeAll()
//        for list in dataModel.lists{
//            print("HomeView dataModel: \(list.coinName)")
//            print("HomeView dataModel: \(list.checked)")
//        }
//        
//        let index = dataModel.indexOfSelectedChecklist
//        print("Home index: \(index)")
        
        if dataModel.countCheckmark() > 0 {
            for item in dataModel.lists {
                if item.checked && coinlistChecked.count <= 5{
                    coinlistChecked.append(item)
                }
            }
            
//            for list in coinlistChecked{
//                print("HomeView coinlistChecked: \(list.coinName)")
//                print("HomeView coinlistChecked: \(list.checked)")
//            }
            
        }else {
            //print("Checked item: \(dataModel.countCheckmark())")
        }
    }
    
    // 2
    func setSegmentControlTitle() -> Void {
        var fontSize = 0.0
        let modelName = UIDevice.current.modelName
        switch modelName {
        case "iPhone 4", "iPhone 4s":
            fontSize = 10.0
        case "iPhone 5", "iPhone 5s", "iPhone 5c", "iPhone SE":
            fontSize = 11.0
        default:
            fontSize = 13
        }
        
        let attr = NSDictionary(object: UIFont(name: "Helvetica", size: CGFloat(fontSize))!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        if (coinlistChecked.count > 0) {
            for item in self.coinlistChecked {
                self.segmentedControl.setTitle(item.coinName.uppercased(), forSegmentAt: self.coinlistChecked.index(of: item)!)
            }
        }else{
            setEmptySwgmentControlTitle()
        }
    }
    
    func setEmptySwgmentControlTitle() {
        for var index in 0..<5 {
            self.segmentedControl.setTitle("", forSegmentAt: index)
            index += 1
        }
    }
    
/*
    func cleanUpEverything() {
        setEmptySwgmentControlTitle()
        self.tickerInfoDict.removeAll()
        self.coinlistChecked.removeAll()
        self.dataModel.reset()
        
        self.midPrice = 00000.00
        self.highPrice = 00000.00
        self.lowPrice = 00000.00
        self.volume = 000000000
        activityIndicator.stopAnimating()
        refreshButton.isHidden = true
        stopCounting()
        
        print("Clean up is called")
    }
*/
    
    // 3 // Mark: API v1
    func populateJSON() -> Void {
        startPullingJSON()
        
        if coinlistChecked.count > 0 {
            for item in coinlistChecked {
                dljson.downloadPriceV1(coinType: item.coinName, completion: { (info) in
                    //print(item.coinName)
                    //print(info)
                    self.tickerInfoDict.updateValue(info, forKey: item.coinName)
                    self.finishPullingJSON()

                })
            }
        }else{
            print("coinlistChecked.count: \(coinlistChecked.count)")
        }
//        for item in tickerInfoDict {
//            print(item)
//        }
    }
    
    // Mark: API v2
    func populateJSONV2() -> Void {
        startPullingJSON()
        
        if coinlistChecked.count > 0 {
            for item in coinlistChecked {
                dljson.downloadPriceV2(coinType: item.coinName, completion: { (infos) in
                    if !infos.isEmpty {
                        var coinInfoDict = [String : Any]()
                        let keys = self.dljson.keys
                        
                        for (key,info) in zip(keys,infos) {
                            coinInfoDict[key] = info
                        }
                        //print(coinInfoDict)
                        
                        //print(item.coinName)
                        //self.tickerInfoDictV2[item.coinName] = coinInfoDict
                        self.tickerInfoDictV2.updateValue(coinInfoDict, forKey: item.coinName)
                        //print(self.tickerInfoDictV2)
                        
                        self.finishPullingJSON()
                    }
                    
                })
            }
        }
    }
    
    func setLabels(coinName: String) -> Void {
        if let info = tickerInfoDict[coinName]{
            //print("Info From SetLabel func: \(info!)")
            if let mPrice = (info?["mid"] as? NSString)?.doubleValue {
                self.midPrice = mPrice
                //print("midPrice: \(self.midPrice!)")
                self.priceLabel.text = self.midPrice!.dollarString
            }else{
                print("mPrice is nil")
            }
            
            if let vol = (info?["volume"] as? NSString)?.doubleValue {
                self.volume = vol
                self.volumeLabel.text = "24hr vol: \(self.volume!.toInt)"
            }else{
                print("volume is nil")
            }
            
            if let high = (info?["high"] as? NSString)?.doubleValue, let low = (info?["low"] as? NSString)?.doubleValue {
                self.highPrice = high
                self.lowPrice = low
                self.highLowLabel.text = "high: \(self.highPrice!.dollarString)      low: \(self.lowPrice!.dollarString)"
            }else{
                print("high/low is nil")
            }
        }
        if let info2 = tickerInfoDictV2[coinName]{
            if let percent = info2?["DAILY_CHANGE_PERC"] as? Double, let change = info2?["DAILY_CHANGE"] as? Double{
                if change < 0 {
                    self.percentLabel.textColor = UIColor.red
                    self.percentLabel.text = "\(change.twoDecimal)  (\(percent*100)%)"
                }else{
                    self.percentLabel.textColor = UIColor.green
                    self.percentLabel.text = "+\(change.twoDecimal)  (+\(percent*100)%)"
                }
            }
        }
    }
    
    func refreshAllPrice() -> Void {
        stopCounting()
        
        populateJSON()
        //test:
        populateJSONV2()

        startCounting()
    }
    
    func refreshOnePrice(coinType: String) -> Void {
        stopCounting()
        startPullingJSON()
        
        dljson.downloadPriceV2(coinType: coinType) { tickerInfo in
            //self.tickerInfo = tickerInfo
            print(tickerInfo)
            if !tickerInfo.isEmpty {
                if let mPrice = tickerInfo[6] as? Double {
                    self.midPrice = mPrice
                    //print("midPrice: \(self.midPrice!)")
                    self.priceLabel.text = self.midPrice!.dollarString
                }else{
                    print("mPrice is nil")
                }
                
                if let vol = tickerInfo[7] as? Double {
                    self.volume = vol
                    self.volumeLabel.text = "24hr vol: \(self.volume!.toInt)"
                }else{
                    print("volume is nil")
                }
                
                if let high = tickerInfo[8] as? Double, let low = tickerInfo[9] as? Double {
                    self.highPrice = high
                    self.lowPrice = low
                    self.highLowLabel.text = "high: \(self.highPrice!.dollarString)      low: \(self.lowPrice!.dollarString)"
                }else{
                    print("high/low is nil")
                }
                
                if let percent = tickerInfo[5] as? Double, let change = tickerInfo[4] as? Double{
                    if change < 0 {
                        self.percentLabel.textColor = UIColor.red
                        self.percentLabel.text = "\(change.twoDecimal)  (\(percent*100)%)"
                    }else{
                        self.percentLabel.textColor = UIColor.green
                        self.percentLabel.text = "+\(change.twoDecimal)  (+\(percent*100)%)"
                    }
                }
                
                self.finishPullingJSON()
                
            }else{
                print("ticker info is empty!")
            }
        }
        
        //showTime()
        startCounting()
        
    }
    
    // Mark: Timer, utities
    func showTime() -> Void {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        
        let timeString = "\(dateFormatter.string(from: Date() as Date))"
        
        timeStampLabel.text = "Updated at: " + String(timeString)
    }
    
    func startCounting() -> Void {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
    }
    
    func stopCounting() -> Void {
        self.timer.invalidate()
        self.count = 0
    }
    
    func counter() -> Void {
        self.count += 1
        timeStampLabel.text = "Updated \(count) seconds ago"
        if count >= 5 {
            refreshButton.isEnabled = true
        }
        if count >= 2 {
            segmentedControl.isEnabled = true
        }
    }
    
    func checkInternetConnection() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func startPullingJSON(){
        self.activityIndicator.startAnimating()
        refreshButton.isEnabled = false
        segmentedControl.isEnabled = false
    }
    
    func finishPullingJSON(){
        self.activityIndicator.stopAnimating()

    }
    
    // Mark: Test new stuff
    
    func testNewStuff() {
        dljson.downloadCandles(coinType: "tBTCUSD") { (info) in
            if !info.isEmpty {
                print(info)
            }
        }
    }

    
}
