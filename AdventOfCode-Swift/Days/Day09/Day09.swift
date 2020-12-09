
import Foundation

enum Day09: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let values = try integers(for: input)
        let number = try findFirstNumberThatIsNotASum(from: values, in: 5)
        let (min, max) = try find(number, asCongruentSumIn: values)
        precondition(values.count == 20)
        precondition(number == 127)
        precondition((min, max) == (15, 47))
    }

    static func run(input: String) throws {
        let values = try integers(for: input)

        // Day 9-1
        let number = try findFirstNumberThatIsNotASum(from: values, in: 25)
        print("Solution for day 9-1 is \(number)")

        // Day 9-2
        let (min, max) = try find(number, asCongruentSumIn: values)
        print("Solution for day 9-2 is \(min + max)")
    }

    private static func findFirstNumberThatIsNotASum(from input: [Int], in window: Int) throws -> Int {
        assert(input.count > window)
        for current in window..<input.count {
            let number = input[current]
            if !isNumber(number, sumOfTwoIn: input[current-window...current-1]) {
                return number
            }
        }
        throw Errors.unsolvable
    }

    private static func isNumber(_ number: Int, sumOfTwoIn numbers: ArraySlice<Int>) -> Bool {
        var toTest = numbers
        while let first = toTest.popLast() {
            let second = number - first
            if toTest.contains(second) {
                return true
            }
        }
        return false
    }

    private static func find(_ number: Int, asCongruentSumIn numbers: [Int]) throws -> (min: Int, max: Int) {
        // Brute force is probably not the most elegant solution
        mainLoop: for minIndex in 0..<numbers.count-1 {
            for maxIndex in minIndex+1..<numbers.count {
                let subArray = numbers[minIndex...maxIndex]
                let sum = subArray.reduce(0, +)
                if sum == number {
                    return (subArray.min()!, subArray.max()!)
                }
                if sum > number {
                    continue mainLoop
                }
            }
        }
        throw Errors.unsolvable
    }
}
