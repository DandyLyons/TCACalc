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
struct Testables {
  static let blankCalcScreenStore = TestStore(
    initialState: CalcScreenFeature.State(
      hScreen: .init(calcGridH: .init()),
      vScreen: .init(calcGridV: .init())
    ),
    reducer: CalcScreenFeature()
  )
}

@MainActor
final class TCACalcTests: XCTestCase {
//  func testTypingNumbers() async {
//    let store = Testables.blankCalcScreenStore
//    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 1))))) {
//      $0.updateCurrentNum { $0 = 1 }
//      $0.updateIsInBlankState(byPerforming: { $0 = false })
//    }
//    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2))))) {
//      $0.updateCurrentNum { $0 = 12 }
//    }
//  }
  
  func test1Plus1() async {
    let store = Testables.blankCalcScreenStore
    
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
    await store.send(.vScreen(.calcGrid(.view(.onTapPlusButton)))) {
      $0.updateActiveOperation(to: .plus)
    }
    await store.send(.vScreen(.calcGrid(.view(.onTap(int: 1))))) {
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

}
