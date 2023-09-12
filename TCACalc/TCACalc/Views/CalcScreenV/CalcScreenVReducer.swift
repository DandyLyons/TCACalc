//
//  CalcScreenVReducer.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import ComposableArchitecture
import TCACalc_UI

struct CalcScreenVReducer: Reducer {
  struct State: Equatable {
    
    var currentOperationButton: OperationButton = .none
    enum OperationButton {
      case divide, multiply, minus, plus, equal, none
    }
    var currentNum: String = "Not initialized"
    
    var calcGridV: CalcGridVFeature.State
    
  }
  enum Action: Equatable {
    
    // SUBVIEWS
    case calcGridV(CalcGridVFeature.Action)
    
    case view(ViewAction)
    enum ViewAction: Equatable {
      case onTapSettingsButton
      case onTapNumDisplay
      }
    case delegate(Delegate)
    enum Delegate: Equatable {
      case presentSettingsView
      case numDisplayTapped
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        case let .view(viewAction):
          switch viewAction {
            case .onTapSettingsButton:
              return .run { send in
                await send(.delegate(.presentSettingsView))
              }
            case .onTapNumDisplay:
              return .run { send in
                  await send(.delegate(.numDisplayTapped))
              }
          }
          
  // Reducer should not be responding to its own delegate calls.
        case .delegate:
          return .none
          
          // SPYING ON SUBVIEWS
        case .calcGridV:
          return .none
      }
    }
    
    Scope(state: \.calcGridV, action: /Action.calcGridV) {
      CalcGridVFeature()
    }
  }
}





