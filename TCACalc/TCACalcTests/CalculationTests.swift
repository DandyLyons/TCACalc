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
    initialState: CalcScreenReducer.State(
      hScreen: .init(calcGridH: .init()),
      vScreen: .init(calcGridV: .init()),
      currentOrientation: .portrait,
      userSettings: .init()
    ),
    reducer: {
      CalcScreenReducer()
    },
    withDependencies: {
      $0.decode = .json
    }
  )
  
  func testPercent() async {
    let store = ts
            store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 1)))))
    await store.receive(.calculation(.input(.int(1)))) {
      $0.calculation.num1 = 1
      $0.calculation.status = .t_from_initial
      $0.calculation.display = .num1
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapPercentButton))))
    await store.receive(.calculation(.input(.toPercent))) {
      $0.calculation.num1 = 0.01
    }
    
    await store.send(.vScreen(.calcGridV(.view(.onTapPercentButton))))
    await store.receive(.calculation(.input(.toPercent))) {
      $0.calculation.num1 = 0.0001
    }
  }
  
  func test34timesEqualEqualEqual() async {
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
  
  func test2000minus1000() async {
    let store = ts
    
//        store.exhaustivity = .off(showSkippedAssertions: true)
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2)))))
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0))))) 
    await store.receive(.calculation(.input(.int(0)))) {
      $0.calculation.num1 = 2000
      $0.calculation.status = .t_from_initial
      $0.calculation.display = .num1
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapMinusButton)))) 
    await store.receive(.calculation(.input(.operation(.minus)))) {
      $0.calculation.status = .transition
      $0.calculation.op1 = .minus
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 1))))) 
    await store.receive(.calculation(.input(.int(1)))) {
      $0.calculation.status = .t_from_transition
      $0.calculation.num2 = 1
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0))))) 
    await store.receive(.calculation(.input(.int(0)))) {
      $0.calculation.num2 = 1000
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapEqualButton)))) 
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.status = .equal
    }
  }
  
  func test30point47times20point203() async {
    let store = ts
    
//    store.exhaustivity = .off(showSkippedAssertions: true)
        store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.receive(.calculation(.input(.int(0)))) {
      $0.calculation.num1 = 0
      $0.calculation.status = .initial
      $0.calculation.buffer.trailingZeroesAfterDecimal = 0
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3)))))
    await store.receive(.calculation(.input(.int(3)))) {
      $0.calculation.num1 = 3
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0))))) 
    await store.receive(.calculation(.input(.int(0)))) {
      $0.calculation.num1 = 30
      $0.calculation.buffer.trailingZeroesAfterDecimal = 0
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapDecimalButton)))) 
    await store.receive(.calculation(.input(.decimal))) {
      $0.calculation.buffer.isDecimalOn = true
      $0.calculation.buffer.trailingZeroesAfterDecimal = 0
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 4))))) 
    await store.receive(.calculation(.input(.int(4)))) {
      $0.calculation.num1 = 30.4
      $0.calculation.buffer.isDecimalOn = false
      $0.calculation.buffer.trailingZeroesAfterDecimal = 0
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 7))))) 
    await store.receive(.calculation(.input(.int(7)))) {
      $0.calculation.num1 = 30.47
      $0.calculation.buffer.trailingZeroesAfterDecimal = 0
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapMultiplyButton)))) 
    await store.receive(.calculation(.input(.operation(.multiply)))) {
      $0.calculation.status = .transition
      $0.calculation.op1 = .multiply
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2))))) 
    await store.receive(.calculation(.input(.int(2)))) {
      $0.calculation.status = .t_from_transition
      $0.calculation.num2 = 2
      $0.calculation.buffer.trailingZeroesAfterDecimal = 0
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0)))))
    await store.receive(.calculation(.input(.int(0)))) {
      $0.calculation.num2 = 20
      $0.calculation.buffer.trailingZeroesAfterDecimal = 0
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapDecimalButton)))) 
    await store.receive(.calculation(.input(.decimal))) {
      $0.calculation.buffer.isDecimalOn = true
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 2))))) 
    await store.receive(.calculation(.input(.int(2)))) {
      $0.calculation.buffer.isDecimalOn = false
      $0.calculation.num2 = 20.2
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 0))))) 
    await store.receive(.calculation(.input(.int(0)))) {
      $0.calculation.num2 = 20.20
      $0.calculation.buffer.isDecimalOn = false
    }
    await store.send(.vScreen(.calcGridV(.view(.onTap(int: 3))))) 
    await store.receive(.calculation(.input(.int(3)))) {
      $0.calculation.num2 = 20.203
    }
    await store.send(.vScreen(.calcGridV(.view(.onTapEqualButton)))) 
    await store.receive(.calculation(.input(.equals))) {
      $0.calculation.status = .equal
      $0.calculation.display = .num1
    }
    XCTAssertEqual(store.state.calculation.num1, 615.58541, accuracy: 0.000001)
  }
  
  func test20point03005() async {
    let calcStore = TestStore(
      initialState: CalculationReducer.State(),
      reducer: { CalculationReducer() }
    )
    calcStore.exhaustivity = .off(showSkippedAssertions: false)
    
    await calcStore.send(.input(.int(2))) {
      $0.num1 = 2
      $0.status = .t_from_initial
    }
    await calcStore.send(.input(.int(0))) {
      $0.num1 = 20
      $0.buffer.trailingZeroesAfterDecimal = 0
    }
    await calcStore.send(.input(.decimal)) {
      $0.buffer.isDecimalOn = true
    }
    await calcStore.send(.input(.int(0))) {
      $0.buffer.trailingZeroesAfterDecimal = 1
//      $0.isDecimalOn = false
    }
    await calcStore.send(.input(.int(3))) {
      $0.num1 = 20.03
      $0.buffer.trailingZeroesAfterDecimal = 0
    }
    await calcStore.send(.input(.int(0))) {
      $0.buffer.trailingZeroesAfterDecimal = 1
    }
    await calcStore.send(.input(.int(0))) {
      $0.buffer.trailingZeroesAfterDecimal = 2
    }
    await calcStore.send(.input(.int(5))) {
      $0.buffer.trailingZeroesAfterDecimal = 0
//      $0.num1 = 20.03005 // does not equal 20.03005000000000512,
      // 👆🏼 fails the test
    }
    XCTAssertEqual(calcStore.state.num1, 20.03005, accuracy: 0.00001)
    // 👆🏼 this is okay as a workaround
    // but only if using non-exhaustive tests
  }
  
  func testReset() {
    // call reset within every status
    let store = ts
    
    store.exhaustivity = .off(showSkippedAssertions: true)
    //    store.exhaustivity = .off(showSkippedAssertions: false)
    
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
