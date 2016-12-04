//
//  Valy.swift
//  ValidatorSample
//
//  Created by Kazuya Ueoka on 2016/11/14.
//  Copyright © 2016年 Timers Inc. All rights reserved.
//

import Foundation

public enum ValyRule: AnyValidatorRule {
    case required
    case match(String)
    case pattern(String)
    case alphabet
    case digit
    case alnum
    case number
    case minLength(Int)
    case maxLength(Int)
    case exactLength(Int)
    case numericMin(Double)
    case numericMax(Double)
    case numericBetween(min: Double, max: Double)

    private func hasValue(with value: String?) -> String? {
        guard let value: String = value else {
            return nil
        }

        if 0 < value.characters.count {
            return value
        } else {
            return nil
        }
    }

    public func run(with value: String?) -> Bool {
        switch self {
        case .required:
            return nil != self.hasValue(with: value)
        case .minLength(let length):
            guard let value: String = self.hasValue(with: value) else {
                return true
            }
            return length <= value.characters.count
        case .maxLength(let length):
            guard let value: String = self.hasValue(with: value) else {
                return true
            }
            return length >= value.characters.count
        case .exactLength(let length):
            guard let value: String = self.hasValue(with: value) else {
                return true
            }
            return length == value.characters.count
        case .numericMin(let min):
            guard let value: String = self.hasValue(with: value) else {
                return true
            }
            guard let v: Double = Double(value) else {
                return true
            }
            return min <= v
        case .numericMax(let max):
            guard let value: String = self.hasValue(with: value) else {
                return true
            }
            guard let v: Double = Double(value) else {
                return true
            }
            return v <= max
        case .numericBetween(let min, let max):
            guard let value: String = self.hasValue(with: value) else {
                return true
            }
            guard let v: Double = Double(value) else {
                return true
            }
            return min <= v && v <= max
        case .match(let match):
            guard let value: String = self.hasValue(with: value) else {
                return true
            }
            return match == value
        case .pattern(let pattern):
            guard let value: String = self.hasValue(with: value) else {
                return true
            }
            do {
                let regexp: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: [])
                let range: NSRange = NSRange(location: 0, length: value.characters.count )
                return 0 < regexp.numberOfMatches(in: value, options: [], range: range)
            } catch {
                return true
            }
        case .alphabet:
            return ValyRule.pattern("^[a-zA-Z]+$").run(with: value)
        case .digit:
            return ValyRule.pattern("^[0-9]+$").run(with: value)
        case .alnum:
            return ValyRule.pattern("^[a-zA-Z0-9]+$").run(with: value)
        case .number:
            return ValyRule.pattern("^[\\+\\-]?[0-9\\.,]+$").run(with: value)
        }
    }
}

public class Valy: AnyValidatable {
    public typealias ErrorGenerator = (_ rule: AnyValidatorRule) -> String?
    
    private (set) public var rules: [AnyValidatorRule] = []
    public var failed: ErrorGenerator?
    public func errorMessage(_ result: ValidatorResult) -> String? {
        switch result {
        case .success:
            return nil
        case .failure(let rule):
            return self.failed?(rule)
        }
    }

    private init() {}
    private init(rules: [AnyValidatorRule]) {
        self.rules = rules
    }

    public static func factory() -> AnyValidator {
        return Valy.init()
    }

    public static func factory(rules: [AnyValidatorRule]) -> AnyValidatable {
        return Valy.init(rules: rules)
    }

    public func add(rule: AnyValidatorRule) -> AnyValidatable {
        self.rules.append(rule)
        return self
    }

    public func add(rules: [AnyValidatorRule]) -> AnyValidatable {
        self.rules += rules
        return self
    }
}
