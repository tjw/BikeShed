//
//  AppDelegate.swift
//  Klondike
//
//  Created by Timothy J. Wood on 10/6/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let deck = Deck().shuffled
        print("deck = \(deck)")
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

