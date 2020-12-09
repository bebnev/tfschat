//
//  MockDispatchQueue.swift
//  TFSChatTests
//
//  Created by Anton Bebnev on 09.12.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

@testable import TFSChat
import Foundation

final class MockDispatchQueue: IDispatchQueue {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
