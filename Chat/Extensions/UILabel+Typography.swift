//
//  UILabel+Typography.swift
//  Chat
//
//  Created by Anton Bebnev on 21.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension UILabel {
    func setLineHeight(_ value: CGFloat) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.lineSpacing = value
        paragraphStyle.lineHeightMultiple = value

        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func setLetterSpacing(_ value: CGFloat) {
        guard let labelText = self.text else { return }
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(.kern, value: value, range: NSMakeRange(0, attributedString.length))
    }
}
