//
//  PopoverContentView.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/31/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Cocoa

class PopoverContentView:NSView {
    var backgroundView:PopoverBackgroundView?
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if let frameView = self.window?.contentView?.superview {
            if backgroundView == nil {
                backgroundView = PopoverBackgroundView(frame: frameView.bounds)
                backgroundView!.autoresizingMask = [.width, .height]
                frameView.addSubview(backgroundView!, positioned: NSWindow.OrderingMode.below, relativeTo: frameView)
            }
        }
    }
}



class PopoverBackgroundView:NSView {
    override func draw(_ dirtyRect: NSRect) {
        #colorLiteral(red: 0.9294117647, green: 0.9254901961, blue: 0.9294117647, alpha: 1).set()
        dirtyRect.fill()
    }
}
