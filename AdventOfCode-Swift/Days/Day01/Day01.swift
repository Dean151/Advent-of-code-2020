
import Foundation

struct Day01: Day {
    static func run(input: String) {

        // Day 1-1
        #if DEBUG
        assert(integers(for: "1721\n979\n366\n299\n675\n1456").count == 6)
        assert(findTwo(2020, in: integers(for: "1721\n979\n366\n299\n675\n1456")) ?? (-1,-1) == (299, 1721))
        #endif

        let numbers = integers(for: input)
        guard let (first, second) = findTwo(2020, in: numbers) else {
            fatalError("No solution found for Day 1-1")
        }
        print("Solution for day 1-1 is \(first * second)")

        // Day 1-2
        #if DEBUG
        assert(findThree(2020, in: integers(for: "1721\n979\n366\n299\n675\n1456")) ?? (-1,-1,-1) == (675, 366, 979))
        #endif

        guard let (a, b, c) = findThree(2020, in: numbers) else {
            fatalError("No solution found for Day 1-1")
        }
        print("Solution for day 1-2 is \(a * b * c)")
    }

    static func integers(for input: String) -> [Int] {
        input.components(separatedBy: .newlines).compactMap { Int($0) }
    }

    static func findTwo(_ number: Int, in numbers: [Int]) -> (Int, Int)? {
        var toTest = numbers
        while let first = toTest.popLast() {
            let second = number - first
            if toTest.contains(second) {
                return (first, second)
            }
        }
        return nil
    }

    static func findThree(_ number: Int, in numbers: [Int]) -> (Int, Int, Int)? {
        var toTest = numbers
        while let first = toTest.popLast() {
            let secondAndThird = number - first
            if let (second, third) = findTwo(secondAndThird, in: toTest) {
                return (first, second, third)
            }
        }
        return nil
    }
}
