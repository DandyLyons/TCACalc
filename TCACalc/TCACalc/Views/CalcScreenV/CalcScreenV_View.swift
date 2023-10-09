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



/// The View that ``CalcScreenView`` will show when in portrait orientation
struct CalcScreenV_View: View {
  let store: StoreOf<CalcScreenVReducer>
  @Environment(\.colorScheme) var colorScheme
  
  struct ViewState: Equatable {
    let currentNum: String
    let canRequestNumFact: Bool
    let a11yFocus: CalcScreenVReducer.State.A11yFocus?
    
    init(state: CalcScreenVReducer.State) {
      self.currentNum = state.currentNum
      self.canRequestNumFact = state.canRequestNumFact
      self.a11yFocus = state.a11yFocus
    }
  }
  
  @AccessibilityFocusState var a11yFocus: CalcScreenVReducer.State.A11yFocus?
    
  @ViewBuilder
  func numDisplay(_ viewStore: ViewStore<ViewState, CalcScreenVReducer.Action>) -> some View {
    HStack {
      Spacer()
      Text(viewStore.currentNum)
        .font(.system(size: 60, weight: .semibold, design: .default))
        .monospacedDigit()
        .preferredColorScheme(colorScheme.opposite)
        .textSelection(.enabled)
        .padding()
        .contentTransition(.numericText())
        .animation(.snappy, value: viewStore.currentNum)
        .onTapGesture { viewStore.send(.view(.onTapNumDisplay)) }
    }
    .accessibilityAddTraits(.isSummaryElement)
    .accessibilityLabel("Result")
    .accessibilityValue(viewStore.currentNum)
    .accessibilityAction(named: "Clear") { viewStore.send(.calcGridV(.view(.onTapACButton)))}
  }
  
  @ViewBuilder
  func settingsButton(_ viewStore: ViewStore<ViewState, CalcScreenVReducer.Action>) -> some View {
    Button { viewStore.send(.view(.onTapSettingsButton))} label: {
      Image(systemName: "gear.circle.fill")
        .resizable()
        .frame(width: 50, height: 50)
    }
    .padding([.leading])
    .accessibilityLabel("Settings")
    .tint(colorSchemeMode == .night ? .red : userSelectedColor)
  }
  
  @ViewBuilder
  func numberFactsButton(_ viewStore: ViewStore<ViewState, CalcScreenVReducer.Action>) -> some View {
    if viewStore.state.canRequestNumFact {
      Button { viewStore.send(.view(.onTapNumberFactsButton))} label: {
        Image(systemName: "info.circle.fill")
          .resizable()
          .frame(width: 50, height: 50)
      }
      .padding([.trailing])
      .accessibilityLabel(Text("Get Number Fact"))
      .animation(.default, value: viewStore.state.canRequestNumFact)
      .tint(colorSchemeMode == .night ? .red : userSelectedColor)
      .transition(.asymmetric(insertion: .scale.animation(.bouncy), removal: .opacity.animation(.smooth(duration: 1))))
    }
  }
  
  @Environment(\.colorSchemeMode) var colorSchemeMode
  @Environment(\.userSelectedColor) var userSelectedColor
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      ZStack {
        self.view(for: colorScheme, light: { Color.white }, dark: { Color.black })
          .ignoresSafeArea()
        
        VStack(spacing: 0) {
          Spacer()
          
          self.numDisplay(viewStore)
            .accessibilityFocused(self.$a11yFocus, equals: .numDisplay)
            .bind(
              viewStore.binding(get: \.a11yFocus,
                                send: {
                                  .view(.a11yFocusChanged($0))
                                }),
              to: self.$a11yFocus
            )
          
          CalcGridV(
            store: self.store.scope(
              state: \.calcGridV,
              action: CalcScreenVReducer.Action.calcGridV
            )
          )
        }
        .padding(.horizontal)
        
      }
      .onAppear(perform: { viewStore.send(.view(.onAppear))})
      .overlay(alignment: .topLeading) {
        self.settingsButton(viewStore)
      }
      .overlay(alignment: .topTrailing) {
        self.numberFactsButton(viewStore)
      }
      
      
    }
  }
}


// MARK: Previews
#Preview("CalcScreenV_View (in CalcScreen)", traits: .portrait) {
  CalcScreen(
    store: .init(
      initialState: .init(
        hScreen: .init(currentNum: "0", calcGridH: .init()),
        vScreen: .init(currentNum: "0", calcGridV: .init()),
        userSettings: .init(colorSchemeMode: .night, accentColor: .green)
      ),
      reducer: {
        CalcScreenReducer()._printChanges()
      })
  )
}


struct CalcScreenV_View_Previews: PreviewProvider {
  
  static var previews: some View {
    CalcScreenV_View(store: Store(
      initialState: .init(calcGridV: .init()),
      reducer: {})
    )
  }
}

//#Preview("CalcScreenV_View", traits: .portrait) {
//  CalcScreenV_View(
//    store: .init(
//      initialState: .init(calcGridV: .init()),
//      reducer: {
////        CalcScreenVReducer()
//      }
//    )
//  )
//}

