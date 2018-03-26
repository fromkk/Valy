
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
<img src="valy.png" width="320" height="auto" />

# Valy

Valy is string validation library with Swift 3.

# Required

- Swift 3
- Xcode 8
- iOS 8~ / watchOS 2~ / tvOS 8~ / macOS 10.16~
- Carthage or Cocoapods

# Install

## with Carthage

Add `github "fromkk/Valy"` to **Cartfile** and execute `carthage update` command on your terminal in project directory.  

Add **Carthage/Build/{Platform}/Valy.framework** to **Link Binary with Libralies** in you project.  
If you doesn't use Carthage, add **New Run Script Phase** and input `/usr/local/bin/carthage copy-frameworks` in **Build Phases** tab.  
Add `$(SRCROOT)/Carthage/Build/{Platform}/Valy.framework` to **Input Files**.

## with Cocoapods

Add `pod 'Valy'` to **Podfile** and run `pod install` command on your terminal in project directory.
Open `{YourProject}.xcworkspace` file.

# Usage

## Basic

```swift
import Valy

let value: String? = nil
let result = Valy.factory(rules: [ValyRule.required]).run(with: value)
switch result {
case .failure(let rule):
    switch rule {
    case ValyRule.required:
        print("value (\(value)) is required...")
    default:
        break
    }
default:
    print("value (\(value)) is successed!")
    break
}
```

## Add rule

```swift
Valy.factory().add(rule: ValyRule.required).add(rule: ValyRule.maxLength(10)).run(with: value)
```

## Text Field

```swift
let textField = VLTextField(frame: frame)
textField.add(rules: [
    ValyRule.required,
    ValyRule.maxLength(30)
])
textField.ovserveValidation { (status, result) in
    switch result {
    case .success:
        print("textField success")
    case .failure(let rule):
        print("failed \(rule)")
    }
}
```

## CustomRule

```swift
enum CustomValidatorRule: AnyValidatorRule {
    case email
    func run(with value: String?) -> Bool {
        switch self {
        case .email:
            return doYourEmailValidation()
        }
    }
}

Valy.factory().add(rule: CustomValidatorRule.email).run(with: value)
```
