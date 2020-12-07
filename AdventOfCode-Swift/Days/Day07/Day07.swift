
import Foundation

enum Day07: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let rules = try Rule.parse(input)
        precondition(rules.count == 9)
        let goldShinyRule = rules["shiny gold"]!
        precondition(goldShinyRule.possibleRecursiveColorsContainers(with: rules).count == 4)
        
        let input2 = try Input.getFromFile("\(Self.self)", file: "test2")
        let rules2 = try Rule.parse(input2)
        precondition(rules2.count == 7)
        let goldShinyRule2 = rules2["shiny gold"]!
        precondition(goldShinyRule2.recursiveNumberOfBags(with: rules2) == 126)
    }

    static func run(input: String) throws {
        let rules = try Rule.parse(input)

        // Day 7-1
        let countOfContainers = rules["shiny gold"]!.possibleRecursiveColorsContainers(with: rules).count
        print("Solution for day 7-1 is \(countOfContainers)")

        // Day 7-2
        let impressiveNumberOfBagsRequired = rules["shiny gold"]!.recursiveNumberOfBags(with: rules)
        print("Solution for day 7-2 is \(impressiveNumberOfBagsRequired)")
    }

    private struct Rule {
        let color: String
        let contains: [String: Int]
        var isContained: Set<String> = []

        func possibleRecursiveColorsContainers(with rules: [String: Rule]) -> Set<String> {
            var colors: Set<String> = []
            colors = colors.union(isContained)
            for color in isContained {
                colors = colors.union(rules[color]!.possibleRecursiveColorsContainers(with: rules))
            }
            return colors
        }

        func recursiveNumberOfBags(with rules: [String: Rule]) -> Int {
            var contained = 0
            for (color, number) in contains {
                contained += number * (1 + rules[color]!.recursiveNumberOfBags(with: rules))
            }
            return contained
        }

        init(from line: String) throws {
            let components = line.components(separatedBy: " bags contain ")
            guard components.count == 2 else {
                throw Errors.unparsable
            }
            color = components[0]
            if components[1] == "no other bags." {
                contains = [:]
                return
            }
            let list = components[1].components(separatedBy: ", ")
            var contains: [String: Int] = [:]
            for contained in list {
                let words = contained.components(separatedBy: .whitespaces)
                assert(words.count == 4)
                guard let count = Int(words[0]) else {
                    throw Errors.unparsable
                }
                let color = words[1] + " " + words[2]
                contains[color] = count
            }
            self.contains = contains
        }

        static func parse(_ input: String) throws -> [String: Rule] {
            var rules: [String: Rule] = [:]
            for line in input.components(separatedBy: .newlines) {
                let rule = try Rule(from: line)
                assert(rules[rule.color] == nil)
                rules[rule.color] = rule
            }

            // Resolve isContained
            for (color, rule) in rules {
                for (containedColor, _) in rule.contains {
                    rules[containedColor]!.isContained.insert(color)
                }
            }
            return rules
        }
    }
}
