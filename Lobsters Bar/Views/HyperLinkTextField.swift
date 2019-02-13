//
//  HyperLinkTextfield.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 2/13/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
class HyperlinkTextField: NSTextField {
    
    @IBInspectable var href: String = ""
    
    override func resetCursorRects() {
        discardCursorRects()
        addCursorRect(self.bounds, cursor: NSCursor.pointingHand)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TODO:  Fix this and get the hover click to work.
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        if let localHref = URL(string: href) {
            NSWorkspace.shared.open(localHref)
        }
    }
}

