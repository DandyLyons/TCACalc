//
//  TCACalcTests.swift
//  TCACalcTests
//
//  Created by Daniel Lyons on 7/13/23.
//

import XCTest
@testable import TCACalc

final class TCACalcTests: XCTestCase {
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
  }

}
