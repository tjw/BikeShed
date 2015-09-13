
enum BinarySearchResult<T> {
    case Missing(insertIndex:T)
    case Found(index:T)
}

protocol BinarySearchable {
    typealias Index: ForwardIndexType
    typealias Element: Comparable
    func binarySearch(item:Element) -> BinarySearchResult<Index>
}

// Add this to Indexable so that we get it on Array<T>, ArraySlice<T>, and ContiguousArray<T>
extension Indexable where Self._Element: Comparable {
    func binarySearch(item:Self._Element) -> BinarySearchResult<Self.Index> {
        var left = self.startIndex
        var right = self.endIndex
        
        while (left.distanceTo(right) > 0) {
            let mid = left.advancedBy(left.distanceTo(right) / 2)
            
            if self[mid] == item {
                return BinarySearchResult.Found(index:mid)
            }
            if self[mid] < item {
                left = mid.advancedBy(1)
            } else {
                right = mid
            }
        }
        
        // left == right is a zero length range
        return BinarySearchResult.Missing(insertIndex:left)
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
