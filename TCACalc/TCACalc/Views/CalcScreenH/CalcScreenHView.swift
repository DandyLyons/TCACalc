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
import PlusNightMode


/// The View that ``CalcScreen`` will show when in landscape orientation.
struct CalcScreenHView: View {
  let store: StoreOf<CalcScreenHReducer>
  @Environment(\.colorScheme) var colorScheme
  @AccessibilityFocusState var a11yFocus: CalcScreenHReducer.State.A11yFocus?
  
  struct ViewState: Equatable {
    let currentNum: String
    let canRequestNumFact: Bool
    let a11yFocus: CalcScreenHReducer.State.A11yFocus?
    
    init(state: CalcScreenHReducer.State) {
      self.currentNum = state.currentNum
      self.canRequestNumFact = state.canRequestNumFact
      self.a11yFocus = state.a11yFocus
    }
  }
  
  @ViewBuilder
  func settingsButton(_ viewStore: ViewStore<ViewState, CalcScreenHReducer.Action>) -> some View {
    Button { viewStore.send(.view(.onTapSettingsButton))} label: {
      Image(systemName: "gear.circle.fill")
        .resizable()
        .frame(width: 40, height: 40)
        .padding(.top)
    }
    .padding([.leading])
    .accessibilityLabel("Settings")
    .tint(colorSchemeMode == .night ? .red : userSelectedColor)
  }
  
  @ViewBuilder
  func numberFactsButton(_ viewStore: ViewStore<ViewState, CalcScreenHReducer.Action>) -> some View {
    Button { viewStore.send(.view(.onTapNumberFactsButton))} label: {
      Image(systemName: "info.circle.fill")
        .resizable()
        .frame(width: 40, height: 40)
        .padding(.top)
    }
    .accessibilityLabel(Text("Get Number Fact"))
    .disabled(!viewStore.state.canRequestNumFact)
    .animation(.default, value: viewStore.state.canRequestNumFact)
    .tint(colorSchemeMode == .night ? .red : userSelectedColor)
    .transition(.asymmetric(insertion: .scale.animation(.bouncy), removal: .opacity.animation(.smooth(duration: 1))))
  }
  
  @Environment(\.colorSchemeMode) var colorSchemeMode
  @Environment(\.userSelectedColor) var userSelectedColor
  
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
              .font(.system(size: 50, weight: .semibold, design: .default))
              .monospacedDigit()
              .preferredColorScheme(colorScheme.opposite)
              .textSelection(.enabled)
              .padding()
              .contentTransition(.numericText(countsDown: true)) // feature idea: set countsdown to match if the number is increasing/decreasing
              .animation(.snappy, value: viewStore.currentNum)
            
            
          }
          .accessibilityFocused(self.$a11yFocus, equals: .numDisplay)
          .accessibilityLabel("Result")
          .accessibilityValue(viewStore.currentNum)
          .accessibilityAddTraits(.isSummaryElement)
          .accessibilityAction(named: "Clear") {
            viewStore.send(.calcGridH(.view(.onTapACButton)))
          }
          .onTapGesture {
            viewStore.send(.view(.onTapNumDisplay))
          }
          .bind(
            viewStore.binding(get: \.a11yFocus,
                              send: {
                                .view(.a11yFocusChanged($0))
                              }),
            to: self.$a11yFocus
          )
          
          CalcGridH(store: self.store.scope(state: \.calcGridH,
                                            action: CalcScreenHReducer.Action.calcGridH)
          )
        }
        .padding(.horizontal)
        
        
        .overlay(alignment: .topLeading) {
          HStack {
            self.settingsButton(viewStore)
            self.numberFactsButton(viewStore)
          }
        }
        
      }
      .onAppear { viewStore.send(.view(.onAppear)) }
      
    }
  }
}

// MARK: Previews

struct CalcScreenHView_Previews: PreviewProvider {
  
  static var previews: some View {
//    CalcScreenHView(store: Store(
//      initialState: .init(calcGridH: .init()),
//      reducer: {})
//    )
//    .previewInterfaceOrientation(.landscapeLeft)
    CalcScreen(
      store: .init(
        initialState: .init(
          hScreen: .init(calcGridH: .init()),
          vScreen: .init(calcGridV: .init()),
          userSettings: .init()
        ),
        reducer: {
          CalcScreenReducer()._printChanges()
        })
    )
  }
}

//#Preview("CalcScreenHView in CalcScreen", traits: .landscapeLeft) {
//  CalcScreen(
//    store: .init(
//      initialState: .init(
//        hScreen: .init(calcGridH: .init()),
//        vScreen: .init(calcGridV: .init()),
//        userSettings: .init()
//      ),
//      reducer: {
//        CalcScreenReducer()._printChanges()
//      })
//  )
//}
