//
//  CoinModel.swift
//  BitTicker
//
//  Created by Tony Man on 8/1/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import Foundation

class CoinModel: NSObject, NSCoding, NSCopying {
    var coinName = ""
    var checked = false
    
    init(coinName: String, checked: Bool) {
        self.coinName = coinName
        self.checked = checked
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        coinName = aDecoder.decodeObject(forKey: "CoinName") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = CoinModel(coinName: coinName, checked: checked)
        return copy
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(coinName, forKey: "CoinName")
        aCoder.encode(checked, forKey: "Checked")
    }
}
