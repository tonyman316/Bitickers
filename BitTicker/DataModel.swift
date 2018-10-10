//
//  DataModel.swift
//  BitTicker
//
//  Created by Tony Man on 8/1/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [CoinModel]()
    let coinName = ["btcusd", "bchusd", "ethusd", "etcusd", "ltcusd", "omgusd", "sanusd", "zecusd", "iotusd", "dshusd", "eosusd", "xrpusd", "xmrusd"]
    let coinChecked = [true,true,true,true,true,false,false,false,false,false,false,false,false]

    init() {
        loadlists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Coinlists.plist")
    }
    
    func savelists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Coinlists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
        //print("Data file path is \(dataFilePath())")
        print("Saving data...")
    }
    
    func loadlists() {
        let path = dataFilePath()
        //print("Data file path is \(dataFilePath())")
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Coinlists") as! [CoinModel]
            unarchiver.finishDecoding()
            print("Loading data...")
        }
    }
    
    func registerDefaults() {
        print("Reg defaults")
        let dictionary: [String: Any] = [ "CoinlistIndex": -1, "FirstTime": true]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {

        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        // Todo: use dictionary, index = .count
        if firstTime {
//            let coinName = ["btcusd", "bchusd", "ethusd", "etcusd", "ltcusd", "omgusd", "sanusd", "zecusd", "iotusd", "dshusd", "eosusd", "xrpusd", "xmrusd"]
//            let coinChecked = [true,true,true,true,true,false,false,false,false,false,false,false,false]
            
            print("handleFirstTime")
            
            for (name, check) in zip(coinName,coinChecked) {
                let coin = CoinModel(coinName: name, checked: check)
                lists.append(coin)
            }
            
            indexOfSelectedChecklist = coinName.count
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "CoinlistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CoinlistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    func reset(){
        lists.removeAll()
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(true, forKey: "FristTime")
//        userDefaults.synchronize()
//        let coinName = ["btcusd", "bchusd", "ethusd", "etcusd", "ltcusd", "omgusd", "sanusd", "zecusd", "iotusd", "dshusd", "eosusd", "xrpusd", "xmrusd"]
//        let coinChecked = [true,true,true,true,true,false,false,false,false,false,false,false,false]
        
        for (name, check) in zip(coinName,coinChecked) {
            let coin = CoinModel(coinName: name, checked: check)
            lists.append(coin)
        }
        indexOfSelectedChecklist = coinName.count

        print("Reset is called")

    }
    
    func countCheckmark() -> Int {
        var checkmarkCounter = 0
        for item in lists {
            if item.checked {
                checkmarkCounter += 1
            }
        }
        print("checkmark: \(checkmarkCounter)")
        return checkmarkCounter
    }

}

