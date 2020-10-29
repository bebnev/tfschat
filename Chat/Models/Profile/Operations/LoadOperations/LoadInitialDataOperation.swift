//
//  LoadInitialDataOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class LoadInitialDataOperation: BaseProfileOperation {
    override func main() {
       profile.loadInitialData()
       
       finish()
    }
}
