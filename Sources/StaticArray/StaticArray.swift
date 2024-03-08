import CStaticArray

public struct StaticArray<Element, Storage: StaticArrayStorage>: RandomAccessCollection {
    public typealias Index = Int
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<StaticArray<Element, Storage>>
    public typealias Iterator = IndexingIterator<StaticArray<Element, Storage>>

    @usableFromInline
    var storage: Storage

    @inlinable
    public init() {
        self.storage = Storage()
        assert(_isPOD(Element.self), "Element type must be POD (Plain Old Data type). \(Element.self) is not a POD type.")
    }

    @inlinable
    public init(repeating repeatedValue: Element) {
        self.init()
        for i in 0..<count {
            self[i] = repeatedValue
        }
    }

    @inlinable
    public static var count: Int {
        return MemoryLayout<Storage>.size / MemoryLayout<Element>.size
    }

    @inlinable
    public var count: Int {
        return Self.count
    }

    @inlinable
    public var startIndex: Int {
        return 0
    }

    @inlinable
    public var endIndex: Int {
        return count
    }

    @inlinable
    public subscript(position: Int) -> Element {
        get {
            withUnsafePointer(to: storage) { pointer in
                pointer.withMemoryRebound(to: Element.self, capacity: Self.count) { buffer in
                    return buffer[position]
                }
            }
        }
        mutating set {
            withUnsafeMutablePointer(to: &storage) { pointer in
                pointer.withMemoryRebound(to: Element.self, capacity: Self.count) { buffer in
                    buffer[position] = newValue
                }
            }
        }
    }

    @inlinable
    public subscript(safe position: Int) -> Element? {
        guard position >= 0, position < count else { return nil }
        return self[position]
    }
}

public protocol StaticArrayStorage { @inlinable init() }

extension CStaticArray.StaticArray64Bytes: StaticArrayStorage {}
extension CStaticArray.StaticArray512Bytes: StaticArrayStorage {}
extension CStaticArray.StaticArray4096Bytes: StaticArrayStorage {}
extension CStaticArray.StaticArray32768Bytes: StaticArrayStorage {}

public typealias StaticArray64Bytes<Element> = StaticArray<Element, CStaticArray.StaticArray64Bytes>
public typealias StaticArray512Bytes<Element> = StaticArray<Element, CStaticArray.StaticArray512Bytes>
public typealias StaticArray4096Bytes<Element> = StaticArray<Element, CStaticArray.StaticArray4096Bytes>
public typealias StaticArray32768Bytes<Element> = StaticArray<Element, CStaticArray.StaticArray32768Bytes>