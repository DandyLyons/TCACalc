//
//  CalculationTests.swift
//  TCACalcTests
//
//  Created by Daniel Lyons on 8/25/23.
//

import XCTest
@testable import TCACalc
import ComposableArchitecture

@MainActor
final class NumberFactClientsTests: XCTestCase {
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
      $0.numberFact = .previewValue
    }
  )
  
  func testTapNumDisplay() async {
    let store = ts
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 5)))))
    await store.send(.vScreen(.view(.onTapNumDisplay)))
    await store.receive(.vScreen(.delegate(.numDisplayTapped)))
    await store.receive(.factResponse("5 is a cool number")) {
      $0.presentation = .alert(.alert_numberFact("5 is a cool number"))
    }
    await store.send(.presentation(.dismiss))
    
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 4)))))
    await store.send(.hScreen(.view(.onTapNumDisplay)))
    await store.receive(.hScreen(.delegate(.numDisplayTapped)))
    await store.receive(.factResponse("54 is a cool number")) {
      $0.presentation = .alert(.alert_numberFact("54 is a cool number"))
    }
    await store.send(.presentation(.dismiss))
    
    await store.send(.hScreen(.calcGridH(.view(.onTapDecimalButton))))
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 7))))) 
    await store.send(.hScreen(.view(.onTapNumDisplay))) 
    await store.receive(.hScreen(.delegate(.numDisplayTapped))) {
      $0.presentation = .alert(.alert_numberFactError_NotWholeNumber())
    }
  }
  
  
}
