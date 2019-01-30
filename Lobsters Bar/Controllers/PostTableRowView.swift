//
//  PostTableRowView.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/29/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Cocoa

class PostTableRowView: NSTableRowView {
    
    @IBOutlet weak var lblPoint: NSTextField!
    @IBOutlet weak var lblComment: NSTextField!
    @IBOutlet weak var lblTitle: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = #colorLiteral(red: 0.8529883027, green: 0.2303652167, blue: 0.285782963, alpha: 0.9)
        
        lblPoint.textColor = NSColor.white
        lblComment.textColor = NSColor.white
        lblTitle.textColor = NSColor.white
    }
    
    func set(post: Post) {
        lblTitle.stringValue = post.title
        lblPoint.stringValue = "\(post.points)"
        lblComment.stringValue = "\(post.comments)"
    }
    
}
