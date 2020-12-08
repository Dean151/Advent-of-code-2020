
import Foundation

enum Day08: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let program = try Program.parse(input)
        precondition(program.instructions.count == 9)
        precondition(program.execute() == 5)
        precondition(program.execute(autofix: true) == 8)
    }

    static func run(input: String) throws {
        let program = try Program.parse(input)

        let brokenProgramValue = program.execute()
        print("Solution for day 8-1 is \(brokenProgramValue)")

        let fixedProgramValue = program.execute(autofix: true)
        print("Solution for day 8-2 is \(fixedProgramValue)")
    }

    struct Program {
        enum Instruction {
            case noOperation(value: Int)
            case jump(value: Int)
            case accumulator(value: Int)

            func execute(output: inout Int, pointer: inout Int) {
                switch self {
                case .noOperation:
                    pointer += 1
                case .jump(value: let value):
                    pointer += value
                case .accumulator(value: let value):
                    output += value
                    pointer += 1
                }
            }

            static func parse(_ input: String) throws -> Instruction {
                let components = input.components(separatedBy: .whitespaces)
                guard components.count == 2, let value = Int(components[1]) else {
                    throw Errors.unparsable
                }
                switch components[0] {
                case "nop":
                    return .noOperation(value: value)
                case "jmp":
                    return .jump(value: value)
                case "acc":
                    return .accumulator(value: value)
                default:
                    throw Errors.unparsable
                }
            }
        }

        let instructions: [Instruction]

        var toReplaceForAutofix: [Int] {
            return instructions.enumerated().filter({
                switch $0.element {
                case .accumulator:
                    return false
                default:
                    return true
                }
            }).map({ $0.offset }).reversed()
        }

        func execute(autofix: Bool = false) -> Int {
            var executed: Set<Int> = []
            var value = 0, current = 0

            // Autofix
            let toReplaceForAutofix = autofix ? self.toReplaceForAutofix : []
            var autofixValue = -1
            var replaced: Int?
            while true {
                if executed.contains(current) && !autofix {
                    break
                }
                if executed.contains(current) {
                    // Autofix case
                    autofixValue += 1
                    replaced = toReplaceForAutofix[autofixValue]
                    executed.removeAll()
                    value = 0
                    current = 0
                    continue
                }
                executed.insert(current)
                if autofix && current == replaced {
                    switch instructions[current] {
                    case .accumulator:
                        instructions[current].execute(output: &value, pointer: &current)
                    case .jump:
                        Instruction.noOperation(value: 0).execute(output: &value, pointer: &current)
                    case .noOperation(value: let jump):
                        Instruction.jump(value: jump).execute(output: &value, pointer: &current)
                    }
                } else {
                    if current >= instructions.count {
                        break
                    }
                    instructions[current].execute(output: &value, pointer: &current)
                }
            }
            return value
        }

        static func parse(_ input: String) throws -> Program {
            let instructions = try input.components(separatedBy: .newlines).map { try Instruction.parse($0) }
            return Program(instructions: instructions)
        }
    }
}
