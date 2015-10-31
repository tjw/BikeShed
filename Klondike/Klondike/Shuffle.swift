//
//  Shuffle.swift
//  Klondike
//
//  Created by Timothy J. Wood on 10/6/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

import Foundation

// <http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift>

extension CollectionType where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
