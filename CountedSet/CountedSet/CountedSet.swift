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
    
    var isEmpty: Bool {
        return items.count == 0
    }

    var count:Int {
        return items.reduce(0) {accum, item in accum + item.count}
    }

    func count(member: Element) -> Int {
        let item = items.first { $0.element == member }
        return item?.count ?? 0
    }
    
    func contains(member: Element) -> Bool {
        return items.any { $0.element == member }
    }
    
    var hashValue: Int {
        return items.reduce(0) { accum, item in accum ^ item.count.hashValue ^ item.element.hashValue }
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
    
    // Could also maintain an independent count of items...
    var isEmpty: Bool {
        return buckets.all { $0.isEmpty }
    }

    var count: Int {
        return buckets.reduce(0) {accum, bucket in accum + bucket.count }
    }
    
    func contains(member: Element) -> Bool {
        let b = findBucket(member)
        return b.bucket.contains(member)
    }

    func count(member: Element) -> Int {
        let b = findBucket(member)
        return b.bucket.count(member)
    }
    
    var hashValue: Int {
        return buckets.reduce(0) { accum, bucket in accum ^ bucket.hashValue }
    }

    mutating func add(member:Element) {
        let b = findBucket(member)
        
        var bucket = b.bucket
        if !isUniquelyReferencedNonObjC(&bucket) {
            bucket = Bucket(bucket)
            buckets[b.bucketIndex] = bucket
        }
        
        bucket.add(member)
    }
    
    private func findBucket(element:Element) -> (bucket:Bucket,bucketIndex:Int) {
        let hash = element.hashValue
        let bucketIndex = hash % buckets.count
        return (buckets[bucketIndex], bucketIndex)
    }
}

// Can't be in a generic type.
// Start with a non-zero number of buckets so add() can use '%' w/o having to check for a zero bucket count.
private let MinimumBucketCount = 3

public struct CountedSet<Element:Hashable> : Equatable, Hashable {

    private typealias Storage = _CountedSetStorage<Element>
    
    private var storage:Storage

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
    
    public var isEmpty: Bool {
        return storage.isEmpty
    }

    // Returns the sum of the counts of all the items in the set (so if a single item has been added twice, it will add two to the count)
    public var count: Int {
        return storage.count
    }
    
    public var hashValue: Int {
        return storage.hashValue
    }
    
    
    public func contains(member: Element) -> Bool {
        return storage.contains(member)
    }
    
    public func count(member: Element) -> Int {
        return storage.count(member)
    }
    
    public mutating func insert(member: Element) {
        // TODO: Copy on write
        storage.add(member)
    }
    
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

public func ==<T>(set1:CountedSet<T>, otherSet:CountedSet<T>) -> Bool {
    abort() // Enumeate items and check counts? Could maybe convince ourselves that the bucketing of items would be the same, so only bucket by bucket comparision would be needed (but probably not since a removal right after a grow shouldn't shrink the bucket count).
    return false
}
