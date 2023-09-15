//
//  CalcScreenHView.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/12/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import TCACalc_UI

struct CalcScreenHView: View {
  let store: StoreOf<CalcScreenHReducer>
  @Environment(\.colorScheme) var colorScheme
  
  struct ViewState: Equatable {
    let currentNum: String
    
    init(state: CalcScreenHReducer.State) {
      self.currentNum = state.currentNum
    }
  }
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      
      ZStack {
        // background
        self.view(for: colorScheme, light: { Color.white }, dark: { Color.black })
          .ignoresSafeArea()
        
        VStack {
          HStack {
            Spacer()
            
            Text(viewStore.currentNum)
              .accessibilityLabel(Text("Result"))
              .accessibilityValue(Text(viewStore.currentNum))
              .font(.system(size: 50, weight: .semibold, design: .default))
              .monospacedDigit()
              .foregroundStyle(.white)
              .preferredColorScheme(colorScheme.opposite)
              .textSelection(.enabled)
              .padding()
              .contentTransition(.numericText(countsDown: true)) // feature idea: set countsdown to match if the number is increasing/decreasing
              .animation(.snappy, value: viewStore.currentNum)
            
              .onTapGesture {
                viewStore.send(.view(.onTapNumDisplay))
              }
            
          }
          
          CalcGridH(store: self.store.scope(state: \.calcGridH,
                                            action: CalcScreenHReducer.Action.calcGridH)
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
          .accessibilityLabel(Text("Open Settings"))
          
        }
      }
      
    }
  }
}

#Preview("CalcScreenHView", traits: .landscapeLeft) {
  CalcScreenHView(store: .init(initialState: .init(calcGridH: .init()), reducer: {
    CalcScreenHReducer()
  }))
}
