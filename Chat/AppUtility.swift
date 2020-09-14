//
//  AppUtility.swift
//  Chat
//
//  Created by Anton Bebnev on 15.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

func log(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    let fileURL = NSURL(string: file)?.lastPathComponent ?? ""
    print("\(fileURL) > \(function)[\(line)]: \(message)\n")
}
