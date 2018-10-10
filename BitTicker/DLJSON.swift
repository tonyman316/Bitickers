//
//  DLv2.swift
//  BitTicker
//
//  Created by Tony Man on 8/8/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import Foundation
import Alamofire

class DLJSON {
    
    let keys = ["BID", "BID_SIZE", "ASK", "ASK_SIZE", "DAILY_CHANGE","DAILY_CHANGE_PERC", "LAST_PRICE", "VOLUME", "HIGH", "LOW"]

    func downloadPriceV2(coinType: String, completion: @escaping ([Any]) -> Void){
        
        Alamofire.request(
            "https://api.bitfinex.com/v2/ticker/\(convertCoinTypeV2(coinType: coinType))"
            
            )
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion([Any]())
                    return
                }
                guard let responseJSON = response.result.value as? [Any] else {
                    print("Invalid tag information received from the service")
                    completion([Any]())
                    return
                }
                
                //print(responseJSON)
                completion(responseJSON)
        }
    }
    
    func convertCoinTypeV2(coinType: String) -> String{
        //print(coinType)
        //print("t\(coinType.uppercased())")
        return "t\(coinType.uppercased())"
    }

    func downloadPriceV1(coinType: String, completion: @escaping ([String: Any]) -> Void){
        
        Alamofire.request(
            "https://api.bitfinex.com/v1/pubticker/\(coinType)"
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
    
    func downloadCandles(coinType: String, completion: @escaping ([Any]) -> Void){
        
        Alamofire.request(
            //"https://api.bitfinex.com/v2/candles/trade:1D:tBTCUSD/last"
            "https://api.bitfinex.com/v2/candles/trade:1M:tBTCUSD/hist"
            
            )
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion([Any]())
                    return
                }
                guard let responseJSON = response.result.value as? [Any] else {
                    print("Invalid tag information received from the service")
                    completion([Any]())
                    return
                }
                
                //print(responseJSON)
                completion(responseJSON)
        }
    }

}
