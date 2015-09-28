//
//  AppDelegate.swift
//  LangValue
//
//  Created by Timothy J. Wood on 9/24/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        var val = LangValue.Table(value:[:])
        
        do {
            try val.setObject(LangValue.IntValue(value: 1), forKey:"foo")
        
            let foo = try val.objectForKey("foo")
            print("\(foo)")
        } catch let err {
            print("error:", err)
        }
        
        let s = LangValue.StringValue(value:"This is a string")
        let n = LangValue.IntValue(value:42)
        let someValues = [s,n]
        
        assert(try! addIntegerValues(someValues).integerValue() == 42)
        assert(try! addStringValues(someValues).stringValue() == "This is a string42")
        
        let unknownResult = try! s + n
        assert(try! unknownResult.stringValue() == "This is a string42")
        
        //
        do {
            var t = LangValue([:])
            try t.setObject(LangValue(10), forKey:"SomeInt")
            let someString = LangValue("Some string")
            try t.setObject(someString, forKey:"SomeString")
            
            var subtable = LangValue([:])
            try subtable.setObject(LangValue(50), forKey:"SubtableInt")
            let anotherString = LangValue("Another string")
            try subtable.setObject(anotherString, forKey:"SubtableString")
            try t.setObject(subtable, forKey:"Subtable")
            
            let setOfStrings = recursiveSetOfStringsInTable(t)
            assert(setOfStrings == Set([someString, anotherString]))
        } catch let err {
            print("error:", err)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

