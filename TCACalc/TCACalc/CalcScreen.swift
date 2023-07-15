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
    
    /// to mutate `currentNum` use `updateCurrentNum(byPerforming: )`
    private(set) var currentNum: Decimal = 0
    
    
    mutating func updateCurrentNum(byPerforming mutation: (inout Decimal) -> Void) {
      mutation(&self.currentNum)
      mutation(&self.hScreen.currentNum)
      mutation(&self.vScreen.currentNum)
    }
    
    var previousNum: Decimal = 0
    private(set) var isInBlankState: Bool = true
    
    mutating func determineIfBlank () {
      if self.currentNum == 0,
         self.previousNum == 0 {
        self.updateIsInBlankState(byPerforming: { $0 = true})
      } else {
        self.updateIsInBlankState(byPerforming: { $0 = false})
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
              state.updateCurrentNum(byPerforming: { $0.append(int)})
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
            default:
              return .none
          }
          
        case let .hScreen(hScreenAction):
          return .none
      }
    }
    Reduce<State, Action> { state, action in
      state.determineIfBlank()
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

#Preview("CalcScreen") {
  CalcScreen(store: .init(initialState: .init(hScreen: .init(),
                                              vScreen: .init(calcGrid: .init()),
                                              currentOrientation: .portrait
                                             ),
                          reducer: {
    CalcScreenFeature()._printChanges()
  }))
}
