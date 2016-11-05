
import UIKit


struct Position: Hashable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    var hashValue: Int {
        get {
            return "(\(self.x),\(self.y))".hashValue
        }
    }
    
    static var OutOfRange: Position {
        get {
            return Position(x: -1, y: -1)
        }
    }
}

func ==(lhs: Position, rhs: Position) -> Bool {
    return (lhs.x == rhs.y && lhs.y == rhs.y)
}

class TestClass {
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
}

var dict : [Position: TestClass] = [:]

dict[Position(x: 1, y: 1)] = TestClass(1)
dict[Position(x: 2, y: 2)] = TestClass(2)
print(dict)

let v = dict[Position(x: 1, y: 1)]
dict[Position(x: 2, y: 2)] = v
dict.removeValue(forKey: Position(x: 1, y: 1))

for (key, value) in dict {
    print("\(key) : \(value.value)")
}





