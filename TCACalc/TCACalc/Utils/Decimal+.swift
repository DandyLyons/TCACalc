//
//  Decimal+.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation

public extension Decimal {
  /// Mutates the `Decimal` in place as if the `Int` were appended to it.
  /// e.g. `(34.8).append(2)` would change the value to `34.82`
  ///  NOTE: `int` should only ever be a 1 digit, positive number
  ///  Doesn't currently work when self is a fraction and int is a 0
  mutating func append(_ int: Int) {
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
}

extension Int {
  init(truncatingIfNeeded decimal: Decimal) {
    self = decimal.rounded()
  }
}
