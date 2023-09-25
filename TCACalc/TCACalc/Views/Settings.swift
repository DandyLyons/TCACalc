//
//  Settings.swift
//  TCACalc
//
//  Created by Daniel Lyons on 8/17/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import DependenciesAdditions
import PlusNightMode



struct SettingsReducer: Reducer {
  struct State: Equatable {
    @BindingState var userSettings: UserSettings
    @PresentationState var presentation: Presentation.State?
    
    init(_ userSettings: UserSettings = .init(),
         presentation: Presentation.State? = nil
    ) {
      self.userSettings = userSettings
      self.presentation = presentation
    }
      
  }
  enum Action: Equatable, BindableAction {
    case view(ViewAction)
    case delegate(DelegateAction)
    case _internal(InternalAction)
    case binding(BindingAction<State>)
    case presentation(PresentationAction<Presentation.Action>)
    
    enum DelegateAction: Equatable {
      case colorSchemeModeChanged(ColorSchemeMode)
      case isDebugModeOnChanged(Bool)
      case userSettingsChanged(UserSettings)
    }
    enum InternalAction: Equatable {
      case showError(ShowError)
      enum ShowError { case saveError }
    }
    enum ViewAction: Equatable {
      case onTapDoneButton
    }
    
    
  }
  
  struct Presentation: Reducer {
    enum State: Equatable {
      case alert(AlertState<Action.Alert>)
    }
    
    enum Action: Equatable {
      case alert(Alert)
      enum Alert: Equatable {
        case saveError
      }
    }
    
    var body: some ReducerOf<Self> {
      Reduce<State, Action> { state, action in
        switch action {
          case .alert(let alertAction):
            switch alertAction {
              case .saveError: return .none
            }
        }
      }
    }
  }
  
  // MARK: Dependencies
   @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    BindingReducer()
      .onChange(of: \.userSettings) { oldValue, newValue in
        Reduce<State, Action> { _, _ in
          @Dependency(\.logger) var logger
          logger.notice("UserSettings did change in SettingsReducer.State. Saving now.")
          @Dependency(\.userSettings.save) var saveUserSettings
          do {
            try saveUserSettings(newValue)
          } catch {
            logger.warning("UserSettings failed to save.")
            return .send(._internal(.showError(.saveError)))
          }
          return .send(.delegate(.userSettingsChanged(newValue)))
        }
      }
      
    
    Reduce<State, Action> { state, action in
      switch action {
          
        case .delegate, .binding, .presentation:
          return .none
          
        case .view(let viewAction):
          switch viewAction {
            case .onTapDoneButton:
              return .run { send in await self.dismiss() }
          }
          
        case ._internal(let _internalAction):
          switch _internalAction {
            case .showError(let showError):
              switch showError {
                case .saveError:
                  state.presentation = .alert(.alert_saveError())
                  return .none
              }
          }
      }
    }
    .ifLet(\.$presentation, action: /Action.presentation) {
      Self.Presentation()
    }
  }
}

struct SettingsView: View {
  let store: StoreOf<SettingsReducer>
  
  struct ViewState: Equatable {
    @BindingViewState var userSettings: UserSettings
    
    init(bindingViewStore: BindingViewStore<SettingsReducer.State>) {
      self._userSettings = bindingViewStore.$userSettings
    }
  }
  
  @ViewBuilder
  func appearancePicker(style: some PickerStyle, _ viewStore: ViewStore<ViewState, SettingsReducer.Action>) -> some View {
    Picker("Appearance", selection: viewStore.$userSettings.colorSchemeMode) {
      ForEach(ColorSchemeMode.allCases) { colorSchemeMode in
        Text(colorSchemeMode.localizedString)
          .tag(colorSchemeMode)
      }
    }
    .pickerStyle(style)
    .tint(viewStore.state.userSettings.accentColor)
  }
  
  @Environment(\.colorSchemeMode) var colorSchemeMode
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      Form {
        Section("Appearance") {
          self.appearancePicker(style: .segmented, viewStore)
          
          ColorPicker("Accent Color", selection: viewStore.$userSettings.accentColor)
            .disabled(viewStore.userSettings.colorSchemeMode == .night)
        }
        Section {
          Toggle("Debug Mode", isOn: viewStore.$userSettings.isDebugModeOn)
        } header: {
          Text("🪲 Debugging")
        } footer: {
          Text("Debugging labels are only visible in portrait orientation.")
        }
        
        
        Section("Info") {
          Link(destination: URL(string: "https://github.com/DandyLyons/TCACalc")!) {
            Text("See the GitHub repo")
          }
        }
      }
      .tint(viewStore.userSettings.accentColor)
      .toolbar {
        Button("Done") { viewStore.send(.view(.onTapDoneButton))}
      }
      
      // View Presentation
      .alert(store: self.store.scope(state: \.$presentation, action: { .presentation($0)}),
             state: /SettingsReducer.Presentation.State.alert,
             action: SettingsReducer.Presentation.Action.alert
      )
    }
  }
}

// MARK: Previews
#Preview("SettingsView") {
  let store = StoreOf<SettingsReducer>(
    initialState: SettingsReducer.State(),
    reducer: {
      SettingsReducer()
        ._printChanges()
    }
  )
  
  return NavigationStack {
    SettingsView(store: store)
      .navigationTitle("Settings")
  }
}

extension AlertState where Action == SettingsReducer.Presentation.Action.Alert {
  static func alert_saveError() -> Self {
    return Self {
      TextState("There was an error while saving your UserSettings.")
    }
  }
}
