import XCTest
@testable import StaticArray

final class StaticArrayTests: XCTestCase {
    func testInts() throws {
        var staticArray = StaticArray64Bytes<Int>()
        XCTAssertEqual(MemoryLayout<StaticArray64Bytes<Int>>.size, 64)
        XCTAssertEqual(MemoryLayout.size(ofValue: staticArray), 64)
        XCTAssertEqual(StaticArray64Bytes<Int>.count, 64 / MemoryLayout<Int>.size)
        XCTAssertEqual(staticArray.count, 64 / MemoryLayout<Int>.size)
        for i in 0..<staticArray.count {
            XCTAssertEqual(staticArray[i], 0)
        }
        for i in 0..<staticArray.count {
            staticArray[i] = i
        }
        for i in 0..<staticArray.count {
            XCTAssertEqual(staticArray[i], i)
        }
    }
    func testLargerStruct() {
        struct S {
            var array1: StaticArray64Bytes<Int>
            var array2: StaticArray64Bytes<Int>
        }
        var s = S(
            array1: StaticArray64Bytes<Int>(),
            array2: StaticArray64Bytes<Int>(repeating: 3)
        )
        XCTAssertEqual(MemoryLayout<S>.size, 128)
        XCTAssertEqual(MemoryLayout.size(ofValue: s), 128)
        XCTAssertEqual(s.array1.count, 64 / MemoryLayout<Int>.size)
        XCTAssertEqual(s.array2.count, 64 / MemoryLayout<Int>.size)
        for i in 0..<s.array1.count {
            XCTAssertEqual(s.array1[i], 0)
        }
        for i in 0..<s.array2.count {
            XCTAssertEqual(s.array2[i], 3)
        }
        for i in 0..<(s.array1.count + s.array2.count) {
            if i < s.array1.count {
                s.array1[i] = i
            } else {
                s.array2[i - s.array1.count] = (i - s.array1.count) * 10
            }
        }
        for i in 0..<s.array1.count {
            XCTAssertEqual(s.array1[i], i)
        }
        for i in 0..<s.array2.count {
            XCTAssertEqual(s.array2[i], i * 10)
        }
    }
    func testIteratorAndLoops() {
        var staticArray = StaticArray64Bytes<Int>()
        for i in 0..<staticArray.count {
            staticArray[i] = i
        }
        var i = 0
        for element in staticArray {
            XCTAssertEqual(element, i)
            i += 1
        }
        i = 0
        for element in staticArray.lazy {
            XCTAssertEqual(element, i)
            i += 1
        }
        i = 0
        for element in staticArray.reversed() {
            XCTAssertEqual(element, staticArray.count - i - 1)
            i += 1
        }
        i = 0
        for element in staticArray.lazy.reversed() {
            XCTAssertEqual(element, staticArray.count - i - 1)
            i += 1
        }
        let onlyValuesGreaterThan3 = staticArray.filter { $0 > 3 }
        XCTAssertEqual(onlyValuesGreaterThan3.count, staticArray.count / 2)
        XCTAssertNil(staticArray[safe: -1])
        XCTAssertNil(staticArray[safe: staticArray.count])
        XCTAssertEqual(staticArray[safe: 0], 0)
        XCTAssertEqual(staticArray[safe: staticArray.count - 1], staticArray.count - 1)
    }
    func veryLargeStaticArray() {
        struct S {
            var before: String = "before"
            var staticArray = StaticArray32768Bytes<Int>(repeating: .max)
            var after: String = "after"
        }
        var s = S()
        XCTAssertEqual(MemoryLayout<S>.size, 32768 + 16 + 16)
        XCTAssertEqual(MemoryLayout.size(ofValue: s), 32768 + 16 + 16)
        XCTAssertEqual(s.staticArray.count, 32768 / MemoryLayout<Int>.size)
        for i in 0..<s.staticArray.count {
            XCTAssertEqual(s.staticArray[i], .max)
        }
        for i in 0..<s.staticArray.count {
            s.staticArray[i] = i
        }
        for i in 0..<s.staticArray.count {
            XCTAssertEqual(s.staticArray[i], i)
        }
        XCTAssertEqual(s.before, "before")
        XCTAssertEqual(s.after, "after")
        XCTAssertNil(s.staticArray[safe: -1])
        XCTAssertNil(s.staticArray[safe: s.staticArray.count])
        XCTAssertEqual(s.staticArray[safe: 0], 0)
        XCTAssertEqual(s.staticArray[safe: s.staticArray.count - 1], s.staticArray.count - 1)
    }
}
