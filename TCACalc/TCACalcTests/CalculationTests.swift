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
final class CalculationTests: XCTestCase {
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
  
  func test34timesequalEqualEqual() async {
    let store = ts
//    store.exhaustivity = .off(showSkippedAssertions: true)
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3)))))
    await store.receive(.calculation(.input(.int(3)))) {
      $0.calculation.num1 = 3
      $0.calculation.status = .t_from_initial
      $0.calculation.display = .num1
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 4)))))
    await store.receive(.calculation(.input(.int(4)))) {
      $0.calculation.num1 = 34
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapMultiplyButton))))
    await store.receive(.calculation(.input(.operation(.multiply)))) {
      $0.calculation.op1 = .multiply
      $0.calculation.status = .transition
      $0.calculation.num2 = $0.calculation.num1
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapEqualButton))))
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.status = .equal
      $0.calculation.num1 = 34 * 34 // 1,156
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapEqualButton))))
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.status = .equal
      $0.calculation.num1 = 1_156 * 34  // 39_304
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapEqualButton))))
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.status = .equal
      $0.calculation.num1 = 39_304 * 34 // 1_336_336
    }
  }
  
  func test1plus2minus3() async {
    let store = ts
//        store.exhaustivity = .off(showSkippedAssertions: true)
    store.exhaustivity = .off(showSkippedAssertions: false)
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 1)))))
    await store.receive(.calculation(.input(.int(1)))) {
      $0.calculation.num1 = 1
      $0.calculation.status = .t_from_initial
      $0.calculation.display = .num1
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapPlusButton))))
    await store.receive(.calculation(.input(.operation(.plus)))) {
      $0.calculation.op1 = .plus
      $0.calculation.status = .transition
      $0.calculation.num2 = $0.calculation.num1
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2)))))
    await store.receive(.calculation(.input(.int(2)))) {
      $0.calculation.num2 = 2
      $0.calculation.status = .t_from_transition
      $0.calculation.display = .num2
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapMinusButton))))
    await store.receive(.calculation(.input(.operation(.minus)))) {
      $0.calculation.op1 = .minus
      $0.calculation.status = .transition
      $0.calculation.display = .num1
      $0.calculation.num1 = 3
      $0.calculation.num2 = $0.calculation.num1
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3)))))
    await store.receive(.calculation(.input(.int(3)))) {
      $0.calculation.status = .t_from_transition
      $0.calculation.num2 = 3
      $0.calculation.display = .num2
      
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapEqualButton))))
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.status = .equal
      $0.calculation.display = .num1
      $0.calculation.num1 = 0
    }
  }
  
  func test23plus34times56() async {
    let store = ts
    
//    store.exhaustivity = .off(showSkippedAssertions: true)
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2)))))
    await store.receive(.calculation(.input(.int(2)))) {
      $0.calculation.num1 = 2
      $0.calculation.status = .t_from_initial
      $0.calculation.display = .num1
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3)))))
    await store.receive(.calculation(.input(.int(3)))) {
      $0.calculation.num1 = 23
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapPlusButton))))
    await store.receive(.calculation(.input(.operation(.plus)))) {
      $0.calculation.op1 = .plus
      $0.calculation.status = .transition
      $0.calculation.num2 = $0.calculation.num1
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3)))))
    await store.receive(.calculation(.input(.int(3)))) {
      $0.calculation.num2 = 3
      $0.calculation.status = .t_from_transition
      $0.calculation.display = .num2
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 4)))))
    await store.receive(.calculation(.input(.int(4)))) {
      $0.calculation.num2 = 34
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapMultiplyButton))))
    await store.receive(.calculation(.input(.operation(.multiply)))) {
      $0.calculation.op2 = .multiply
      $0.calculation.status = .trailing
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 5)))))
    await store.receive(.calculation(.input(.int(5)))) {
      $0.calculation.num3 = 5
      $0.calculation.status = .t_from_trailing
      $0.calculation.display = .num3
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 6)))))
    await store.receive(.calculation(.input(.int(6)))) {
      $0.calculation.num3 = 56
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapEqualButton))))
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.status = .equal
      $0.calculation.num2 = 34 * 56
      $0.calculation.num1 = 23 + (34 * 56)
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapEqualButton))))
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.num1 = 1927 + 1904
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapACButton))))
    await store.receive(.calculation(.input(.reset))) {
      $0.calculation.status = .t_from_initial
      $0.calculation.num1 = 0
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapACButton))))
    await store.receive(.calculation(.input(.reset))) {
      $0.calculation.status = .initial
      $0.calculation.num1 = 0
      $0.calculation.op1 = nil
      $0.calculation.num2 = 0
      $0.calculation.op2 = nil
      $0.calculation.num3 = 0
      $0.calculation.display = .num1
    }
  }
  
}
