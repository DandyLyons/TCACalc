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
#if os(iOS)
    let currentOrientation: UIDeviceOrientation
#endif
    let isNightModeOn: Bool
    let colorSchemeMode: ColorSchemeMode
    let isDebugModeOn: Bool
    let isInBlankState: Bool
    
    let currentTintColor: Color
    let calculationState: CalculationReducer.State
    
    let buffer: CalculationReducer.State.Buffer
    
    init(state: CalcScreenReducer.State) {
#if os(iOS)
      self.currentOrientation = state.currentOrientation
#endif
      
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
      Text("Current orientation: \(viewStore.currentOrientation.debugDescription)")
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
  
  
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      Group {
        switch viewStore.currentOrientation {
          case .portrait, .portraitUpsideDown,.faceDown, .faceUp:
            self.vScreen(viewStore)
            
          case .landscapeLeft, .landscapeRight:
            self.hScreen
          case .unknown:
            // TODO: Delete this
            self.vScreen(viewStore)
              .onAppear { print("UIDeviceOrientation is unknown") }
            
          @unknown default:
            self.vScreen(viewStore)
              .onAppear { print("UIDeviceOrientation received unknown default") }
        }
      }
      // MARK: View Events
      .task(priority: .userInitiated) {
        viewStore.send(.currentOrientationChangedTo(UIDevice.current.orientation))
      }
      .onRotate { newOrientation in
        guard newOrientation != .portraitUpsideDown,
              newOrientation != viewStore.currentOrientation else { return }
        viewStore.send(.currentOrientationChangedTo(newOrientation))
      }
      
      // MARK: View Styling
      .preferredColorScheme(viewStore.colorSchemeMode.resolvedColorScheme)
      .observingNightMode(viewStore.isNightModeOn)
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
              .preferredColorScheme(viewStore.colorSchemeMode.resolvedColorScheme)
          }
          .observingNightMode(viewStore.colorSchemeMode == .night)
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
}

#Preview("CalcScreen V"
) {
  CalcScreen(
    store: .init(
      initialState: .init(
        hScreen: .init(currentNum: "0", calcGridH: .init()),
        vScreen: .init(currentNum: "0", calcGridV: .init()),
        currentOrientation: .portrait,
        userSettings: .init(isDebugModeOn: true)
      ),
      reducer: {
        CalcScreenReducer()._printChanges()
      }))
}
