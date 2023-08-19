//
//  CalcScreenHorizontal.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture
import TCACalc_UI

struct CalcScreenHFeature: Reducer {
  struct State: Equatable {
    var currentNum: Decimal = 0
    var calcGridH: CalcGridHFeature.State
  }
  enum Action: Equatable {
    //    case internalAction
    
    // SUBVIEWS
    case calcGridH(CalcGridHFeature.Action)
    
    case view(View)
    enum View: Equatable {
      case onTapSettingsButton
    }
    case delegate(Delegate)
    enum Delegate: Equatable {
      case presentSettingsView
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

import SwiftUI

struct CalcScreenHorizontal: View {
  let store: StoreOf<CalcScreenHFeature>
  @Environment(\.colorScheme) var colorScheme
  
  struct ViewState: Equatable {
    let currentNum: Decimal
    
    init(state: CalcScreenHFeature.State) {
      self.currentNum = state.currentNum
    }
  }
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      
      ZStack {
        self.view(for: colorScheme, light: { Color.white }, dark: { Color.black })
          .ignoresSafeArea()
        
        VStack {
          HStack {
            Spacer()
            
            Text(viewStore.currentNum.formatted())
              .font(.system(size: 50, weight: .semibold, design: .default))
              .monospacedDigit()
              .foregroundStyle(.white)
              .preferredColorScheme(colorScheme.opposite)
              .textSelection(.enabled)
              .padding()
              .contentTransition(.numericText(countsDown: true)) // feature idea: set countsdown to match if the number is increasing/decreasing
              .animation(.snappy, value: viewStore.currentNum)
            
          }
          
          CalcGridH(store: self.store.scope(state: \.calcGridH,
                                            action: CalcScreenHFeature.Action.calcGridH)
          )
        }
        .padding(.horizontal)
        
        
        .overlay(alignment: .topLeading) {
          
          Button { viewStore.send(.view(.onTapSettingsButton))} label: {
            Image(systemName: "gear.circle.fill")
              .resizable()
              .frame(width: 40, height: 40)
              .padding(.top)
          }
          .padding([.leading])
          
        }
      }

    }
  }
}

#Preview("CalcScreenHorizontal", traits: .landscapeLeft) {
  CalcScreenHorizontal(store: .init(initialState: .init(calcGridH: .init()), reducer: {
    CalcScreenHFeature()
  }))
}
