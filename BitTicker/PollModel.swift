//
//  Poll.swift
//  BitTicker
//
//  Created by Tony Man on 8/22/17.
//  Copyright © 2017 Tony Man. All rights reserved.
//

import Foundation
import CloudKit

class Poll: NSObject {
    
    var record: CKRecord!
    weak var database: CKDatabase!
    var title = String()
    var option1 = String()
    var option2 = String()
    var option1Count = Int()
    var option2Count = Int()
    
    init(record: CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        
        self.title = record["Title"] as! String
        //some more
        self.option1 = record["Option1"] as! String
        self.option2 = record["Option2"] as! String
        self.option1Count = record["Option1Count"] as! Int
        self.option2Count = record["Option2Count"] as! Int

    }
    
    
}
