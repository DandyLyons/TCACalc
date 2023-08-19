//
//  CalcScreenVFeature.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import ComposableArchitecture

struct CalcScreenVFeature: Reducer {
  struct State: Equatable {
    
    var currentOrangeButton: CurrentOrangeButton = .none
    enum CurrentOrangeButton {
      case divide, multiply, minus, plus, equal, none
    }
    var currentNum: Decimal = 0
    
    var calcGridV: CalcGridVFeature.State
    
  }
  enum Action: Equatable {
    //    case internalAction
    
    // SUBVIEWS
    case calcGridV(CalcGridVFeature.Action)
    
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
              return .run { send in
                await send(.delegate(.presentSettingsView))
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

import SwiftUI
import TCACalc_UI



struct CalcScreenVertical: View {
  let store: StoreOf<CalcScreenVFeature>
  @Environment(\.colorScheme) var colorScheme
  
  struct ViewState: Equatable {
    let currentNum: Decimal
    
    init(state: CalcScreenVFeature.State) {
      self.currentNum = state.currentNum
    }
  }
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      ZStack {
        self.view(for: colorScheme, light: { Color.white }, dark: { Color.black })
          .ignoresSafeArea()
        
        VStack(alignment: .trailing, spacing: 0) {
          Spacer()
          
          Text(viewStore.currentNum.formatted())
            .font(.system(size: 60, weight: .semibold, design: .default))
            .monospacedDigit()
            
            .preferredColorScheme(colorScheme.opposite)
            .textSelection(.enabled)
            .padding()
            .contentTransition(.numericText(countsDown: true)) // feature idea: set countsdown to match if the number is increasing/decreasing
            .animation(.snappy, value: viewStore.currentNum)
          
          CalcGridV(store: self.store.scope(state: \.calcGridV,
                                           action: CalcScreenVFeature.Action.calcGridV)
          )
        }
        .padding(.horizontal)
        
      }
      .overlay(alignment: .topLeading) {
        
        Button { viewStore.send(.view(.onTapSettingsButton))} label: {
//          Label("Settings", systemImage: "gear.circle.fill").labelStyle(.iconOnly)
          Image(systemName: "gear.circle.fill")
            .resizable()
            .frame(width: 50, height: 50)
        }
        .padding([.leading])

      }
      
    }
  }
}

//#Preview("CalcScreenVertical") {
//  CalcScreenVertical(store: .init(initialState: .init(calcGridV: .init()), reducer: {
//    CalcScreenVFeature()._printChanges()
//  }))
//}

#Preview("CalcScreenVertical (in CalcScreen)") {
  CalcScreen(
    store: .init(
      initialState: .init(
        hScreen: .init(calcGridH: .init()),
        vScreen: .init(calcGridV: .init()),
        currentOrientation: .portrait,
        userSettings: .init()
      ),
                          reducer: {
    CalcScreenFeature()._printChanges()
  }))
}


