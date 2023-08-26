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
    initialState: CalcScreenFeature.State(
      hScreen: .init(calcGridH: .init()),
      vScreen: .init(calcGridV: .init()),
      currentOrientation: .portrait,
      userSettings: .init()
    ),
    reducer: {
      CalcScreenFeature()
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
  
  func testPercentButton() async {
    let store = ts
    store.exhaustivity = .off(showSkippedAssertions: true)
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
  
  func test1Plus1() async {
    let store = ts
//        store.exhaustivity = .off(showSkippedAssertions: true)
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.currentOrientationChangedTo(.landscapeLeft)) {
      $0.currentOrientation = .landscapeLeft
    }
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 1))))) 
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "1"
      $0.hScreen.currentNum = "1"
      $0.vScreen.calcGridV.currentOperation = nil
    }
    
    await store.send(.currentOrientationChangedTo(.portrait)) {
      $0.currentOrientation = .portrait
    }
    await store.send(.hScreen(.calcGridH(.view(.onTapPlusButton))))
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.calcGridV.currentOperation = .plus
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 1))))) 
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.currentNum = "1"
      $0.hScreen.currentNum = "1"
      $0.vScreen.calcGridV.currentOperation = nil
    }
    await store.send(.currentOrientationChangedTo(.landscapeRight)) {
      $0.currentOrientation = .landscapeRight
    }
    await store.send(.hScreen(.calcGridH(.view(.onTapEqualButton)))) 
    await store.receive(.calculation(.delegate(.didFinishCalculating))) {
      $0.vScreen.calcGridV.currentOperation = nil
    }
  }

//  func testNegate() async {
//    let store = TestStore(
//      initialState: CalcScreenFeature.State(
//        hScreen: .init(calcGridH: .init()),
//        vScreen: .init(calcGridV: .init())
//      ),
//      reducer: CalcScreenFeature()
//    )
//    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3))))) {
//      $0.updateIsInBlankState(to: false)
//      $0.updateCurrentNum { $0 = 3 }
//    }
//    await store.send(.hScreen(.calcGridH(.view(.onTapNegateSignButton)))) {
//      $0.updateCurrentNum(byPerforming: { $0 = -3 })
//    }
//  }
//  
  
}
