//
//  CalcScreenHReducer.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture
import TCACalc_UI

struct CalcScreenHReducer: Reducer {
  struct State: Equatable {
    var currentNum: String = "Not initialized"
    var calcGridH: CalcGridHFeature.State
  }
  enum Action: Equatable {
    
    // SUBVIEWS
    case calcGridH(CalcGridHFeature.Action)
    
    case view(View)
    enum View: Equatable {
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
              return .run{ send in
                await send(.delegate(.presentSettingsView))
              }
              
            case .onTapNumDisplay:
              return .run { send in
                await send(.delegate(.numDisplayTapped))
              }
          }
          
          // Reducers should not be responding to their own delegate calls
        case .delegate: return .none
          
          // SPYING ON SUBVIEWS
        case .calcGridH:
          return .none
      }
    }
    Scope(state: \.calcGridH, action: /Action.calcGridH) {
      CalcGridHFeature()
    }
    
  }
}


