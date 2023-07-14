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
        case let .hScreen(hScreenAction):
          return .none
        case let .vScreen(vScreenAction):
          return .none
        case let .currentOrientationChangedTo(newOrientation):
          state.currentOrientation = newOrientation
          return .none
      }
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
            CalcScreenHorizontal(
              store: self.store.scope(
                state: \.hScreen,
                action: CalcScreenFeature.Action.hScreen
              )
            )
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
  
}

#Preview("CalcScreen") {
  CalcScreen(store: .init(initialState: .init(hScreen: .init(),
                                              vScreen: .init(calcGrid: .init()),
                                              currentOrientation: .portrait
                                             ),
                          reducer: {
    CalcScreenFeature()
  }))
}
