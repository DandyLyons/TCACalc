//
//  CalcScreen.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture

struct CalcScreenFeature: ReducerProtocol {
  struct State: Equatable {
    var hScreen: CalcScreenHorizontalFeature.State
    var vScreen: CalcScreenVerticalFeature.State
    
    var currentOrientation = UIDeviceOrientation.portrait
    
    private(set) var activeOperation: ActiveOperation? = nil
    enum ActiveOperation { case divide, multiply, minus, plus }
    
    /// to mutate `currentNum` use `updateCurrentNum(byPerforming: )`
    private(set) var currentNum: Decimal = 0
    
    
    mutating func updateCurrentNum(byPerforming mutation: (inout Decimal) -> Void) {
      mutation(&self.currentNum)
      mutation(&self.hScreen.currentNum)
      mutation(&self.vScreen.currentNum)
    }
    
    mutating func updateActiveOperation(to newValue: ActiveOperation?) {
      self.activeOperation = newValue
      switch newValue {
        case .divide:
          self.hScreen.calcGridH.turnDivideOn()
          self.vScreen.calcGrid.turnDivideOn()
        case .multiply:
          self.hScreen.calcGridH.turnMultiplyOn()
          self.vScreen.calcGrid.turnMultiplyOn()
        case .minus:
          self.hScreen.calcGridH.turnMinusOn()
          self.vScreen.calcGrid.turnMinusOn()
        case .plus:
          self.hScreen.calcGridH.turnPlusOn()
          self.vScreen.calcGrid.turnPlusOn()
        case nil:
          self.hScreen.calcGridH.turnAllOff()
          self.vScreen.calcGrid.turnAllOff()
      }
    }
    
    mutating func _performArithmetic() {
      guard let activeOperation,
            let previousNum else {
        return
      }
      let result: Decimal
      
      switch activeOperation {
          
        case .divide:
          result = previousNum / self.currentNum
        case .multiply:
          result = previousNum * self.currentNum
        case .minus:
          result = previousNum - self.currentNum
        case .plus:
          result = previousNum + self.currentNum
      }
      self.previousNum = self.currentNum
      self.updateCurrentNum(byPerforming: { $0 = result})
    }
    
    var previousNum: Decimal? = nil
    private(set) var isInBlankState: Bool = true
    
    mutating func determineIfInBlankState () {
      if self.currentNum == 0,
         self.previousNum == nil {
        self.updateIsInBlankState(byPerforming: { $0 = true })
      } else {
        self.updateIsInBlankState(byPerforming: { $0 = false })
      }
    }
    
    mutating func updateIsInBlankState(byPerforming mutation: (inout Bool) -> Void) {
      mutation(&self.isInBlankState)
      mutation(&self.vScreen.calcGrid.isInBlankState)
    }

  }
  enum Action: Equatable {
    //    case internalAction
    
    case hScreen(CalcScreenHorizontalFeature.Action)
    case vScreen(CalcScreenVerticalFeature.Action)
    
    case currentOrientationChangedTo(UIDeviceOrientation)
    
    case view(View)
    enum View: Equatable {
      //      case viewAction
    }
    case delegate(Delegate)
    enum Delegate: Equatable {
      //      case delegateAction
    }
    
    
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        case let .currentOrientationChangedTo(newOrientation):
          state.currentOrientation = newOrientation
          return .none
          
          // SPYING ON SUBVIEWS
        case let .vScreen(.calcGrid(calcGridAction)):
          switch calcGridAction {
            case .view(.onTap(int: let int)):
              if state.isInBlankState {
                state.updateCurrentNum(byPerforming: { $0.append(int)})
              } else {
                state.previousNum = state.currentNum
                state.updateCurrentNum(byPerforming: { $0 = Decimal(int) })
              }
              return .none
            case .view(.onTapACButton):
              state.updateCurrentNum(byPerforming: { $0 = 0})
              state.previousNum = nil
              state.updateIsInBlankState(byPerforming: { $0 = true })
              return .none
            case .view(.onTapPercentButton):
              state.updateCurrentNum(byPerforming: { $0 /= 100 })
              return .none
            case .view(.onTapNegateSignButton):
              state.updateCurrentNum(byPerforming: { $0 *= -1 })
              return .none
              
            case .view(.onTapDivideButton):
              state.updateActiveOperation(to: .divide)
              return .none
            case .view(.onTapMultiplyButton):
              state.updateActiveOperation(to: .multiply)
              return .none
            case .view(.onTapMinusButton):
              state.updateActiveOperation(to: .minus)
              return .none
            case .view(.onTapPlusButton):
              state.updateActiveOperation(to: .plus)
              return .none
              
            case .view(.onTapEqualButton):
              state._performArithmetic()
              return .none
            default:
              return .none
          }
          
        case let .hScreen(.calcGridH(hCalcGridAction)):
          switch hCalcGridAction {
            case .view(.onTap(int: let int)):
              if state.isInBlankState {
                state.updateCurrentNum(byPerforming: { $0.append(int)})
              }
              return .none
            case .view(.onTapACButton):
              state.updateCurrentNum(byPerforming: { $0 = 0})
              return .none
            case .view(.onTapPercentButton):
              state.updateCurrentNum(byPerforming: { $0 /= 100 })
              return .none
            case .view(.onTapNegateSignButton):
              state.updateCurrentNum(byPerforming: { $0 *= -1 })
              return .none
            case .view(.onTapEqualButton):
              state._performArithmetic()
              return .none
            default:
              return .none
              
          }
      }
    }
    Reduce<State, Action> { state, action in
      state.determineIfInBlankState()
      return .none
    }
    
    Scope(state: \.hScreen, action: /Action.hScreen) {
      CalcScreenHorizontalFeature()
    }
    Scope(state: \.vScreen, action: /Action.vScreen) {
      CalcScreenVerticalFeature()
    }
  }
}

import SwiftUI

struct CalcScreen: View {
  let store: StoreOf<CalcScreenFeature>
  @State private var currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Group {
        switch viewStore.currentOrientation {
          case .portrait, .portraitUpsideDown,.faceDown, .faceUp:
            self.vScreen
          case .landscapeLeft, .landscapeRight:
            self.hScreen
          case .unknown:
            // TODO: Delete this
            self.vScreen
              .onAppear { print("Something is broken") }
            
          @unknown default:
            self.vScreen
              .onAppear { print("Something is broken") }
        }
      }
      .onAppear {
        viewStore.send(.currentOrientationChangedTo(UIDeviceOrientation.portrait))
      }
      .onRotate { newOrientation in
        viewStore.send(.currentOrientationChangedTo(newOrientation))
      }
    }
  }
  
  var vScreen: some View {
    CalcScreenVertical(
      store: self.store.scope(
        state: \.vScreen,
        action: CalcScreenFeature.Action.vScreen
      )
    )
  }
  
  var hScreen: some View {
    CalcScreenHorizontal(
      store: self.store.scope(
        state: \.hScreen,
        action: CalcScreenFeature.Action.hScreen
      )
    )
  }
  
}

//#Preview("CalcScreen H"
//         , traits: .landscapeLeft
//) {
//  CalcScreen(store: .init(initialState: .init(hScreen: .init(calcGridH: .init()),
//                                              vScreen: .init(calcGrid: .init()),
//                                              currentOrientation: .landscapeLeft
//                                             ),
//                          reducer: {
//    CalcScreenFeature()._printChanges()
//  }))
//}

#Preview("CalcScreen V"
) {
  CalcScreen(store: .init(initialState: .init(hScreen: .init(calcGridH: .init()),
                                              vScreen: .init(calcGrid: .init()),
                                              currentOrientation: .portrait
                                             ),
                          reducer: {
    CalcScreenFeature()._printChanges()
  }))
}
