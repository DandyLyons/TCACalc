//
//  CalcScreenHReducer.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture
import TCACalc_UI
import SwiftUI

struct CalcScreenHReducer: Reducer {
  struct State: Equatable {
    var currentNum: String = "0"
    var calcGridH: CalcGridHFeature.State
    var canRequestNumFact: Bool = true
  }
  enum Action: Equatable {
    
    // SUBVIEWS
    case calcGridH(CalcGridHFeature.Action)
    
    case view(View)
    enum View: Equatable {
      case onTapSettingsButton
      case onTapNumDisplay
      case onTapNumberFactsButton
    }
    case delegate(Delegate)
    enum Delegate: Equatable {
      case presentSettingsView
      case numDisplayTapped
      case requestNumFact
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
            case .onTapNumberFactsButton:
              return .run { send in
                await send(.delegate(.requestNumFact))
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


