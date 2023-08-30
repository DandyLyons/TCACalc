//
//  Decimal+Tests.swift
//  TCACalcTests
//
//  Created by Daniel Lyons on 7/17/23.
//

import XCTest
@testable import TCACalc

final class Decimal_Tests: XCTestCase {

  func testDecimalToTheNthPower() throws {
    var base = 3
    var power = 3
    XCTAssertEqual(Decimal(base).toTheNthPower(power), 27)
    base = 10
    power = -4
    XCTAssertEqual(Decimal(base).toTheNthPower(power), 0.0001)
    power = 4
    XCTAssertEqual(Decimal(base).toTheNthPower(power), 10_000)
    
  }
  
  func testDecimalAppend() throws {
    var base: Decimal = 1
    base.append(1)
    XCTAssertEqual(base, 11)
    base.append(4)
    XCTAssertEqual(base, 114)
    
    base = 0.1
    base.append(2)
    XCTAssertEqual(base, 0.12)
    base.append(9)
    XCTAssertEqual(base, 0.129)
    
    base = 0
    base.append(1)
    base.append(9)
    base.append(8)
    base.append(4)
    XCTAssertEqual(base, 1984)
    
    base = 3_000
    base.append(0)
    XCTAssertEqual(base, 30_000)
    base.append(7)
    XCTAssertEqual(base, 300_007)
    
    base = 0
    base.append(2)
    XCTAssertEqual(base, 2)
    base.append(0)
    XCTAssertEqual(base, 20)
    base.append(0)
    XCTAssertEqual(base, 200)
    base.append(0)
    XCTAssertEqual(base, 2000)
    
    base = 20.20
    base.append(3, afterZeroes: 1)
    XCTAssertEqual(base, 20.203)
    base.append(5, afterZeroes: 5)
    XCTAssertEqual(base, 20.203000005)
  }
  
  func testDecimalAppendDot() {
    var base: Decimal = 3
    base.append(dot: 1)
    XCTAssertEqual(base, 3.1)
    
    base = 0
    base.append(dot: 7)
    XCTAssertEqual(base, 0.7)
    
    base = 0
    base.append(dot: 2, afterZeroes: 2)
    XCTAssertEqual(base, 0.002)
    
    base = 100
    base.append(dot: 7)
    XCTAssertEqual(base, 100.7)
    
    base = 20
    base.append(dot:3, afterZeroes: 1)
    XCTAssertEqual(base, 20.03, accuracy: 0.00000000001)
    base.append(5, afterZeroes: 2)
    XCTAssertEqual(base, 20.03005, accuracy: 0.00000000001)
    
    
  }

}
