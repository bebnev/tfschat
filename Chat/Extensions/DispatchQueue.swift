//
//  DispatchQueue.swift
//  Chat
//
//  Created by Anton Bebnev on 09.12.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IDispatchQueue {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: IDispatchQueue {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .default, flags: [], execute: work)
    }
}
