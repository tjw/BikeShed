
extension Range {
    var length:Element.Distance {
        return startIndex.distanceTo(endIndex)
    }
    func indexAtOffset(offset:Element.Distance) -> Element {
        return startIndex.advancedBy(offset)
    }
    func subrangeToIndex(index:Index) -> Range {
        return Range(start:startIndex, end:index)
    }
    func subrangeFromIndex(index:Index) -> Range {
        return Range(start:index, end:endIndex)
    }
}

extension Indexable {
    var entireRange: Range<Self.Index> {
        return Range(start:startIndex, end:endIndex)
    }
}

// Sadly, can't add an enum inside an extension, or this would be better inside Indexable
enum SearchResult<T> {
    case Missing(insertIndex:T)
    case Found(index:T)
}

// Add this to Indexable so that we get it on Array<T>, ArraySlice<T>, and ContiguousArray<T>
extension Indexable where Self._Element: Comparable {
    
    // Can't have `range:Range<Self.Index> = entireRange` here or we get "member 'entireRange' cannot be used on value of protocol type 'Indexable'; use a generic constraint instead", so define to versions of the function.
    func binarySearch(item:Self._Element, range:Range<Self.Index>) -> SearchResult<Self.Index> {
        let length = range.length
        if length == 0 {
            return SearchResult.Missing(insertIndex:range.startIndex)
        }
        
        let mid = range.indexAtOffset(length / 2)
        if self[mid] == item {
            return SearchResult.Found(index:mid)
        }
        
        if self[mid] < item {
            return binarySearch(item, range:range.subrangeFromIndex(mid.advancedBy(1)))
        } else {
            return binarySearch(item, range:range.subrangeToIndex(mid))
        }
    }
    
    func binarySearch(item:Self._Element) -> SearchResult<Self.Index> {
        return binarySearch(item, range:entireRange)
    }
}


let ints = [0, 4, 5, 6, 8, 9, 13]
print("ints.binarySearch(1) -> \(ints.binarySearch(1))")
print("ints.binarySearch(2) -> \(ints.binarySearch(2))")
print("ints.binarySearch(5) -> \(ints.binarySearch(5))")

let strings = ["a", "b", "c", "ca", "cat"]

var result = strings.binarySearch("a")
print("strings.binarySearch(\"a\") -> \(result)")

result = strings.binarySearch("ba")
print("strings.binarySearch(\"ba\") -> \(result)")
