
import Foundation

enum Day01: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let numbers = try integers(for: input)
        let (a, b) = try findTwo(2020, in: integers(for: input))
        let (c, d, e) = try findThree(2020, in: integers(for: input))
        precondition(numbers.count == 6)
        precondition(a == 299 && b == 1721)
        precondition(c == 675 && d == 366 && e == 979)
    }

    static func run(input: String) throws {
        let numbers = try integers(for: input)

        // Day 1-1
        let (first, second) = try findTwo(2020, in: numbers)
        print("Solution for day 1-1 is \(first * second)")

        // Day 1-2
        let (a, b, c) = try findThree(2020, in: numbers)
        print("Solution for day 1-2 is \(a * b * c)")
    }

    private static func findTwo(_ number: Int, in numbers: [Int]) throws -> (Int, Int) {
        var toTest = numbers
        while let first = toTest.popLast() {
            let second = number - first
            if toTest.contains(second) {
                return (first, second)
            }
        }
        throw Errors.unsolvable
    }

    private static func findThree(_ number: Int, in numbers: [Int]) throws -> (Int, Int, Int) {
        var toTest = numbers
        while let first = toTest.popLast() {
            let secondAndThird = number - first
            if let (second, third) = try? findTwo(secondAndThird, in: toTest) {
                return (first, second, third)
            }
        }
        throw Errors.unsolvable
    }
}
