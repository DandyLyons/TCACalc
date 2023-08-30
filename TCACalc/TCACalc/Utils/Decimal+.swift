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
  /// - Parameter afterZeroes: Only used if appending to a decimal with trailing zeroes after a decimal (e.g. `(20.2).append(3, afterZeroes: 3)` returns `20.20003`
  mutating func append(_ int: Int, afterZeroes leadingZeroes: UInt = 0) {
    guard (0...9).contains(int) else { XCTFail("Must be a value contained in 0...9"); return }
    
    var result: Decimal
    
    
    switch self.exponent {
        
        // all negative exponents
        // where Decimal is < 1
      case let exponent where exponent < 0:
        var appendable = Decimal(int)
        
        // the number of times we need to move the decimal place to the left before we can append
        // the int to self
        
        
        var decimalPlacesToTheLeft = abs(self.exponent - 1) + Int(leadingZeroes)
        while decimalPlacesToTheLeft > 0 {
          appendable /= 10
          decimalPlacesToTheLeft -= 1
        }
        self += appendable
        
        // exactly 0
      case 0:
        result = (self * 10) + Decimal(int)
        self = result
        return
        
        // all positive exponents
        // ?: where Decimal is > 10
      case let exponent where exponent > 0:
        guard int != 0 else {
          self *= 10
          return
        }
        let appendable = Decimal(int)
        
        // add this to self
        self = (self * 10) + appendable
      
      default:
        XCTFail("Decimal.append() encountered unexpected value")
        
    }
  }
  
  
  
  /// Mutates the `Decimal` in place as if the `Int` were appended to it after a "dot"
  /// e.g. `34.append(dot:8)` would change the value to `34.8`
  /// - Parameter int: should only ever be a 1 digit, positive number
  mutating func append(dot int: Int, afterZeroes leadingZeroes: UInt = 0) {
    guard (0...9).contains(int) else { XCTFail("Must be a value contained in 0...9"); return }
    guard self.isWholeNumber else {
      XCTFail("Decimal.append(dot:) should not be called Decimal is a whole number. User .append( ) instead.")
      return
    }
    var shifter = leadingZeroes
    
    while shifter > 0 {
      shifter -= 1
      self *= 10
    }
    
    self.append(int)
    while shifter < leadingZeroes {
      shifter += 1
      self /= 10
    }
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
