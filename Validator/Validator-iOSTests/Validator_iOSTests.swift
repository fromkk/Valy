//
//  Validator_iOSTests.swift
//  Validator-iOSTests
//
//  Created by Kazuya Ueoka on 2016/11/14.
//
//

import XCTest
@testable import Valy

/*
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
*/

class Validator_iOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequired() {
        let value1: String? = nil
        XCTAssertFalse(ValyRule.required.run(with: value1))
        let value2: String? = "hello world"
        XCTAssertTrue(ValyRule.required.run(with: value2))
    }

    func testMatch() {
        let match = ValyRule.match("ABC")
        let value1: String = "abc"
        XCTAssertFalse(match.run(with: value1))
        let value2: String = "ABC"
        XCTAssertTrue(match.run(with: value2))
    }

    func testPattern() {
        let pattern = ValyRule.pattern("^[a-z]+$")
        let value1: String = "Hello!"
        XCTAssertFalse(pattern.run(with: value1))

        let value2: String = "Hello"
        XCTAssertFalse(pattern.run(with: value2))

        let value3: String = "hello"
        XCTAssertTrue(pattern.run(with: value3))
    }

    func testAlphabet() {
        let alphabet = ValyRule.alphabet
        let value1: String = "Hello world!"
        XCTAssertFalse(alphabet.run(with: value1))

        let value2: String = "123"
        XCTAssertFalse(alphabet.run(with: value2))

        let value3: String = "HelloWorld"
        XCTAssertTrue(alphabet.run(with: value3))
    }

    //digit
    func testDigit() {
        let digit = ValyRule.digit
        let value1: String = "Hello world!"
        XCTAssertFalse(digit.run(with: value1))

        let value2: String = "0"
        XCTAssertTrue(digit.run(with: value2))

        let value3: String = "0123456789"
        XCTAssertTrue(digit.run(with: value3))

        let value4: String = "-1,234,567,890"
        XCTAssertFalse(digit.run(with: value4))
    }

    //alnum
    func testAlnum() {
        let alnum = ValyRule.alnum
        let value1: String = "Hello world!"
        XCTAssertFalse(alnum.run(with: value1))

        let value2: String = "0123456789"
        XCTAssertTrue(alnum.run(with: value2))

        let value3: String = "HelloWorld"
        XCTAssertTrue(alnum.run(with: value3))

        let value4: String = "Hello0123456789World"
        XCTAssertTrue(alnum.run(with: value4))
    }


    //number
    func testNumber() {
        let number = ValyRule.number
        let value1: String = "Hello world!"
        XCTAssertFalse(number.run(with: value1))

        let value2: String = "0"
        XCTAssertTrue(number.run(with: value2))

        let value3: String = "0123456789"
        XCTAssertTrue(number.run(with: value3))

        let value4: String = "-1,234,567,890"
        XCTAssertTrue(number.run(with: value4))
    }

    //minLength(Int)
    func testMinLength() {
        let minLength = ValyRule.minLength(10)
        let value1: String = "Hellooooo"
        XCTAssertFalse(minLength.run(with: value1))

        let value2: String = "Helloworld"
        XCTAssertTrue(minLength.run(with: value2))

        let value3: String = "helloworld!"
        XCTAssertTrue(minLength.run(with: value3))
    }

    //maxLength(Int)
    func testMaxLength() {
        let maxLength = ValyRule.maxLength(10)
        let value1: String = "Hellooooo"
        XCTAssertTrue(maxLength.run(with: value1))

        let value2: String = "Helloworld"
        XCTAssertTrue(maxLength.run(with: value2))

        let value3: String = "helloworld!"
        XCTAssertFalse(maxLength.run(with: value3))
    }

    //exactLength(Int)
    func exactLength() {
        let exactLength = ValyRule.exactLength(10)
        let value1: String = "Hellooooo"
        XCTAssertFalse(exactLength.run(with: value1))

        let value2: String = "Helloworld"
        XCTAssertTrue(exactLength.run(with: value2))

        let value3: String = "helloworld!"
        XCTAssertFalse(exactLength.run(with: value3))
    }

    //numericMin(Double)
    func numericMin() {
        let min = ValyRule.numericMin(10)
        let value1: String = "9"
        XCTAssertFalse(min.run(with: value1))

        let value2: String = "10"
        XCTAssertTrue(min.run(with: value2))

        let value3: String = "11"
        XCTAssertTrue(min.run(with: value3))
    }

    //numericMax(Double)
    func numericMax() {
        let max = ValyRule.numericMax(10)
        let value1: String = "9"
        XCTAssertTrue(max.run(with: value1))

        let value2: String = "10"
        XCTAssertTrue(max.run(with: value2))

        let value3: String = "11"
        XCTAssertFalse(max.run(with: value3))
    }

    //numericBetween(min: Double, max: Double)
    func numericBetween() {
        let between = ValyRule.numericBetween(min: 10, max: 20)
        let value1: String = "9"
        XCTAssertFalse(between.run(with: value1))

        let value2: String = "10"
        XCTAssertTrue(between.run(with: value2))

        let value3: String = "11"
        XCTAssertTrue(between.run(with: value3))

        let value4: String = "15"
        XCTAssertTrue(between.run(with: value4))

        let value5: String = "19"
        XCTAssertTrue(between.run(with: value5))

        let value6: String = "20"
        XCTAssertTrue(between.run(with: value6))

        let value7: String = "21"
        XCTAssertFalse(between.run(with: value7))
    }
}
