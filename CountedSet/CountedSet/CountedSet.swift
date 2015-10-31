//
//  CountedSet.swift
//  CountedSet
//
//  Created by Timothy J. Wood on 10/30/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

// Huh. Can't put inner structs in a generic container struct.

private struct _Item<Element> {
    let element:Element
    let count:Int // TODO: Allow negative counts?
}

private class _Bucket<Element:Hashable> {

    private typealias Item = _Item<Element>

    var items:[Item]
    
    init() {
        self.items = []
    }
    init(_ bucket:_Bucket<Element>) {
        self.items = bucket.items
    }
    
    func add(element:Element) {
        let idx = items.indexOf { $0.element == element }
        if let idx = idx {
            let oldItem = items[idx]
            let item = Item(element:element, count: oldItem.count + 1)
            items[idx] = item
        } else {
            let item = Item(element:element, count:1)
            items.append(item)
        }
    }
}

private struct _CountedSetStorage<Element:Hashable> {

    private typealias Bucket = _Bucket<Element>

    var buckets:[Bucket]
    
    init(bucketCount:Int) {
        var bs:[Bucket] = []
        
        for _ in (0..<bucketCount) {
            bs.append(Bucket())
        }
        
        self.buckets = bs
    }
    
    mutating func add(element:Element) {
        let hash = element.hashValue
        let bucketIndex = hash % buckets.count
        var bucket = buckets[bucketIndex]
        
        if !isUniquelyReferencedNonObjC(&bucket) {
            bucket = Bucket(bucket)
            buckets[bucketIndex] = bucket
        }
        
        bucket.add(element)
    }
}

// Can't be in a generic type.
// Start with a non-zero number of buckets so add() can use '%' w/o having to check for a zero bucket count.
private let MinimumBucketCount = 3

public struct CountedSet<Element:Hashable> {

    private typealias Storage = _CountedSetStorage<Element>
    
    private let storage:Storage

    /// Make an empty set
    public init() {
        self.storage = Storage(bucketCount: MinimumBucketCount)
    }
    
    /// Consume a sequence to form the set.
    public init<S: SequenceType where S.Generator.Element == Element>(sequence:S) {
        var storage = Storage(bucketCount: MinimumBucketCount)
        
        for e in sequence {
            storage.add(e)
        }
        
        self.storage = storage
    }
    
//    public var isEmpty: Bool { get }
//    public var count: Int { get }
//    public var hashValue: Int { get }
//    public func contains(member: Element) -> Bool
//    public func count(member: Element) -> Int
//    public mutating func insert(member: Element)
//    public mutating func remove(member: Element) -> Element?
//    public mutating func removeAll()
    
    /*
    isSubsetOf
    isStrictSubsetOf
    isSupersetOf
    isStrictSupersetOf
    isDisjointWith
    union
    mutating unionInPlace
    subtract
    mutating subtractInPlace
    intersect
    mutating intersectInPlace
    exclusiveOr
    mutating exclusiveOrInPlace
    */
    
}
