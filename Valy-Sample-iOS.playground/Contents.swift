//: Playground - noun: a place where people can play

import UIKit
import Valy
import PlaygroundSupport

// value1 -------------------------------------
let value1: String? = nil

let required = Valy.factory(rules: [ValyRule.required])
let result1 = required.run(with: value1)

switch result1 {
case .failure(let rule):
    switch rule {
    case ValyRule.required:
        print("value1 (\(value1)) is required...")
    default:
        break
    }
default:
    print("value1 (\(value1)) is successed!")
    break
}

// value2 -------------------------------------
let value2 = "Hello validator!"
let result2 = required.run(with: value2)

switch result2 {
case .success:
    print("value2 (\(value2)) is successed!!")
default:
    print("value2 (\(value2)) failure...")
    break
}

// value3 -------------------------------------
let value3 = "Hello world"
let exactLength = Valy.factory(rules: [ValyRule.exactLength(11)])
switch exactLength.run(with: value3) {
case .success:
    print("value3 (\(value3)) is match 11 length!!!")
case .failure(let rule):
    switch rule {
    case ValyRule.exactLength(let l):
        print("value3 (\(value3)) is not matched \(l) length...")
    default:
        print("value3 (\(value3)) is not validated...")
        break
    }
}

// value4 -------------------------------------
let value4 = "hello world"
let multi = Valy.factory().add(rule: ValyRule.required).add(rule: ValyRule.minLength(10)).add(rule: ValyRule.maxLength(20)).run(with: value4)
switch multi {
case .success:
    print("value4 (\(value4)) is valid!")
case .failure(let rule):
    switch rule {
    case ValyRule.required:
        print("value4 \(value4) is required")
    case ValyRule.minLength(let l):
        print("value4 \(value4) is not min length \(l)")
    case ValyRule.maxLength(let l):
        print("value4 \(value4) is not max length \(l)")
    default:
        print("value4 is not valid")
    }
}

// textField ----------------------------------
let textField: VLTextField = VLTextField(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 320.0, height: 20.0)))
textField.add(rule: ValyRule.required).add(rule: ValyRule.maxLength(30))
textField.ovserveValidation { (status, result) in
    let errorMessage: String? = textField.errorMessage(result)
    print("observe", errorMessage)
}
textField.backgroundColor = UIColor.white
textField.textColor = UIColor.gray
textField.failed = { (_ rule: AnyValidatorRule) -> String? in
    switch rule {
    case ValyRule.maxLength(let length):
        return "textField can input max \(length) length"
    default:
        return nil
    }
}

// textView ----------------------------------
let textView: VLTextView = VLTextView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 320.0, height: 40.0)), textContainer: nil)
textView.add(rules: [
    ValyRule.required,
    ValyRule.minLength(10),
    ValyRule.maxLength(30),
    ValyRule.alnum
])
textView.ovserveValidation { (status, result) in
    print(status)
    switch result {
    case .success:
        print("textView success")
    case .failure(let rule):
        print("failed \(rule)")
    }
}

let validator = Valy.factory(rules: [ValyRule.minLength(5)])
validator.failed = { (_ rule: AnyValidatorRule) -> String? in
    switch rule {
    case ValyRule.minLength(let length):
        return "need \(length) length"
    default:
        return nil
    }
}
let result: ValidatorResult = validator.run(with: "test")
let errorMessage: String? = validator.errorMessage(result)
print(errorMessage ?? "")

PlaygroundPage.current.liveView = textView
