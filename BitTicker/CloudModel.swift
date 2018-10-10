//
//  ModelCloud.swift
//  BitTicker
//
//  Created by Tony Man on 8/22/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

// Specify the protocol to be used by view controllers to handle notifications.
protocol ModelDelegate {
    func errorUpdating(_ error: NSError)
    func modelUpdated()
}

class CloudModel {
    
    // MARK: - Properties
    static let sharedInstance = CloudModel()
    var delegate: ModelDelegate?
    var items: [Poll] = []
    //let userInfo: UserInfo
    
    // Define databases.
    
    // Represents the default container specified in the iCloud section of the Capabilities tab for the project.
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
        //userInfo = UserInfo(container: container)
    }
    
    @objc func refresh() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Poll", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { [unowned self] results, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error! as NSError)
                    print("Cloud Query Error - Refresh: \(error!)")
                }
                return
            }
            
            self.items.removeAll(keepingCapacity: true)
            
            for record in results! {
                let poll = Poll(record: record, database: self.publicDB)
                self.items.append(poll)
            }
            
            DispatchQueue.main.async {
                self.delegate?.modelUpdated()
            }
        }
    }
    
    func poll(_ ref: CKReference) -> Poll! {
        let matching = items.filter { $0.record.recordID == ref.recordID }
        return matching.first
    }
}
