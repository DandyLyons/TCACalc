//
//  CalcScreenVReducer.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import ComposableArchitecture
import TCACalc_UI
import SwiftUI

struct CalcScreenVReducer: Reducer {
  struct State: Equatable {
    
    var currentOperationButton: OperationButton = .none
    enum OperationButton {
      case divide, multiply, minus, plus, equal, none
    }
    var currentNum: String = "0"
    
    var calcGridV: CalcGridVFeature.State
    var canRequestNumFact: Bool = true
    var a11yFocus: A11yFocus?
    enum A11yFocus: Hashable { case numDisplay }
    
  }
  enum Action: Equatable {
    
    // SUBVIEWS
    case calcGridV(CalcGridVFeature.Action)
    
    case view(ViewAction)
    enum ViewAction: Equatable {
      case onTapSettingsButton
      case onTapNumDisplay
      case onTapNumberFactsButton
      
      case a11yFocusChanged(CalcScreenVReducer.State.A11yFocus?)
      
      case onAppear
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
              return .run { send in
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
            case .onAppear:
              state.a11yFocus = .numDisplay
              return .none
            case .a11yFocusChanged(let newFocus):
              state.a11yFocus = newFocus
              return .none
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





