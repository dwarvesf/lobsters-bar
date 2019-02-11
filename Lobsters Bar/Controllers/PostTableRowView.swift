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
        
//        self.wantsLayer = true
//        self.layer?.backgroundColor = #colorLiteral(red: 0.8529883027, green: 0.2303652167, blue: 0.285782963, alpha: 0.9)
        
        lblPoint.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        lblComment.textColor = #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1)
        lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
    }
    
    func set(post: Post) {
        lblTitle.stringValue = post.title
        lblPoint.stringValue = "\(post.points)"
        lblComment.stringValue = "\(post.comments)"
    }
    
}
