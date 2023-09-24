//
//  CalcScreenView.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/12/23.
//

import Foundation
import ComposableArchitecture
import PlusNightMode

// MARK: View
import SwiftUI

struct CalcScreen: View {
  typealias ViewStoreOf_CalcScreen = ViewStore<ViewState, CalcScreenReducer.Action>
  let store: StoreOf<CalcScreenReducer>
  
  struct ViewState: Equatable {
    let isNightModeOn: Bool
    let colorSchemeMode: ColorSchemeMode
    let isDebugModeOn: Bool
    let isInBlankState: Bool
    
    let currentTintColor: Color
    let calculationState: CalculationReducer.State
    
    let buffer: CalculationReducer.State.Buffer
    
    init(state: CalcScreenReducer.State) {
      
      self.calculationState = state.calculation
      
      self.colorSchemeMode = state.userSettings.colorSchemeMode
      self.isDebugModeOn = state.userSettings.isDebugModeOn
      
      self.isInBlankState = state.calculation.status == .initial
      self.currentTintColor = state.userSettings.accentColor
      self.buffer = state.calculation.buffer
      self.isNightModeOn = state.userSettings.colorSchemeMode == .night
    }
  }
  
  @ViewBuilder
  func vDebugView(_ viewStore: ViewStoreOf_CalcScreen) -> some View {
    VStack(alignment: .trailing) {
      Divider()
      Text("buffer.isDecimalOn:\(viewStore.buffer.isDecimalOn.description)")
      Text("buffer.trailingZeroesAfterDecimal:\(viewStore.buffer.trailingZeroesAfterDecimal)")
      Text("buffer.isNegativeOn:\(viewStore.buffer.isNegativeOn.description)")
      
      VStack(alignment: .leading) {
        Text("State: \(viewStore.calculationState.status.rawValue)")
        Text("num1: \(viewStore.calculationState.num1.formatted())")
        Text("op1: \(viewStore.calculationState.op1?.rawValue ?? "")")
        Text("num2: \(viewStore.calculationState.num2.formatted())")
        Text("op2: \(viewStore.calculationState.op2?.rawValue ?? "")")
        Text("num3: \(viewStore.calculationState.num3.formatted())")
      }.frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  @Dependency(\.logger) var logger
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      Group {
        VHView {
          self.vScreen(viewStore)
        } hView: {
          self.hScreen
        }
      }
      // MARK: View Events
      
      // MARK: View Styling
      .preferredColorScheme(viewStore.colorSchemeMode.resolvedColorScheme)
      .colorSchemeMode(viewStore.binding(get: \.colorSchemeMode, send: { .internalAction(.colorScreenModeChanged($0))}))
      .tint(viewStore.currentTintColor)
      
      // MARK: View Presentation
      .sheet(
        store: self.store.scope(state: \.$presentation, action: { .presentation($0) }),
        state: /CalcScreenReducer.Presentation.State.settings,
        action: CalcScreenReducer.Presentation.Action.settings,
        onDismiss: nil,
        content: { settingsStore in
          NavigationStack {
            SettingsView(store: settingsStore)
              .navigationTitle("Settings")
          }
          .colorSchemeMode(viewStore.binding(get: \.colorSchemeMode, send: { .internalAction(.colorScreenModeChanged($0))}))
          .accessibilityLabel(Text("Settings Screen"))
          .tint(viewStore.currentTintColor)
        }
      )
      .alert(store: self.store.scope(state: \.$presentation, action: { .presentation($0)}),
             state: /CalcScreenReducer.Presentation.State.alert,
             action: CalcScreenReducer.Presentation.Action.alert
      )
      
    }
  }
  
  @ViewBuilder
  func vScreen(_ viewStore: ViewStoreOf_CalcScreen) -> some View {
    CalcScreenV_View(
      store: self.store.scope(
        state: \.vScreen,
        action: CalcScreenReducer.Action.vScreen
      )
    )
    .overlay(alignment: .topTrailing) {
      if viewStore.isDebugModeOn {
        self.vDebugView(viewStore).padding(.trailing)
      }
    }
    
  }
  
  var hScreen: some View {
    CalcScreenHView(
      store: self.store.scope(
        state: \.hScreen,
        action: CalcScreenReducer.Action.hScreen
      )
    )
  }
  
}

struct Presentation: Reducer {
  enum State: Equatable {
    case settings(SettingsReducer.State)
  }
  enum Action: Equatable {
    case settings(SettingsReducer.Action)
  }
  var body: some ReducerOf<Self> {
    Scope(state: /State.settings, action: /Action.settings) {
      SettingsReducer()
    }
  }
}

extension AlertState where Action == CalcScreenReducer.Presentation.Action.Alert {
  static func alert_numberFact(_ fact: String) -> Self {
    return Self {
      TextState(fact)
    } actions: {
      ButtonState(role: .none, label: { TextState("Ok")})
    }
  }
  
  static func alert_numberFactError_NotWholeNumber() -> Self {
    return Self {
      TextState("Cannot get a number fact for non-whole numbers.")
    }
  }
  
  static func alert_notYetImplemented() -> Self {
    let title = """
    🚧 👷🏼‍♀️ 👷🏼‍♂️ 🚧
You've discovered a feature that hasn't been implemented!

"""
    let message = """
Feel free to submit an issue or pull request on my GitHub repo. 😄
"""
    return .init {
      TextState(title)
    } actions: {
      ButtonState(action: .send(.notYetImplemented(.viewGitHub))) {
        TextState("View GitHub repo")
      }
      ButtonState(role: .cancel, label: { TextState("OK") })
    } message: {
      TextState(message)
    }

  }
}

#Preview("CalcScreen V"
) {
  CalcScreen(
    store: .init(
      initialState: .init(
        hScreen: .init(currentNum: "0", calcGridH: .init()),
        vScreen: .init(currentNum: "0", calcGridV: .init()),
        userSettings: .init(isDebugModeOn: false)
      ),
      reducer: {
        CalcScreenReducer()._printChanges()
      }))
}
