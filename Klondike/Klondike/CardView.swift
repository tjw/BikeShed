//
//  CardView.swift
//  Klondike
//
//  Created by Timothy J. Wood on 10/6/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

import Cocoa

class CardView: NSView {

    let textField:NSTextField
    
    override init(frame frameRect: NSRect) {
        textField = NSTextField()
        super.init(frame:frameRect)
    }
    required init?(coder: NSCoder) {
        textField = NSTextField()
        super.init(coder:coder)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
