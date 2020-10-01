//
//  String+Acronym.swift
//  Chat
//
//  Created by Anton Bebnev on 23.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

extension String {
    func getAcronyms() -> String {
        let wordsArray = self.components(separatedBy: " ")
        var acronyms = ""
        
        for word in wordsArray {
            if let char = word.first {
                acronyms = acronyms + String(char)
            }
        }
        
        return acronyms.uppercased()
    }
}
