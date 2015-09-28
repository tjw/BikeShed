//
//  LangValue.swift
//  LangValue
//
//  Created by Timothy J. Wood on 9/24/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

import Foundation

/// One of the language values
enum LangValue {
    enum Error : ErrorType {
        case BadCoercion
    }
    
    /// Construct a LangValue from an Int
    case IntValue(value:Int)
    init(_ v:Int) {
        self = LangValue.IntValue(value:v)
    }

    func integerValue() throws -> Int {
        switch self {
        case .IntValue(let value):
            return value
        case .StringValue(let value):
            return (value as NSString).integerValue
        default:
            throw Error.BadCoercion
        }
    }
    

    case StringValue(value:String)
    init(_ v:String) {
        self = LangValue.StringValue(value:v)
    }

    func stringValue() throws -> String {
        switch self {
        case .IntValue(let value):
            return "\(value)"
        case .StringValue(let value):
            return value
        default:
            throw Error.BadCoercion
        }
    }

    // subscript can't be marked mutating or throws, it seems
    case Table(value:[String:LangValue])
    init(_ v:[String:LangValue]) {
        self = LangValue.Table(value:v)
    }

    func keys() throws -> [String] {
        guard case .Table(let table) = self else {
            throw Error.BadCoercion
        }
        return table.keys.map { $0 } // Other way to flatten the lazy bits to array?
    }
    
    func objectForKey(key:String) throws -> LangValue? {
        guard case .Table(let table) = self else {
            throw Error.BadCoercion
        }
        return table[key]
    }
    
    mutating func setObject(object:LangValue?, forKey key:String) throws {
        guard case .Table(let table) = self else {
            throw Error.BadCoercion
        }
        var updated = table
        updated[key] = object
        self = LangValue(updated)
    }
    
    mutating func removeObjectForKey(key: String) throws {
        try setObject(nil, forKey:key)
    }
}

func +(lhs:LangValue, rhs:LangValue) throws -> LangValue {
    switch (lhs, rhs) {

    // Same type
    case (.IntValue(let leftValue), .IntValue(let rightValue)):
        return LangValue(leftValue + rightValue)
    case (.StringValue(let leftValue), .StringValue(let rightValue)):
        return LangValue(leftValue + rightValue)

    // Different types
    case (.IntValue, .StringValue(let rightValue)):
        return try LangValue(lhs.stringValue() + rightValue)
        
    case (.StringValue(let leftValue), .IntValue):
        return try LangValue(leftValue + rhs.stringValue())
        
    // Wrong types
    default:
        throw LangValue.Error.BadCoercion
    }

}

func addIntegerValues(values:[LangValue]) -> LangValue {
    let total = values.reduce(0, combine: { (sum:Int, v:LangValue) in
        return sum + ((try? v.integerValue()) ?? 0)
    })
    return LangValue(total)
}
func addStringValues(values:[LangValue]) -> LangValue {
    let total = values.reduce("", combine: { (sum:String, v:LangValue) in
        return sum + ((try? v.stringValue()) ?? "")
    })
    return LangValue(total)
}

extension LangValue: Equatable {}
func ==(lhs:LangValue, rhs:LangValue) -> Bool {
    switch (lhs, rhs) {
    case (.IntValue(let leftValue), .IntValue(let rightValue)):
        return leftValue == rightValue
        
    case (.StringValue(let leftValue), .StringValue(let rightValue)):
        return leftValue == rightValue
        
    case (.Table(let leftValue), .Table(let rightValue)):
        // == isn't inferred by the dictionary...
        guard leftValue.count == rightValue.count else { return false }
        for (lk, lv) in leftValue {
            guard let rv = rightValue[lk] where lv == rv else { return false }
        }
        return true
        
    default:
        return false
    }
}

extension LangValue: Hashable {
    var hashValue: Int {
        switch self {
        case .IntValue(let v):
            return v.hashValue
        case .StringValue(let v):
            return v.hashValue
        case .Table(let t):
            // reduce() on a dictionary seems to pass (T, V) instead of (T, (K,V))...
            // Using xor here should be stable over random key orderings.
            var h = 0;
            for (k, v) in t {
                h = h ^ k.hashValue ^ v.hashValue
            }
            return h
        }
    }
}

func recursiveSetOfStringsInTable(v:LangValue) -> Set<LangValue> {
    var strings = Set<LangValue>()

    func add(v:LangValue) {
        switch (v) {
        case .StringValue:
            strings.insert(v)
        case .Table(let t):
            for (_, v) in t {
                add(v)
            }
        default:
            break
        }
    }
    
    add(v)
    return strings
}
