# Static Arrays in Swift

## Install as Swift Package

```swift
dependencies: [
    .package(url: "github.com/joehinkle11/StaticArray", from: "1.0.0")
]
```

## Usage

```swift
import StaticArray

struct MyStruct {
    var normalProperty: Int
    var array1: StaticArray64Bytes<Int> // equivalent `unsigned char data[64]` in C
    var array2: StaticArray64Bytes<Int> // equivalent `unsigned char data[64]` in C
}

var myStruct = MyStruct(
    normalProperty: 1,
    array1: StaticArray64Bytes(), // initialize with all zeros
    array2: StaticArray64Bytes(repeating: 42) // initialize with all 42s
)

print(myStruct.array1[0]) // 0
print(myStruct.array2[0]) // 42
myStruct.array1[0] = 123
print(myStruct.array1[0]) // 123
print(myStruct.array1.count) // 8, because 64 bytes = 8 Ints
print(StaticArray64Bytes<Int>) // 8, because 64 bytes = 8 Ints
```

## Supported Sizes

Static array sizes cannot be chosen arbitrarily. The following sizes are supported:

| Size (bytes)  | Type |
|-------|------|
| 64    | `StaticArray64Bytes` |
| 512   | `StaticArray512Bytes` |
| 4096  | `StaticArray4096Bytes` |
| 32768 | `StaticArray32768Bytes` |

If you wish to use a different size, you can create a new type which combines several smaller arrays. For example, to create a 128-byte array, you could use two `StaticArray64Bytes`:

```swift
struct StaticArray128Bytes<T> {
    var a: StaticArray64Bytes<T>
    var b: StaticArray64Bytes<T>
}
```

You can also fork this repository and add support for additional sizes.

## How does this work?

Swift can import fixed-size C arrays as tuples. This library is then able to exploit this fact to make fix length arrays in Swift.

## Limitations

You **cannot** use non-PODs (Plain Old Data) types in the array. This means you cannot use classes, strings, or other complex types. You can use simple types like `Int`, `Float`, `Double`, `Bool`, etc. or even your own structs provided they are don't contain any non-POD types. There is a runtime check to ensure that the type is a POD so you will know if you are trying to use a non-POD type.

### References

Thanks to this blog post by ole Begemann for the inspiration: [Swift imports fixed-size C arrays as tuples](https://oleb.net/blog/2017/12/swift-imports-fixed-size-c-arrays-as-tuples/)