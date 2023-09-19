//
//  TCACalcTests.swift
//  TCACalcTests
//
//  Created by Daniel Lyons on 7/13/23.
//

import XCTest
@testable import TCACalc
import ComposableArchitecture



@MainActor
final class TCACalcTests: XCTestCase {
  let ts = TestStore(
    initialState: CalcScreenReducer.State(
      hScreen: .init(calcGridH: .init()),
      vScreen: .init(calcGridV: .init()),
      userSettings: .init()
    ),
    reducer: {
      CalcScreenReducer()
    },
    withDependencies: {
      $0.decode = .json
    }
  )
  
  func testTypingNumbers() async {
    let store = ts
//    store.exhaustivity = .off(showSkippedAssertions: true)
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 1)))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "1"
    }
    
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 2)))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "12"
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3))))) 
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "123"
    }
  }
  
  func testTypeDecimals() async {
    let store = ts
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0"
      $0.hScreen.currentNum = "0"
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapDecimalButton))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0."
      $0.hScreen.currentNum = "0."
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0.0"
      $0.hScreen.currentNum = "0.0"
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 5)))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0.05"
      $0.hScreen.currentNum = "0.05"
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0.050"
      $0.hScreen.currentNum = "0.050"
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 9)))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0.0509"
      $0.hScreen.currentNum = "0.0509"
    }
  }
  
  func testPercentButton() async {
    let store = ts
    store.exhaustivity = .off(showSkippedAssertions: false)
    //    store.exhaustivity = .off(showSkippedAssertions: false)
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 9)))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "9"
      $0.hScreen.currentNum = "9"
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapPercentButton))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0.09"
      $0.hScreen.currentNum = "0.09"
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapPercentButton))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0.0009"
      $0.hScreen.currentNum = "0.0009"
    }
  }
  
  func test1Plus2() async {
    let store = ts
        store.exhaustivity = .on
    
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 1))))) 
    await store.receive(.calculation(.input(.int(1)))) {
      $0.calculation.num1 = 1
      $0.calculation.status = .t_from_initial
    }
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "1"
      $0.hScreen.currentNum = "1"
      $0.vScreen.calcGridV.isInBlankState = false
      $0.hScreen.calcGridH.isInBlankState = false
    }
    
    
    await store.send(.hScreen(.calcGridH(.view(.onTapPlusButton))))
    await store.receive(.calculation(.input(.operation(.plus)))) {
      $0.calculation.status = .transition
      $0.calculation.num2 = 1
      $0.calculation.op1 = .plus
    }
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.calcGridV.currentOperation = .plus
      $0.hScreen.calcGridH.currentOperation = .plus
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2)))))
    await store.receive(.calculation(.input(.int(2)))) {
      $0.calculation.status = .t_from_transition
      $0.calculation.num2 = 2
    }
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "2"
      $0.hScreen.currentNum = "2"
      $0.vScreen.calcGridV.currentOperation = nil
      $0.hScreen.calcGridH.currentOperation = nil
    }
    
    await store.send(.hScreen(.calcGridH(.view(.onTapEqualButton))))
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.status = .equal
      $0.calculation.num1 = 3
    }
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.calcGridV.currentOperation = nil
      $0.hScreen.calcGridH.currentOperation = nil
      $0.vScreen.currentNum = "3"
      $0.hScreen.currentNum = "3"
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapACButton))))
    await store.receive(.calculation(.input(.reset))) {
      $0.calculation.status = .t_from_initial
      $0.calculation.num1 = 0
    }
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "0"
      $0.hScreen.currentNum = "0"
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapACButton))))
    await store.receive(.calculation(.input(.reset))) {
      $0.calculation.status = .initial
    }
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.calcGridV.isInBlankState = true
      $0.hScreen.calcGridH.isInBlankState = true
    }
  }

  // tests the negate button if it is pressed after the number
  func testNegateAfter() async {
    let store = ts
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3))))) 
    await store.receive(.calculation(.input(.int(3)))) {
      $0.calculation.num1 = 3
    }
    await store.send(.hScreen(.calcGridH(.view(.onTapNegateSignButton)))) 
    await store.receive(.calculation(.input(.negate))) {
      $0.calculation.num1 = -3
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapPlusButton))))
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 5)))))
    await store.send(.hScreen(.calcGridH(.view(.onTapNegateSignButton))))
    await store.receive(.calculation(.input(.negate))) {
      $0.calculation.num2 = -5
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapMultiplyButton))))
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2)))))
    await store.send(.hScreen(.calcGridH(.view(.onTapNegateSignButton))))
    await store.receive(.calculation(.input(.negate))) {
      $0.calculation.num3 = -2
    }
    
  }
  
//  // tests the negate button if it is pressed before the number
//  func testNegateBefore() async {
//    let store = ts
//    store.exhaustivity = .off(showSkippedAssertions: true)
//    //    store.exhaustivity = .off(showSkippedAssertions: false)
//    
//    await store.send(.hScreen(.calcGridH(.view(.onTapNegateSignButton))))
//    await store.receive(.calculation(.input(.negate))) {
//      $0.calculation.num1 = -3
//    }
//    // assert negative 0
//    
//    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3)))))
//    await store.receive(.calculation(.input(.int(3)))) {
//      $0.calculation.num1 = 3
//    }
//    await store.send(.vScreen(.calcGridV(.view(.onTapPlusButton))))
//    await store.send(.hScreen(.calcGridH(.view(.onTapNegateSignButton))))
//    // assert negative 0
//    
//    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 5)))))
//    await store.receive(.calculation(.input(.negate))) {
//      $0.calculation.num2 = -5
//    }
//    await store.send(.vScreen(.calcGridV(.view(.onTapMultiplyButton))))
//    await store.send(.hScreen(.calcGridH(.view(.onTapNegateSignButton))))
//    // assert negative 0
//    
//    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2)))))
//    await store.receive(.calculation(.input(.negate))) {
//      $0.calculation.num3 = -2
//    }
//    
//  }
  
  
}
