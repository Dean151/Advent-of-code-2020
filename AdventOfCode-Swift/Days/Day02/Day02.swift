
import Foundation

enum Day02: Day {
    static func test() throws {
        let expectedPart1 = [
            "1-3 a: abcde" : true,
            "1-3 b: cdefg" : false,
            "2-9 c: ccccccccc" : true
        ]
        for (input, expected) in expectedPart1 {
            let result = try PasswordAndPolicy.from(input).isValid(mode: .occurences)
            precondition(result == expected)
        }

        let expectedPart2 = [
            "1-3 a: abcde" : true,
            "1-3 b: cdefg" : false,
            "2-9 c: ccccccccc" : false
        ]
        for (input, expected) in expectedPart2 {
            let result = try PasswordAndPolicy.from(input).isValid(mode: .position)
            precondition(result == expected)
        }
    }

    static func run(input: String) throws {
        let passwordsAndPolicies = try input.components(separatedBy: .newlines).map { try PasswordAndPolicy.from($0) }

        // Day 2-1
        let nbValidByOccurences = passwordsAndPolicies.count { $0.isValid(mode: .occurences) }
        print("Solution for Day 2-1 is \(nbValidByOccurences)")

        // Day 2-2
        let nbValidByPosition = passwordsAndPolicies.count { $0.isValid(mode: .position) }
        print("Solution for Day 2-2 is \(nbValidByPosition)")
    }

    private struct PasswordAndPolicy {
        struct Policy {
            enum Mode {
                case occurences
                case position
            }

            let letter: Character
            let first: Int
            let second: Int

            func test(_ password: String, mode: Mode) -> Bool {
                switch mode {
                case .occurences:
                    let occurences = password.count { $0 == letter }
                    return occurences >= first && occurences <= second
                case .position:
                    guard password.count >= second else {
                        return false
                    }
                    let firstIndex = password.index(password.startIndex, offsetBy: first - 1)
                    let secondIndex = password.index(password.startIndex, offsetBy: second - 1)
                    return password[firstIndex] == letter && password[secondIndex] != letter || password[firstIndex] != letter && password[secondIndex] == letter
                }
            }

            static func from(_ string: String) throws -> Policy {
                let components = string.components(separatedBy: CharacterSet.alphanumerics.inverted)
                guard components.count == 3 else {
                    throw Errors.unparsable
                }
                guard let first = Int(components[0]), let second = Int(components[1]) else {
                    throw Errors.unparsable
                }
                guard components[2].count == 1, let char = components[2].first else {
                    throw Errors.unparsable
                }
                return Policy(letter: char, first: first, second: second)
            }
        }

        let password: String
        let policy: Policy

        func isValid(mode: Policy.Mode) -> Bool {
            policy.test(password, mode: mode)
        }

        static func from(_ string: String) throws -> PasswordAndPolicy {
            let components = string.components(separatedBy: ": ")
            guard components.count == 2 else {
                throw Errors.unparsable
            }
            let policy = try Policy.from(components[0])
            return PasswordAndPolicy(password: components[1], policy: policy)
        }
    }
}
