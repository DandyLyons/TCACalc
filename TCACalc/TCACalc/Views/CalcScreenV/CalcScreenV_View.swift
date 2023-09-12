//
//  CalcScreenV_View.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/12/23.
//

import Foundation

import SwiftUI
import TCACalc_UI
import ComposableArchitecture


struct CalcScreenV_View: View {
  let store: StoreOf<CalcScreenVReducer>
  @Environment(\.colorScheme) var colorScheme
  
  struct ViewState: Equatable {
    let currentNum: String
    
    init(state: CalcScreenVReducer.State) {
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
          
          Text(viewStore.currentNum)
            .font(.system(size: 60, weight: .semibold, design: .default))
            .monospacedDigit()
          
            .preferredColorScheme(colorScheme.opposite)
            .textSelection(.enabled)
            .padding()
            .contentTransition(.numericText(countsDown: true)) // feature idea: set countsdown to match if the number is increasing/decreasing
            .animation(.snappy, value: viewStore.currentNum)
          
            .onTapGesture { viewStore.send(.view(.onTapNumDisplay)) }
          
          CalcGridV(store: self.store.scope(state: \.calcGridV,
                                            action: CalcScreenVReducer.Action.calcGridV)
          )
        }
        .padding(.horizontal)
        
      }
      .overlay(alignment: .topLeading) {
        
        Button { viewStore.send(.view(.onTapSettingsButton))} label: {
          Image(systemName: "gear.circle.fill")
            .resizable()
            .frame(width: 50, height: 50)
        }
        .padding([.leading])
        
      }
      
    }
  }
}

#Preview("CalcScreenV_View (in CalcScreen)") {
  CalcScreen(
    store: .init(
      initialState: .init(
        hScreen: .init(calcGridH: .init()),
        vScreen: .init(calcGridV: .init()),
        currentOrientation: .portrait,
        userSettings: .init()
      ),
      reducer: {
        CalcScreenReducer()._printChanges()
      }))
}

