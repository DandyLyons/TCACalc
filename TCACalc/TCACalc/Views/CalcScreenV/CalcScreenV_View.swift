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
    
    init(state: CalcScreenVReducer.State) {
      self.currentNum = state.currentNum
      self.canRequestNumFact = state.canRequestNumFact
    }
  }
  
  @ViewBuilder
  func numDisplay(_ viewStore: ViewStore<ViewState, CalcScreenVReducer.Action>) -> some View {
    Text(viewStore.currentNum)
      .font(.system(size: 60, weight: .semibold, design: .default))
      .monospacedDigit()
    
      .accessibilityRepresentation {
        HStack {
          
          Text(viewStore.currentNum)
            .accessibilityAddTraits(.isSummaryElement)
            .accessibilityLabel(Text("Result"))
            .accessibilityValue(Text(viewStore.currentNum))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .horizontal)
      }
    
      .preferredColorScheme(colorScheme.opposite)
      .textSelection(.enabled)
      .padding()
      .contentTransition(.numericText(countsDown: true)) // feature idea: set countsdown to match if the number is increasing/decreasing
      .animation(.snappy, value: viewStore.currentNum)
      .onTapGesture { viewStore.send(.view(.onTapNumDisplay)) }
  }
  
  @ViewBuilder
  func settingsButton(_ viewStore: ViewStore<ViewState, CalcScreenVReducer.Action>) -> some View {
    Button { viewStore.send(.view(.onTapSettingsButton))} label: {
      Image(systemName: "gear.circle.fill")
        .resizable()
        .frame(width: 50, height: 50)
    }
    .padding([.leading])
    .accessibilityLabel(Text("Open Settings"))
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
        
        VStack(alignment: .trailing, spacing: 0) {
          Spacer()
          
          self.numDisplay(viewStore)
          
          CalcGridV(
            store: self.store.scope(
              state: \.calcGridV,
              action: CalcScreenVReducer.Action.calcGridV
            )
          )
        }
        .padding(.horizontal)
        
      }
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

