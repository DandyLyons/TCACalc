//
//  Decimal+.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import XCTestDynamicOverlay

public extension Decimal {
  /// Mutates the `Decimal` in place as if the `Int` were appended to it.
  /// e.g. `(34.8).append(2)` would change the value to `34.82`
  ///  NOTE: Doesn't currently work when self is a fraction and int is a 0
  /// - Parameter int: should only ever be a 1 digit, positive number
  mutating func append(_ int: Int) {
    guard (0...9).contains(int) else { XCTFail("Must be a value contained in 0...9"); return }
    
    var result: Decimal
    
    // find out where the decimal place of self is
    guard self.exponent != 0 else {
      result = (self * 10) + Decimal(int)
      self = result
      return
    }
    let decimalPlace = self.exponent - 1
    
    // multiply `int` by the appropriate power of ten and assign it to "appendable"
    let appendable = Decimal(int) * (Decimal(10).toTheNthPower(decimalPlace))
    
    // add this to self
    self += appendable
  }
  
  /// Mutates the `Decimal` in place as if the `Int` were appended to it after a "dot"
  /// e.g. `34.append(dot:8)` would change the value to `34.8`
  /// - Parameter int: should only ever be a 1 digit, positive number
  mutating func append(dot int: Int) {
    guard (0...9).contains(int) else { XCTFail("Must be a value contained in 0...9"); return }
    let decimalPlace = self.exponent - 1
    
    // Divide the current Decimal by 10 raised to the power of the current decimalPlace
    let factor = Decimal(10).toTheNthPower(decimalPlace)
    self /= factor
    
    // Add the new decimal digit to the right of the current value
    self += Decimal(int) / Decimal(10).toTheNthPower(decimalPlace + 1)
    self /= 10
  }
  
  func toTheNthPower(_ exponent: Int) -> Decimal {
    switch exponent {
      case 0:
        return 1
      case 0...Int.max:
        return pow(self, exponent)
      case Int.min...0:
        
        return Decimal(1) / pow(self, -exponent)
      default:
        print("Unexpected input in toTheNthPower")
        return 1
    }
  }
}

extension Decimal {
  /// returns a Decimal rounded to the nearest integer
  func rounded(scale: Int = 0, roundingMode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
    var result = Decimal()
    var source = self
    NSDecimalRound(&result, &source, scale, roundingMode)
    return result
  }
  
  func rounded() -> Int {
    let decimal: Decimal = self.rounded()
    let double: Double = NSDecimalNumber(decimal: decimal).doubleValue
    return Int(double)
  }
  
  var isWholeNumber: Bool {
    let intValue = NSDecimalNumber(decimal: self).intValue
    let decimalValue = Decimal(intValue)
    return decimalValue == self
  }
}

extension Int {
  init(truncatingIfNeeded decimal: Decimal) {
    self = decimal.rounded()
  }
}
