
import Foundation

enum Day06: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let groups = try Group.parse(input)
        precondition(groups.count == 5)
        precondition(groups.reduce(0, { $0 + $1.anyAnswerCount }) == 11)
        precondition(groups.reduce(0, { $0 + $1.allAnswersCount }) == 6)
    }

    static func run(input: String) throws {
        let groups = try Group.parse(input)

        // Day 6-1
        let anyAnswerCount = groups.reduce(0, { $0 + $1.anyAnswerCount })
        print("Solution for day 6-1 is \(anyAnswerCount)")
        
        // Day 6-2
        let allAnswersCount = groups.reduce(0, { $0 + $1.allAnswersCount })
        print("Solution for day 6-2 is \(allAnswersCount)")
    }

    private struct Group {
        private var peopleCount = 0
        private var answers: [Character:Int] = [:]

        var anyAnswerCount: Int {
            return answers.count
        }

        var allAnswersCount: Int {
            return answers.count { $0.value == peopleCount }
        }

        private mutating func feed(with line: String) throws {
            peopleCount += 1
            for char in line {
                if let nb = answers[char] {
                    answers[char] = nb + 1
                } else {
                    answers[char] = 1
                }
            }
        }

        static func parse(_ input: String) throws -> [Group] {
            let lines = input.components(separatedBy: .newlines)
            var groups: [Group] = []
            var current = Group()
            for line in lines {
                if line.isEmpty {
                    groups.append(current)
                    current = Group()
                    continue
                }
                try current.feed(with: line)
            }
            if !current.answers.isEmpty {
                // Add the final group
                groups.append(current)
            }
            return groups
        }
    }
}
