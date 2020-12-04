
import Foundation

enum Day04: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let passports = try Passport.parse(input)
        precondition(passports.count == 4)
        precondition(passports.count(where: { $0.isWeakValid }) == 2)

        let invalids = try Input.getFromFile("\(Self.self)", file: "invalids")
        let invalidsPassports = try Passport.parse(invalids)
        precondition(invalidsPassports.count == 4)
        precondition(invalidsPassports.count(where: { $0.isStrongValid }) == 0)

        let valids = try Input.getFromFile("\(Self.self)", file: "valids")
        let validsPassports = try Passport.parse(valids)
        precondition(!validsPassports.isEmpty)
        precondition(validsPassports.count(where: { $0.isStrongValid }) == validsPassports.count)
    }

    static func run(input: String) throws {
        let passports = try Passport.parse(input)

        // Day 4-1
        let validNumber = passports.count(where: { $0.isWeakValid })
        print("Solution for day 4-1 is \(validNumber)")

        // Day 4-2
        let strongValidNumber = passports.count(where: { $0.isStrongValid })
        print("Solution for day 4-2 is \(strongValidNumber)")
    }

    private struct Passport {
        var birthYear: String?
        var issueYear: String?
        var expirationYear: String?
        var height: String?
        var hairColor: String?
        var eyeColor: String?
        var passportId: String?

        /// This one is fine if nil
        var countryId: String?

        var isWeakValid: Bool {
            return birthYear != nil
                && issueYear != nil
                && expirationYear != nil
                && height != nil
                && hairColor != nil
                && eyeColor != nil
                && passportId != nil
        }

        var isStrongValid: Bool {
            func validateInteger(value: String?, min: Int, max: Int) -> Bool {
                guard let value = value, let integer = Int(value) else { return false }
                return integer >= min && integer <= max
            }

            func validateHeight(value: String?) -> Bool {
                guard let value = value else { return false }
                if value.count == 4 {
                    guard value.hasSuffix("in") else { return false }
                    return validateInteger(value: String(value.prefix(2)), min: 59, max: 76)
                } else if value.count == 5 {
                    guard value.hasSuffix("cm") else { return false }
                    return validateInteger(value: String(value.prefix(3)), min: 150, max: 193)
                }
                return false
            }

            func validateHairColor(value: String?) -> Bool {
                guard var value = value else { return false }
                guard value.count == 7 else { return false }
                guard value.first == "#" else { return false }
                for _ in 1..<6 {
                    guard let char = value.popLast() else { return false }
                    guard char.isHexDigit else { return false }
                }
                return true
            }

            func validateEyeColor(value: String?) -> Bool {
                guard let value = value else { return false }
                let valid = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
                return valid.contains(value)
            }

            func validatePassportId(value: String?) -> Bool {
                guard let value = value else { return false }
                return Int(value) != nil && value.count == 9
            }

            return validateInteger(value: birthYear, min: 1920, max: 2002)
                && validateInteger(value: issueYear, min: 2010, max: 2020)
                && validateInteger(value: expirationYear, min: 2020, max: 2030)
                && validateHeight(value: height)
                && validateHairColor(value: hairColor)
                && validateEyeColor(value: eyeColor)
                && validatePassportId(value: passportId)
        }

        private var hasValue: Bool {
            return birthYear != nil
                || issueYear != nil
                || expirationYear != nil
                || height != nil
                || hairColor != nil
                || eyeColor != nil
                || passportId != nil
                || countryId != nil
        }

        /// Convenience empty init()
        private init() {}
        private mutating func feed(with line: String) throws {
            let fields = line.components(separatedBy: .whitespaces)
            for field in fields {
                let components = field.components(separatedBy: ":")
                precondition(components.count == 2)
                try assign(key: components[0], value: components[1])
            }
        }

        private mutating func assign(key: String, value: String) throws {
            switch key {
            case "byr":
                birthYear = value
            case "iyr":
                issueYear = value
            case "eyr":
                expirationYear = value
            case "hgt":
                height = value
            case "hcl":
                hairColor = value
            case "ecl":
                eyeColor = value
            case "pid":
                passportId = value
            case "cid":
                countryId = value
            default:
                throw Errors.unparsable
            }
        }

        static func parse(_ input: String) throws -> [Passport] {
            let lines = input.components(separatedBy: .newlines)
            var passports: [Passport] = []
            var current = Passport()
            for line in lines {
                if line.isEmpty {
                    passports.append(current)
                    current = Passport()
                    continue
                }
                try current.feed(with: line)
            }
            if current.hasValue {
                // Add the final passport
                passports.append(current)
            }
            return passports
        }
    }
}
