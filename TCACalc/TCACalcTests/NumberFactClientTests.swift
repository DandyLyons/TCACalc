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
    withDependencies: { _ in
//      $0
    }
  )
  
  func testTapNumDisplay() async {
    let store = ts
    store.exhaustivity = .off
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 5)))))
    await store.send(.vScreen(.view(.onTapNumberFactsButton)))
    await store.send(.vScreen(.delegate(.requestNumFact)))
    await store.receive(.factResponse("5 is a cool number")) {
      $0.presentation = .alert(.alert_numberFact("5 is a cool number"))
    }
    await store.send(.presentation(.dismiss))
    
    await store.send(.hScreen(.calcGridH(.view(.onTap(int: 4)))))
    await store.send(.hScreen(.view(.onTapNumberFactsButton)))
    await store.send(.hScreen(.delegate(.requestNumFact)))
    await store.receive(.factResponse("54 is a cool number")) {
      $0.presentation = .alert(.alert_numberFact("54 is a cool number"))
    }
    await store.send(.presentation(.dismiss))
  }
  
  
}
