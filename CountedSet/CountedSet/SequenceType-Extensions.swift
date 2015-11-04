//
//  SequenceType-Extensions.swift
//  CountedSet
//
//  Created by Timothy J. Wood on 11/1/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

extension SequenceType {

    typealias Element = Self.Generator.Element
    
    func any(predicate:(Element->Bool)) -> Bool {
        for item in self {
            if (predicate(item)) {
                return true
            }
        }
        return false
    }
    func all(predicate:(Element->Bool)) -> Bool {
        for item in self {
            if (!predicate(item)) {
                return false
            }
        }
        return true
    }
    func first(predicate:(Element->Bool)) -> Element? {
        for item in self {
            if (predicate(item)) {
                return item
            }
        }
        return nil
    }
}
