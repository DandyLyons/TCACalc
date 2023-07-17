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
  func testTypingNumbers() async {
    let store = TestStore(
      initialState: CalcScreenFeature.State(
        hScreen: .init(calcGridH: .init()),
        vScreen: .init(calcGridV: .init())
      ),
      reducer: CalcScreenFeature()
    )
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 1))))) {
      $0.updateCurrentNum { $0 = 1 }
      $0.updateIsInBlankState(byPerforming: { $0 = false })
    }
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 2))))) {
      $0.updateCurrentNum { $0 = 12}
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3))))) {
      $0.updateCurrentNum { $0 = 123 }
    }
  }
  
  func test1Plus1() async {
    let store = TestStore(
      initialState: CalcScreenFeature.State(
        hScreen: .init(calcGridH: .init()),
        vScreen: .init(calcGridV: .init())
      ),
      reducer: CalcScreenFeature()
    )
    
    await store.send(.currentOrientationChangedTo(.landscapeLeft)) {
      $0.currentOrientation = .landscapeLeft
    }
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 1))))) {
      $0.updateCurrentNum(byPerforming: { $0 = 1 })
      $0.updateIsInBlankState(byPerforming: { $0 = false })
    }
    await store.send(.currentOrientationChangedTo(.portrait)) {
      $0.currentOrientation = .portrait
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapPlusButton)))) {
      $0.updateActiveOperation(to: .plus)
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 1))))) {
      $0.updateCurrentNum(byPerforming: { $0 = 1 })
      $0.previousNum = 1
    }
    await store.send(.currentOrientationChangedTo(.landscapeRight)) {
      $0.currentOrientation = .landscapeRight
    }
    await store.send(.hScreen(.calcGridH(.view(.onTapEqualButton)))) {
      $0.updateCurrentNum(byPerforming: { $0 = 2 })
      $0.updateActiveOperation(to: nil)
    }
  }

  func testNegate() async {
    let store = TestStore(
      initialState: CalcScreenFeature.State(
        hScreen: .init(calcGridH: .init()),
        vScreen: .init(calcGridV: .init())
      ),
      reducer: CalcScreenFeature()
    )
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3))))) {
      $0.updateIsInBlankState(to: false)
      $0.updateCurrentNum { $0 = 3 }
    }
    await store.send(.hScreen(.calcGridH(.view(.onTapNegateSignButton)))) {
      $0.updateCurrentNum(byPerforming: { $0 = -3 })
    }
  }
  
  func testPercentButton() async {
    let store = TestStore(
      initialState: CalcScreenFeature.State(
        hScreen: .init(calcGridH: .init()),
        vScreen: .init(calcGridV: .init())
      ),
      reducer: CalcScreenFeature()
    )
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 9))))) {
      $0.updateCurrentNum(byPerforming: { $0 = 9 })
      $0.updateIsInBlankState(to: false)
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapPercentButton)))) {
      $0.updateCurrentNum(byPerforming: { $0 = 0.09 })
    }
  }
}
